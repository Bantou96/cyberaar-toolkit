# Role: linux_user_management_ubuntu

## Purpose

Hardens local user accounts and access control on Ubuntu/Debian systems:
- Locks shell and password for system/service accounts that do not need interactive login
- Ensures root is the only UID 0 account
- Sets root account shell and safe PATH
- Enforces umask policy in `/etc/login.defs`, `/etc/profile`, and `/etc/bash.bashrc`
- Sets the inactive account grace period in `/etc/default/useradd`
- Detects and fails the play if any account has an empty password field

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 5.4 Ensure shadow password suite is configured
- 5.5.1.4 Ensure inactive password lock is 30 days or less
- 5.5.2 Ensure system accounts are secured
- 5.5.3 Ensure default group for root account is GID 0
- 6.2.1 Ensure accounts in /etc/passwd use shadowed passwords

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_user_management_lock_system_accounts` | `true` | Lock shell + password for service accounts |
| `linux_user_management_system_accounts` | `[daemon, bin, sys, sync, games, ...]` | List of system accounts to lock |
| `linux_user_management_root_shell` | `/bin/bash` | Shell to assign to root |
| `linux_user_management_umask` | `027` | Default umask applied system-wide |
| `linux_user_management_inactive_days` | `30` | Days of inactivity before account lock (`INACTIVE` in `/etc/default/useradd`) |
| `linux_user_management_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml
linux_user_management_umask: "027"
linux_user_management_inactive_days: 30

# Lock additional service accounts specific to your stack
linux_user_management_system_accounts:
  - daemon
  - bin
  - sys
  - www-data
  - nobody
  - postgres
  - redis
```

## Differences from RHEL9 Counterpart

| Aspect | Ubuntu/Debian | RHEL9 |
|---|---|---|
| Inactive account enforcement | `lineinfile` on `/etc/default/useradd` (`INACTIVE=`) | `useradd -D` or `chage` |
| sudo group | `sudo` group | `wheel` group |
| Shadow group | `shadow` | `root` (no shadow group by default) |
| System account list | Includes Debian-specific accounts (`www-data`, `messagebus`, etc.) | Includes RHEL-specific accounts |
