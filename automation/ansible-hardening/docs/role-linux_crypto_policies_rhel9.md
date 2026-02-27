# Role: linux_crypto_policies_rhel9

## Purpose

Configures system-wide cryptographic policies to use strong algorithms only  
(FUTURE policy + explicit disable of SHA1 and legacy ciphers).  
This significantly reduces exposure to weak TLS/SSH crypto attacks.

## CIS Coverage

- 1.13 Ensure system-wide crypto policy is not LEGACY (Level 2)
- Related: SSH strong ciphers/MACs/Kex (cross-reference with auth)

## Main Actions

- Installs `crypto-policies` package
- Sets policy to FUTURE (or custom via var)
- Adds local module to disable SHA1
- Re-applies policy

## Variables

| Variable                              | Default     | Description                                           |
|---------------------------------------|-------------|-------------------------------------------------------|
| linux_crypto_policies_policy          | FUTURE      | DEFAULT / FUTURE / FIPS / LEGACY                      |
| linux_crypto_policies_reload          | true        | Reload crypto backends immediately?                   |
| linux_crypto_policies_subpolicies     | ["no-sha1"] | List of .pmod files to create (e.g. disable-SHA1)     |
| linux_crypto_policies_disabled        | false       | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_crypto_policies_rhel9
  vars:
    linux_crypto_policies_policy: FUTURE
    linux_crypto_policies_subpolicies:
      - "no-sha1"
      - "no-3des"
