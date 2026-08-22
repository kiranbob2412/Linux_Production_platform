#!/bin/bash
echo "=========================================="
echo " CRON STATUS"
echo "=========================================="
echo
echo "Current User crontab:"
crontab -l 2>/dev/null || echo "No crontab configured."
echo
echo "Cron Service:"
if command -v systemctl >/dev/null 2>&1; then
systemctl is-active cron 2>/dev/null ||
systemctl is-active crond 2>/dev/null ||
echo "Cron service is not active"
fi
