#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$ROOT/modules/cloud_networking"

FAILURES=0

for file in "$DIR"/*.sh; do
    if bash -n "$file"; then
        echo "PASS: syntax $(basename "$file")"
    else
        echo "FAIL: syntax $(basename "$file")"
        FAILURES=$((FAILURES + 1))
    fi
done

REQUIRED=(
    aws_common.sh
    aws_vpc.sh
    aws_subnets.sh
    aws_route_tables.sh
    aws_gateways.sh
    aws_ipv6.sh
    aws_network_master.sh
)

for file in "${REQUIRED[@]}"; do
    if [ -f "$DIR/$file" ]; then
        echo "PASS: module $file"
    else
        echo "FAIL: missing $file"
        FAILURES=$((FAILURES + 1))
    fi
done

if [ "$FAILURES" -eq 0 ]; then
    echo
    echo "PASS: AWS NETWORKING FOUNDATION TEST"
    exit 0
fi

echo
echo "FAIL: AWS NETWORKING FOUNDATION TEST"
exit 1
