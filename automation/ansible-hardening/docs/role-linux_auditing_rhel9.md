# Role: linux_auditing_rhel9

## Purpose

Deploys and hardens auditd:  
- Installs auditd + plugins  
- Configures sensible log rotation & space actions  
- Applies comprehensive audit rules (identity files, privileged execs, mounts, SELinux, kernel modules, etc.)  
- Makes rules immutable (-e 2)  
- Optional: forwards audit events to rsyslog + remote server

## CIS Coverage

- 6.3.1 Install & enable auditd  
- 6.3.2 Configure auditd.conf (log size, actions)  
- 6.3.3 Configure audit rules (watches, execve, syscalls)

## Variables

| Variable                                 | Default       | Description                                           |
|------------------------------------------|---------------|-------------------------------------------------------|
| linux_auditd_max_log_file                | 8             | MB per log file                                       |
| linux_auditd_space_left_action           | email         | What to do when space low                             |
| linux_audit_rules_identity               | true          | Watch /etc/passwd, shadow, group, etc.                |
| linux_audit_rules_privileged             | true          | Watch su, sudo, mount, passwd, etc.                   |
| linux_audit_rules_delete                 | true          | unlink/rename events (can be noisy)                   |
| linux_rsyslog_remote_host                | ""            | Forward logs to central server (IP or hostname)       |
| linux_auditing_forwarding_disabled       | false         | Skip log forwarding                                   |

## Usage Example

```yaml
- role: linux_auditing_rhel9
  vars:
    linux_rsyslog_remote_host: "192.168.10.50"
    linux_audit_rules_delete: false           # avoid noise
    linux_audit_rules_file_integrity_high: false
