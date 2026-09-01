#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS VPC PEERING"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws ec2 describe-vpc-peering-connections \
    --query 'VpcPeeringConnections[].{
        Peering:VpcPeeringConnectionId,
        Status:Status.Code,
        Requester:RequesterVpcInfo.VpcId,
        Accepter:AccepterVpcInfo.VpcId,
        RequesterRegion:RequesterVpcInfo.Region,
        AccepterRegion:AccepterVpcInfo.Region
    }' \
    --output table 2>/dev/null || {
        aws_warn "VPC peering inventory unavailable"
        exit 0
    }

aws_ok "VPC peering analysis completed"
