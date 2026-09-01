#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS VPC DNS ANALYSIS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "VPC DNS attributes:"

for vpc in $(aws ec2 describe-vpcs \
    --query 'Vpcs[].VpcId' \
    --output text 2>/dev/null); do

    echo
    echo "VPC: $vpc"

    aws ec2 describe-vpc-attribute \
        --vpc-id "$vpc" \
        --attribute enableDnsSupport \
        --output json 2>/dev/null || true

    aws ec2 describe-vpc-attribute \
        --vpc-id "$vpc" \
        --attribute enableDnsHostnames \
        --output json 2>/dev/null || true
done

echo
echo "Route 53 hosted zones:"

aws route53 list-hosted-zones \
    --query 'HostedZones[].{
        Zone:Name,
        Id:Id,
        Private:Config.PrivateZone,
        RecordCount:ResourceRecordSetCount
    }' \
    --output table 2>/dev/null || true

aws_ok "AWS DNS analysis completed"
