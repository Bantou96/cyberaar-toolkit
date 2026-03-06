# Role: linux_aide_ubuntu

## Purpose

Installs and configures AIDE (Advanced Intrusion Detection Environment) for file integrity monitoring on Ubuntu/Debian systems:
- Installs the `aide` package
- Creates required directories (`/var/lib/aide`, `/var/log/aide`)
- Deploys a CIS-aligned AIDE configuration
- Validates the configuration before attempting database initialisation
- Initialises the AIDE database on first run (or when config changes)
- Activates the database (`aide.db.new` → `aide.db`)
- Schedules daily integrity checks via cron

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 1.4.1 Ensure AIDE is installed
- 1.4.2 Ensure filesystem integrity is regularly checked

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_aide_monitored_paths` | `[/bin, /sbin, /usr/bin, /usr/sbin, /etc, /boot, /var/log, /root, /lib, /lib64, /usr/lib]` | Filesystem paths to monitor |
| `linux_aide_check_attributes` | `p+i+n+u+g+s+acl+xattrs+sha512` | AIDE check attributes (permissions, inode, sha512 hash, ACLs, xattrs) |
| `linux_aide_cron_time` | `0 5 * * *` | Cron schedule for daily integrity checks |
| `linux_aide_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml
linux_aide_cron_time: "0 3 * * *"  # Run at 3am instead

linux_aide_monitored_paths:
  - /bin
  - /sbin
  - /usr/bin
  - /usr/sbin
  - /etc
  - /boot
  - /var/log
  - /root
  - /lib
  - /opt/myapp/bin   # Custom application binary path
```

## Notes

- AIDE database initialisation (`aide --init`) can take several minutes on large filesystems. The role runs it asynchronously (10 min timeout, polling every 15s).
- If a previous initialisation was interrupted, the role detects `aide.db.new` and promotes it automatically (recovery path).
- The role skips re-initialisation if the database already exists and the AIDE config has not changed.

## Differences from RHEL9 Counterpart

The variables and behaviour are identical between the Ubuntu and RHEL9 AIDE roles. The package name (`aide`) and database path (`/var/lib/aide/aide.db`) are the same on both platforms.
