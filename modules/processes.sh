#!/bin/bash
echo "=========================================="
echo " PROCESS MONITORING"
echo "=========================================="
echo
echo "System Load:"
uptime
echo
echo "Top CPU Processes:"
ps aux --sort=-%cpu | head -11
echo
echo "Top Memory Processes:"
ps aux --sort=-%mem | head -11
echo
echo "Total Processes:"
ps -e --no-headers | wc -l
