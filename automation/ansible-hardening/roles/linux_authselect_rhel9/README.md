# linux_authselect_rhel9

## Purpose
Hardens local authentication on RHEL 9 family using `authselect`:  
- Selects secure profile (e.g. sssd)  
- Enables features like faillock (lockout) & pwquality (complexity)  
- Enforces strong password rules & account lockout

## Targeted OS
- Red Hat Enterprise Linux 9  
- AlmaLinux OS 9  
- Rocky Linux 9  

## CIS References (2026 current)
- CIS Red Hat Enterprise Linux 9 Benchmark v2.0.0  
  - 5.3.x PAM Configuration  
  - 5.4.x Password Policies (minlen ≥14, credits -1, etc.)  
  - 5.5.x Account Lockout (deny=5, unlock ≥600s)

## Idempotence Features
- Parses `authselect current -r` to check profile/features  
- Only selects/enables what's missing  
- `lineinfile` for conf files (idempotent)  
- `apply-changes` only if something actually changed

## Variables Highlights
- `linux_authselect_pwquality.minlen: "14"`  
- `linux_authselect_faillock.deny: "5"`  
- Extend `linux_authselect_features` for more (e.g. `"with-smartcard"`)
