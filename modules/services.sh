#!/bin/bash
echo "=========================================="
echo " SERVICE HEALTH"
echo "=========================================="
echo
if command -v systemctl >/dev/null 2>&1; then
echo "Failed Services:"
systemctl --failed --no-pager
echo
echo "Running Services:"
systemctl lists-units --type=service --state=running --no-pager | head -20
else
echo "systemctl is not available in this environment."
fi
