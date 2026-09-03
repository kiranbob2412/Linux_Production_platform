#!/bin/bash
set -euo pipefail

source "$(dirname "$0")/../common.sh"

obs_section "TEMPO RUNTIME"

if [[ ! -x /usr/local/bin/tempo ]]; then
    echo "Tempo binary missing: /usr/local/bin/tempo"
    exit 1
fi

if ! systemctl is-active --quiet tempo; then
    echo "Tempo service is not active."
    exit 1
fi

if ! curl -fsS --max-time 5 http://127.0.0.1:3200/ready >/dev/null; then
    echo "Tempo readiness check failed."
    exit 1
fi

if ! sudo -u tempo test -w /var/tempo; then
    echo "Tempo cannot write /var/tempo."
    exit 1
fi

if ! sudo -u tempo test -w /var/lib/tempo; then
    echo "Tempo cannot write /var/lib/tempo."
    exit 1
fi

echo "Tempo service: ACTIVE"
echo "Tempo API: READY"
echo "Tempo storage: WRITABLE"

obs_report "Tempo runtime is healthy."
