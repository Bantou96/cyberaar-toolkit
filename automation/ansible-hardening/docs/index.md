# CyberAar Hardening Documentation

Ansible-based hardening suite for **RHEL 9 family servers** (RHEL 9, AlmaLinux 9, Rocky Linux 9), aligned with **CIS Red Hat Enterprise Linux 9 Benchmark v2.0.0**.

**Goal**  
Help secure critical infrastructure in Senegal (government servers, DAF, ministries, etc.) against common threats — with focus on practicality, idempotence, and auditability.

## Quick Links

- [Installation & Setup](installation.md)
- [How to Use / Run the Playbook](usage.md)
- [All Roles Overview](roles-overview.md)
- [Security Considerations & Testing Advice](security-considerations.md)
- [Contributing / Adding New Roles](contributing.md)
- [Changelog](../CHANGELOG.md)

## Current Roles (as of February 2026)

See [roles-overview.md](roles-overview.md) for full list and status.

## Philosophy

- **Idempotent** — safe to re-run many times
- **Granular control** — enable/disable each role via variables
- **Secure defaults** — no hardcoded secrets (use vault/env)
- **CIS-focused** — Level 1 + selected Level 2 controls
- **Critical infra ready** — drop zone, root lock, SELinux enforcing, audit forwarding, etc.

## License

MIT / GPL-3.0 — open for reuse and contribution.

**CyberAar Team** — Pour un Sénégal numérique plus sécurisé
