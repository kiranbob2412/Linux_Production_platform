#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/../common.sh"

PROJECT_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
CONFIG="$PROJECT_ROOT/config/observability/tempo/tempo.yml"

obs_section "TEMPO CONFIGURATION"

if [[ ! -f "$CONFIG" ]]; then
    echo "Tempo project configuration missing: $CONFIG"
    exit 1
fi

grep -q 'http_listen_port: 3200' "$CONFIG"
grep -q 'grpc_listen_port: 9095' "$CONFIG"
grep -q 'endpoint: 127.0.0.1:4327' "$CONFIG"
grep -q 'endpoint: 127.0.0.1:4328' "$CONFIG"
grep -q 'backend: local' "$CONFIG"

echo "Tempo configuration: VALID"
obs_report "Tempo project configuration validated."
