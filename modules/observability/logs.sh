#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "LOG OBSERVABILITY"

echo "Journal:"
if obs_command_exists journalctl; then
    journalctl --disk-usage 2>/dev/null
    echo "journalctl: AVAILABLE"
else
    echo "journalctl: NOT AVAILABLE"
fi

echo
echo "Log sources:"

for path in \
    /var/log/syslog \
    /var/log/messages \
    /var/log/auth.log \
    /var/log/kern.log
do
    if [ -f "$path" ]; then
        echo "FOUND: $path"
    else
        echo "N/A:   $path"
    fi
done

obs_report "Log source discovery completed."
