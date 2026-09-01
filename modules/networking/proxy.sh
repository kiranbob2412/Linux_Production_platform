#!/bin/bash

source "$(dirname "$0")/common.sh"

section "PROXY DIAGNOSTICS"

echo "Configured proxy environment:"

env |
    grep -iE '^(http|https|all|no)_proxy=' |
    sed 's/=.*$/=<configured>/' ||
    echo "No proxy environment variables configured"

echo
echo "Proxy-related listeners:"

ss -lnt 2>/dev/null |
    grep -E ':(3128|8080|8000|8888|8443)\b' ||
    echo "No common proxy ports detected"

ok "Proxy diagnostics completed"
