#!/bin/bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
MODULE="$PROJECT_ROOT/modules/observability/ebpf_observability.sh"

test -x "$MODULE"
test -r /sys/kernel/btf/vmlinux
mountpoint -q /sys/fs/bpf
command -v bpftool >/dev/null 2>&1
command -v bpftrace >/dev/null 2>&1

sudo bpftool prog show >/dev/null
sudo bpftool map show >/dev/null

echo "EBPF_OBSERVABILITY_TEST: PASS"
