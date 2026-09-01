#!/bin/bash

set -u

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$ROOT/modules/cloud_networking"

REPORT_DIR="$ROOT/reports/cloud_networking"
mkdir -p "$REPORT_DIR"

REPORT="$REPORT_DIR/aws_network_$(date +%Y%m%d_%H%M%S).report"

exec > >(tee "$REPORT") 2>&1

echo "============================================================"
echo " LINUX PRODUCTION PLATFORM"
echo " AWS CLOUD NETWORKING ANALYZER"
echo "============================================================"

source "$DIR/aws_common.sh"

MODULES=(
    aws_vpc.sh
    aws_subnets.sh
    aws_route_tables.sh
    aws_gateways.sh
    aws_ipv6.sh
)

for module in "${MODULES[@]}"; do

    echo
    echo "------------------------------------------------------------"
    echo "MODULE: $module"
    echo "------------------------------------------------------------"

    bash "$DIR/$module" || true

done

echo
echo "============================================================"
echo " AWS NETWORKING SUMMARY"
echo "============================================================"

echo "OK       : $AWS_OK"
echo "WARN     : $AWS_WARN"
echo "FAIL     : $AWS_FAIL"
echo "N/A      : $AWS_NA"

echo
echo "Report: $REPORT"
