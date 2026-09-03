#!/bin/bash
set -u

source "$(dirname "$0")/../observability/common.sh"

obs_section "LINUX AUDIT ENGINEERING"

FAILURES=0
HEALTHY=0
TOTAL=6

echo "Audit userspace:"

if command -v auditctl >/dev/null 2>&1; then
    echo "  auditctl: AVAILABLE"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  auditctl: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

if command -v auditd >/dev/null 2>&1; then
    echo "  auditd: AVAILABLE"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  auditd: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Audit daemon:"

if systemctl is-active --quiet auditd 2>/dev/null; then
    echo "  auditd: ACTIVE"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  auditd: NOT ACTIVE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Kernel audit subsystem:"

if command -v auditctl >/dev/null 2>&1 &&
   sudo auditctl -s 2>/dev/null | grep -q '^enabled[[:space:]]\+1'; then
    echo "  Kernel auditing: ENABLED"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  Kernel auditing: NOT CONFIRMED ENABLED"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Audit configuration:"

if sudo test -f /etc/audit/auditd.conf &&
   sudo test -r /etc/audit/auditd.conf 2>/dev/null; then
    echo "  auditd.conf: PRESENT"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  auditd.conf: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Audit logging:"

if [[ -f /var/log/audit/audit.log ]]; then
    echo "  audit.log: PRESENT"
    HEALTHY=$((HEALTHY + 1))
else
    echo "  audit.log: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "Audit runtime status:"
sudo auditctl -s 2>/dev/null || true

echo
echo "Loaded audit rules:"
sudo auditctl -l 2>/dev/null || true

echo
echo "Security checks: $HEALTHY/$TOTAL"

if [[ "$FAILURES" -eq 0 ]]; then
    echo "Linux audit engineering: HEALTHY"
    obs_report "Linux audit subsystem health passed: $HEALTHY/$TOTAL."
else
    echo "Linux audit engineering: REVIEW REQUIRED"
    obs_report "Linux audit subsystem requires review: $HEALTHY/$TOTAL."
fi

exit "$FAILURES"
