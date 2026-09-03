#!/bin/bash

set -u

echo "======================================"
echo "LOKI HEALTH"
echo "======================================"

if command -v curl >/dev/null 2>&1; then
    if curl -fsS --max-time 5 \
        http://127.0.0.1:3100/ready >/dev/null 2>&1; then

        echo "Loki: HEALTHY"
        exit 0
    else
        echo "Loki: NOT AVAILABLE"
        exit 1
    fi
else
    echo "curl: NOT FOUND"
    exit 1
fi
