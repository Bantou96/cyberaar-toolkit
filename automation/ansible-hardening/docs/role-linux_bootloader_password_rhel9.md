# Role: linux_bootloader_password_rhel9

## Purpose

Protects the GRUB2 bootloader with a password to prevent unauthorized editing of boot parameters or booting into single-user/recovery mode (evil maid / offline attacks).

## CIS Coverage

- 1.4.2 Ensure bootloader password is set (Level 1)  
- 1.4.1 Ensure permissions on bootloader config are configured  
- 1.4.3 Ensure authentication is required for single-user mode

## Variables

| Variable                           | Default       | Description                                           |
|------------------------------------|---------------|-------------------------------------------------------|
| linux_bootloader_password_enabled  | true          | Enable GRUB password protection                       |
| linux_bootloader_superuser         | root          | GRUB superuser name (can be changed for obfuscation)  |
| linux_bootloader_password          | (env lookup)  | Password (must be set via env var or vault)           |
| linux_bootloader_disable_nolog     | false         | Disable no_log on sensitive tasks (debug only)        |

## Usage Example

```bash
# Set password securely before running
read -sr LINUX_BOOTLOADER_PASSWORD ; export LINUX_BOOTLOADER_PASSWORD

ansible-playbook configure_hardening_rhel9.yml --tags bootloader
