#!/bin/bash
echo "=========================================="
echo " SSH HEALTH"
echo "=========================================="
echo
echo "SSH Client:"
ssh -V 2>&1
echo echo "SSH Configuration:"
if [ -f /etc/ssh/sshd_config ]; then
echo "/etc/ssh/sshd_config exists"
else
echo "SSH server configuration not found"
fi
echo
echo "SSH Services:"
if command -v systemctl >/dev/null 2>&1; then
systemctl is -active ssh 2>/dev/null ||
systemctl is-active sshd 2>/dev/null ||
echo "SSH services not active"
fi
