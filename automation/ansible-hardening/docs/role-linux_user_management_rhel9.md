# Role: linux_user_management_rhel9

## Purpose

Hardens user accounts and authentication:

- Locks root account (no direct login)
- Disables root over SSH
- Locks legacy/unused system accounts
- Enforces password expiry, min/max days, history
- Removes/locks accounts with empty passwords
- Restricts sudo to wheel group

## CIS Coverage

- 5.2.1 Ensure root is only UID 0 account
- 5.3.3.4.3 Ensure root login is restricted
- 5.4.1 Password policies (expiry, history)
- 5.5 Ensure no legacy accounts
- 5.7 Ensure access to su/sudo restricted

## Variables

| Variable                            | Default     | Description                                            |
|-------------------------------------|-------------|--------------------------------------------------------|
| linux_root_login_disabled           | true        | Lock root account                                      |
| linux_root_ssh_disabled             | true        | PermitRootLogin = no in sshd_config                    |
| linux_legacy_accounts_to_lock       | [games,news,...] | System accounts to lock/nologin                   |
| linux_password_max_days             | 90          | Max password age                                       |
| linux_password_min_days             | 1           | Min days before change                                 |
| linux_password_history              | 5           | Remember previous passwords                            |
| linux_restrict_sudo_to_wheel        | true        | %wheel ALL=(ALL) ALL                                   |

## Usage Example

```yaml
- role: linux_user_management_rhel9
  vars:
    linux_password_max_days: 60
    linux_legacy_accounts_to_lock:
      - games
      - ftp
      - news
