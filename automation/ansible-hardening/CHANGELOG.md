# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] — 2026-03-06

### Added

- **3 new RHEL9 hardening roles** — closes CIS gaps identified in benchmark gap analysis:
  - `linux_sudo_hardening_rhel9` — sudo use_pty + logfile enforcement (CIS 1.3.1–1.3.3)
  - `linux_cron_hardening_rhel9` — crond service + strict cron dir/file perms + cron.allow/at.allow (CIS 5.1.1–5.1.9)
  - `linux_wireless_rhel9` — nmcli radio disable + kernel module blacklisting (CIS 3.1.2)

### Changed

- **`linux_bootloader_password_rhel9`** — added CIS 1.5.3: rescue.service and emergency.service now require root authentication via systemd-sulogin-shell; new `Reload systemd daemon` handler
- **`linux_tmp_mounts_rhel9`** — added CIS 1.1.14: /home nodev mount option (union with existing options, no-op if /home is not a separate partition); added CIS 1.1.21: sticky bit enforcement on all world-writable directories
- **`linux_disable_unnecessary_services_rhel9`** — expanded services to mask (autofs, xinetd, rsyncd, snmpd, squid, smb, dovecot, httpd, vsftpd, named, slapd, dhcpd, ypserv) and packages to remove (xinetd, rsync, net-snmp, squid, samba, dovecot, httpd, vsftpd, bind, openldap-servers, dhcp-server, ypserv, ypbind, rsh, talk, telnet, openldap-clients) per CIS 2.x
- **`linux_user_management_rhel9`** — added CIS 6.2.x audit section: home directory existence/permissions, dot-file writability, .forward/.netrc/.rhosts detection, duplicate UID/GID/username/groupname checks, shadow group membership — all as warnings, no destructive remediation
- **`2_configure_hardening.yml`** — registered the 3 new RHEL9 roles (wireless, sudo, cron) in the main hardening playbook execution order

### Coverage

- New CIS controls covered: 1.3.1, 1.3.2, 1.3.3, 1.5.3, 3.1.2, 5.1.1–5.1.9, 1.1.14, 1.1.21, 2.x (expanded), 6.2.5–6.2.18

---

## [1.2.0] — 2026-03-03

### Added

- **21 Ubuntu/Debian hardening roles** — complete CIS-aligned hardening library
  for Debian-family systems, mirroring the RHEL9 role structure:
  - `linux_ssh_hardening_ubuntu` — SSH server hardening (Protocol 2, key auth, CIS ciphers)
  - `linux_kernel_hardening_ubuntu` — sysctl hardening + module blacklisting
  - `linux_auditing_ubuntu` — auditd + 14-category audit rules + rsyslog forwarding
  - `linux_aide_ubuntu` — AIDE file integrity with template-based config
  - `linux_bootloader_password_ubuntu` — GRUB PBKDF2 password protection
  - `linux_firewall_ubuntu` — UFW hardening (replaces firewalld)
  - `linux_apparmor_ubuntu` — AppArmor enforce-all (replaces SELinux)
  - `linux_authselect_ubuntu` — PAM/pwquality/faillock hardening (replaces authselect)
  - `linux_unattended_upgrades_ubuntu` — Automatic security updates (replaces dnf-automatic)
  - `linux_chrony_ubuntu` — NTP hardening, disables systemd-timesyncd
  - `linux_login_banner_ubuntu` — Login banners, disables Ubuntu dynamic MOTD
  - `linux_crypto_policies_ubuntu` — OpenSSL + GnuTLS TLS hardening
  - `linux_disable_unnecessary_services_ubuntu` — Stop/mask 20+ unnecessary services
  - `linux_user_management_ubuntu` — System accounts, umask, inactive policy
  - `linux_fail2ban_ubuntu` — fail2ban with systemd backend
  - `linux_ip_forwarding_ubuntu` — IP forwarding sysctl with validation
  - `linux_ctrl_alt_del_ubuntu` — Mask ctrl-alt-del.target
  - `linux_core_dumps_ubuntu` — Core dump restriction (limits.d + sysctl + systemd)
  - `linux_tmp_mounts_ubuntu` — /tmp and /dev/shm mount hardening
  - `linux_secure_boot_ubuntu` — Secure Boot check + /boot permissions
  - `linux_file_permissions_ubuntu` — Critical file and directory permissions

### Fixed

- **HIGH** `linux_kernel_hardening_rhel9`: sysctl and modprobe template files
  moved from role root to `templates/` directory — fixes "template not found" on all runs
- **HIGH** `linux_auditing_rhel9`: `99-cis-audit.rules.j2` was empty — deployed
  a blank ruleset on every run, wiping all audit configuration
- **HIGH** `linux_auditing_rhel9`: GRUB cmdline `lineinfile` used
  `ansible_default_ipv4.gateway` instead of backreference, corrupting kernel params
- **MEDIUM** `linux_auditing_rhel9`: removed `audispd-plugins` package (merged
  into `audit` on RHEL9, caused dnf failure)

## [1.1.0] - 2026-03-01

### Added

- 10 new hardening roles for RHEL 9 family servers:  
  - linux_aide_rhel9: File integrity monitoring (AIDE)  
  - linux_chrony_rhel9: Secure NTP with Chrony  
  - linux_ssh_hardening_rhel9: Deep SSH server hardening  
  - linux_tmp_mounts_rhel9: noexec/nodev/nosuid on temp dirs  
  - linux_dnf_automatic_rhel9: Automatic security updates  
  - linux_core_dumps_rhel9: Restrict core dumps  
  - linux_ip_forwarding_rhel9: Disable IP forwarding & redirects  
  - linux_login_banner_rhel9: SSH & console banners (CyberAar branding)  
  - linux_ctrl_alt_del_rhel9: Disable Ctrl+Alt+Del reboot    
  - linux_secure_boot_rhel9: Enforce Secure Boot verification  

- Per-role detailed documentation in docs/ (purpose, CIS refs, vars, usage, testing, notes)  
- Consistent formatting across all roles (double quotes, when after name, ---/...)  
- Updated root README with new structure, roles table, and quick-start  
- LICENSE aligned to GPL-3.0 everywhere

### Changed

- Minor refinements in existing roles (e.g. banner templates with CyberAar branding in English)

### Security

- Enhanced protections like Secure Boot enforcement, core dump restrictions, IP forwarding disable

## [1.0.0] - 2026-02-26

### Added

- Initial release of CyberAar hardening collection for RHEL 9 family
- Main playbook: `configure_hardening_rhel9.yml`
- Roles:
  - linux_crypto_policies_rhel9
  - linux_authselect_rhel9
  - linux_kernel_hardening_rhel9 (sysctl + module blacklist)
  - linux_auditing_rhel9 (with rsyslog forwarding)
  - linux_firewalld_rhel9 (using ansible.posix.firewalld)
  - linux_fail2ban_rhel9
  - linux_disable_unnecessary_services_rhel9
  - linux_file_permissions_rhel9
  - linux_selinux_rhel9 (using ansible.posix.selinux)
  - linux_bootloader_password_rhel9 (secure password via env/vault)
  - linux_user_management_rhel9

### Security

- GRUB password uses PBKDF2 hash + environment variable / vault
- No hardcoded secrets in defaults
- no_log protection on sensitive tasks

### Notes

- Focused on CIS Red Hat Enterprise Linux 9 Benchmark v2.0.0
- Designed for critical infrastructure servers (Senegal government context)
- Idempotent roles with granular enable/disable variables
