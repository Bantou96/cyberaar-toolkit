# linux_user_management_rhel9

## Purpose
Hardens user accounts & authentication:  
- Locks root & legacy accounts  
- Disables root SSH login  
- Enforces password expiry, history, min/max days  
- Removes empty/null password risks  
- Restricts sudo to wheel group

## CIS References (v2.0.0)
- 5.2.1 Ensure root is the only UID 0 account
- 5.3.3.4.3 Ensure root login is restricted
- 5.4.1 Ensure password policies (expiry, history)
- 5.5 Ensure no legacy accounts are present
- 5.7 Ensure access to su is restricted

## Idempotence & Safety
- Uses getent → only acts on existing users
- Never removes root or active accounts
- Password checks are read-only + lock if empty

## Variables Highlights
```yaml
linux_root_login_disabled: true
linux_legacy_accounts_to_lock: ["games", "ftp", ...]
linux_password_max_days: 90
linux_restrict_sudo_to_wheel: true
