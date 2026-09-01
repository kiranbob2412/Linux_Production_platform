#!/bin/bash

source "$(dirname "$0")/k8s_common.sh"

k8s_section "eBPF NETWORKING ANALYSIS"

echo "bpftool:"
if k8s_command_exists bpftool; then
    bpftool version 2>/dev/null || true

    echo
    echo "Loaded BPF programs:"
    bpftool prog show 2>/dev/null |
        sed -n '1,200p' || true

    echo
    echo "BPF maps:"
    bpftool map show 2>/dev/null |
        sed -n '1,160p' || true

    k8s_ok "eBPF tooling available"
else
    k8s_na "bpftool unavailable"
fi

echo
echo "Kernel:"
uname -r

echo
echo "BPF filesystem:"
if [ -d /sys/fs/bpf ]; then
    mountpoint -q /sys/fs/bpf 2>/dev/null &&
        k8s_ok "BPF filesystem mounted" ||
        k8s_warn "BPF filesystem exists but is not mounted"
else
    k8s_na "BPF filesystem unavailable"
fi
