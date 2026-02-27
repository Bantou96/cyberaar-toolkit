# Role: linux_authselect_rhel9

## Purpose

Hardens local authentication on RHEL 9 family systems using `authselect`:  
- Selects secure profile (usually `sssd`)  
- Enables features: faillock (lockout), pwquality (complexity), mkhomedir, pamaccess  
- Enforces strong password quality rules  
- Configures account lockout after failed attempts

## CIS Coverage

- 5.3 Configure PAM  
- 5.4 Password Policies (min length, character classes, credits)  
- 5.5 Account Lockout (deny, fail_interval, unlock_time)

## Variables

| Variable                           | Default       | Description                                           |
|------------------------------------|---------------|-------------------------------------------------------|
| linux_authselect_profile           | sssd          | authselect profile (sssd, winbind, nis, etc.)         |
| linux_authselect_features          | [with-faillock, with-pwquality, ...] | Features to enable                     |
| linux_authselect_pwquality         | {minlen:14, dcredit:-1, ...} | Password complexity rules              |
| linux_authselect_faillock          | {deny:5, fail_interval:900, unlock_time:600} | Lockout settings               |
| linux_authselect_disabled          | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_authselect_rhel9
  vars:
    linux_authselect_pwquality:
      minlen: 14
      dcredit: -1
      ucredit: -1
      ocredit: -1
      lcredit: -1
      minclass: 3
    linux_authselect_faillock:
      deny: 5
      unlock_time: 600
