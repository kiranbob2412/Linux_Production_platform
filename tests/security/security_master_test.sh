#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

MODULE="$PROJECT_ROOT/modules/security/host_hardening.sh"
MASTER="$PROJECT_ROOT/modules/security/security_master.sh"

test -d "$PROJECT_ROOT/modules/security"
test -d "$PROJECT_ROOT/tests/security"

test -x "$MODULE"
test -x "$MASTER"

bash "$MASTER" >/dev/null

echo "SECURITY_MASTER_TEST: PASS"
