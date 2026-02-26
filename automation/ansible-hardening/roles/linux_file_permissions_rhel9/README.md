# linux_file_permissions_rhel9

## Purpose
Hardens file permissions and default umask per CIS RHEL 9 Benchmark section 6.x & 5.4.x  
- Strict mode on /etc/shadow, /boot/grub.cfg, SSH keys, logs  
- umask 027 system-wide  
- su restricted to wheel group  
- Optional world-writable scan/report

## CIS Coverage
- 6.1.1 Ensure permissions on /etc/passwd are 0644  
- 6.1.2 Ensure permissions on /etc/shadow are 0000 or 0640  
- 6.1.10 Ensure permissions on /boot/grub* are restricted  
- 5.4.1.1 Ensure default user umask is 027  
- 5.7 Ensure access to su is restricted to wheel group

## Idempotence
- `file` module + `lineinfile` → only changes if needed  
- World-writable find is read-only by default (safety first)

## Variables Highlights
```yaml
linux_umask_default: "027"
linux_critical_files: [...]   # extend with your own
linux_remove_world_writable: false   # enable only after dry-run
