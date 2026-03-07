# =============================================================================
#  JSON RENDERER
#  Iterates RESULT_* parallel arrays to build the JSON report file.
# =============================================================================
_render_json() {
  [[ -z "$JSON_OUT" ]] && return

  local n="${#RESULT_ID[@]}"
  local JSON_ARR="["
  for (( i=0; i<n; i++ )); do
    # JSON-escape: backslash first, then double-quote, then strip newlines
    local de="${RESULT_DETAIL[$i]//\\/\\\\}"
    de="${de//\"/\\\"}"; de="${de//$'\n'/ }"
    local re="${RESULT_REMEDIATION[$i]//\\/\\\\}"
    re="${re//\"/\\\"}"; re="${re//$'\n'/ }"
    local ne="${RESULT_NAME_EN[$i]//\\/\\\\}"
    ne="${ne//\"/\\\"}"
    JSON_ARR+="{\"id\":\"${RESULT_ID[$i]}\",\"category\":\"${RESULT_CATEGORY[$i]}\",\"status\":\"${RESULT_STATUS[$i]}\",\"check\":\"${ne}\",\"detail\":\"${de}\",\"remediation\":\"${re}\"}"
    [[ $i -lt $((n-1)) ]] && JSON_ARR+=","
  done
  JSON_ARR+="]"

  cat > "$JSON_OUT" <<EOF
{
  "cyberaar_baseline": {
    "version": "4.0.0",
    "host": "${HOSTNAME_VAL}",
    "os": "${OS_VAL}",
    "date": "${DATE_VAL}",
    "score": ${SCORE},
    "summary": {
      "pass": ${PASS},
      "warn": ${WARN},
      "fail": ${FAIL},
      "total": ${TOTAL}
    },
    "results": ${JSON_ARR},
    "ansible_remediation": {
      "fail_ids": [$(printf '"%s",' "${FAIL_IDS[@]}" | sed 's/,$//')],
      "warn_ids": [$(printf '"%s",' "${WARN_IDS[@]}" | sed 's/,$//')],
      "playbook": "playbooks/2_configure_hardening.yml",
      "inventory": "${ANSIBLE_INVENTORY:-inventory/hosts.yml}"
    }
  }
}
EOF
  printf "  📄 JSON: %s\n" "$JSON_OUT"
}
