# Aar-Act 🇸🇳💻

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](CONTRIBUTING.md)
[![Issues](https://img.shields.io/github/issues/Bantou96/Aar-Act)](https://github.com/Bantou96/Aar-Act/issues)
[![Release](https://img.shields.io/github/v/release/Bantou96/Aar-Act)](https://github.com/Bantou96/Aar-Act/releases)

**Aar-Act** (from CyberAar) is a volunteer-driven, open collaboration to gather and share
**best practices** for securing Senegal's critical infrastructure against cyber threats.

Inspired by recent attacks (e.g., DAF breach in 2026), we unite Senegalese talents
(home & diaspora) + global allies to build a **living, production-ready toolkit**
in French & English.

> 🇸🇳 *Sécurisons ensemble l'infrastructure numérique du Sénégal.*

---

## 🚀 What's Inside

### 🔧 Automation (Production Ready)

| Tool | Description | Docs |
|------|-------------|------|
| `cyberaar-baseline` | Security baseline checker — audits a Linux server and generates HTML + JSON reports | [→ script](automation/scripts/cyberaar-baseline.sh) |
| Ansible Hardening Roles | 10+ hardening roles for RHEL 9 / Ubuntu / Debian | [→ README](automation/ansible/README.md) |
| Full Pipeline Playbooks | baseline → harden → baseline, with per-host reports | [→ site.yml](automation/ansible/site.yml) |

#### Quick Start — Local Baseline Scan
```bash
# Install the script
sudo bash automation/scripts/cyberaar-baseline.sh --install

# Run a local audit
sudo cyberaar-baseline --html-out /tmp/report.html --json-out /tmp/report.json
```

#### Quick Start — Full Hardening Pipeline (Ansible)
```bash
# Step 1 + 2 + 3: baseline → harden → baseline
ansible-playbook automation/ansible/site.yml -i inventory/hosts.yml

# Only audit (no hardening)
ansible-playbook automation/ansible/site.yml -i inventory/hosts.yml --tags baseline

# Remote fleet scan
cyberaar-baseline --host-file /etc/cyberaar/hosts.txt --user admin --output-dir /var/log/cyberaar
```

#### Pipeline Overview
```
┌─────────────────────────────────────────────────────────┐
│               CyberAar Hardening Pipeline               │
├──────────────┬──────────────────┬───────────────────────┤
│   Step 1     │     Step 2       │       Step 3          │
│  Baseline    │    Hardening     │      Baseline         │
│  (Before)    │  (10+ Roles)     │      (After)          │
│              │                  │                       │
│ Snapshot of  │ Apply CIS/ANSSI  │ Measure improvement   │
│ current      │ controls via     │ vs Step 1 — HTML/JSON │
│ security     │ Ansible roles    │ report per host       │
│ posture      │                  │                       │
└──────────────┴──────────────────┴───────────────────────┘
```

---

### 📚 Practices & Knowledge Base

Community-maintained security guides adapted for Senegal's context:

- `/practices/` — Best practices per topic (hardening, access control, incident response…)
- `/examples/` — Senegal-specific cases and templates
- `/translations/` — French versions of all guides

---

## 🎯 Goal

Build a **free, community-maintained security toolkit** with practical,
context-adapted tools and guides for sectors like:

- 🏛️ Government & public administration
- ⚡ Energy & utilities
- 🏦 Finance & banking
- 📡 Telecom & critical systems
- 🏥 Healthcare & transport

---

## 🗂️ Repository Structure

```
Aar-Act/
├── automation/
│   ├── scripts/
│   │   └── cyberaar-baseline.sh      # Baseline audit script (v3.0.0)
│   └── ansible-hardening/
│       ├── site.yml                  # Main pipeline orchestrator
│       ├── 1_execute_baseline_before.yml     # Pre-hardening snapshot
│       ├── 2_configure_hardening.yml           # Hardening roles
│       ├── 3_execute_baseline_after.yml      # Post-hardening snapshot
│       ├── roles/                    # 10+ hardening roles
│       ├── inventory/                # Host inventory
│       └── docs/                     # Full documentation
├── practices/                        # Best practice guides (.md)
├── examples/                         # Senegal-specific templates
├── translations/                     # French versions
└── .github/                          # Issue templates, workflows
```

---

## 🤝 How to Contribute

No long commitments — add one tip when you have 10 minutes!

1. **Browse** existing sections or suggest new ones via [Issues](https://github.com/Bantou96/Aar-Act/issues)
2. **Fork** this repo (or work in a branch)
3. **Add/Edit** files — code in `/automation/`, guides in `/practices/`
4. **Submit** a Pull Request — we review & merge quickly
5. Get **credit** in the Contributors list & README!

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

---

## 📄 License

**GNU General Public License v3.0**

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

See the [LICENSE](LICENSE) file for the full text.

© 2025–2026 CyberAar Team

---

## ✨ Contributors

Thanks to these legends:

- [@Bantou96](https://github.com/Bantou96) — Founder

---

*#Cybersecurity #Senegal #AarAct #CyberAar*
