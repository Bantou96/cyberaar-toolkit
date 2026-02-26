# Role: linux_firewalld_rhel9

## Purpose

Configures firewalld to minimize attack surface:  
- Default zone = drop (blocks unsolicited inbound)  
- Allows only explicit services/ports (default: SSH)  
- Restricts SSH to trusted source IPs + rate limiting  
- Logs dropped packets for monitoring

## CIS Coverage

- 4.2.1 Ensure firewalld installed & enabled (L1)
- 4.2.2 Ensure default zone is drop (L1 Server)
- 4.2.3–4.2.x Ensure unnecessary services/ports removed

## Variables

| Variable                           | Default       | Description                                             |
|------------------------------------|---------------|---------------------------------------------------------|
| linux_firewalld_default_zone       | drop          | drop / public / internal                                |
| linux_firewalld_allowed_services   | ["ssh"]       | List of services to allow                               |
| linux_firewalld_allowed_ports      | []            | Additional ports e.g. ["443/tcp"]                       |
| linux_firewalld_ssh_sources        | []            | Restrict SSH to these CIDRs/IPs (highly recommended)    |
| linux_firewalld_ssh_rate_limit     | "3/m"         | SSH rate limit (rich rule)                              |
| linux_firewalld_log_denied         | all           | Log dropped packets: all / unicast / off                |

## Usage Example

```yaml
- role: linux_firewalld_rhel9
  vars:
    linux_firewalld_default_zone: drop
    linux_firewalld_ssh_sources:
      - "192.168.10.0/24"
      - "203.0.113.50"
    linux_firewalld_allowed_ports:
      - "443/tcp"
