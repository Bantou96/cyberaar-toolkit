# Role: linux_authselect_rhel9

## Purpose

Hardens local authentication on RHEL 9 family systems using `authselect`:
- Installs `authselect`, `sssd`, `libpwquality`, and `pam_faillock`
- Selects the desired authselect profile (default: `sssd`)
- Enables PAM features: `with-faillock` (account lockout), `with-pwquality` (password complexity), `with-mkhomedir`, `with-pamaccess`
- Configures password quality rules in `/etc/security/pwquality.conf`
- Configures account lockout parameters in `/etc/security/faillock.conf`
- Applies changes and optionally restarts `sssd`

## Supported Platforms

- RHEL 9.x (Red Hat Enterprise Linux)
- AlmaLinux 9.x
- Rocky Linux 9.x

## CIS Coverage

- 5.3.1 Ensure password creation requirements are configured
- 5.3.2 Ensure lockout for failed password attempts is configured
- 5.3.3 Ensure password reuse is limited
- 5.4.1 Ensure password hashing algorithm is up to date
- 5.5.1 Ensure minimum days between password changes is configured
- 5.5.2 Ensure maximum days between password changes is configured
- 5.5.3 Ensure password expiration warning days is configured

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_authselect_profile` | `sssd` | authselect profile (`sssd` / `winbind` / `nis`) |
| `linux_authselect_features` | `[with-faillock, with-pwquality, with-mkhomedir, with-pamaccess]` | PAM features to enable |
| `linux_authselect_pwquality` | See below | Password complexity rules written to `pwquality.conf` |
| `linux_authselect_faillock` | See below | Account lockout settings written to `faillock.conf` |
| `linux_authselect_disabled` | `false` | Set `true` to skip this role entirely |

### Default `linux_authselect_pwquality` settings

| Key | Default | Description |
|---|---|---|
| `minlen` | `14` | Minimum password length |
| `dcredit` | `-1` | Require at least one digit |
| `ucredit` | `-1` | Require at least one uppercase letter |
| `ocredit` | `-1` | Require at least one special character |
| `lcredit` | `-1` | Require at least one lowercase letter |
| `minclass` | `3` | Minimum number of character classes |
| `maxrepeat` | `3` | Maximum consecutive identical characters |
| `maxclassrepeat` | `4` | Maximum consecutive characters from same class |
| `dictcheck` | `1` | Check password against dictionary (1 = enabled) |

### Default `linux_authselect_faillock` settings

| Key | Default | Description |
|---|---|---|
| `deny` | `5` | Lock after this many consecutive failures |
| `fail_interval` | `900` | Counting window in seconds (15 minutes) |
| `unlock_time` | `600` | Lock duration in seconds (10 minutes) |
| `even_deny_root` | `true` | Apply lockout policy to root as well |
| `root_unlock_time` | `never` | Root account never auto-unlocks after lockout |

## Usage Example

```yaml
# group_vars/rhel_servers.yml

linux_authselect_pwquality:
  minlen: 14
  dcredit: -1
  ucredit: -1
  ocredit: -1
  lcredit: -1
  minclass: 3

linux_authselect_faillock:
  deny: 5
  fail_interval: 900
  unlock_time: 600

# Unlock accounts manually: faillock --user <username> --reset
```

## Differences from Ubuntu Counterpart

| Aspect | RHEL9 | Ubuntu/Debian |
|---|---|---|
| Tool | `authselect` (profile-based PAM management) | Direct PAM config + `pam-auth-update` |
| Package | `authselect`, `pam_faillock`, `libpwquality` | `libpam-pwquality`, `libpam-faillock` |
| Lockout config | `/etc/security/faillock.conf` | `/etc/security/faillock.conf` |
| Password quality | `/etc/security/pwquality.conf` | `/etc/security/pwquality.conf` |
| Profile concept | Yes (sssd / winbind / nis) | Not applicable |
| Variables | Identical key structure | Identical key structure |
