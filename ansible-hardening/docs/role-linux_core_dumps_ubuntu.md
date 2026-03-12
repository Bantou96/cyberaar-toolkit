# Role: linux_core_dumps_ubuntu

## Purpose

Restricts core dump creation on Ubuntu/Debian systems to reduce the risk of credential or memory leaks:
- Disables SUID core dumps via `fs.suid_dumpable = 0` (sysctl)
- Optionally disables core dumps for all processes via `ulimit` in `/etc/security/limits.d/`
- Configures systemd coredump storage to `none` (disables collection in `/var/lib/systemd/coredump/`)
- Applies settings persistently across reboots

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 1.5.1 Ensure core dumps are restricted
- 1.6.4 Ensure core dumps are restricted (SUID programs)

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_core_dumps_sysctl_file` | `/etc/sysctl.d/99-cis-coredump.conf` | Sysctl config file path |
| `linux_core_dumps_suid_dumpable` | `0` | `fs.suid_dumpable` value (0 = disable SUID core dumps) |
| `linux_core_dumps_use_pid` | `1` | Include PID in core file name |
| `linux_core_dumps_systemd_storage` | `none` | systemd-coredump storage (`none` = disabled) |
| `linux_core_dumps_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml

# Default settings are sufficient for CIS compliance
linux_core_dumps_suid_dumpable: 0
linux_core_dumps_systemd_storage: "none"

# Skip on development systems that need core dumps for debugging
linux_core_dumps_disabled: true
```

## Differences from RHEL9 Counterpart

The variables and behaviour are identical. The only structural difference is that Ubuntu systems use `systemd-coredump` more pervasively, making the systemd coredump config (`/etc/systemd/coredump.conf.d/`) particularly important. The role creates the `coredump.conf.d/` directory before deploying the config file to ensure correct ordering on first run.
