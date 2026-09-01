#!/bin/bash

source "$(dirname "$0")/common.sh"

section "DNS DIAGNOSTICS"

echo "Resolver configuration:"
if [ -f /etc/resolv.conf ]; then
    grep -E '^[[:space:]]*nameserver|^[[:space:]]*search|^[[:space:]]*domain' \
        /etc/resolv.conf || true
else
    warn "/etc/resolv.conf not found"
fi

echo
echo "Hostname resolution:"

for host in google.com example.com; do
    if getent ahosts "$host" >/dev/null 2>&1; then
        echo "$host: RESOLVED"
        ok "DNS resolution works for $host"
    else
        echo "$host: FAILED"
        fail "DNS resolution failed for $host"
    fi
done

echo
echo "DNS query details:"

if command_exists dig; then
    dig +time=3 +tries=1 google.com A 2>/dev/null |
        sed -n '/ANSWER SECTION:/,/^$/p'

    echo
    dig +time=3 +tries=1 google.com AAAA 2>/dev/null |
        sed -n '/ANSWER SECTION:/,/^$/p'

    echo
    echo "Reverse DNS:"
    gateway="$(default_gateway)"

    if [ -n "$gateway" ]; then
        dig +time=3 +tries=1 -x "$gateway" 2>/dev/null |
            sed -n '/ANSWER SECTION:/,/^$/p'
    fi
else
    na "dig is not installed"
fi

if command_exists resolvectl; then
    echo
    echo "systemd-resolved status:"
    resolvectl status 2>/dev/null | sed -n '1,100p'
fi
