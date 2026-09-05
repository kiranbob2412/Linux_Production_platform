#!/bin/bash
set -u

source "$(dirname "$0")/../observability/common.sh"

obs_section "LINUX AUDIT POLICY"

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

SOURCE_RULES="$PROJECT_ROOT/config/security/audit/rules/50-linux-production-platform.rules"
RUNTIME_RULES="/etc/audit/rules.d/50-linux-production-platform.rules"

FAILURES=0
HEALTHY=0
TOTAL=8

EXPECTED_RULES=(
    "-w /etc/passwd -p wa -k identity"
    "-w /etc/group -p wa -k identity"
    "-w /etc/shadow -p wa -k identity"
    "-w /etc/gshadow -p wa -k identity"
    "-w /etc/sudoers -p wa -k privilege"
    "-w /etc/sudoers.d/ -p wa -k privilege"
    "-w /etc/pam.d/ -p wa -k authentication"
)

echo "Policy source:"
if [[ -f "$SOURCE_RULES" ]]; then
    echo "  PRESENT"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  NOT FOUND"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Policy validation:"

RULE_VALIDATION_FAILED=0

if [[ -f "$SOURCE_RULES" ]]; then
    for rule in "${EXPECTED_RULES[@]}"; do
        if grep -Fxq -- "$rule" "$SOURCE_RULES"; then
            echo "  PASS: $rule"
        else
            echo "  FAIL: $rule"
            RULE_VALIDATION_FAILED=1
        fi
    done
fi

if [[ "$RULE_VALIDATION_FAILED" -eq 0 && -f "$SOURCE_RULES" ]]; then
    HEALTHY=$((HEALTHY + 1))
else
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Runtime policy:"

if sudo test -f "$RUNTIME_RULES"; then
    echo "  PRESENT"

    if sudo cmp -s "$SOURCE_RULES" "$RUNTIME_RULES"; then
        echo "  MATCHES PROJECT POLICY"
        HEALTHY=$((HEALTHY + 1))
    else
        echo "  DOES NOT MATCH PROJECT POLICY"
        FAILURES=$((FAILURES + 1))
    fi
else
    echo "  NOT INSTALLED"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Generated audit.rules:"

if sudo test -f /etc/audit/audit.rules; then
    echo "  PRESENT"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Loader state:"

if sudo augenrules --check >/dev/null 2>&1; then
    echo "  CONSISTENT"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  CHANGES REQUIRED"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Kernel policy:"

KERNEL_RULES="$(sudo auditctl -l 2>/dev/null || true)"
KERNEL_VALIDATION_FAILED=0

for rule in "${EXPECTED_RULES[@]}"; do
    normalized_rule="$(printf '%s\n' "$rule" | sed -E 's#(/etc/[^ ]*)/([[:space:]])#\1\2#')"

    if printf '%s\n' "$KERNEL_RULES" | grep -Fxq -- "$rule" ||
       printf '%s\n' "$KERNEL_RULES" | grep -Fxq -- "$normalized_rule"; then
        echo "  PASS: $rule"
    else
        echo "  FAIL: $rule"
        KERNEL_VALIDATION_FAILED=1
    fi
done

if [[ "$KERNEL_VALIDATION_FAILED" -eq 0 ]]; then
    HEALTHY=$((HEALTHY + 1))
else
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Audit runtime status:"

AUDIT_STATUS="$(sudo auditctl -s 2>/dev/null || true)"

if printf '%s\n' "$AUDIT_STATUS" |
   grep -q '^enabled[[:space:]]\+1'; then
    echo "  Kernel auditing: ENABLED"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  Kernel auditing: NOT ENABLED"
    FAILURES=$((FAILURES + 1))
fi

if printf '%s\n' "$AUDIT_STATUS" |
   grep -q '^lost[[:space:]]\+0'; then
    echo "  Lost events: 0"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  Lost events: NON-ZERO"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Policy deployment:"

if [[ -f "$SOURCE_RULES" ]]; then
    if sudo test -f "$RUNTIME_RULES" &&
       sudo cmp -s "$SOURCE_RULES" "$RUNTIME_RULES"; then
        echo "  No deployment required"
    else
        echo "  Installing project policy"

        if sudo install -o root -g root -m 0640 \
            "$SOURCE_RULES" "$RUNTIME_RULES"; then

            echo "  Policy installed"

            if sudo augenrules --load >/dev/null 2>&1; then
                echo "  Audit rules loaded"
            else
                echo "  Audit rule load FAILED"
                FAILURES=$((FAILURES + 1))
            fi
        else
            echo "  Policy installation FAILED"
            FAILURES=$((FAILURES + 1))
        fi
    fi
fi

echo
echo "Security checks: $HEALTHY/$TOTAL"

if [[ "$FAILURES" -eq 0 ]]; then
    echo "Linux audit policy: HEALTHY"
    obs_report "Linux audit policy deployment and runtime validation passed."
else
    echo "Linux audit policy: REVIEW REQUIRED"
    obs_report "Linux audit policy requires review: $FAILURES check(s) failed."
fi

exit "$FAILURES"
