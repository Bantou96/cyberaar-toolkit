# Role: linux_file_permissions_ubuntu

## Purpose

Enforces strict permissions on critical system files on Ubuntu/Debian systems:
- Sets owner, group, and mode on authentication files (`/etc/passwd`, `/etc/shadow`, `/etc/group`, `/etc/gshadow`, `/etc/sudoers`)
- Sets owner, group, and mode on system files (`/etc/ssh/sshd_config`, `/etc/crontab`, cron directories)
- Optionally scans for world-writable files in critical paths and fails the play if found
- Optionally scans for unowned files (no valid UID/GID)

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 6.1.1 Ensure permissions on `/etc/passwd` are configured
- 6.1.2 Ensure permissions on `/etc/passwd-` are configured
- 6.1.3 Ensure permissions on `/etc/group` are configured
- 6.1.4 Ensure permissions on `/etc/group-` are configured
- 6.1.5 Ensure permissions on `/etc/shadow` are configured
- 6.1.6 Ensure permissions on `/etc/shadow-` are configured
- 6.1.7 Ensure permissions on `/etc/gshadow` are configured
- 6.1.8 Ensure permissions on `/etc/gshadow-` are configured
- 6.1.9 Ensure no world-writable files exist
- 6.1.10 Ensure no unowned files or directories exist

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_file_permissions_auth_files` | See below | List of `{path, owner, group, mode}` for auth files |
| `linux_file_permissions_system_files` | See below | List of `{path, owner, group, mode}` for system files |
| `linux_file_permissions_find_world_writable` | `true` | Scan for world-writable files |
| `linux_file_permissions_fail_on_world_writable` | `false` | Fail the play if world-writable files are found |
| `linux_file_permissions_find_unowned` | `true` | Scan for unowned files |
| `linux_file_permissions_disabled` | `false` | Set `true` to skip this role entirely |

### Default authentication file permissions

| Path | Owner | Group | Mode |
|---|---|---|---|
| `/etc/passwd` | root | root | 0644 |
| `/etc/passwd-` | root | root | 0644 |
| `/etc/shadow` | root | shadow | 0640 |
| `/etc/shadow-` | root | shadow | 0640 |
| `/etc/group` | root | root | 0644 |
| `/etc/group-` | root | root | 0644 |
| `/etc/gshadow` | root | shadow | 0640 |
| `/etc/gshadow-` | root | shadow | 0640 |
| `/etc/sudoers` | root | root | 0440 |

### Default system file permissions

| Path | Owner | Group | Mode |
|---|---|---|---|
| `/etc/ssh/sshd_config` | root | root | 0600 |
| `/etc/crontab` | root | root | 0600 |
| `/etc/cron.hourly` | root | root | 0700 |
| `/etc/cron.daily` | root | root | 0700 |
| `/etc/cron.weekly` | root | root | 0700 |
| `/etc/cron.monthly` | root | root | 0700 |
| `/etc/cron.d` | root | root | 0700 |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml

# Fail the play if any world-writable files are found
linux_file_permissions_fail_on_world_writable: true

# Add custom application config files to enforce
linux_file_permissions_system_files:
  - { path: "/etc/ssh/sshd_config",  owner: "root", group: "root", mode: "0600" }
  - { path: "/etc/crontab",          owner: "root", group: "root", mode: "0600" }
  - { path: "/etc/myapp/secrets.conf", owner: "root", group: "myapp", mode: "0640" }
```

## Differences from RHEL9 Counterpart

| Aspect | Ubuntu/Debian | RHEL9 |
|---|---|---|
| `/etc/shadow` group | `shadow` | `root` |
| `/etc/gshadow` group | `shadow` | `root` |
| Variables | Identical structure | Identical structure |

The shadow group differs: on Ubuntu/Debian, `/etc/shadow` is readable by the `shadow` group (used by `su`, `sudo`, and PAM). On RHEL9, shadow files are owned by `root:root` with mode `0000`.
