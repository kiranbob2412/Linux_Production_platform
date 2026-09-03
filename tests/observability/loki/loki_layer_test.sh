#!/bin/bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"

CONFIG="$PROJECT_ROOT/config/observability/loki/loki.yml"
CONFIG_MODULE="$PROJECT_ROOT/modules/observability/loki/loki_config.sh"
HEALTH_MODULE="$PROJECT_ROOT/modules/observability/loki/loki_health.sh"
MASTER="$PROJECT_ROOT/modules/observability/loki/loki.sh"

echo "=== Loki Layer Test ==="

test -f "$CONFIG"
test -x "$CONFIG_MODULE"
test -x "$HEALTH_MODULE"
test -x "$MASTER"

grep -q "http_listen_port: 3100" "$CONFIG"
grep -q "path_prefix: /var/lib/loki" "$CONFIG"
grep -q "store: tsdb" "$CONFIG"
grep -q "object_store: filesystem" "$CONFIG"

echo "Loki configuration structure: PASS"
echo "Loki module structure: PASS"
echo "Loki layer test: PASS"
