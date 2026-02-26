# Role: linux_kernel_hardening_rhel9

## Purpose

Hardens the Linux kernel via sysctl parameters and module blacklisting:  
- Enables ASLR, restricts ptrace, hides kernel pointers  
- Mitigates network spoofing, SYN floods, redirects  
- Disables unused/risky kernel modules (filesystems, USB storage, FireWire, etc.)

## CIS Coverage

- 1.5 Kernel Parameters (ASLR, ptrace_scope, dmesg_restrict, kptr_restrict)  
- 3.3 Network Parameters (rp_filter, accept_redirects=0, tcp_syncookies=1)  
- 1.1.1 Disable unused filesystem modules

## Variables

| Variable                              | Default       | Description                                           |
|---------------------------------------|---------------|-------------------------------------------------------|
| linux_kernel_apply_aslr               | true          | kernel.randomize_va_space = 2                         |
| linux_kernel_apply_network_ipv4       | true          | rp_filter=1, no redirects, tcp_syncookies=1, etc.     |
| linux_kernel_blacklist_filesystems    | true          | Disable cramfs, hfs, squashfs, udf, etc.              |
| linux_kernel_blacklist_usb_storage    | true          | Prevent rogue USB devices                             |
| linux_kernel_blacklist_firewire       | false         | High-risk legacy interface                            |
| linux_kernel_sysctl_file              | /etc/sysctl.d/99-cis-kernel-hardening.conf | Config file path            |

## Usage Example

```yaml
- role: linux_kernel_hardening_rhel9
  vars:
    linux_kernel_blacklist_usb_storage: true
    linux_kernel_apply_network_ipv6: true
