#!/bin/bash

source "$(dirname "$0")/common.sh"

section "NETWORK HEALTH ENGINE"

echo "Health counters:"
echo "  OK      : $N_OK"
echo "  WARN    : $N_WARN"
echo "  FAIL    : $N_FAIL"
echo "  N/A     : $N_NA"

echo

if [ "$N_FAIL" -gt 0 ]; then
    echo "NETWORK HEALTH: DEGRADED"
    exit 1
fi

if [ "$N_WARN" -gt 0 ]; then
    echo "NETWORK HEALTH: WARNING"
    exit 0
fi

echo "NETWORK HEALTH: OK"
exit 0
