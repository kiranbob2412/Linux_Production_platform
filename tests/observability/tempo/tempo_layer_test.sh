#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"

CONFIG="$PROJECT_ROOT/config/observability/tempo/tempo.yml"
MODULE="$PROJECT_ROOT/modules/observability/tempo/tempo_master.sh"

test -f "$CONFIG"
test -x "$MODULE"

grep -q 'target: all' "$CONFIG"
grep -q 'http_listen_port: 3200' "$CONFIG"
grep -q 'grpc_listen_port: 9095' "$CONFIG"
grep -q '127.0.0.1:4327' "$CONFIG"
grep -q '127.0.0.1:4328' "$CONFIG"
grep -q 'backend: local' "$CONFIG"

echo "TEMPO_LAYER_TEST: PASS"
