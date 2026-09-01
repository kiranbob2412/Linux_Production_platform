#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
NETWORK_MODULE="$PROJECT_ROOT/modules/network.sh"

if [ ! -f "$NETWORK_MODULE" ]; then
    echo "FAIL: network.sh not found"
    exit 1
fi

output=$(bash "$NETWORK_MODULE")
network_exit_code=$?

if [ "$network_exit_code" -ne 0 ]; then
    echo "FAIL: Network module returned exit code $network_exit_code"
    exit 1
fi

echo "$output" | grep -q "NETWORK DIAGNOSTICS" || {
    echo "FAIL: Network diagnostics header missing"
    exit 1
}

echo "$output" | grep -q "Network Interfaces:" || {
    echo "FAIL: Network interface check missing"
    exit 1
}

echo "$output" | grep -q "Gateway:" || {
    echo "FAIL: Gateway check missing"
    exit 1
}

echo "$output" | grep -q "DNS Resolution:" || {
    echo "FAIL: DNS check missing"
    exit 1
}

echo "$output" | grep -q "Listening Ports:" || {
    echo "FAIL: Port check missing"
    exit 1
}

echo "$output" | grep -q "Internet Connectivity:" || {
    echo "FAIL: Connectivity check missing"
    exit 1
}

echo "$output" | grep -q "NETWORK HEALTH:" || {
    echo "FAIL: Network health summary missing"
    exit 1
}

echo "PASS: Networking module structure and diagnostics verified"
exit 0
