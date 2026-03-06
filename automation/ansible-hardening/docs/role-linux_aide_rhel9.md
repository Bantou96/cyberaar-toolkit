# Role: linux_aide_rhel9

## Purpose

Installs and configures AIDE (Advanced Intrusion Detection Environment) for file integrity monitoring on RHEL 9 family systems:
- Installs the `aide` package
- Initialises the AIDE database on first run (skipped if database already exists)
- Activates the database (`aide.db.new.gz` → `aide.db.gz`)
- Re-initialises the database when monitored path configuration changes
- Schedules daily integrity checks via cron with email reporting

## Supported Platforms

- RHEL 9.x (Red Hat Enterprise Linux)
- AlmaLinux 9.x
- Rocky Linux 9.x

## CIS Coverage

- 1.4.1 Ensure AIDE is installed
- 1.4.2 Ensure filesystem integrity is regularly checked

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_aide_monitored_paths` | `[/bin, /sbin, /usr/bin, /usr/sbin, /etc, /boot, /var/log, /root, /lib, /lib64, /usr/lib]` | Filesystem paths to monitor |
| `linux_aide_cron_time` | `0 5 * * *` | Cron schedule for daily integrity checks |
| `linux_aide_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/rhel_servers.yml

linux_aide_cron_time: "0 3 * * *"   # Run at 3am instead of 5am

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

- AIDE database initialisation (`aide --init`) can take several minutes on large filesystems. The role skips it if `/var/lib/aide/aide.db.gz` already exists (`creates:` guard).
- If a previous initialisation was interrupted, the `.db.new.gz` file will be promoted automatically on next run.
- The role re-initialises the database if `linux_aide_monitored_paths` changes (config drift detection).

## Differences from Ubuntu Counterpart

| Aspect | RHEL9 | Ubuntu/Debian |
|---|---|---|
| Package name | `aide` | `aide` |
| Database path | `/var/lib/aide/aide.db.gz` | `/var/lib/aide/aide.db.gz` |
| Config file | `/etc/aide.conf` | `/etc/aide.conf` |
| Check attributes | `p+i+n+u+g+s+acl+selinux+xattrs+sha512` | `p+i+n+u+g+s+acl+xattrs+sha512` |
| SELinux context | Included in check attributes | Not applicable |
| Variables | Identical structure | Identical structure |

The only difference is the check attributes string: the RHEL9 role includes `selinux` context checking, which is not present on Ubuntu/Debian systems.
