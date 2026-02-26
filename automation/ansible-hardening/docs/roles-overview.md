# Roles Overview

| Role                                      | Main Purpose                                      | CIS Sections          | Status     | Tags                     |
|-------------------------------------------|---------------------------------------------------|-----------------------|------------|--------------------------|
| linux_crypto_policies_rhel9               | Strong system-wide crypto (FUTURE + disable SHA1) | 1.13                  | Stable     | crypto, tls              |
| linux_authselect_rhel9                    | PAM, pwquality, faillock, authselect profile      | 5.3, 5.4              | Stable     | auth, pam                |
| linux_kernel_hardening_rhel9              | Sysctl hardening + module blacklisting            | 1.5, 3.3              | Stable     | kernel, sysctl           |
| linux_auditing_rhel9                      | auditd rules + rsyslog forwarding                 | 6.3                   | Stable     | audit, logging           |
| linux_firewalld_rhel9                     | firewalld default drop + SSH restrictions         | 4.2                   | Stable     | firewall                 |
| linux_fail2ban_rhel9                      | Brute-force protection (sshd + firewalld synergy) | —                     | Stable     | fail2ban                 |
| linux_disable_unnecessary_services_rhel9  | Mask/disable legacy services                      | 2.x                   | Stable     | services                 |
| linux_file_permissions_rhel9              | Strict perms on shadow, ssh keys, umask 027       | 5.4, 6.1              | Stable     | permissions              |
| linux_selinux_rhel9                       | Enforcing mode + booleans + restorecon            | 1.6                   | Stable     | selinux                  |
| linux_bootloader_password_rhel9           | GRUB2 PBKDF2 password protection                  | 1.4                   | Stable     | bootloader               |
| linux_user_management_rhel9               | Root lock, legacy users, password policy          | 5.2–5.5               | Stable     | users                    |

**Legend**  
- **Stable** — production ready, well tested  
- **Beta** — functional but needs more testing (none currently)

Each role has its own detailed page:  
`docs/role-<name>.md`
