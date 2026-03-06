# Role: linux_selinux_rhel9

## Purpose

Ensures SELinux is in **enforcing** mode, uses targeted policy, sets hardening booleans, and restores contexts on critical paths.

## CIS Coverage

- 1.6.1 Ensure SELinux is installed & enabled
- 1.6.1.4 Ensure no unconfined services
- 1.6.2 Ensure SELinux is not disabled in bootloader
- 1.6.3 Ensure SELinux policy is configured

## Variables

| Variable                           | Default       | Description                                      |
|------------------------------------|---------------|--------------------------------------------------|
| linux_selinux_mode                 | enforcing     | enforcing / permissive / disabled                |
| linux_selinux_policy               | targeted      | targeted (default) or mls                        |
| linux_selinux_booleans             | see defaults  | List of booleans (deny_ptrace=on, etc.)          |
| linux_selinux_relabel_paths        | see defaults  | Paths passed to `restorecon -R` when enabled     |
| linux_selinux_relabel_enabled      | **false**     | Run `restorecon -R` on relabel paths (slow — opt-in) |
| linux_selinux_force_autorelabel    | false         | Touch /.autorelabel for full relabel on reboot   |
| linux_selinux_disabled             | false         | Set `true` to skip this role entirely            |

> **Performance note:** `restorecon -R` on paths like `/etc`, `/home`, `/var/log` scans every inode and can take several minutes on a loaded system. It is disabled by default (`linux_selinux_relabel_enabled: false`). Enable it only when file contexts are known to be corrupted — for example after a manual file migration or OS upgrade.

## Usage

```yaml
- role: linux_selinux_rhel9
  vars:
    linux_selinux_mode: enforcing
    linux_selinux_booleans:
      - name: deny_ptrace
        state: on
