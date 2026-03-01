# Role: linux_core_dumps_rhel9

## Purpose

Hardens core dump behavior to prevent sensitive data leaks from crashed processes:  
- Disables core dumps globally (`* hard core 0`)  
- Disables setuid core dumps (`fs.suid_dumpable = 0`)  
- Redirects core files to `/dev/null` (`kernel.core_pattern`)

## CIS Coverage

- 1.5.4 Ensure core dumps are restricted (L1)  
- 5.4.1.3 Ensure core dumps are disabled for setuid programs

## Variables

| Variable                        | Default       | Description                                           |
|---------------------------------|---------------|-------------------------------------------------------|
| linux_core_dumps_limit          | "0"           | Core file size limit (0 = disabled)                   |
| linux_core_suid_dumpable        | "0"           | fs.suid_dumpable (0 = disable setuid cores)           |
| linux_core_pattern              | "/dev/null"   | Where to store core files (null = discard)            |
| linux_core_dumps_disabled       | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_core_dumps_rhel9
  vars:
    linux_core_dumps_limit: "0"
    linux_core_pattern: "/dev/null"
