#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS MULTI-AZ NETWORK RESILIENCE"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Subnets by Availability Zone:"
aws ec2 describe-subnets \
    --query 'Subnets[].{
        VPC:VpcId,
        Subnet:SubnetId,
        AZ:AvailabilityZone,
        CIDR:CidrBlock,
        AvailableIPs:AvailableIpAddressCount
    }' \
    --output table 2>/dev/null || true

echo
echo "NAT Gateways by AZ:"
aws ec2 describe-nat-gateways \
    --query 'NatGateways[].{
        NAT:NatGatewayId,
        AZ:AvailabilityZone,
        VPC:VpcId,
        State:State
    }' \
    --output table 2>/dev/null || true

echo
echo "Load Balancer AZ placement:"
aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[].{
        Name:LoadBalancerName,
        Type:Type,
        AZs:AvailabilityZones[].ZoneName
    }' \
    --output table 2>/dev/null || true

aws_ok "Multi-AZ resilience inventory completed"
