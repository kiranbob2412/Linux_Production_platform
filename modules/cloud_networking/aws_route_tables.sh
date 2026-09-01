#!/bin/bash

source "$(dirname "$0")/aws_common.sh"

aws_section "AWS ROUTE TABLE ANALYSIS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws ec2 describe-route-tables \
    --query 'RouteTables[].{
        RouteTable:RouteTableId,
        VPC:VpcId,
        Routes:Routes,
        Associations:Associations
    }' \
    --output json 2>/dev/null |
    sed -n '1,500p' || {
        aws_warn "Route table inventory unavailable"
        exit 0
    }

echo
echo "Internet/default routes:"
aws ec2 describe-route-tables \
    --query 'RouteTables[].Routes[?DestinationCidrBlock==`0.0.0.0/0` || DestinationIpv6CidrBlock==`::/0`]' \
    --output table 2>/dev/null || true

aws_ok "Route table analysis completed"
