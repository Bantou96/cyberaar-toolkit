# Role: linux_authselect_ubuntu

## Purpose

Hardens local authentication on Ubuntu/Debian systems using PAM directly (no `authselect` on Debian family):
- Configures `pam_pwquality` for strong password complexity
- Configures `pam_faillock` (or `pam_tally2` on older releases) for account lockout
- Sets password aging policies in `/etc/login.defs`
- Enforces password history via `pam_pwhistory`

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 5.3 Configure PAM modules
- 5.4.1 Password complexity (minlen, character classes)
- 5.4.2 Account lockout (deny, fail_interval, unlock_time)
- 5.4.3 Password history (remember N passwords)
- 5.5.1 Password aging and expiry

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_authselect_minlen` | `14` | Minimum password length |
| `linux_authselect_minclass` | `4` | Minimum number of character classes |
| `linux_authselect_dcredit` | `-1` | Require at least 1 digit |
| `linux_authselect_ucredit` | `-1` | Require at least 1 uppercase letter |
| `linux_authselect_ocredit` | `-1` | Require at least 1 special character |
| `linux_authselect_lcredit` | `-1` | Require at least 1 lowercase letter |
| `linux_authselect_maxrepeat` | `3` | Max consecutive repeated characters |
| `linux_authselect_maxsequence` | `3` | Max monotonic character sequences |
| `linux_authselect_gecoscheck` | `true` | Reject passwords containing GECOS fields |
| `linux_authselect_dictcheck` | `true` | Reject passwords found in dictionary |
| `linux_authselect_deny` | `5` | Lock account after N failed attempts |
| `linux_authselect_unlock_time` | `900` | Seconds before auto-unlock (0 = never) |
| `linux_authselect_fail_interval` | `900` | Sliding window (seconds) for failed attempts |
| `linux_authselect_even_deny_root` | `true` | Apply lockout to root account too |
| `linux_authselect_root_unlock_time` | `60` | Root unlock time (seconds) |
| `linux_authselect_pass_max_days` | `365` | Maximum password age (days) |
| `linux_authselect_pass_min_days` | `1` | Minimum days between password changes |
| `linux_authselect_pass_warn_age` | `7` | Days before expiry to warn user |
| `linux_authselect_pass_min_len` | `14` | Minimum length in `/etc/login.defs` |
| `linux_authselect_remember` | `24` | Number of previous passwords to prevent reuse |
| `linux_authselect_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml
linux_authselect_minlen: 16
linux_authselect_deny: 3
linux_authselect_unlock_time: 1800
linux_authselect_remember: 12
linux_authselect_pass_max_days: 90
```

## Differences from RHEL9 Counterpart

| Aspect | Ubuntu/Debian | RHEL9 |
|---|---|---|
| PAM profile management | Direct PAM config (`/etc/pam.d/`) | `authselect` profiles |
| Lockout module | `pam_faillock` | `pam_faillock` via authselect |
| Password quality | `pam_pwquality` | `pam_pwquality` via authselect |
| History | `pam_pwhistory` | `pam_pwhistory` via authselect |

The variable names are identical between the two OS roles for easy cross-platform configuration.
