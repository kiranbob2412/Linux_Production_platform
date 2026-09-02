#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "NETWORK FLOW OBSERVABILITY"

echo "Socket summary:"
ss -s 2>/dev/null

echo
echo "Listening services:"
ss -tuln 2>/dev/null

echo
echo "Network interfaces:"
ip -br addr 2>/dev/null

echo
echo "Flow telemetry sources:"
echo "Linux socket statistics"
echo "Packet capture"
echo "AWS VPC Flow Logs"
echo "Kubernetes network telemetry"
echo "eBPF network telemetry"

obs_report "Network flow observability discovery completed."
