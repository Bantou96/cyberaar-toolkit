# CyberAar Hardening — Ansible Collection

CIS-aligned hardening playbooks and roles for:
- **RHEL 9 family**: Red Hat Enterprise Linux 9, AlmaLinux 9, Rocky Linux 9
- **Ubuntu/Debian**: Ubuntu 20.04 / 22.04 / 24.04, Debian 11 / 12

**Goal**
Provide a practical, maintainable, and idempotent set of Ansible roles to significantly improve the security posture of Linux servers — especially critical infrastructure systems in Senegal (government, DAF, ministries, etc.).

**Collection**: `cyberaar.hardening` v1.1.0 (March 2026)
**Total roles**: 21 RHEL9 + 21 Ubuntu/Debian = 42 roles
**License**: [GPL-3.0](../../LICENSE)

OS detection is **automatic**: one playbook, one run — the correct role set is applied per host based on `ansible_os_family`.

---

## Included Roles

### RHEL 9 / AlmaLinux 9 / Rocky Linux 9

| Role | Purpose | CIS Section(s) | Tags |
|---|---|---|---|
| `linux_kernel_hardening_rhel9` | Sysctl + module blacklisting | 1.5, 3.3 | kernel, sysctl |
| `linux_selinux_rhel9` | SELinux enforcing + booleans + restorecon | 1.6 | mac, selinux |
| `linux_authselect_rhel9` | PAM, pwquality, faillock, authselect | 5.3, 5.4 | auth, pam |
| `linux_user_management_rhel9` | Root lock, legacy users, password policy | 5.2–5.5 | users |
| `linux_ssh_hardening_rhel9` | Deep SSH server hardening | 5.1 | ssh |
| `linux_firewalld_rhel9` | firewalld default drop + SSH restrictions | 3.5 | firewall |
| `linux_ip_forwarding_rhel9` | Disable IP forwarding & redirects | 3.1, 3.2 | network |
| `linux_crypto_policies_rhel9` | System-wide crypto (FUTURE + no SHA1) | 1.13 | crypto, tls |
| `linux_auditing_rhel9` | auditd + CIS rules + rsyslog forwarding | 6.3 | audit, logging |
| `linux_aide_rhel9` | File integrity monitoring (AIDE) | 1.4 | integrity, aide |
| `linux_chrony_rhel9` | Secure NTP with Chrony | 2.1 | time, ntp |
| `linux_bootloader_password_rhel9` | GRUB2 PBKDF2 password | 1.5.2 | boot, grub |
| `linux_login_banner_rhel9` | SSH & console banners | 1.7 | banner |
| `linux_disable_unnecessary_services_rhel9` | Mask/disable legacy daemons | 2.x | services |
| `linux_dnf_automatic_rhel9` | Automatic security updates | 1.9 | updates, patching |
| `linux_core_dumps_rhel9` | Restrict core dumps | 1.5.1 | coredump |
| `linux_ctrl_alt_del_rhel9` | Disable Ctrl+Alt+Del reboot | 1.6.1 | system |
| `linux_tmp_mounts_rhel9` | noexec/nodev/nosuid on /tmp, /dev/shm | 1.1.2 | mounts |
| `linux_secure_boot_rhel9` | Secure Boot + /boot permissions | 1.5.1 | secureboot |
| `linux_file_permissions_rhel9` | Critical file perms + world-writable scan | 6.1 | permissions |
| `linux_fail2ban_rhel9` | Dynamic IP banning (sshd + firewalld) | — | fail2ban |

### Ubuntu 20.04 / 22.04 / 24.04 — Debian 11 / 12

| Role | Purpose | CIS Section(s) | Tags |
|---|---|---|---|
| `linux_kernel_hardening_ubuntu` | Sysctl + module blacklisting | 1.5, 3.3 | kernel, sysctl |
| `linux_apparmor_ubuntu` | AppArmor enforce mode + profile management | 1.6 | mac, apparmor |
| `linux_authselect_ubuntu` | PAM, pwquality, pam_faillock | 5.3, 5.4 | auth, pam |
| `linux_user_management_ubuntu` | Root lock, system accounts, inactive lock | 5.4, 5.5 | users |
| `linux_ssh_hardening_ubuntu` | Deep SSH server hardening | 5.1 | ssh |
| `linux_firewall_ubuntu` | UFW default-deny + allow/deny rules | 3.5 | firewall |
| `linux_ip_forwarding_ubuntu` | Disable IP forwarding & redirects | 3.1, 3.2 | network |
| `linux_crypto_policies_ubuntu` | OpenSSL/GnuTLS TLS policy | 1.10 | crypto, tls |
| `linux_auditing_ubuntu` | auditd + CIS rules + rsyslog forwarding | 6.3 | audit, logging |
| `linux_aide_ubuntu` | File integrity monitoring (AIDE) | 1.4 | integrity, aide |
| `linux_chrony_ubuntu` | Secure NTP with Chrony | 2.1 | time, ntp |
| `linux_bootloader_password_ubuntu` | GRUB password (BIOS + EFI) | 1.5.2 | boot, grub |
| `linux_login_banner_ubuntu` | Banners + disable dynamic MOTD | 1.7 | banner |
| `linux_disable_unnecessary_services_ubuntu` | Mask/disable legacy daemons | 2.x | services |
| `linux_unattended_upgrades_ubuntu` | Automatic security updates | 1.9 | updates, patching |
| `linux_core_dumps_ubuntu` | Restrict core dumps | 1.5.1 | coredump |
| `linux_ctrl_alt_del_ubuntu` | Disable Ctrl+Alt+Del reboot | 1.6.1 | system |
| `linux_tmp_mounts_ubuntu` | noexec/nodev/nosuid on /tmp, /dev/shm | 1.1.2 | mounts |
| `linux_secure_boot_ubuntu` | Secure Boot + /boot permissions | 1.5.1 | secureboot |
| `linux_file_permissions_ubuntu` | Critical file perms + world-writable scan | 6.1 | permissions |
| `linux_fail2ban_ubuntu` | Brute-force protection via Fail2ban | — | fail2ban |

Full per-role documentation is in [`docs/`](docs/) — see [`docs/roles-overview.md`](docs/roles-overview.md).

---

## Quick Start

```bash
# 1. Install required collections
ansible-galaxy collection install -r requirements.yml

# 2. Set sensitive variables (NEVER commit them!)
read -sr LINUX_BOOTLOADER_PASSWORD ; export LINUX_BOOTLOADER_PASSWORD

# 3. Dry-run against a single host (always start here)
ANSIBLE_LOG_PATH=~/logs/$(date +%Y-%m-%d)-hardening.log \
ansible-playbook --diff --check -u <your_user> -b \
  -i inventory/hosts \
  --extra-vars "target=ubuntu-vm-01" \
  playbooks/2_configure_hardening.yml --tags hardening
