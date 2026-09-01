#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
NET="$ROOT/modules/networking"

FAILURES=0

pass() {
    echo "PASS: $1"
}

fail() {
    echo "FAIL: $1"
    FAILURES=$((FAILURES + 1))
}

echo "============================================================"
echo " NETWORKING BEHAVIORAL / HARDENING TEST"
echo "============================================================"

# ------------------------------------------------------------
# 1. Syntax validation
# ------------------------------------------------------------

echo
echo "Checking shell syntax..."

for file in "$NET"/*.sh; do
    if bash -n "$file"; then
        pass "syntax: $(basename "$file")"
    else
        fail "syntax: $(basename "$file")"
    fi
done

# ------------------------------------------------------------
# 2. Required helper functions
# ------------------------------------------------------------

echo
echo "Checking common library..."

source "$NET/common.sh"

for fn in section ok warn fail na command_exists \
          default_interface default_gateway interface_exists \
          is_root timestamp; do

    if declare -F "$fn" >/dev/null 2>&1; then
        pass "helper function: $fn"
    else
        fail "missing helper function: $fn"
    fi

done

# ------------------------------------------------------------
# 3. Required modules
# ------------------------------------------------------------

echo
echo "Checking required modules..."

MODULES=(
    interfaces.sh
    addressing.sh
    neighbors.sh
    routing.sh
    gateway.sh
    dhcp.sh
    dns.sh
    tcp.sh
    udp.sh
    sockets.sh
    icmp.sh
    connectivity.sh
    http.sh
    tls.sh
    firewall.sh
    nat.sh
    mtu.sh
    packet_capture.sh
    performance.sh
    kernel_networking.sh
    vlan.sh
    bridge.sh
    bonding.sh
    namespace.sh
    virtual_networking.sh
    tunnels.sh
    security.sh
    service_connectivity.sh
    proxy.sh
    load_balancer.sh
    observability.sh
    troubleshooting.sh
    resilience.sh
    network_health.sh
    network_master.sh
)

for module in "${MODULES[@]}"; do
    if [ -f "$NET/$module" ]; then
        pass "module exists: $module"
    else
        fail "module missing: $module"
    fi
done

# ------------------------------------------------------------
# 4. Tool availability contract
# ------------------------------------------------------------

echo
echo "Checking tool detection..."

TOOLS=(
    ip
    ping
    ss
    curl
    getent
    ethtool
    nmcli
    dig
)

for tool in "${TOOLS[@]}"; do

    if command_exists "$tool"; then
        pass "tool available: $tool"
    else
        echo "INFO: tool unavailable: $tool"
    fi

done

# ------------------------------------------------------------
# 5. Interface discovery must not be hard-coded
# ------------------------------------------------------------

echo
echo "Checking interface discovery..."

IFACE="$(default_interface)"

if [ -n "$IFACE" ]; then
    pass "default interface dynamically discovered: $IFACE"
else
    echo "INFO: no default interface detected"
fi

# ------------------------------------------------------------
# 6. Gateway discovery must not be hard-coded
# ------------------------------------------------------------

echo
echo "Checking gateway discovery..."

GW="$(default_gateway)"

if [ -n "$GW" ]; then
    pass "default gateway dynamically discovered: $GW"
else
    echo "INFO: no default gateway detected"
fi

# ------------------------------------------------------------
# 7. Existing entry point
# ------------------------------------------------------------

echo
echo "Checking main networking entry point..."

if [ -x "$ROOT/modules/network.sh" ]; then
    pass "network.sh executable"
else
    fail "network.sh is not executable"
fi

# ------------------------------------------------------------
# 8. Master execution
# ------------------------------------------------------------

echo
echo "Executing master networking diagnostics..."

OUTPUT="/tmp/lps_networking_behavior.$$"

if bash "$ROOT/modules/network.sh" >"$OUTPUT" 2>&1; then
    pass "master networking execution"
else
    RC=$?
    echo "INFO: master returned exit code $RC"
fi

# ------------------------------------------------------------
# 9. Health contract
# ------------------------------------------------------------

if grep -qE "NETWORK HEALTH: (OK|WARNING|DEGRADED)" "$OUTPUT"; then
    pass "network health contract"
else
    fail "network health contract missing"
fi

# ------------------------------------------------------------
# 10. Report generation
# ------------------------------------------------------------

REPORT_COUNT="$(
    find "$ROOT/reports/networking" \
        -type f 2>/dev/null |
        wc -l
)"

if [ "$REPORT_COUNT" -gt 0 ]; then
    pass "network report generated"
else
    fail "network report not generated"
fi

# ------------------------------------------------------------
# 11. Log generation
# ------------------------------------------------------------

LOG_COUNT="$(
    find "$ROOT/logs/networking" \
        -type f 2>/dev/null |
        wc -l
)"

if [ "$LOG_COUNT" -gt 0 ]; then
    pass "network log generated"
else
    fail "network log not generated"
fi

# ------------------------------------------------------------
# 12. No obvious hard-coded local interface
# ------------------------------------------------------------

if grep -RqsE 'enp0s3|10\.0\.2\.15' "$NET"; then
    fail "environment-specific interface/IP hard-coded in networking modules"
else
    pass "no current-machine interface/IP hard-coded"
fi

# ------------------------------------------------------------
# 13. No destructive network commands
# ------------------------------------------------------------

if grep -RqsE \
    'ip (addr|route|link|rule) (add|del|replace|change)|nmcli .*modify|iptables .* -A|nft .* add rule' \
    "$NET"; then

    fail "potential configuration-changing network command detected"

else
    pass "networking modules remain diagnostics-oriented"
fi

# ------------------------------------------------------------
# 14. Output sanity
# ------------------------------------------------------------

if grep -q "NETWORKING ENGINEERING SUMMARY" "$OUTPUT"; then
    pass "engineering summary generated"
else
    fail "engineering summary missing"
fi

if grep -q "Timestamp" "$OUTPUT"; then
    pass "timestamp present"
else
    fail "timestamp missing"
fi

if grep -q "Kernel" "$OUTPUT"; then
    pass "kernel information present"
else
    fail "kernel information missing"
fi

rm -f "$OUTPUT"

echo
echo "============================================================"

if [ "$FAILURES" -eq 0 ]; then
    echo "PASS: NETWORKING BEHAVIORAL / HARDENING TEST"
    echo "PASS: ALL HARDENING CHECKS PASSED"
    echo "============================================================"
    exit 0
fi

echo "FAIL: NETWORKING BEHAVIORAL / HARDENING TEST"
echo "FAILURES: $FAILURES"
echo "============================================================"

exit 1
