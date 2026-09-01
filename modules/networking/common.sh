#!/bin/bash

NETWORK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

NETWORK_TIMEOUT="${NETWORK_TIMEOUT:-5}"

N_OK=0
N_WARN=0
N_FAIL=0
N_NA=0

section() {
    echo
    echo "======================================"
    echo "$1"
    echo "======================================"
}

ok() {
    echo "OK: $1"
    N_OK=$((N_OK + 1))
}

warn() {
    echo "WARN: $1"
    N_WARN=$((N_WARN + 1))
}

fail() {
    echo "FAIL: $1"
    N_FAIL=$((N_FAIL + 1))
}

na() {
    echo "N/A: $1"
    N_NA=$((N_NA + 1))
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

default_interface() {
    ip route show default 2>/dev/null |
        awk 'NR==1 {print $5}'
}

default_gateway() {
    ip route show default 2>/dev/null |
        awk 'NR==1 {print $3}'
}

interface_exists() {
    ip link show "$1" >/dev/null 2>&1
}

is_root() {
    [ "$(id -u)" -eq 0 ]
}

timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}
