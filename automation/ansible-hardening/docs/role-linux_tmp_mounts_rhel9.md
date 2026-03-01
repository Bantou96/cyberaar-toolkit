# Role: linux_tmp_mounts_rhel9

## Purpose

Hardens temporary filesystems (`/tmp`, `/var/tmp`, `/dev/shm`) by mounting them with security flags:  
- `noexec`: prevents execution of binaries  
- `nodev`: blocks device special files  
- `nosuid`: blocks setuid/setgid bits  

Prevents attackers from using temp dirs to drop and run malicious code.

## CIS Coverage

- 1.1.2 Ensure /tmp is configured with noexec, nodev, nosuid  
- 1.1.3 Ensure /var/tmp is configured with noexec, nodev, nosuid  
- 1.1.5 Ensure /dev/shm is configured with noexec, nodev, nosuid

## Variables

| Variable                       | Default       | Description                                           |
|--------------------------------|---------------|-------------------------------------------------------|
| linux_tmp_mount_options        | [noexec, nodev, nosuid] | Mount flags to enforce                           |
| linux_tmp_mount_paths          | [/tmp, /var/tmp, /dev/shm] | Filesystems to harden                            |
| linux_tmp_mounts_disabled      | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_tmp_mounts_rhel9
  vars:
    linux_tmp_mount_options:
      - noexec
      - nodev
      - nosuid
