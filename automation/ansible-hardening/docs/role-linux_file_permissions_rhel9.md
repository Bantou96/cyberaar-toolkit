# Role: linux_file_permissions_rhel9

## Purpose

Applies strict permissions and ownership to critical system files and directories, and enforces a secure default umask for new files and processes.

## CIS Coverage

- 5.4.1 Ensure default user umask is 027  
- 6.1.x Ensure permissions on critical files (/etc/passwd, /etc/shadow, /boot/grub.cfg, SSH keys, logs, etc.)  
- 6.1.10 Ensure permissions on bootloader config are configured

## Variables

| Variable                           | Default       | Description                                           |
|------------------------------------|---------------|-------------------------------------------------------|
| linux_umask_default                | 027           | Default umask for users and root                      |
| linux_umask_apply_profile          | true          | Apply via /etc/profile.d/                             |
| linux_critical_files               | list          | Array of {path, mode, owner, group} (see defaults)    |
| linux_restrict_su_to_wheel         | true          | Restrict su to wheel group via pam_wheel              |
| linux_remove_world_writable        | false         | Scan & report (or optionally fix) world-writable files|

## Usage Example

```yaml
- role: linux_file_permissions_rhel9
  vars:
    linux_umask_default: "027"
    linux_critical_files:
      - path: "/etc/shadow"
        mode: "0000"
        owner: "root"
        group: "root"
    linux_remove_world_writable: false   # set true only after dry-run
