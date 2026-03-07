_checks_network() {
# =============================================================================
#  5. NETWORK
# =============================================================================
section "5. NETWORK / Réseau"

# NET-01 Firewall
if svc_active firewalld; then
  add_result "Network" "PASS" "NET-01" "firewalld active" "firewalld actif" "firewalld: running" ""
elif svc_active ufw; then
  add_result "Network" "PASS" "NET-01" "ufw active" "ufw actif" "ufw: running" ""
elif iptables -L INPUT -n 2>/dev/null | grep -qvE "^(Chain|target|$)"; then
  add_result "Network" "WARN" "NET-01" "iptables rules (verify)" "Règles iptables (à vérifier)" "iptables rules found" \
    "Vérifiez vos règles iptables ou migrez vers firewalld."
else
  add_result "Network" "FAIL" "NET-01" "No firewall active" "Aucun pare-feu actif" "No firewall detected" \
    "Activez: 'systemctl enable --now firewalld'"
fi

# NET-02 IP Forwarding
IPF=$(sysctl -n net.ipv4.ip_forward 2>/dev/null || echo "?")
if [[ "$IPF" == "0" ]]; then
  add_result "Network" "PASS" "NET-02" "IP forwarding disabled" "Transfert IP désactivé" "ip_forward=0" ""
else
  add_result "Network" "WARN" "NET-02" "IP forwarding enabled" "Transfert IP activé" "ip_forward=$IPF" \
    "Désactivez si inutile: 'sysctl -w net.ipv4.ip_forward=0'"
fi

# NET-03 ICMP Redirects (accept)
ICR=$(sysctl -n net.ipv4.conf.all.accept_redirects 2>/dev/null || echo "?")
if [[ "$ICR" == "0" ]]; then
  add_result "Network" "PASS" "NET-03" "ICMP redirects disabled" "Redirections ICMP désactivées" "accept_redirects=0" ""
else
  add_result "Network" "FAIL" "NET-03" "ICMP redirects accepted" "Redirections ICMP acceptées" "accept_redirects=$ICR" \
    "Ajoutez dans /etc/sysctl.d/: 'net.ipv4.conf.all.accept_redirects=0'"
fi

# NET-04 SYN Cookies
SC=$(sysctl -n net.ipv4.tcp_syncookies 2>/dev/null || echo "?")
if [[ "$SC" == "1" ]]; then
  add_result "Network" "PASS" "NET-04" "TCP SYN cookies enabled" "SYN cookies TCP activés" "tcp_syncookies=1" ""
else
  add_result "Network" "FAIL" "NET-04" "TCP SYN cookies disabled" "SYN cookies TCP désactivés" "tcp_syncookies=$SC" \
    "Activez: 'sysctl -w net.ipv4.tcp_syncookies=1'"
fi

# NET-05 Dangerous services
DANGEROUS_SVCS=("telnet" "rsh" "rlogin" "ftp" "tftp" "nis" "talk" "chargen" "telnetd" "ftpd")
FOUND_SVCS=()
for svc in "${DANGEROUS_SVCS[@]}"; do
  svc_active "$svc" && FOUND_SVCS+=("$svc") || true
done
if [[ ${#FOUND_SVCS[@]} -eq 0 ]]; then
  add_result "Network" "PASS" "NET-05" "No dangerous services" "Aucun service dangereux" "telnet/ftp/rsh all inactive" ""
else
  add_result "Network" "FAIL" "NET-05" "Dangerous services active" "Services dangereux actifs" "${FOUND_SVCS[*]}" \
    "Désactivez: 'systemctl disable --now <service>'"
fi

# NET-06 Source routing disabled
SRC_ROUTE=$(sysctl -n net.ipv4.conf.all.accept_source_route 2>/dev/null || echo "?")
if [[ "$SRC_ROUTE" == "0" ]]; then
  add_result "Network" "PASS" "NET-06" "Source routing disabled" "Routage source désactivé" "accept_source_route=0" ""
else
  add_result "Network" "FAIL" "NET-06" "Source routing enabled" "Routage source activé" "accept_source_route=$SRC_ROUTE" \
    "Ajoutez: 'net.ipv4.conf.all.accept_source_route=0' dans /etc/sysctl.d/"
fi

# NET-07 Send redirects disabled
SEND_REDIR=$(sysctl -n net.ipv4.conf.all.send_redirects 2>/dev/null || echo "?")
if [[ "$SEND_REDIR" == "0" ]]; then
  add_result "Network" "PASS" "NET-07" "Send redirects disabled" "Envoi redirections ICMP désactivé" "send_redirects=0" ""
else
  add_result "Network" "FAIL" "NET-07" "Send redirects enabled" "Envoi redirections ICMP activé" "send_redirects=$SEND_REDIR" \
    "Ajoutez: 'net.ipv4.conf.all.send_redirects=0' dans /etc/sysctl.d/"
fi

# NET-08 Martian packet logging
MARTIAN=$(sysctl -n net.ipv4.conf.all.log_martians 2>/dev/null || echo "?")
if [[ "$MARTIAN" == "1" ]]; then
  add_result "Network" "PASS" "NET-08" "Martian packet logging enabled" "Journalisation paquets Martien active" "log_martians=1" ""
else
  add_result "Network" "WARN" "NET-08" "Martian packet logging disabled" "Paquets Martien non journalisés" "log_martians=$MARTIAN" \
    "Activez: 'net.ipv4.conf.all.log_martians=1' dans /etc/sysctl.d/"
fi

# NET-09 Reverse path filtering
RP_FILTER=$(sysctl -n net.ipv4.conf.all.rp_filter 2>/dev/null || echo "?")
if [[ "$RP_FILTER" == "1" || "$RP_FILTER" == "2" ]]; then
  add_result "Network" "PASS" "NET-09" "Reverse path filtering enabled" "Filtrage chemin inverse actif" "rp_filter=$RP_FILTER" ""
else
  add_result "Network" "FAIL" "NET-09" "Reverse path filtering disabled" "Filtrage chemin inverse inactif" "rp_filter=$RP_FILTER" \
    "Activez: 'net.ipv4.conf.all.rp_filter=1' dans /etc/sysctl.d/"
fi

# NET-10 IPv6 router advertisements disabled
IPV6_RA=$(sysctl -n net.ipv6.conf.all.accept_ra 2>/dev/null || echo "0")
if [[ "$IPV6_RA" == "0" ]]; then
  add_result "Network" "PASS" "NET-10" "IPv6 RA disabled" "Annonces routeur IPv6 désactivées" "accept_ra=0" ""
else
  add_result "Network" "WARN" "NET-10" "IPv6 RA accepted" "Annonces routeur IPv6 acceptées" "accept_ra=$IPV6_RA" \
    "Si IPv6 non requis: 'net.ipv6.conf.all.accept_ra=0' dans /etc/sysctl.d/"
fi

# NET-11 ICMP broadcast ignored
BCAST_ICMP=$(sysctl -n net.ipv4.icmp_echo_ignore_broadcasts 2>/dev/null || echo "?")
if [[ "$BCAST_ICMP" == "1" ]]; then
  add_result "Network" "PASS" "NET-11" "ICMP broadcast ignored" "Broadcast ICMP ignoré" "icmp_echo_ignore_broadcasts=1" ""
else
  add_result "Network" "WARN" "NET-11" "ICMP broadcast not ignored" "Broadcast ICMP non ignoré" "icmp_echo_ignore_broadcasts=$BCAST_ICMP" \
    "Activez: 'net.ipv4.icmp_echo_ignore_broadcasts=1' dans /etc/sysctl.d/"
fi
}
