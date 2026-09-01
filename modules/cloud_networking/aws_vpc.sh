#!/bin/bash

source "$(dirname "$0")/aws_common.sh"

aws_section "AWS VPC INVENTORY"

if ! aws_cli_ready; then
    aws_na "AWS CLI not installed"
    exit 0
fi

if ! aws sts get-caller-identity >/dev/null 2>&1; then
    aws_na "AWS credentials/account access unavailable"
    exit 0
fi

echo "Account:"
aws sts get-caller-identity \
    --query 'Account' \
    --output text 2>/dev/null || true

echo
echo "Region:"
aws_region

echo
echo "VPCs:"

aws ec2 describe-vpcs \
    --query 'Vpcs[].{
        VPC:VpcId,
        CIDR:CidrBlock,
        State:State,
        Default:IsDefault
    }' \
    --output table 2>/dev/null || {
        aws_fail "Unable to query VPCs"
        exit 0
    }

aws_ok "VPC inventory completed"
