#!/bin/bash
set -u

PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
CONFIG="$PROJECT_ROOT/config/observability/loki/loki.yml"

echo "======================================"
echo "LOKI CONFIGURATION"
echo "======================================"

if [ ! -f "$CONFIG" ]; then
    echo "Configuration: NOT FOUND"
    echo "Expected: $CONFIG"
    exit 1
fi

required_patterns=(
    "http_listen_port: 3100"
    "path_prefix: /var/lib/loki"
    "store: tsdb"
    "object_store: filesystem"
)

for pattern in "${required_patterns[@]}"; do
    if grep -Fq "$pattern" "$CONFIG"; then
        echo "PASS: $pattern"
    else
        echo "FAIL: $pattern"
        exit 1
    fi
done

echo
echo "Loki configuration: VALID"
