#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "======================================"
echo "TEMPO MASTER"
echo "======================================"

"$SCRIPT_DIR/tempo_config.sh"

echo
"$SCRIPT_DIR/tempo_runtime.sh"

echo
echo "TEMPO MASTER: PASS"
