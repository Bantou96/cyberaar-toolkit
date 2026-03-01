# Role: linux_ctrl_alt_del_rhel9

## Purpose

Disables Ctrl+Alt+Del key combination to prevent immediate system reboot from console/physical access (evil maid / local attack vector).

## CIS Coverage

- 1.4.4 Ensure Ctrl-Alt-Del is disabled (L1)

## Variables

| Variable                     | Default | Description                     |
|------------------------------|---------|---------------------------------|
| linux_ctrl_alt_del_enabled   | true    | Apply the hardening             |
| linux_ctrl_alt_del_disabled  | false   | Skip role                       |

## Testing

```bash
systemctl is-enabled ctrl-alt-del.target   # → masked
