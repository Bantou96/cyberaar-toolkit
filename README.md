# Aar-Act — CyberAar Security Toolkit

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](CONTRIBUTING.md)
[![Issues](https://img.shields.io/github/issues/Bantou96/Aar-Act)](https://github.com/Bantou96/Aar-Act/issues)
[![Release](https://img.shields.io/github/v/release/Bantou96/Aar-Act)](https://github.com/Bantou96/Aar-Act/releases)

**Aar-Act** (from CyberAar) is a volunteer-driven, open collaboration to gather and share
**best practices** for securing Senegal's critical infrastructure against cyber threats.

Inspired by recent attacks on Senegalese public systems, we unite Senegalese talents
(home & diaspora) + global allies to build a **living, production-ready toolkit**
available in French & English.

> *Sécurisons ensemble l'infrastructure numérique du Sénégal.* — 🇸🇳

---

## Table of Contents

- [What's Inside](#whats-inside)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Deliverable 1 — Baseline Audit Script](#deliverable-1--baseline-audit-script-cyberaar-baselinesh)
- [Deliverable 2 — Ansible Hardening Collection](#deliverable-2--ansible-hardening-collection)
  - [The Three-Step Pipeline](#the-three-step-pipeline)
  - [Step 1 — Pre-Hardening Baseline](#step-1--pre-hardening-baseline)
  - [Step 2 — System Hardening](#step-2--system-hardening)
  - [Step 3 — Post-Hardening Baseline](#step-3--post-hardening-baseline)
- [Running the Pipeline](#running-the-pipeline)
- [Hardening Roles Reference](#hardening-roles-reference)
- [Tag Reference](#tag-reference)
- [Inventory & Variable Configuration](#inventory--variable-configuration)
- [Sensitive Variables](#sensitive-variables)
- [Report Output](#report-output)
- [Practices & Knowledge Base](#practices--knowledge-base)
- [Goal & Target Sectors](#goal--target-sectors)
- [How to Contribute](#how-to-contribute)
- [License](#license)
- [Contributors](#contributors)

---

## What's Inside

| Deliverable | Description | Version |
|-------------|-------------|---------|
| `automation/scripts/cyberaar-baseline.sh` | Standalone bash script — audits a Linux server across 93 security checks, produces HTML + JSON reports with Ansible remediation plan | v4.1.0 |
| `automation/ansible-hardening/` | Ansible collection (`cyberaar.hardening`) — 47 CIS-aligned hardening roles for RHEL 9 family and Ubuntu/Debian | v1.7.0 |

Both tools are independent: you can run the baseline script standalone without Ansible, or use Ansible to run the full three-step pipeline (audit → harden → audit) across an entire fleet.

---

## Repository Structure

```
Aar-Act/
├── automation/
│   ├── scripts/
│   │   ├── cyberaar-baseline.sh          # Standalone audit script (v4.0.0) — generated bundle
│   │   ├── build.sh                      # Rebuilds cyberaar-baseline.sh from src/
│   │   ├── run-hardening.sh              # Pipeline runner (wraps ansible-playbook)
│   │   ├── README.md                     # Baseline checker full reference
│   │   └── src/                          # Source layout (edit here, not in the bundle)
│   │       ├── main.sh                   # Shebang, CLI args, install/uninstall
│   │       ├── run.sh                    # Execution entry point
│   │       ├── lib/                      # core.sh, ansible_map.sh, remote.sh
│   │       ├── checks/                   # 8 files — one per check section
│   │       └── renderers/               # terminal.sh, json.sh, html.sh
│   └── ansible-hardening/
│       ├── galaxy.yml                    # Collection metadata (cyberaar.hardening v1.7.0)
│       ├── requirements.yml              # ansible.posix + community.general
│       ├── inventory/
│       │   ├── hosts                     # INI inventory (rhel_servers / ubuntu_servers / dmz_servers)
│       │   └── group_vars/
│       │       ├── all.yml               # Global defaults
│       │       ├── linux_servers.yml     # Shared Linux defaults
│       │       ├── rhel_servers.yml      # RHEL-specific vars + IP prefix
│       │       ├── ubuntu_servers.yml    # Ubuntu-specific vars + IP prefix
│       │       └── dmz_servers.yml       # Stricter thresholds for DMZ hosts
│       ├── playbooks/
│       │   ├── site.yml                  # Pipeline orchestrator (imports all 3 steps)
│       │   ├── 1_execute_baseline_before.yml   # Pre-hardening audit
│       │   ├── 2_configure_hardening.yml       # Hardening roles (RHEL9 + Ubuntu)
│       │   └── 3_execute_baseline_after.yml    # Post-hardening audit
│       └── roles/                        # 47 hardening roles (parallel RHEL9 + Ubuntu)
├── practices/                            # Community security guides (English)
├── translations/                         # French versions of all guides
├── examples/                             # Senegal-specific templates & sample reports
└── .github/                              # Issue templates, PR template
```

---

## Prerequisites

### Control node (where you run Ansible)

```bash
# Python 3.8+ and Ansible 2.14+
pip install ansible

# Required Ansible collections (run once)
ansible-galaxy collection install -r automation/ansible-hardening/requirements.yml
# Installs: ansible.posix >=1.5.4  |  community.general >=8.0.0
```

### Managed nodes (the servers being hardened)

- **RHEL 9 family**: RHEL 9, AlmaLinux 9, Rocky Linux 9
- **Ubuntu/Debian**: Ubuntu 20.04, 22.04, 24.04 — Debian 11, 12
- Python 3 installed
- SSH access with a sudo-capable admin user
- No agent required — push-based via SSH

---

## Deliverable 1 — Baseline Audit Script (`cyberaar-baseline.sh`)

The standalone audit script runs **88 security checks** across 8 sections and produces:

- **Terminal output** — colour-coded PASS / WARN / FAIL with a security score
- **HTML report** — self-contained file for sharing with management or auditors
- **JSON report** — machine-readable, suitable for SIEM or CI pipeline ingestion
- **Ansible remediation plan** — targeted `ansible-playbook` commands for every failing check, mapped to the correct role and tag

No Ansible required — pure bash, no dependencies beyond standard Linux tools.

### Install to PATH (optional)

```bash
sudo bash automation/scripts/cyberaar-baseline.sh --install
# Installs to /usr/local/bin/cyberaar-baseline
```

### Run a local audit

```bash
# Without installing
sudo bash automation/scripts/cyberaar-baseline.sh \
  --html-out /tmp/report.html \
  --json-out /tmp/report.json

# After installing to PATH
sudo cyberaar-baseline --output-dir /var/log/cyberaar

# Remote single host
cyberaar-baseline --host 10.0.1.10 --user admin --output-dir /var/log/cyberaar

# Fleet scan from Ansible inventory
cyberaar-baseline --inventory automation/ansible-hardening/inventory/hosts \
  --user admin --output-dir /var/log/cyberaar
```

### What it checks

93 checks across 8 sections — each mapped to a CIS benchmark control:

| Section | Checks | Coverage highlights |
|---|---|---|
| 1. System & OS | 10 | OS support, kernel updates, SELinux/AppArmor, time sync, GRUB perms, Secure Boot, `/dev/shm`, Ctrl-Alt-Del |
| 2. Authentication | 16 | Root lock, empty passwords, password age/complexity, faillock lockout, shell timeout, UID 0 audit, group/gshadow perms, sudo use_pty, sudo logfile |
| 3. SSH Hardening | 15 | 15 sshd_config directives including ciphers, session timeout, banner, PermitEmpty, HostbasedAuth, sshd_config perms |
| 4. Filesystem | 12 | World-writable files, SUID count, noexec mounts, sticky bit, crontab perms, unowned files, SSH key perms |
| 5. Network | 12 | Firewall, IP forwarding, ICMP redirects, SYN cookies, source routing, martian logging, rp_filter, IPv6 RA, wireless disabled |
| 6. Logging & Audit | 8 | auditd, rsyslog, logrotate, audit rules, log size, `audit=1` at boot, journald persistence, remote syslog |
| 7. Integrity | 8 | AIDE, rootkit scanner, suspicious cron, open ports, package GPG check, fail2ban, AIDE DB, cron dir perms |
| 8. Compliance | 12 | Legal banner, /tmp partition, /home+/var partitions, umask, ASLR, kptr_restrict, dmesg_restrict, ptrace, USB blacklist, cron service, cron.allow/at.allow |

Checks that require human judgment are flagged `(manual review required)` in the output — the script highlights them, the operator decides.

> Full reference: [`automation/scripts/README.md`](automation/scripts/README.md)

---

## Deliverable 2 — Ansible Hardening Collection

The Ansible collection (`cyberaar.hardening`) contains **47 hardening roles** organised in parallel pairs — each control area has a `_rhel9` variant and an `_ubuntu` variant (plus some Ubuntu-only roles like `fail2ban`). OS detection is automatic: the playbook applies the correct role set based on `ansible_os_family`.

### The Three-Step Pipeline

```
playbooks/site.yml
│
├── Step 1 — 1_execute_baseline_before.yml    [tags: baseline, before]
│     ├── Copies cyberaar-baseline.sh to each remote host
│     ├── Runs the audit script
│     ├── Fetches HTML + JSON reports back to the control node
│     └── Reports saved to:
│           automation/ansible-hardening/reports/before/<hostname>/
│
├── Step 2 — 2_configure_hardening.yml        [tags: hardening]
│     ├── Verifies OS is supported (RedHat or Debian family)
│     ├── Detects OS family and applies the matching role set
│     ├── 47 roles applied in CIS dependency order:
│     │     kernel → MAC → auth → users → SSH → firewall →
│     │     network → wireless → crypto → audit → integrity →
│     │     time → boot → banner → services → updates →
│     │     coredump → system → mounts → secureboot →
│     │     permissions → sudo → cron → fail2ban
│     └── Each role is independently skippable via <role>_disabled=true
│
└── Step 3 — 3_execute_baseline_after.yml     [tags: baseline, after]
      ├── Re-runs the audit script on each remote host
      ├── Fetches updated HTML + JSON reports
      ├── Reports saved to:
      │     automation/ansible-hardening/reports/after/<hostname>/
      └── Compare before/ vs after/ to measure hardening impact
```

**Report comparison**: After a full pipeline run, open `reports/before/<host>/report.html` and `reports/after/<host>/report.html` side by side to see the security score improvement per control category.

---

### Step 1 — Pre-Hardening Baseline

Captures the security posture of each host **before** any changes are made. This is your baseline measurement.

```bash
# Run Step 1 only
bash automation/scripts/run-hardening.sh -u <admin_user> -t <host_or_group> -s 1

# Or directly with ansible-playbook
ansible-playbook \
  -u <admin_user> -b \
  -i automation/ansible-hardening/inventory/hosts \
  --extra-vars "target=linux_servers" \
  --tags baseline \
  automation/ansible-hardening/playbooks/1_execute_baseline_before.yml
```

Reports are saved locally to `automation/ansible-hardening/reports/before/<hostname>/`.

---

### Step 2 — System Hardening

Applies all applicable CIS-aligned hardening roles to each host. OS detection is automatic — you do not need separate runs for RHEL and Ubuntu hosts.

```bash
# Dry-run (check mode — no changes applied, always start here)
bash automation/scripts/run-hardening.sh -u <admin_user> -t <host_or_group> -s 2 -c

# Apply full hardening
bash automation/scripts/run-hardening.sh -u <admin_user> -t <host_or_group> -s 2

# Apply a specific category only (e.g. SSH)
bash automation/scripts/run-hardening.sh -u <admin_user> -t <host_or_group> -T ssh

# Skip a role without modifying the playbook
bash automation/scripts/run-hardening.sh -u <admin_user> -t <host_or_group> \
  -- --extra-vars "linux_bootloader_password_rhel9_disabled=true"
```

---

### Step 3 — Post-Hardening Baseline

Re-runs the audit on each host to measure the impact of the hardening. The JSON output can also be ingested into a SIEM or dashboard.

```bash
# Run Step 3 only
bash automation/scripts/run-hardening.sh -u <admin_user> -t <host_or_group> -s 3

# Or directly
ansible-playbook \
  -u <admin_user> -b \
  -i automation/ansible-hardening/inventory/hosts \
  --extra-vars "target=linux_servers" \
  --tags baseline \
  automation/ansible-hardening/playbooks/3_execute_baseline_after.yml
```

Reports are saved to `automation/ansible-hardening/reports/after/<hostname>/`.

---

## Running the Pipeline

### The `run-hardening.sh` wrapper (recommended)

The script auto-discovers `ansible-hardening/` by walking up the directory tree — run it from anywhere in the repo.

```
Usage: bash automation/scripts/run-hardening.sh [options]

Options:
  -u USER    SSH admin user              (default: ansible)
  -t TARGET  Ansible host or group       (default: linux_servers)
  -s STEP    Step: 1 | 2 | 3 | all      (default: 2)
  -T TAGS    Override tags for step 2    (default: hardening)
  -K         Prompt for sudo password
  -c         Check mode (--check --diff, no changes applied)
  -h         Show help
```

**Common workflows:**

```bash
# 1. Connectivity check
ansible -i automation/ansible-hardening/inventory/hosts linux_servers -m ping

# 2. Dry-run step 2 on a single Ubuntu host
bash automation/scripts/run-hardening.sh -u ubuntu -t ubuntu-vm-01 -s 2 -c

# 3. Full 3-step pipeline dry-run (baseline → harden → baseline)
bash automation/scripts/run-hardening.sh -u ubuntu -t ubuntu-vm-01 -s all -c

# 4. Apply full pipeline to a Rocky Linux host
bash automation/scripts/run-hardening.sh -u rockylinux -t rocky-vm-01 -s all

# 5. Harden only SSH across all Linux servers
bash automation/scripts/run-hardening.sh -u ansible -t linux_servers -T ssh

# 6. Full pipeline with sudo password prompt
bash automation/scripts/run-hardening.sh -u ansible -t linux_servers -s all -K
```

Logs are automatically saved to `~/logs/<timestamp>-hardening-<target>.log`.

### Direct `ansible-playbook` usage

```bash
# Dry-run step 2 on a single host
ANSIBLE_LOG_PATH=~/logs/$(date +%Y-%m-%d)-hardening.log \
ansible-playbook --diff --check \
  -u <admin_user> -b \
  -i automation/ansible-hardening/inventory/hosts \
  --extra-vars "target=ubuntu-vm-01" \
  --tags hardening \
  automation/ansible-hardening/playbooks/2_configure_hardening.yml

# Apply hardening to an entire group
ANSIBLE_LOG_PATH=~/logs/$(date +%Y-%m-%d)-hardening.log \
ansible-playbook --diff \
  -u <admin_user> -b \
  -i automation/ansible-hardening/inventory/hosts \
  --extra-vars "target=rhel_servers" \
  --tags hardening \
  automation/ansible-hardening/playbooks/2_configure_hardening.yml

# Full 3-step pipeline via site.yml
ansible-playbook --diff \
  -u <admin_user> -b \
  -i automation/ansible-hardening/inventory/hosts \
  --extra-vars "target=linux_servers" \
  automation/ansible-hardening/playbooks/site.yml
```

---

## Hardening Roles Reference

Each control area has **two parallel roles** — one for RHEL 9 family and one for Ubuntu/Debian. Both are applied in a single play; the correct one activates automatically via `ansible_os_family`.

| Control Area | RHEL 9 Role | Ubuntu/Debian Role | CIS Section |
|---|---|---|---|
| Kernel hardening & sysctl | `linux_kernel_hardening_rhel9` | `linux_kernel_hardening_ubuntu` | 3.x, 4.x |
| Mandatory Access Control | `linux_selinux_rhel9` | `linux_apparmor_ubuntu` | 1.6 |
| Authentication & PAM | `linux_authselect_rhel9` | `linux_authselect_ubuntu` | 5.3 |
| User management | `linux_user_management_rhel9` | `linux_user_management_ubuntu` | 5.4, 5.5 |
| SSH hardening | `linux_ssh_hardening_rhel9` | `linux_ssh_hardening_ubuntu` | 5.2 |
| Firewall | `linux_firewalld_rhel9` | `linux_firewall_ubuntu` | 3.5 |
| IP forwarding / network params | `linux_ip_forwarding_rhel9` | `linux_ip_forwarding_ubuntu` | 3.1, 3.2 |
| Crypto policies / TLS | `linux_crypto_policies_rhel9` | `linux_crypto_policies_ubuntu` | 1.10 |
| Auditing & rsyslog | `linux_auditing_rhel9` | `linux_auditing_ubuntu` | 4.1, 4.2 |
| File integrity (AIDE) | `linux_aide_rhel9` | `linux_aide_ubuntu` | 1.4 |
| Time sync (chrony) | `linux_chrony_rhel9` | `linux_chrony_ubuntu` | 2.1.1 |
| Bootloader password | `linux_bootloader_password_rhel9` | `linux_bootloader_password_ubuntu` | 1.5.2 |
| Login banners | `linux_login_banner_rhel9` | `linux_login_banner_ubuntu` | 1.8 |
| Disable unnecessary services | `linux_disable_unnecessary_services_rhel9` | `linux_disable_unnecessary_services_ubuntu` | 2.1 |
| Automatic updates | `linux_dnf_automatic_rhel9` | `linux_unattended_upgrades_ubuntu` | 1.9 |
| Core dump restriction | `linux_core_dumps_rhel9` | `linux_core_dumps_ubuntu` | 1.6.4 |
| Ctrl-Alt-Del disable | `linux_ctrl_alt_del_rhel9` | `linux_ctrl_alt_del_ubuntu` | 1.6.1 |
| /tmp & /dev/shm mounts | `linux_tmp_mounts_rhel9` | `linux_tmp_mounts_ubuntu` | 1.1.x |
| Secure Boot | `linux_secure_boot_rhel9` | `linux_secure_boot_ubuntu` | 1.5.1 |
| File permissions | `linux_file_permissions_rhel9` | `linux_file_permissions_ubuntu` | 6.1 |
| Fail2ban | `linux_fail2ban_rhel9` | `linux_fail2ban_ubuntu` | — |
| Wireless interfaces | `linux_wireless_rhel9` | `linux_wireless_ubuntu` | 3.1.2 |
| Sudo hardening | `linux_sudo_hardening_rhel9` | `linux_sudo_hardening_ubuntu` | 1.3.2–1.3.3 |
| Cron hardening | `linux_cron_hardening_rhel9` | `linux_cron_hardening_ubuntu` | 5.1 |

**RHEL 9 technology stack**: `firewalld`, `SELinux`, `dnf-automatic`, `authselect`, `grub2`

**Ubuntu/Debian technology stack**: `ufw`, `AppArmor`, `unattended-upgrades`, `PAM`, `grub`

### Role internal structure

Each role uses a two-file task pattern:

```
roles/<role_name>/
├── defaults/main.yml   # All tunable variables with safe defaults
├── handlers/main.yml   # Service restart / reload handlers
└── tasks/
    ├── main.yml        # Gating only: checks <role_name>_disabled, then imports tasks.yml
    └── tasks.yml       # Actual task implementation
```

To **disable any role** without modifying the playbook:

```bash
# Via run-hardening.sh extra-vars
ansible-playbook ... --extra-vars "linux_bootloader_password_rhel9_disabled=true"

# Or set in group_vars/host_vars
linux_aide_ubuntu_disabled: true
```

---

## Tag Reference

Use tags to run only a subset of the pipeline. All tags work with both `--tags` and `--skip-tags`.

| Tag | Roles activated |
|-----|----------------|
| `hardening` | All hardening roles |
| `kernel`, `sysctl` | `linux_kernel_hardening_*`, `linux_ip_forwarding_*` |
| `mac` | `linux_selinux_rhel9`, `linux_apparmor_ubuntu` |
| `auth`, `pam` | `linux_authselect_*` |
| `users` | `linux_user_management_*` |
| `ssh` | `linux_ssh_hardening_*` |
| `firewall` | `linux_firewalld_rhel9`, `linux_firewall_ubuntu` |
| `network` | `linux_ip_forwarding_*`, firewall roles |
| `crypto`, `tls` | `linux_crypto_policies_*` |
| `audit`, `logging` | `linux_auditing_*` |
| `integrity`, `aide` | `linux_aide_*` |
| `time`, `ntp` | `linux_chrony_*` |
| `boot`, `grub` | `linux_bootloader_password_*` |
| `secureboot` | `linux_secure_boot_*` |
| `banner` | `linux_login_banner_*` |
| `services` | `linux_disable_unnecessary_services_*` |
| `updates`, `patching` | `linux_dnf_automatic_rhel9`, `linux_unattended_upgrades_ubuntu` |
| `coredump` | `linux_core_dumps_*` |
| `system` | `linux_ctrl_alt_del_*` |
| `mounts`, `filesystem` | `linux_tmp_mounts_*`, `linux_file_permissions_*` |
| `permissions` | `linux_file_permissions_*` |
| `fail2ban` | `linux_fail2ban_rhel9`, `linux_fail2ban_ubuntu` |
| `wireless` | `linux_wireless_rhel9`, `linux_wireless_ubuntu` |
| `sudo` | `linux_sudo_hardening_rhel9`, `linux_sudo_hardening_ubuntu` |
| `cron` | `linux_cron_hardening_rhel9`, `linux_cron_hardening_ubuntu` |
| `baseline` | Baseline audit steps (Steps 1 & 3) |
| `before` | Step 1 only |
| `after` | Step 3 only |

---

## Inventory & Variable Configuration

### Inventory file — `inventory/hosts` (INI format)

```ini
[rhel_servers]
rocky-vm-01    index="139"

[ubuntu_servers]
ubuntu-vm-01   index="132"

[dmz_servers]
# Hosts here receive stricter thresholds via group_vars/dmz_servers.yml

[linux_servers:children]
rhel_servers
ubuntu_servers
# dmz_servers intentionally excluded — managed separately
```

Each host's `ansible_host` IP is derived from the `index` variable combined with a network prefix defined in `group_vars/rhel_servers.yml` or `group_vars/ubuntu_servers.yml`.

The naming convention for hosts follows: `<role>.<site>-<env>-<os>-<idx>.corp.example.com`
- `site`: geographic code (e.g. `dk` = Dakar, `th` = Thiès)
- `env`: `pr` = prod, `st` = staging, `dv` = dev
- `os`: `rh` = RHEL, `ku` = Ubuntu

### Variable precedence (low → high)

```
group_vars/linux_servers.yml        ← shared defaults
  └── group_vars/rhel_servers.yml   ← RHEL-specific overrides
  └── group_vars/ubuntu_servers.yml ← Ubuntu-specific overrides
        └── group_vars/dmz_servers.yml ← DMZ stricter overrides
              └── host_vars/<hostname>.yml ← per-host overrides
                    └── --extra-vars at runtime ← highest precedence
```

Every role's `defaults/main.yml` exposes all tunable parameters. Review them before running to understand what will be applied in your environment.

---

## Sensitive Variables

The bootloader password must **never** be committed or stored in inventory. Set it in your shell immediately before running the pipeline, then unset it:

```bash
# Set before running
read -sr LINUX_BOOTLOADER_PASSWORD
export LINUX_BOOTLOADER_PASSWORD

# Run the pipeline
bash automation/scripts/run-hardening.sh -u <admin_user> -t <target> -s all

# Unset immediately after
unset LINUX_BOOTLOADER_PASSWORD
```

If `LINUX_BOOTLOADER_PASSWORD` is not set, `run-hardening.sh` will warn and the `linux_bootloader_password_*` roles will be skipped automatically.

---

## Report Output

After running Steps 1 and 3, HTML and JSON reports are saved locally:

```
automation/ansible-hardening/reports/
├── before/
│   └── <hostname>/
│       ├── report.html     # Human-readable audit report (pre-hardening)
│       └── report.json     # Machine-parseable report (pre-hardening)
└── after/
    └── <hostname>/
        ├── report.html     # Human-readable audit report (post-hardening)
        └── report.json     # Machine-parseable report (post-hardening)
```

Open `before/` and `after/` HTML reports side by side to visualise the security score improvement per control category. The JSON reports can be ingested into a SIEM, Elasticsearch, or a custom dashboard.

---

## Practices & Knowledge Base

Community-maintained security guides adapted for the Senegalese context:

- `practices/` — Best practices per topic (hardening, access control, incident response, network security…)
- `translations/` — French versions of all guides
- `examples/` — Senegal-specific templates, sample inventory files, and baseline report examples

---

## Goal & Target Sectors

Build a **free, community-maintained security toolkit** that provides practical, context-adapted tools and guides for:

- Government & public administration
- Energy & utilities
- Finance & banking
- Telecom & critical systems
- Healthcare & transport

---

## How to Contribute

No long commitments required — add one improvement when you have 10 minutes.

1. **Browse** existing sections or suggest new ones via [Issues](https://github.com/Bantou96/Aar-Act/issues)
2. **Fork** this repo or create a branch
3. **Add or edit** — hardening roles in `automation/ansible-hardening/roles/`, guides in `practices/`
4. **Submit** a Pull Request — reference the CIS benchmark section when adding hardening controls
5. Get **credit** in the Contributors list

New hardening roles should follow the `linux_<category>_<rhel9|ubuntu>` naming convention and include parallel RHEL9 and Ubuntu implementations.

**Contributing to the baseline script:** `cyberaar-baseline.sh` is a generated bundle — do not edit it directly. Edit the source files under `automation/scripts/src/`, then rebuild:

```bash
bash automation/scripts/build.sh
bash -n automation/scripts/cyberaar-baseline.sh   # verify syntax
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

---

## License

**GNU General Public License v3.0**

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

See the [LICENSE](LICENSE) file for the full text.

© 2025–2026 CyberAar Team

---

## Contributors

- [@Bantou96](https://github.com/Bantou96) — Founder

---

*#Cybersecurity #Senegal #AarAct #CyberAar*
