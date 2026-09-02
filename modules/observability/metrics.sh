#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "SYSTEM METRICS"

echo "CPU / Uptime:"
uptime

echo
echo "Memory:"
free -h

echo
echo "Load:"
cat /proc/loadavg

echo
echo "Disk:"
df -h

echo
echo "Top CPU processes:"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -10

obs_report "System metrics collection completed."
