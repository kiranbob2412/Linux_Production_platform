#!/bin/bash

source "$(dirname "$0")/common.sh"

section "TLS / CERTIFICATE DIAGNOSTICS"

host="${NETWORK_TLS_HOST:-example.com}"

echo "TLS target: $host:443"

if ! command_exists openssl; then
    na "openssl unavailable"
    exit 0
fi

certificate="$(
    timeout "$NETWORK_TIMEOUT" \
    openssl s_client \
        -connect "$host:443" \
        -servername "$host" \
        </dev/null 2>/dev/null |
    openssl x509 -noout -subject -issuer -dates 2>/dev/null
)" || certificate=""

if [ -n "$certificate" ]; then
    echo "$certificate"
    ok "TLS certificate retrieved"
else
    fail "TLS certificate inspection failed"
fi

echo
echo "TLS protocol negotiation:"
timeout "$NETWORK_TIMEOUT" \
    openssl s_client \
    -connect "$host:443" \
    -servername "$host" \
    </dev/null 2>/dev/null |
    grep -E 'Protocol|Cipher|Verify return code' ||
    true
