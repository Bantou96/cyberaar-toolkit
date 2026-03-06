# Role: linux_user_management_rhel9

## Purpose

Hardens local user accounts and authentication policy on RHEL 9 family systems:
- Locks the root account and disables direct root SSH login
- Locks legacy/unused system accounts (games, news, uucp, ftp, etc.) with `/sbin/nologin`
- Enforces password expiry, minimum days, warning days, and history
- Locks accounts with empty passwords
- Restricts `sudo` access to the `wheel` group
- Optionally defines which users belong to the `wheel` group

## Supported Platforms

- RHEL 9.x (Red Hat Enterprise Linux)
- AlmaLinux 9.x
- Rocky Linux 9.x

## CIS Coverage

- 5.4.1.1 Ensure password expiration is configured
- 5.4.1.2 Ensure minimum days between password changes is configured
- 5.4.1.3 Ensure password expiration warning days is configured
- 5.4.1.4 Ensure inactive password lock is configured
- 5.4.2.1 Ensure accounts in `/etc/passwd` use shadowed passwords
- 5.4.2.2 Ensure `/etc/shadow` password fields are not empty
- 5.4.3.1 Ensure nologin is not listed in `/etc/shells`
- 5.6.1.1 Ensure root is the only UID 0 account
- 5.6.2 Ensure root path integrity
- 5.7 Ensure access to the su command is restricted

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_root_login_disabled` | `true` | Lock the root account (`passwd -l root`) |
| `linux_root_ssh_disabled` | `true` | Set `PermitRootLogin no` in `sshd_config` |
| `linux_legacy_accounts_to_lock` | `[games, news, uucp, gopher, ftp, operator, lp, adm, sync, shutdown, halt]` | System accounts to lock with `/sbin/nologin` |
| `linux_password_min_days` | `1` | `PASS_MIN_DAYS` in `/etc/login.defs` |
| `linux_password_max_days` | `90` | `PASS_MAX_DAYS` in `/etc/login.defs` |
| `linux_password_warn_days` | `7` | `PASS_WARN_AGE` in `/etc/login.defs` |
| `linux_password_history` | `5` | Number of previous passwords remembered (via `pam_pwhistory`) |
| `linux_restrict_sudo_to_wheel` | `true` | Add `%wheel ALL=(ALL) ALL` to sudoers |
| `linux_sudo_wheel_group_members` | `[]` | Users to add to the `wheel` group (empty = do not modify group) |
| `linux_remove_empty_password_users` | `true` | Lock accounts with empty password fields in `/etc/shadow` |
| `linux_system_shell` | `/sbin/nologin` | Shell assigned to locked system accounts |
| `linux_user_management_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/rhel_servers.yml

linux_password_max_days: 60
linux_password_min_days: 1
linux_password_warn_days: 14

# Define who can sudo on these servers
linux_sudo_wheel_group_members:
  - "alice"
  - "bob"

# Keep gopher in legacy list but remove ftp (used by vsftpd)
linux_legacy_accounts_to_lock:
  - "games"
  - "news"
  - "uucp"
  - "gopher"
  - "operator"
  - "lp"
```

## Differences from Ubuntu Counterpart

| Aspect | RHEL9 | Ubuntu/Debian |
|---|---|---|
| Password policy file | `/etc/login.defs` | `/etc/login.defs` |
| Inactive lock | `chage -I` | `lineinfile` on `/etc/default/useradd` (`INACTIVE=`) |
| `nologin` path | `/sbin/nologin` | `/usr/sbin/nologin` |
| Variables | Identical structure | Identical structure |
