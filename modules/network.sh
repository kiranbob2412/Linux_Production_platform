#!/bin/bash
echo "=========================================="
echo " NETWORK DIAGNOSTICS"
echo "=========================================="
echo
echo "Network Interfaces:"
ip -br addr 2>/dev/null
echo
echo "DNS Resulution:"
getebt hosts google.com 2>/dev/null
echo
echo "Listing Ports:"
ss -tuln 2>/dev/null |head -20
echo "Connectivity:"
if ping -c 2 -w 2 1.1.1.1 >/dev/null 2>&1; then
echo "Internet Connectivity:OK"
else
echo "Internet connectivity: FAILED"
fi
