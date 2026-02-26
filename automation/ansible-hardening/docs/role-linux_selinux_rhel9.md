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
| linux_selinux_force_autorelabel    | false         | Touch /.autorelabel for full relabel on reboot   |

## Usage

```yaml
- role: linux_selinux_rhel9
  vars:
    linux_selinux_mode: enforcing
    linux_selinux_booleans:
      - name: deny_ptrace
        state: on
