# Role: linux_secure_boot_rhel9

## Purpose

Verifies that Secure Boot is enabled (and optionally fails the playbook if disabled).  
Prevents boot-time tampering (modified kernel, initrd, etc.).

## CIS Coverage

- 1.4.5 Ensure Secure Boot is enabled (L1 – extension)

## Variables

| Variable                      | Default | Description                                      |
|-------------------------------|---------|--------------------------------------------------|
| linux_secure_boot_enforce     | true    | Fail if Secure Boot is off                       |
| linux_secure_boot_disabled    | false   | Skip entire role                                 |

## Usage Example

```yaml
- role: linux_secure_boot_rhel9
  vars:
    linux_secure_boot_enforce: true
