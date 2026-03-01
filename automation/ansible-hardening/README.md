# CyberAar Hardening – Ansible Collection for RHEL 9 Family Servers

CIS-aligned hardening playbooks and roles for Red Hat Enterprise Linux 9, AlmaLinux 9, Rocky Linux 9 (and derivatives).

**Goal**  
Provide a practical, maintainable, and mostly idempotent set of Ansible roles to significantly improve security posture of Linux servers – especially critical infrastructure systems in Senegal (government, DAF, ministries, etc.).

**Current focus**  
RHEL 9 family – CIS Red Hat Enterprise Linux 9 Benchmark v2.0.0 (Level 1 & selected Level 2)

**Current version**: v1.1.0 (March 2026)  
**Total roles**: 21  
**License**: [GPL-3.0](../../LICENSE)

## Included Roles

| Role                                   | Purpose                                      | CIS Section(s)        | Tags                 |
|----------------------------------------|----------------------------------------------|-----------------------|----------------------|
| linux_crypto_policies_rhel9            | Strong crypto policies (FUTURE + no SHA1)    | 1.13                  | crypto              |
| linux_authselect_rhel9                 | PAM, pwquality, faillock, authselect profile | 5.3, 5.4              | auth, pam           |
| linux_kernel_hardening_rhel9           | Sysctl + module blacklisting                 | 1.5, 3.3              | kernel, sysctl      |
| linux_auditing_rhel9                   | auditd + rules + rsyslog forwarding          | 6.3                   | audit, logging      |
| linux_firewalld_rhel9                  | firewalld default drop + SSH restrictions    | 4.2                   | firewall            |
| linux_fail2ban_rhel9                   | Dynamic IP banning (sshd + firewalld)        | –                     | fail2ban            |
| linux_disable_unnecessary_services_rhel9 | Mask/disable legacy daemons                | 2.x                   | services            |
| linux_file_permissions_rhel9           | Strict file perms + umask 027                | 5.4, 6.1              | permissions         |
| linux_selinux_rhel9                    | Enforcing mode + booleans + restorecon       | 1.6                   | selinux             |
| linux_bootloader_password_rhel9        | GRUB2 PBKDF2 password                        | 1.4                   | bootloader, grub    |
| linux_user_management_rhel9            | Root lock, legacy users, password policy     | 5.2, 5.3, 5.4, 5.5    | users, accounts     |

Added in v1.1.0: 

| Category             | Role                                   | Purpose                                      |
|----------------------|----------------------------------------|----------------------------------------------|
| New in v1.1.0        | linux_aide_rhel9                       | File integrity monitoring (AIDE)             |
| New in v1.1.0        | linux_chrony_rhel9                     | Secure NTP with Chrony                       |
| New in v1.1.0        | linux_ssh_hardening_rhel9              | Deep SSH server hardening                    |
| New in v1.1.0        | linux_tmp_mounts_rhel9                 | noexec/nodev/nosuid on temp dirs             |
| New in v1.1.0        | linux_dnf_automatic_rhel9              | Automatic security updates                   |
| New in v1.1.0        | linux_core_dumps_rhel9                 | Restrict core dumps                          |
| New in v1.1.0        | linux_ip_forwarding_rhel9              | Disable IP forwarding & redirects            |
| New in v1.1.0        | linux_login_banner_rhel9               | SSH & console banners (CyberAar branding)    |
| New in v1.1.0        | linux_ctrl_alt_del_rhel9               | Disable Ctrl+Alt+Del reboot                  |
| New in v1.1.0        | linux_secure_boot_rhel9                | Enforce Secure Boot verification             |
## Quick Start

```bash
# 1. Install required collections
ansible-galaxy install -r requirements.yml

# 2. Set sensitive variables (NEVER commit them!)
read -sr LINUX_BOOTLOADER_PASSWORD ; export LINUX_BOOTLOADER_PASSWORD

# 3. Run against one or more hosts
ANSIBLE_LOG_PATH=~/logs/$(date +%Y-%m-%d)-hardening.log \
ansible-playbook -u <your_user> -b \
  -i inventory/hosts.yml \
  --extra-vars "target=my_test_server" \
  configure_hardening_rhel9.yml --tags hardening --check
