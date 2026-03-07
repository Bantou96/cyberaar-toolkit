# =============================================================================
#  REMOTE SCAN ENGINE
#  When --host / --host-file / --inventory is given, SSH into each target,
#  copy the script, run it, collect HTML/JSON, then remove it.
# =============================================================================

# ── Parse Ansible INI/YAML inventory into a plain IP/host list ───────────────
_parse_inventory() {
  local inv="$1"
  # Strip comments, blank lines, group headers, vars lines, [*:vars] sections
  # Works for simple INI inventories (the common case)
  grep -vE '^\s*(#|$|\[.*:vars\]|\[.*:children\])' "$inv" 2>/dev/null \
    | grep -vE '^\s*\[' \
    | grep -vE '^\s*[a-zA-Z_]+=.*' \
    | awk '{print $1}' \
    | grep -vE '^$' \
    | sort -u
}

# ── Build the host list from all sources ─────────────────────────────────────
_build_host_list() {
  local -a hosts=()
  [[ -n "$REMOTE_HOST" ]] && hosts+=("$REMOTE_HOST")
  if [[ -n "$REMOTE_HOST_FILE" ]]; then
    while IFS= read -r line; do
      line="${line%%#*}"; line="${line// /}"   # strip comments and spaces
      [[ -n "$line" ]] && hosts+=("$line")
    done < "$REMOTE_HOST_FILE"
  fi
  if [[ -n "$ANSIBLE_INVENTORY" ]]; then
    while IFS= read -r h; do
      [[ -n "$h" ]] && hosts+=("$h")
    done < <(_parse_inventory "$ANSIBLE_INVENTORY")
  fi
  # deduplicate preserving order
  local seen=(); local out=()
  for h in "${hosts[@]}"; do
    [[ " ${seen[*]} " == *" $h "* ]] && continue
    seen+=("$h"); out+=("$h")
  done
  printf '%s\n' "${out[@]}"
}

# ── Run scan on a single remote host via SSH ──────────────────────────────────
_remote_scan() {
  local host="$1"
  local html_out="$2"
  local json_out="$3"

  local ssh_opts=(-o StrictHostKeyChecking=accept-new -o ConnectTimeout=10 -o BatchMode=yes)
  [[ -n "$REMOTE_KEY" ]] && ssh_opts+=(-i "$REMOTE_KEY")
  local target="${REMOTE_USER}@${host}"
  local remote_script="/tmp/.cyberaar-baseline-$$.sh"

  printf "\n${BOLD}${CYAN}━━━  Remote scan: %s  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n" "$host"

  # Test SSH connectivity first
  if ! ssh "${ssh_opts[@]}" "$target" "echo ok" &>/dev/null; then
    printf "  ${RED}❌  SSH connection failed: %s@%s${NC}\n" "$REMOTE_USER" "$host"
    printf "     Check: host reachable, user exists, key/password auth works.\n"
    return 1
  fi

  # Copy script to remote
  scp "${ssh_opts[@]/#-o/-o}" -q "$SCRIPT_PATH" "${target}:${remote_script}" 2>/dev/null

  # Build remote flags
  local rflags=""
  [[ -n "$html_out" ]] && rflags="$rflags --html-out /tmp/.cyberaar-report-$$.html"
  [[ -n "$json_out" ]] && rflags="$rflags --json-out /tmp/.cyberaar-report-$$.json"

  # Execute on remote (always needs root — try sudo if not root user)
  if [[ "$REMOTE_USER" == "root" ]]; then
    ssh "${ssh_opts[@]}" "$target" "bash ${remote_script}${rflags:+ $rflags}" || true
  else
    ssh "${ssh_opts[@]}" "$target" "sudo bash ${remote_script}${rflags:+ $rflags}" || true
  fi

  # Retrieve reports
  if [[ -n "$html_out" ]]; then
    scp "${ssh_opts[@]/#-o/-o}" -q "${target}:/tmp/.cyberaar-report-$$.html" "$html_out" 2>/dev/null \
      && printf "  🌐 HTML fetched → %s\n" "$html_out" \
      || printf "  ${YELLOW}⚠️   Could not fetch HTML report from %s${NC}\n" "$host"
  fi
  if [[ -n "$json_out" ]]; then
    scp "${ssh_opts[@]/#-o/-o}" -q "${target}:/tmp/.cyberaar-report-$$.json" "$json_out" 2>/dev/null \
      && printf "  📄 JSON fetched → %s\n" "$json_out" \
      || printf "  ${YELLOW}⚠️   Could not fetch JSON report from %s${NC}\n" "$host"
  fi

  # Cleanup remote temp files
  ssh "${ssh_opts[@]}" "$target" "rm -f ${remote_script} /tmp/.cyberaar-report-$$.html /tmp/.cyberaar-report-$$.json" &>/dev/null || true
}

# ── Fleet scan dispatcher ─────────────────────────────────────────────────────
FLEET_HOSTS=()
if [[ -n "$REMOTE_HOST" || -n "$REMOTE_HOST_FILE" || -n "$ANSIBLE_INVENTORY" ]]; then
  while IFS= read -r h; do
    [[ -n "$h" ]] && FLEET_HOSTS+=("$h")
  done < <(_build_host_list)

  if [[ ${#FLEET_HOSTS[@]} -eq 0 ]]; then
    printf "${RED}❌  No hosts found from the specified source(s).${NC}\n"
    exit 1
  fi

  printf "${BOLD}${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}\n"
  printf "${BOLD}${CYAN}║  CyberAar Fleet Scan — %d host(s)%-27s║${NC}\n" "${#FLEET_HOSTS[@]}" ""
  printf "${BOLD}${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}\n"

  FLEET_OK=0; FLEET_FAIL=0
  for host in "${FLEET_HOSTS[@]}"; do
    # Build output paths for this host
    local_html=""; local_json=""
    HOST_SLUG=$(echo "$host" | tr -cd 'a-zA-Z0-9.-')
    DATESTR=$(date '+%Y%m%d-%H%M%S')

    if [[ -n "$OUTPUT_DIR" ]]; then
      local_html="${OUTPUT_DIR}/cyberaar-${HOST_SLUG}-${DATESTR}.html"
      local_json="${OUTPUT_DIR}/cyberaar-${HOST_SLUG}-${DATESTR}.json"
    elif [[ -n "$HTML_OUT" ]]; then
      local_html="${HTML_OUT%.html}-${HOST_SLUG}.html"
    elif [[ -n "$JSON_OUT" ]]; then
      local_json="${JSON_OUT%.json}-${HOST_SLUG}.json"
    fi

    if _remote_scan "$host" "$local_html" "$local_json"; then
      ((FLEET_OK++))
    else
      ((FLEET_FAIL++))
    fi
  done

  printf "\n${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
  printf "${BOLD}  Fleet scan complete:${NC} ✅ %d succeeded   ❌ %d failed   (Total: %d)\n" \
    "$FLEET_OK" "$FLEET_FAIL" "${#FLEET_HOSTS[@]}"
  printf "  📁 Reports in: %s\n" "${OUTPUT_DIR:-current directory}"
  printf "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
  printf "  🇸🇳  CyberAar — https://github.com/Bantou96/Aar-Act\n\n"
  exit 0
fi
