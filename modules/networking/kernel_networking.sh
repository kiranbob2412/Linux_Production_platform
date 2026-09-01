#!/bin/bash

source "$(dirname "$0")/common.sh"

section "LINUX KERNEL NETWORKING"

echo "IP forwarding:"
sysctl net.ipv4.ip_forward 2>/dev/null || true
sysctl net.ipv6.conf.all.forwarding 2>/dev/null || true

echo
echo "Reverse path filtering:"
sysctl net.ipv4.conf.all.rp_filter 2>/dev/null || true

echo
echo "TCP congestion control:"
sysctl net.ipv4.tcp_congestion_control 2>/dev/null || true

echo
echo "Available TCP congestion algorithms:"
sysctl net.ipv4.tcp_available_congestion_control 2>/dev/null || true

echo
echo "TCP memory:"
sysctl net.ipv4.tcp_rmem 2>/dev/null || true
sysctl net.ipv4.tcp_wmem 2>/dev/null || true

echo
echo "Socket buffers:"
sysctl net.core.rmem_max 2>/dev/null || true
sysctl net.core.wmem_max 2>/dev/null || true

echo
echo "TCP security:"
sysctl net.ipv4.tcp_syncookies 2>/dev/null || true

echo
echo "TCP connection information:"
ss -ti 2>/dev/null | sed -n '1,160p'

ok "Kernel networking diagnostics collected"
