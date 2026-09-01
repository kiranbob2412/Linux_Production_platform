#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

MASTER="$ROOT/modules/networking/network_master.sh"
ENTRY="$ROOT/modules/network.sh"

FAILURES=0

echo "============================================================"
echo " NETWORKING MASTER REGRESSION TEST"
echo "============================================================"

check_file() {

    if [ -f "$1" ]; then
        echo "PASS: $(basename "$1") exists"
    else
        echo "FAIL: missing $1"
        FAILURES=$((FAILURES + 1))
    fi
}

check_syntax() {

    if bash -n "$1"; then
        echo "PASS: syntax $(basename "$1")"
    else
        echo "FAIL: syntax $(basename "$1")"
        FAILURES=$((FAILURES + 1))
    fi
}

check_file "$MASTER"
check_file "$ENTRY"

echo
echo "Checking Networking modules..."

for module in "$ROOT"/modules/networking/*.sh; do
    check_syntax "$module"
done

echo
echo "Executing Networking master..."

OUTPUT="/tmp/networking_master_test_output.txt"

if bash "$ENTRY" >"$OUTPUT" 2>&1; then
    echo "PASS: Networking master executed"
else
    RC=$?
    echo "WARN: Networking master returned exit code $RC"
fi

echo
echo "Checking required sections..."

REQUIRED_SECTIONS=(
    "NETWORK INTERFACES AND LINK"
    "IP ADDRESSING"
    "ARP AND IPv6 NEIGHBORS"
    "ROUTING"
    "GATEWAY DIAGNOSTICS"
    "DHCP DIAGNOSTICS"
    "DNS DIAGNOSTICS"
    "TCP DIAGNOSTICS"
    "UDP DIAGNOSTICS"
    "SOCKET AND PORT DIAGNOSTICS"
    "ICMP DIAGNOSTICS"
    "END-TO-END CONNECTIVITY"
    "HTTP / HTTPS APPLICATION DIAGNOSTICS"
    "TLS / CERTIFICATE DIAGNOSTICS"
    "FIREWALL DIAGNOSTICS"
    "NAT AND CONNECTION TRACKING"
    "MTU AND PATH-MTU"
    "PACKET CAPTURE DIAGNOSTICS"
    "NETWORK PERFORMANCE"
    "LINUX KERNEL NETWORKING"
    "VLAN DIAGNOSTICS"
    "LINUX BRIDGE DIAGNOSTICS"
    "NIC BONDING / TEAMING"
    "NETWORK NAMESPACES"
    "VIRTUAL NETWORKING"
    "NETWORK TUNNELS"
    "NETWORK SECURITY POSTURE"
    "SERVICE-TO-SERVICE CONNECTIVITY"
    "PROXY DIAGNOSTICS"
    "LOAD BALANCER NETWORKING"
    "NETWORK OBSERVABILITY"
    "NETWORK TROUBLESHOOTING CHAIN"
    "NETWORK RESILIENCE READINESS"
    "NETWORKING ENGINEERING SUMMARY"
)

for section in "${REQUIRED_SECTIONS[@]}"; do

    if grep -q "$section" "$OUTPUT"; then
        echo "PASS: $section"
    else
        echo "FAIL: missing section: $section"
        FAILURES=$((FAILURES + 1))
    fi

done

echo
echo "Checking final health output..."

if grep -qE "NETWORK HEALTH: (OK|WARNING|DEGRADED)" "$OUTPUT"; then
    echo "PASS: Network health result generated"
else
    echo "FAIL: Network health result missing"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "============================================================"

if [ "$FAILURES" -eq 0 ]; then
    echo "PASS: NETWORKING MASTER REGRESSION TEST"
    echo "PASS: ALL STRUCTURAL CHECKS PASSED"
    echo "============================================================"
    rm -f "$OUTPUT"
    exit 0
fi

echo "FAIL: NETWORKING MASTER REGRESSION TEST"
echo "FAILURES: $FAILURES"
echo "============================================================"

echo
echo "Diagnostic output:"
cat "$OUTPUT"

rm -f "$OUTPUT"

exit 1
