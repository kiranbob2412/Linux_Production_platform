#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "METRICS VALIDATION"

failed=0

checks=(
    "/proc/loadavg"
    "/proc/meminfo"
    "/proc/stat"
    "/proc/net/dev"
)

for path in "${checks[@]}"; do
    if [ -r "$path" ]; then
        echo "PASS: $path"
    else
        echo "FAIL: $path"
        failed=$((failed + 1))
    fi
done

commands=(
    uptime
    free
    df
    ps
    ss
    ip
)

for cmd in "${commands[@]}"; do
    if obs_command_exists "$cmd"; then
        echo "PASS: command $cmd"
    else
        echo "FAIL: command $cmd"
        failed=$((failed + 1))
    fi
done

echo

if [ "$failed" -eq 0 ]; then
    echo "PASS: LINUX METRICS VALIDATION"
    obs_report "Linux metrics validation passed."
    exit 0
else
    echo "FAIL: $failed metrics checks failed"
    exit 1
fi
