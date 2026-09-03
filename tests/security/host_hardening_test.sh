#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODULE="$PROJECT_ROOT/modules/security/host_hardening.sh"

test -x "$MODULE"

command -v ufw >/dev/null 2>&1
command -v systemctl >/dev/null 2>&1
command -v sysctl >/dev/null 2>&1

systemctl is-active --quiet ufw

test "$(sysctl -n net.ipv4.conf.all.accept_source_route)" = "0"

if command -v sshd >/dev/null 2>&1; then
    echo "SSH server: AVAILABLE"
else
    echo "SSH server: NOT INSTALLED"
fi

if command -v auditctl >/dev/null 2>&1; then
    echo "auditctl: AVAILABLE"
else
    echo "auditctl: NOT AVAILABLE"
fi

systemctl is-active --quiet unattended-upgrades

echo "HOST_HARDENING_TEST: PASS"
