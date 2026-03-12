# linux_crypto_policies_rhel9

## Purpose
Configures system-wide cryptographic policies on RHEL 9 family (RHEL 9, AlmaLinux 9, Rocky Linux 9) using `crypto-policies` tool.  
Sets strong policy (FUTURE or custom) to disable legacy/weak algorithms.

## Targeted OS
- Red Hat Enterprise Linux 9
- AlmaLinux OS 9
- Rocky Linux 9

## Hardening Details
- Switches to FUTURE policy (strong ciphers, no SHA1, etc.)
- Adds custom subpolicy to explicitly disable SHA1/SHA-1
- Re-applies policy

## CIS References (2026 current versions)
- CIS Red Hat Enterprise Linux 9 Benchmark v2.0.0 – 1.13 Ensure system-wide crypto policy is not LEGACY (L2)
- CIS AlmaLinux OS 9 Benchmark v2.0.0 – aligned to RHEL 9
- CIS Rocky Linux 9 Benchmark v2.0.0 – aligned

## CVEs Mitigated / Risks Reduced
- CVE-2016-2183 (SWEET32) – weak 64-bit block ciphers
- SHA1 signature attacks / collision resistance issues
- General downgrade attacks

## Style & Best Practices Applied
- `when:` conditions immediately after `- name:`
- All strings use double quotes `""` consistently (vars, tags, paths, commands, conditions, etc.)
- Full idempotence:
  - Current policy checked via `--show`
  - Update only runs on mismatch or subpolicy change
  - `copy` module is naturally idempotent
- Role guard in `main.yml` to skip entirely if disabled

## Variables
- `linux_crypto_policies_policy: "FUTURE"`
- `linux_crypto_policies_reload: true`
- `linux_crypto_policies_subpolicies: ["no-sha1"]`
- `linux_crypto_policies_disabled: false`

## Usage
```yaml
roles:
  - linux_crypto_policies_rhel9
