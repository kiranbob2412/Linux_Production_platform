#!/bin/bash

AWS_OK=0
AWS_WARN=0
AWS_FAIL=0
AWS_NA=0

aws_section() {
    echo
    echo "======================================"
    echo "$1"
    echo "======================================"
}

aws_ok() {
    echo "OK: $1"
    AWS_OK=$((AWS_OK + 1))
}

aws_warn() {
    echo "WARN: $1"
    AWS_WARN=$((AWS_WARN + 1))
}

aws_fail() {
    echo "FAIL: $1"
    AWS_FAIL=$((AWS_FAIL + 1))
}

aws_na() {
    echo "N/A: $1"
    AWS_NA=$((AWS_NA + 1))
}

aws_command_exists() {
    command -v "$1" >/dev/null 2>&1
}

aws_cli_ready() {
    aws_command_exists aws
}

aws_region() {
    aws configure get region 2>/dev/null ||
    printf '%s\n' "${AWS_REGION:-${AWS_DEFAULT_REGION:-}}"
}
