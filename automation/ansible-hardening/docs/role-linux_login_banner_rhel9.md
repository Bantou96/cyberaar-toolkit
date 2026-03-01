# Role: linux_login_banner_rhel9

## Purpose

Deploys legal/pre-login and post-login banners with CyberAar branding:  
- `/etc/issue.net` – shown before SSH login (pre-login)  
- `/etc/motd` – shown after successful login (post-login)  
- `/etc/issue` – shown on console/TTY before login prompt  
- Includes hostname, date/time, legal warning, and monitoring notice

## CIS Coverage

- 5.1.7 Ensure SSH warning banner is configured  
- 5.6 Ensure login banners are configured (legal notice)

## Variables

| Variable                           | Default       | Description                                           |
|------------------------------------|---------------|-------------------------------------------------------|
| linux_login_banner_prelogin        | true          | Enable /etc/issue.net (SSH pre-login)                 |
| linux_login_banner_postlogin       | true          | Enable /etc/motd (post-login message)                 |
| linux_login_banner_issue           | true          | Enable /etc/issue (console/TTY pre-login)             |
| linux_login_banner_disabled        | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_login_banner_rhel9
  vars:
    linux_login_banner_prelogin: true
    linux_login_banner_postlogin: true
