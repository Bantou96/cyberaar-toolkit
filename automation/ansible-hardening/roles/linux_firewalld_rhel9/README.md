# linux_firewalld_rhel9

## Purpose
Hardens firewalld on RHEL 9 family:  
- Enables firewalld with nftables backend  
- Sets default zone to drop/public with minimal exposure  
- Allows only explicit services/ports (default: SSH)  
- Restricts SSH sources & rate-limits (anti-brute-force)  
- Logs dropped packets for monitoring

## Targeted OS
Red Hat Enterprise Linux 9, AlmaLinux 9, Rocky Linux 9

## CIS References (v2.0.0, 2024/2025)
- 4.2.1 Ensure firewalld installed/enabled (L1)  
- 4.2.2 Ensure default zone is drop (L1 Server)  
- 4.2.3-4.2.x Ensure unnecessary services removed, ports restricted

## Idempotence Features
- Checks current zone/services via `firewall-cmd --list-*`  
- Adds/removes only what's needed  
- Reload via handler only on change

## Variables Highlights
- `linux_firewalld_default_zone: "drop"` (strongest – blocks all unsolicited inbound)  
- `linux_firewalld_allowed_services: ["ssh"]`  
- `linux_firewalld_ssh_sources: ["10.0.0.0/8"]` (restrict admin access)  
- `linux_firewalld_log_dropped: true` (audit dropped attempts)

## Critical Infra Notes (DAF-like)
- Use `drop` zone + source-restricted SSH → no open ports except trusted IPs  
- Combine with fail2ban or sshguard for brute-force protection  
- Monitor `/var/log/messages` or audit logs for "FINAL_REJECT" entries  
- Test thoroughly: Run from a non-allowed IP → should lock you out (have console/rescue access!)
- For multi-interface: Assign zones per NIC (e.g. internal vs external)

## Usage
Include in playbook → customize vars for your environment (e.g. add HTTPS if web server)
