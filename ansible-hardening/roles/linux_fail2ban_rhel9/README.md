# linux_fail2ban_rhel9

## Purpose
Installs and configures fail2ban to dynamically ban IPs after repeated authentication failures or suspicious activity.  
Works in synergy with firewalld (bans via firewalld rich rules).

## Targeted OS
RHEL 9 / AlmaLinux 9 / Rocky Linux 9

## Key Features
- Backend = firewalld (native integration, no iptables legacy)
- Stronger SSH protection (shorter maxretry, longer ban)
- Optional firewalld jail (bans IPs firewalld already sees as bad)
- Ignore trusted IPs (management networks)
- Optional email alerts

## CIS / STIG Alignment
- Complements 4.2.x Firewall controls
- Mitigates brute-force (common in post-attack reconnaissance)

## Variables Highlights
```yaml
linux_fail2ban_jail_sshd_enabled: true
linux_fail2ban_jail_sshd_maxretry: "4"
linux_fail2ban_ssh_sources: ["10.0.0.0/8"]   # from firewalld role
linux_fail2ban_jail_firewalld_enabled: true  # synergy
