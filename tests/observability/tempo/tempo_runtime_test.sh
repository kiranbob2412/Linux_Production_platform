#!/bin/bash
set -euo pipefail

test -x /usr/local/bin/tempo
test -f /etc/tempo/tempo.yml

systemctl is-active --quiet tempo

curl -fsS --max-time 5 \
    http://127.0.0.1:3200/ready >/dev/null

sudo -u tempo test -w /var/tempo
sudo -u tempo test -w /var/lib/tempo

echo "TEMPO_RUNTIME_TEST: PASS"
