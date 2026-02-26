# Role: linux_disable_unnecessary_services_rhel9

## Purpose

Reduces attack surface by stopping, disabling, and masking unnecessary or legacy services/daemons that are typically installed by default but rarely needed on production servers.

## CIS Coverage

- 2.x Remove or Disable Services  
- 2.1 Remove or Disable Daemons (avahi-daemon, cups, bluetooth, ModemManager, etc.)  
- 2.2 Ensure time synchronization is configured (keep chronyd or systemd-timesyncd)

## Variables

| Variable                                | Default       | Description                                           |
|-----------------------------------------|---------------|-------------------------------------------------------|
| linux_services_to_mask                  | [avahi-daemon, cups, bluetooth, ModemManager, ...] | Services to fully mask (strongest) |
| linux_services_to_disable               | [NetworkManager-wait-online, atd, ...] | Services to disable/stop but not mask |
| linux_packages_to_remove.enabled        | false         | Whether to remove packages (cups, avahi, etc.)        |
| linux_packages_to_remove.list           | [avahi, cups, cups-client, ModemManager, ...] | Packages to purge if enabled |
| linux_services_exceptions               | ["chronyd", "sshd"] | Services never touched (overrides lists) |
| linux_unnecessary_services_disabled     | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_disable_unnecessary_services_rhel9
  vars:
    linux_services_to_mask:
      - avahi-daemon
      - cups
      - cups-browsed
      - bluetooth
    linux_packages_to_remove.enabled: true
    linux_services_exceptions:
      - chronyd
      - sshd
