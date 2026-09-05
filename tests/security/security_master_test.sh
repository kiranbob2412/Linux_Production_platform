#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

MASTER="$PROJECT_ROOT/modules/security/security_master.sh"

HOST_HARDENING_TEST="$PROJECT_ROOT/tests/security/host_hardening_test.sh"
AUDIT_TEST="$PROJECT_ROOT/tests/security/audit_test.sh"
AUDIT_POLICY_TEST="$PROJECT_ROOT/tests/security/audit_policy_test.sh"

test -d "$PROJECT_ROOT/modules/security"
test -d "$PROJECT_ROOT/tests/security"

test -x "$MASTER"
test -x "$HOST_HARDENING_TEST"
test -x "$AUDIT_TEST"
test -x "$AUDIT_POLICY_TEST"

bash "$HOST_HARDENING_TEST"
bash "$AUDIT_TEST"
bash "$AUDIT_POLICY_TEST"

bash "$MASTER" >/dev/null

echo "SECURITY_MASTER_TEST: PASS"
