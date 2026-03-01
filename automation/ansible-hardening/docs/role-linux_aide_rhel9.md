# Role: linux_aide_rhel9

## Purpose

Installs and configures AIDE (Advanced Intrusion Detection Environment) for file integrity monitoring:  
- Initializes database  
- Monitors critical paths for changes  
- Sets up daily cron checks with email reports  
- Detects unauthorized modifications (rootkits, configs, binaries)

## CIS Coverage

- 6.1.1–6.1.10 Ensure file integrity software is installed & configured (L1/L2)  
- Detects changes on /bin, /etc, /boot, /var/log, etc.

## Variables

| Variable                           | Default       | Description                                           |
|------------------------------------|---------------|-------------------------------------------------------|
| linux_aide_monitored_paths         | ["/bin", "/etc", "/boot", ...] | Paths to monitor for integrity |
| linux_aide_cron_time               | "0 5 * * *"   | Cron schedule for daily checks                        |
| linux_aide_disabled                | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_aide_rhel9
  vars:
    linux_aide_monitored_paths:
      - /bin
      - /sbin
      - /etc
      - /var/log
