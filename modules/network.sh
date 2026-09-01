#!/bin/bash

echo "======================================"
echo "NETWORK DIAGNOSTICS"
echo "======================================"
echo

network_ok=1

echo "Network Interfaces:"
ip -br addr 2>/dev/null

echo
echo "Gateway:"
gateway=$(ip route | awk '$1=="default"{print $3; exit}')
interface=$(ip route | awk '$1=="default"{print $5; exit}')

if [ -n "$gateway" ]; then
    echo "Gateway: $gateway"
else
    echo "Gateway: NOT FOUND"
    network_ok=0
fi

echo
echo "Gateway Connectivity:"
if [ -n "$gateway" ] && ping -c 2 -W 2 "$gateway" >/dev/null 2>&1; then
    echo "Gateway Connectivity: OK"
else
    echo "Gateway Connectivity: FAILED"
    network_ok=0
fi

echo
echo "DNS Resolution:"
if getent hosts google.com >/dev/null 2>&1; then
    echo "DNS Resolution: OK"
else
    echo "DNS Resolution: FAILED"
    network_ok=0
fi

echo
echo "Listening Ports:"
ss -tuln 2>/dev/null | head -20

echo
echo "Internet Connectivity:"
if ping -c 2 -W 2 1.1.1.1 >/dev/null 2>&1; then
    echo "Internet Connectivity: OK (ICMP)"
elif curl -fsSI --max-time 5 https://example.com >/dev/null 2>&1; then
    echo "Internet Connectivity: OK (HTTPS)"
else
    echo "Internet Connectivity: FAILED"
    network_ok=0
fi

echo
echo "======================================"

if [ "$network_ok" -eq 1 ]; then
    echo "NETWORK HEALTH: OK"
else
    echo "NETWORK HEALTH: DEGRADED"
fi

echo "======================================"
if [ "$network_ok" -eq 1 ]; then
    exit 0
else
    exit 1
fi
