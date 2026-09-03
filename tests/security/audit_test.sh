#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODULE="$PROJECT_ROOT/modules/security/audit.sh"

test -x "$MODULE"

command -v auditctl >/dev/null 2>&1
command -v auditd >/dev/null 2>&1
command -v systemctl >/dev/null 2>&1
command -v sudo >/dev/null 2>&1

systemctl is-active --quiet auditd

sudo auditctl -s 2>/dev/null |
    grep -q '^enabled[[:space:]]\+1'

sudo test -f /etc/audit/auditd.conf
sudo test -r /etc/audit/auditd.conf

test -f /var/log/audit/audit.log

sudo auditctl -l >/dev/null 2>&1

echo "AUDIT_TEST: PASS"
