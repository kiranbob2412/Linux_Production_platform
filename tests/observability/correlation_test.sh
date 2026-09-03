#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODULE="$PROJECT_ROOT/modules/observability/correlation.sh"

test -x "$MODULE"
command -v ps >/dev/null 2>&1
command -v ss >/dev/null 2>&1
command -v curl >/dev/null 2>&1

ps -e --no-headers >/dev/null
ss -tunH >/dev/null

curl -fsS --max-time 5 \
    http://127.0.0.1:9090/-/ready >/dev/null

curl -fsS --max-time 5 \
    http://127.0.0.1:3100/ready >/dev/null

curl -fsS --max-time 5 \
    http://127.0.0.1:3200/ready >/dev/null

echo "CORRELATION_TEST: PASS"
