# Role: linux_fail2ban_rhel9

## Purpose

Installs and configures fail2ban to dynamically ban IPs after repeated failures:  
- Protects SSH (sshd jail)  
- Optional: bans IPs already rejected by firewalld  
- Uses firewalld as backend (native on RHEL 9)  
- Configurable ban time, find time, maxretry

## CIS Coverage

- Indirectly supports 4.2.x Firewall controls  
- Mitigates brute-force attacks (common post-compromise step)

## Variables

| Variable                               | Default     | Description                                           |
|----------------------------------------|-------------|-------------------------------------------------------|
| linux_fail2ban_jail_sshd_enabled       | true        | Enable sshd jail                                      |
| linux_fail2ban_jail_sshd_maxretry      | 4           | Failures before ban (stricter than global)            |
| linux_fail2ban_jail_sshd_bantime       | 86400       | Ban duration in seconds (24h)                         |
| linux_fail2ban_jail_firewalld_enabled  | false       | Ban IPs firewalld already rejected                    |
| linux_fail2ban_ignoreip                | [127.0.0.1/8, ::1] | Never ban these IPs (add your admin ranges)     |

## Usage Example

```yaml
- role: linux_fail2ban_rhel9
  vars:
    linux_fail2ban_jail_sshd_maxretry: 3
    linux_fail2ban_ignoreip:
      - "192.168.10.0/24"
      - "10.0.0.50"
