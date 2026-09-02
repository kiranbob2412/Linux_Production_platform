#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "SYSTEM LOG COLLECTION"

LOG_SOURCES=(
    "/var/log/syslog"
    "/var/log/auth.log"
    "/var/log/kern.log"
)

for log_file in "${LOG_SOURCES[@]}"; do
    if [ -f "$log_file" ]; then
        echo "Log source: $log_file"
        echo "Status: AVAILABLE"
    else
        echo "Log source: $log_file"
        echo "Status: NOT AVAILABLE"
    fi
done

echo
echo "systemd journal:"
if command -v journalctl >/dev/null 2>&1; then
    echo "Status: AVAILABLE"
else
    echo "Status: NOT AVAILABLE"
fi

obs_report "System log source discovery completed."
