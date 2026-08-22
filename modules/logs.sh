#!/bin/bash
SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_ROOT/logs"
echo "=========================================="
echo " LOG ANALYSIS"
echo "=========================================="
echo
echo "Project Logs:"
ls -hl "$LOG_DIR"
echo
echo "Recent Log Entries:"
for file in "$LOG_DIR"/*.log; do
if [ -f "$file" ]; then
echo
echo "--- $file ---"
tail -20 "$file"
fi
done

echo
echo "ERROR Count:"
grep -Rci "error" "$LOG_DIR" 2>/dev/null || true
echo
echo "WARNING Count:"
grep -Rci "warning" "$LOG_DIR" 2>/dev/null || true
