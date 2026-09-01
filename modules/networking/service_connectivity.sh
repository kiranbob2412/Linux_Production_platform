#!/bin/bash

source "$(dirname "$0")/common.sh"

section "SERVICE-TO-SERVICE CONNECTIVITY"

TARGETS="${NETWORK_SERVICE_TARGETS:-example.com:443,1.1.1.1:53}"

IFS=',' read -ra SERVICES <<< "$TARGETS"

for target in "${SERVICES[@]}"; do

    host="${target%:*}"
    port="${target##*:}"

    echo
    echo "Testing: $host:$port"

    if command_exists nc; then

        if nc -z -w "$NETWORK_TIMEOUT" "$host" "$port" \
            >/dev/null 2>&1; then
            ok "$host:$port reachable"
        else
            warn "$host:$port unreachable"
        fi

    else

        if timeout "$NETWORK_TIMEOUT" \
            bash -c "</dev/tcp/$host/$port" \
            >/dev/null 2>&1; then
            ok "$host:$port reachable"
        else
            warn "$host:$port unreachable"
        fi

    fi
done
