#!/bin/bash
echo "=========================================="
echo " PERFORMANCE ANALYSIS"
echo "=========================================="
echo
echo "CPU / Load:"
uptime
echo "Memory"
free -h
echo "Disk:"
df -h
echo
echo "Top CPU Processes:"
ps aux --sort=-%cpu | head -6
echo
echo "Top Memory Processes:"
ps aux --sort=-%mem | head -6
