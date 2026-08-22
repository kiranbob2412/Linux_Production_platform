#!/bin/bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}").." && pwd)"
echo "=========================================="
echo "FILESYSTEM ANALYSIS"
echo "=========================================="
echo
echo "Disk usage:"
df -h
echo
echo "Filesystem Types:"
df -hT
echo
echo "Project Directory Size:"
du -sh "$PROJECT_ROOT"
echo
echo "Mount Information:"
findmnt 2>/dev/null | head -20
