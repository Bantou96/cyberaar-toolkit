# Role: linux_ip_forwarding_rhel9

## Purpose

Disables IP forwarding and accept_redirects to prevent the server from acting as a router or accepting spoofed redirect packets:  
- net.ipv4.ip_forward = 0  
- net.ipv6.conf.all.forwarding = 0  
- net.*.conf.all.accept_redirects = 0

## CIS Coverage

- 3.3.1 Ensure IP forwarding is disabled (L1)  
- 3.3.2 Ensure packet redirect sending is disabled (L1)  
- 3.3.3 Ensure IPv6 packet redirect sending is disabled (L1)

## Variables

| Variable                        | Default       | Description                                           |
|---------------------------------|---------------|-------------------------------------------------------|
| linux_ip_forwarding             | "0"           | net.ipv4.ip_forward (0 = disabled)                    |
| linux_ipv6_forwarding           | "0"           | net.ipv6.conf.all.forwarding (0 = disabled)           |
| linux_accept_redirects          | "0"           | net.*.conf.all.accept_redirects (0 = disabled)        |
| linux_ip_forwarding_disabled    | false         | Skip entire role                                      |

## Usage Example

```yaml
- role: linux_ip_forwarding_rhel9
  vars:
    linux_ip_forwarding: "0"
    linux_accept_redirects: "0"
