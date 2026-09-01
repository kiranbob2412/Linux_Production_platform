#!/bin/bash

source "$(dirname "$0")/aws_common.sh"

aws_section "AWS GATEWAYS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Internet Gateways:"
aws ec2 describe-internet-gateways \
    --query 'InternetGateways[].{
        IGW:InternetGatewayId,
        State:Attachments[0].State,
        VPC:Attachments[0].VpcId
    }' \
    --output table 2>/dev/null || true

echo
echo "NAT Gateways:"
aws ec2 describe-nat-gateways \
    --query 'NatGateways[].{
        NAT:NATGatewayId,
        State:State,
        VPC:VpcId,
        Subnet:SubnetId,
        AZ:AvailabilityZone
    }' \
    --output table 2>/dev/null || true

echo
echo "Egress-only Internet Gateways:"
aws ec2 describe-egress-only-internet-gateways \
    --query 'EgressOnlyInternetGateways[].{
        EIGW:Id,
        VPC:Attachments[0].VpcId,
        State:Attachments[0].State
    }' \
    --output table 2>/dev/null || true

aws_ok "Gateway inventory completed"
