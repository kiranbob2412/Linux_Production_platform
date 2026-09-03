#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "LOKI MASTER"
echo "======================================"

"$SCRIPT_DIR/loki_config.sh"

echo

"$SCRIPT_DIR/loki_runtime.sh"

echo
echo "LOKI MASTER: PASS"
