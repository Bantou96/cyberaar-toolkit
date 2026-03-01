# Role: linux_ssh_hardening_rhel9

## Purpose

Hardens the OpenSSH server configuration:  
- Disables root login & password auth (keys only)  
- Enforces strong ciphers/MACs/Kex (aligns with crypto policies)  
- Disables weak features (X11, empty passwords)  
- Adds legal banner & rate limiting

## CIS Coverage

- 5.1.1–5.1.20 Ensure SSH server is configured securely  
- 5.1.3.1 Disable root login  
- 5.1.3.2 Disable password authentication  
- 5.1.7 Ensure banner is configured  
- 5.1.13–5.1.15 Ensure strong crypto algorithms

## Variables

| Variable                        | Default       | Description                                           |
|---------------------------------|---------------|-------------------------------------------------------|
| linux_ssh_permit_root_login     | no            | PermitRootLogin (no / prohibit-password / yes)        |
| linux_ssh_password_auth         | no            | PasswordAuthentication (force keys)                   |
| linux_ssh_ciphers               | chacha20…     | Strong ciphers list                                   |
| linux_ssh_macs                  | hmac-sha2…    | Strong MACs                                           |
| linux_ssh_kexalgorithms         | curve25519…   | Strong key exchange                                   |
| linux_ssh_banner                | /etc/issue.net| Legal notice file                                     |

## Usage Example

```yaml
- role: linux_ssh_hardening_rhel9
  vars:
    linux_ssh_permit_root_login: no
    linux_ssh_password_auth: no
    linux_ssh_max_auth_tries: 3
