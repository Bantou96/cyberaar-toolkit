# linux_disable_unnecessary_services_rhel9

## Purpose
Reduces attack surface by disabling/masking/removing services not required on production servers.  
Follows CIS RHEL 9 Benchmark Section 2.x (Remove or Disable Services).

## Targeted OS
Red Hat Enterprise Linux 9, AlmaLinux 9, Rocky Linux 9

## CIS References (v2.0.0)
- 2.1 Remove or Disable Daemons (e.g. avahi-daemon, cups, bluetooth)
- 2.2.1 Ensure chrony is enabled (or timesyncd) – we keep chronyd by default
- 2.3 Remove unnecessary file systems / services

## Idempotence
- Uses service_facts + package_facts → acts only if needed
- Masking is stronger than disable (prevents unit start even manually)

## Variables Highlights
```yaml
linux_services_to_mask:
  - "avahi-daemon"
  - "cups"
linux_packages_to_remove.enabled: false   # set true to purge packages
linux_services_exceptions: ["chronyd"]    # keep your NTP
