#!/bin/bash

K8S_OK=0
K8S_WARN=0
K8S_FAIL=0
K8S_NA=0

k8s_section() {
    echo
    echo "======================================"
    echo "$1"
    echo "======================================"
}

k8s_ok() {
    echo "OK: $1"
    K8S_OK=$((K8S_OK + 1))
}

k8s_warn() {
    echo "WARN: $1"
    K8S_WARN=$((K8S_WARN + 1))
}

k8s_fail() {
    echo "FAIL: $1"
    K8S_FAIL=$((K8S_FAIL + 1))
}

k8s_na() {
    echo "N/A: $1"
    K8S_NA=$((K8S_NA + 1))
}

k8s_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

k8s_ready() {
    k8s_command_exists kubectl
}

k8s_cluster_reachable() {
    kubectl cluster-info >/dev/null 2>&1
}
