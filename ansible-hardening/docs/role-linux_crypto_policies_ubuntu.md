# Role: linux_crypto_policies_ubuntu

## Purpose

Enforces system-wide TLS/SSL cryptographic policies on Ubuntu/Debian systems:
- Sets a minimum TLS version (TLS 1.2 or 1.3) via OpenSSL configuration
- Restricts allowed cipher suites for TLS 1.2 and TLS 1.3
- Enforces a minimum DH parameter size (2048-bit)
- Optionally configures GnuTLS as well (for apps using the GnuTLS library)
- Disables legacy protocol versions: SSLv2, SSLv3, TLS 1.0, TLS 1.1

## Supported Platforms

- Ubuntu 20.04 LTS (Focal)
- Ubuntu 22.04 LTS (Jammy)
- Ubuntu 24.04 LTS (Noble)
- Debian 11 (Bullseye) / Debian 12 (Bookworm)

## CIS Coverage

- 1.10 Ensure system-wide crypto policy is set (adapted for Debian family)
- Aligns with BSI TR-02102 and ANSSI recommendations for TLS

## Variables

| Variable | Default | Description |
|---|---|---|
| `linux_crypto_min_tls_version` | `TLSv1.2` | Minimum TLS version (`TLSv1.2` or `TLSv1.3`) |
| `linux_crypto_tls12_ciphers` | `ECDHE-ECDSA-AES256-GCM-SHA384:...` | Allowed TLS 1.2 cipher suites (OpenSSL notation) |
| `linux_crypto_tls13_ciphers` | `TLS_AES_256_GCM_SHA384:...` | Allowed TLS 1.3 ciphersuites |
| `linux_crypto_dh_min_bits` | `2048` | Minimum DH parameter size in bits |
| `linux_crypto_configure_gnutls` | `true` | Also configure GnuTLS (`/etc/gnutls/config`) |
| `linux_crypto_disable_legacy_tls` | `true` | Disable SSLv2, SSLv3, TLS 1.0, and TLS 1.1 |
| `linux_crypto_disabled` | `false` | Set `true` to skip this role entirely |

## Usage Example

```yaml
# group_vars/ubuntu_servers.yml
linux_crypto_min_tls_version: "TLSv1.2"
linux_crypto_disable_legacy_tls: true
linux_crypto_configure_gnutls: true

# Enforce TLS 1.3 only on high-security hosts
linux_crypto_min_tls_version: "TLSv1.3"
```

## RHEL9 Counterpart

| Ubuntu/Debian | RHEL9 |
|---|---|
| `linux_crypto_policies_ubuntu` | `linux_crypto_policies_rhel9` |
| OpenSSL `/etc/ssl/openssl.cnf` + GnuTLS | `update-crypto-policies` command |
| Manual cipher/version config | System-wide policy (`FUTURE`, `DEFAULT`, custom subpolicies) |

The Ubuntu approach configures individual libraries directly since Debian family does not ship `update-crypto-policies`. See [`role-linux_crypto_policies_rhel9.md`](role-linux_crypto_policies_rhel9.md) for the RHEL9 equivalent.
