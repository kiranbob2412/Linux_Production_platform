#!/bin/bash

source "$(dirname "$0")/aws_common.sh"

aws_section "AWS SUBNET INVENTORY"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws ec2 describe-subnets \
    --query 'Subnets[].{
        Subnet:SubnetId,
        VPC:VpcId,
        AZ:AvailabilityZone,
        CIDR:CidrBlock,
        IPv6:Ipv6CidrBlockAssociationSet[0].Ipv6CidrBlock,
        AvailableIPs:AvailableIpAddressCount,
        MapPublicIP:MapPublicIpOnLaunch
    }' \
    --output table 2>/dev/null || {
        aws_warn "Subnet inventory unavailable"
        exit 0
    }

aws_ok "Subnet inventory completed"
