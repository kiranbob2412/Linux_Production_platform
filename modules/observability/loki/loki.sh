#!/bin/bash

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "LOKI OBSERVABILITY LAYER"
echo "======================================"

echo
"$SCRIPT_DIR/loki_config.sh"

echo
"$SCRIPT_DIR/loki_health.sh"
