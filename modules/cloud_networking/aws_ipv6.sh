#!/bin/bash

source "$(dirname "$0")/aws_common.sh"

aws_section "AWS IPv6 / DUAL-STACK ANALYSIS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "VPC IPv6 ranges:"
aws ec2 describe-vpcs \
    --query 'Vpcs[].{
        VPC:VpcId,
        IPv4:CidrBlock,
        IPv6:Ipv6CidrBlockAssociationSet[].Ipv6CidrBlock
    }' \
    --output table 2>/dev/null || true

echo
echo "Subnet IPv6 ranges:"
aws ec2 describe-subnets \
    --query 'Subnets[].{
        Subnet:SubnetId,
        IPv4:CidrBlock,
        IPv6:Ipv6CidrBlockAssociationSet[].Ipv6CidrBlock
    }' \
    --output table 2>/dev/null || true

echo
echo "IPv6 default routes:"
aws ec2 describe-route-tables \
    --query 'RouteTables[].Routes[?DestinationIpv6CidrBlock==`::/0`]' \
    --output table 2>/dev/null || true

aws_ok "IPv6/dual-stack analysis completed"
