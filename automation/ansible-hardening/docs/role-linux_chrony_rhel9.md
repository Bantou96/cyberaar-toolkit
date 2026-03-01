# Role: linux_chrony_rhel9

## Purpose

Hardens Chrony (default NTP implementation on RHEL 9):  
- Ensures Chrony is installed and running  
- Configures trusted NTP sources/peers  
- Enables NTS (secure NTP) when available  
- Restricts access to prevent abuse (rogue queries, amplification attacks)  
- Sets logging and driftfile for auditability

## CIS Coverage

- 2.2.1 Ensure chrony is enabled and configured  
- 2.2.2 Ensure chrony is using NTP servers with authentication (NTS or symmetric keys)  
- 2.2.3 Ensure chrony restricts access to trusted networks

## Variables

| Variable                    | Default       | Description                                           |
|-----------------------------|---------------|-------------------------------------------------------|
| linux_chrony_mode           | client        | client / server / both                                |
| linux_chrony_servers        | pool.ntp.org  | List of trusted NTP servers/peers                     |
| linux_chrony_use_nts        | true          | Enable NTS (Network Time Security)                    |
| linux_chrony_allow          | [127.0.0.1]   | Networks allowed to query (restrict others)           |
| linux_chrony_disabled       | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_chrony_rhel9
  vars:
    linux_chrony_servers:
      - "time.google.com iburst"
      - "time.cloudflare.com iburst"
      - "ntp.se iburst"
    linux_chrony_use_nts: true
    linux_chrony_allow:
      - "192.168.10.0/24"
