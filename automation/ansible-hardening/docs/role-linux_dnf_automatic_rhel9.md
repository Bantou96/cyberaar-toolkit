# Role: linux_dnf_automatic_rhel9

## Purpose

Configures dnf-automatic for unattended security updates:  
- Installs & enables dnf-automatic.timer  
- Applies only security patches (safe for servers)  
- Optional email notifications on changes  
- Random delay to avoid thundering herd

## CIS Coverage

- 1.7.1 Ensure updates are applied regularly  
- 1.7.2 Ensure automatic updates are configured (security only)

## Variables

| Variable                               | Default       | Description                                           |
|----------------------------------------|---------------|-------------------------------------------------------|
| linux_dnf_automatic_apply_updates      | security      | security / default / all                              |
| linux_dnf_automatic_email_notify       | true          | Send email on updates                                 |
| linux_dnf_automatic_email_to           | root@localhost| Recipient email                                       |
| linux_dnf_automatic_random_sleep       | 300           | Random delay (minutes) before applying                |
| linux_dnf_automatic_disabled           | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_dnf_automatic_rhel9
  vars:
    linux_dnf_automatic_apply_updates: security
    linux_dnf_automatic_email_to: "admin@yourdomain.sn"
