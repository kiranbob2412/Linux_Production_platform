#!/bin/bash
set -u

BASE="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "SECURITY ENGINEERING"
echo "======================================"

modules=(
    host_hardening.sh
    audit.sh
    audit_policy.sh
)

failed=0

for module in "${modules[@]}"; do
    echo
    echo ">>> Running: $module"

    if bash "$BASE/$module"; then
        echo "STATUS: PASS"
    else
        echo "STATUS: FAIL"
        failed=$((failed + 1))
    fi
done

echo
echo "======================================"

if [[ "$failed" -eq 0 ]]; then
    echo "SECURITY HEALTH: PASS"
    exit 0
else
    echo "SECURITY HEALTH: DEGRADED"
    exit 1
fi
