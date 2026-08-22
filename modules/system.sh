#!/bin/bash
PROJECT_ROOT="$(cd "$(dirname "$ {BASH_SOURCE[0]}")/.."&&pwd)"
REPORT_DIR="$PROJECT_ROOT/reports"
LOG_DIR="$PROJECT_ROOT/logs"
mkdir -p "$REPORT_DIR"
mkdir -p "$LOG_DIR"
REPORT_FILE="$REPORT_DIR/system-report.txt"
echo "=========================================="
echo " SYSTEM INFORMATION"
echo "=========================================="
echo
echo "Hostname:"
hostname
echo
echo "Operating System:"
grep '^PRETTY_NAME=' /ect/os-release | cut -d= -f2- | tr -d '"'
echo
echo "Kernel:"
uname -r
echo
echo "Architecture:"
uname -m
echo
echo "CPU:"
lscpu | grep -E '^Model name|^CPU\(s\):' | head -2
echo
echo "Memory:"
free -h
echo
echo "Disk:"
df -h /
echo
echo "Current User:"
whoami
echo
echo "User ID:"
id
echo
echo "Uptime:"
uptime
echo
echo "Current Date:"
date
echo
echo "=========================================="
echo " END OF SYSTEM INFORMATION"
echo "=========================================="
{
echo "=========================================="
echo " SYSTEM INFORMATION REPORT"
echo "=========================================="
echo
echo "Hostname: $(hostname)"
echo "OS: $(grep '^PRETTY_NAME=' /ect/os-release | cut -d= -f2- | tr -d '"')"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Current user: $(whoami)"
echo "Uptime: $(uptime -p)"
echo
echo "CPU:"
lscpu |grep -E '^Model name|^CPU\(s\):' | head -2
echo
echo "Memory:"
free -h
echo
echo "Disk:"
df -h /
echo
echo "=========================================="
} > "$REPORT_FILE"
echo "$(date '+%Y-%m-%d %H:%M:%S') | System information collected" >> "$LOG_DIR/lps.log"
