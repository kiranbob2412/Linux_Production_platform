#!/bin/bash
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "=========================================="
echo " FILE MANAGEMENT"
echo "Total Files:"
find "$PROJECT_ROOT" -type f | wc -l
echo
echo "Total Directories:"
find"$PROJECT_ROOT" -type d | wc -l
echo
echo "Project Files:"
find "$PROJECT_ROOT" -type f |head -20
echo
echo "Largest Project Files:"
find "$PROJECT_ROOT" -type f -exec du -h {} + 2>/dev/null |sort -h |tail -10
