#!/bin/bash
set -u

source "$(dirname "$0")/common.sh"

obs_section "eBPF OBSERVABILITY"

FAILURES=0

echo "Kernel:"
echo "  $(uname -r)"

echo
echo "Architecture:"
echo "  $(uname -m)"

echo
echo "BPF filesystem:"
if mountpoint -q /sys/fs/bpf; then
    echo "  AVAILABLE"
else
    echo "  NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "BTF:"
if [[ -r /sys/kernel/btf/vmlinux ]]; then
    echo "  AVAILABLE"
else
    echo "  NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

echo
echo "eBPF tools:"
if obs_command_exists bpftool; then
    echo "  bpftool: AVAILABLE"
else
    echo "  bpftool: NOT AVAILABLE"
    FAILURES=$((FAILURES + 1))
fi

if obs_command_exists bpftrace; then
    echo "  bpftrace: AVAILABLE"
else
    echo "  bpftrace: NOT AVAILABLE"
fi

echo
echo "Loaded BPF programs:"
if command -v bpftool >/dev/null 2>&1; then
    PROGRAM_COUNT="$(sudo bpftool prog show 2>/dev/null | grep -c '^[0-9]\+:')" || PROGRAM_COUNT=0
    echo "  Count: $PROGRAM_COUNT"

    echo
    echo "  Program types:"
    sudo bpftool prog show 2>/dev/null |
        awk '/^[0-9]+:/ { count[$2]++ }
             END {
                 for (type in count)
                     print "    " type ": " count[type]
             }' |
        sort
else
    echo "  Inventory unavailable"
fi

echo
echo "Loaded BPF maps:"
if command -v bpftool >/dev/null 2>&1; then
    MAP_COUNT="$(sudo bpftool map show 2>/dev/null | grep -c '^[0-9]\+:')" || MAP_COUNT=0
    echo "  Count: $MAP_COUNT"
else
    echo "  Inventory unavailable"
fi

echo
echo "eBPF capability:"
if command -v bpftool >/dev/null 2>&1; then
    if sudo bpftool feature probe kernel 2>/dev/null |
        grep -q "JIT compiler is enabled"; then
        echo "  JIT: ENABLED"
    else
        echo "  JIT: NOT CONFIRMED"
        FAILURES=$((FAILURES + 1))
    fi
else
    echo "  JIT: NOT CHECKED"
fi

echo
if [[ "$FAILURES" -eq 0 ]]; then
    echo "eBPF observability: HEALTHY"
    obs_report "eBPF observability capability and runtime inventory are healthy."
else
    echo "eBPF observability: DEGRADED"
    obs_report "eBPF observability has $FAILURES required capability check failure(s)."
fi

exit "$FAILURES"
