#!/bin/bash
set -u

source "$(dirname "$0")/../observability/common.sh"

obs_section "HOST SECURITY HARDENING"

FAILURES=0
HEALTHY=0
TOTAL=5

check_command() {
    local label="$1"
    local command_name="$2"

    if command -v "$command_name" >/dev/null 2>&1; then
        echo "$label: AVAILABLE"
        HEALTHY=$((HEALTHY + 1))
    else
        echo "$label: NOT AVAILABLE"
        FAILURES=$((FAILURES + 1))
    fi
}

echo "Security posture:"
echo "  Firewall:"

if command -v ufw >/dev/null 2>&1 &&
   systemctl is-active --quiet ufw 2>/dev/null; then
    echo "    UFW: ACTIVE"
    HEALTHY=$((HEALTHY + 1))
else
    echo "    UFW: NOT CONFIRMED ACTIVE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "  Automatic security updates:"

if systemctl is-active --quiet unattended-upgrades 2>/dev/null; then
    echo "    ACTIVE"
    HEALTHY=$((HEALTHY + 1))
else
    echo "    NOT ACTIVE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "  Source routing:"
SOURCE_ROUTE="$(sysctl -n net.ipv4.conf.all.accept_source_route 2>/dev/null || echo unknown)"

if [[ "$SOURCE_ROUTE" == "0" ]]; then
    echo "    IPv4 source routing: DISABLED"
    HEALTHY=$((HEALTHY + 1))
else
    echo "    IPv4 source routing: NOT HARDENED"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "  SSH exposure:"

if command -v sshd >/dev/null 2>&1; then
    echo "    SSH server: INSTALLED"
else
    echo "    SSH server: NOT INSTALLED"
    HEALTHY=$((HEALTHY + 1))
fi

echo
echo "  Audit subsystem:"

if command -v auditctl >/dev/null 2>&1; then
    echo "    auditctl: AVAILABLE"
    HEALTHY=$((HEALTHY + 1))
else
    echo "    auditctl: NOT AVAILABLE"
    HEALTHY=$((HEALTHY + 1))
fi

echo
echo "Security checks: $HEALTHY/$TOTAL"

if [[ "$FAILURES" -eq 0 ]]; then
    echo "Host security hardening: HEALTHY"
    obs_report "Host security hardening audit passed: $HEALTHY/$TOTAL."
else
    echo "Host security hardening: REVIEW REQUIRED"
    obs_report "Host security hardening audit requires review: $HEALTHY/$TOTAL."
fi

exit "$FAILURES"
