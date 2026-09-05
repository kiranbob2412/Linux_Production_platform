#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

MODULE="$PROJECT_ROOT/modules/security/audit_policy.sh"
SOURCE_RULES="$PROJECT_ROOT/config/security/audit/rules/50-linux-production-platform.rules"
RUNTIME_RULES="/etc/audit/rules.d/50-linux-production-platform.rules"

EXPECTED_RULES=(
    "-w /etc/passwd -p wa -k identity"
    "-w /etc/group -p wa -k identity"
    "-w /etc/shadow -p wa -k identity"
    "-w /etc/gshadow -p wa -k identity"
    "-w /etc/sudoers -p wa -k privilege"
    "-w /etc/sudoers.d/ -p wa -k privilege"
    "-w /etc/pam.d/ -p wa -k authentication"
)

test -x "$MODULE"
test -f "$SOURCE_RULES"

sudo test -f "$RUNTIME_RULES"
sudo cmp -s "$SOURCE_RULES" "$RUNTIME_RULES"

sudo test -f /etc/audit/audit.rules

sudo augenrules --check >/dev/null 2>&1

KERNEL_RULES="$(sudo auditctl -l 2>/dev/null)"

for rule in "${EXPECTED_RULES[@]}"; do
    normalized_rule="$(printf '%s\n' "$rule" |
        sed -E 's#(/etc/[^ ]*)/([[:space:]])#\1\2#')"

    printf '%s\n' "$KERNEL_RULES" |
        grep -Fxq -- "$rule" ||
    printf '%s\n' "$KERNEL_RULES" |
        grep -Fxq -- "$normalized_rule"
done

AUDIT_STATUS="$(sudo auditctl -s 2>/dev/null)"

printf '%s\n' "$AUDIT_STATUS" |
    grep -q '^enabled[[:space:]]\+1'

printf '%s\n' "$AUDIT_STATUS" |
    grep -q '^lost[[:space:]]\+0'

bash "$MODULE" >/dev/null

echo "AUDIT_POLICY_TEST: PASS"
