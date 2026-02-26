# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
