#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODULE="$PROJECT_ROOT/modules/observability/flow_logs.sh"

test -x "$MODULE"
command -v ss >/dev/null 2>&1
command -v ip >/dev/null 2>&1
command -v tcpdump >/dev/null 2>&1

ip -br link >/dev/null
ss -s >/dev/null

echo "FLOW_LOGS_TEST: PASS"
