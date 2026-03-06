# Role: linux_firewall_ubuntu

## Purpose

Configures UFW (Uncomplicated Firewall) as the host-based firewall on Ubuntu/Debian systems:
- Resets UFW to a known-good state (deny-all default)
- Opens SSH before enabling to prevent lockout
- Applies custom allow and deny rules
- Sets default inbound policy to `deny`, outbound to `allow`
- Disables IP forwarding in UFW's sysctl unless the host is a router

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 3.5.1 Ensure a firewall package is installed
- 3.5.2 Ensure UFW service is enabled
- 3.5.3 Ensure loopback traffic is configured
- 3.5.4 Ensure outbound connections are configured
- 3.5.5 Ensure firewall rules exist for all open ports

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_firewall_ssh_port` | `22` | SSH port to allow before UFW is enabled (prevents lockout) |
| `linux_firewall_allow_rules` | `[]` | List of `{port, proto, src, comment}` rules to allow |
| `linux_firewall_deny_rules` | `[]` | List of `{port, proto, src, comment}` rules to deny |
| `linux_firewall_disable_ip_forward` | `true` | Disable IP forwarding in UFW sysctl (`/etc/ufw/sysctl.conf`) |
| `linux_firewall_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml
linux_firewall_ssh_port: "22"

linux_firewall_allow_rules:
  - port: "443"
    proto: "tcp"
    comment: "HTTPS"
  - port: "80"
    proto: "tcp"
    src: "192.168.1.0/24"
    comment: "HTTP from LAN only"
  - port: "9100"
    proto: "tcp"
    src: "10.0.0.5"
    comment: "Prometheus node exporter"

linux_firewall_deny_rules:
  - port: "23"
    proto: "tcp"
    comment: "Block Telnet"
```

## RHEL9 Counterpart

| Ubuntu/Debian | RHEL9 |
|---|---|
| `linux_firewall_ubuntu` | `linux_firewalld_rhel9` |
| UFW (`ufw`) | firewalld (`firewalld`) |
| `ufw allow`, `ufw deny` | `firewalld` zones + rules |
| `/etc/ufw/sysctl.conf` | `/etc/firewalld/` |

See [`role-linux_firewalld_rhel9.md`](role-linux_firewalld_rhel9.md) for the RHEL9 equivalent.
