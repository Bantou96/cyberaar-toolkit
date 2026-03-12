# Role: linux_unattended_upgrades_ubuntu

## Purpose

Configures automatic security updates on Ubuntu/Debian systems using `unattended-upgrades`:
- Installs `unattended-upgrades` and `apt-listchanges`
- Enables automatic installation of security updates
- Configures APT periodic tasks (update lists, download, clean)
- Optionally sends email notifications on upgrades or errors
- Optionally reboots automatically after kernel updates (disabled by default)

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 1.9.1 Ensure package manager repositories are configured
- 1.9.2 Ensure updates, patches, and additional security software are installed

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_unattended_upgrades_security` | `true` | Automatically install security updates |
| `linux_unattended_upgrades_all` | `false` | Install all available upgrades (not just security) |
| `linux_unattended_upgrades_autoremove` | `true` | Auto-remove unused dependency packages |
| `linux_unattended_upgrades_mail` | `""` | Email address for upgrade notifications (empty = disabled) |
| `linux_unattended_upgrades_mail_on_error` | `false` | Send email only on errors |
| `linux_unattended_upgrades_reboot` | `false` | Automatically reboot if required (e.g. kernel update) |
| `linux_unattended_upgrades_reboot_time` | `03:00` | Time to reboot if auto-reboot is enabled |
| `linux_unattended_upgrades_update_package_lists` | `1` | Run `apt update` daily (APT::Periodic) |
| `linux_unattended_upgrades_download_upgradeable` | `1` | Download available upgrades daily |
| `linux_unattended_upgrades_autoclean_interval` | `7` | Days between APT cache cleaning |
| `linux_unattended_upgrades_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml

# Security updates only, with email notification to the SOC
linux_unattended_upgrades_security: true
linux_unattended_upgrades_all: false
linux_unattended_upgrades_mail: "soc@example.sn"
linux_unattended_upgrades_mail_on_error: true

# Allow auto-reboot for kernel patches on non-critical servers (at 3am)
linux_unattended_upgrades_reboot: true
linux_unattended_upgrades_reboot_time: "03:30"
```

## RHEL9 Counterpart

| Ubuntu/Debian | RHEL9 |
|---|---|
| `linux_unattended_upgrades_ubuntu` | `linux_dnf_automatic_rhel9` |
| `unattended-upgrades` | `dnf-automatic` |
| `/etc/apt/apt.conf.d/50unattended-upgrades` | `/etc/dnf/automatic.conf` |
| APT periodic cron | dnf-automatic systemd timer |

See [`role-linux_dnf_automatic_rhel9.md`](role-linux_dnf_automatic_rhel9.md) for the RHEL9 equivalent.
