# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
