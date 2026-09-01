#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
NETWORK_DIR="$ROOT/modules/networking"
REPORT_DIR="$ROOT/reports/networking"
LOG_DIR="$ROOT/logs/networking"

mkdir -p "$REPORT_DIR" "$LOG_DIR"

TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"

REPORT="$REPORT_DIR/network_${TIMESTAMP}.report"
LOG="$LOG_DIR/network_${TIMESTAMP}.log"

exec > >(tee "$REPORT" "$LOG") 2>&1

echo "============================================================"
echo " LINUX PRODUCTION PLATFORM"
echo " NETWORKING ENGINEERING SUBSYSTEM"
echo "============================================================"
echo "Host      : $(hostname)"
echo "Timestamp : $(date -Is)"
echo "Kernel    : $(uname -r)"
echo "============================================================"

source "$NETWORK_DIR/common.sh"

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
)

for module in "${MODULES[@]}"; do

    module_path="$NETWORK_DIR/$module"

    echo
    echo "------------------------------------------------------------"
    echo "MODULE: $module"
    echo "------------------------------------------------------------"

    if [ ! -f "$module_path" ]; then
        echo "N/A: module missing: $module"
        N_NA=$((N_NA + 1))
        continue
    fi

    if bash "$module_path"; then
        echo "MODULE RESULT: COMPLETED"
    else
        rc=$?
        echo "MODULE RESULT: RETURNED $rc"
    fi

done

echo
echo "============================================================"
echo " NETWORKING ENGINEERING SUMMARY"
echo "============================================================"

echo "Checks OK      : $N_OK"
echo "Warnings       : $N_WARN"
echo "Failures       : $N_FAIL"
echo "Not Available  : $N_NA"

echo
echo "Report: $REPORT"
echo "Log   : $LOG"

if [ "$N_FAIL" -gt 0 ]; then
    echo
    echo "NETWORK HEALTH: DEGRADED"
    exit 1
fi

if [ "$N_WARN" -gt 0 ]; then
    echo
    echo "NETWORK HEALTH: WARNING"
    exit 0
fi

echo
echo "NETWORK HEALTH: OK"
exit 0
