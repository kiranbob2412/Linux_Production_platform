#!/bin/bash

source "$(dirname "$0")/common.sh"

section "UDP DIAGNOSTICS"

if ! command_exists ss; then
    fail "ss command unavailable"
    exit 1
fi

echo "UDP listening sockets:"
ss -lun 2>/dev/null

echo
echo "UDP sockets:"
ss -uan 2>/dev/null

echo
echo "UDP statistics:"
ss -s 2>/dev/null

ok "UDP diagnostics collected"
