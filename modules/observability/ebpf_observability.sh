#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "eBPF OBSERVABILITY"

if obs_command_exists bpftool; then
    echo "bpftool: AVAILABLE"
    bpftool version 2>/dev/null | head -1
else
    echo "bpftool: NOT AVAILABLE"
fi

if obs_command_exists bpftrace; then
    echo "bpftrace: AVAILABLE"
else
    echo "bpftrace: NOT AVAILABLE"
fi

echo
echo "eBPF targets:"
echo "Processes"
echo "Network traffic"
echo "TCP latency"
echo "System calls"
echo "File I/O"
echo "Kernel events"

obs_report "eBPF observability capability discovery completed."
