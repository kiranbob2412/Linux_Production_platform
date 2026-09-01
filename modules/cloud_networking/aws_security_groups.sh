#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS SECURITY GROUP ANALYSIS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws ec2 describe-security-groups \
    --query 'SecurityGroups[].{
        GroupId:GroupId,
        Name:GroupName,
        VPC:VpcId,
        Description:Description
    }' \
    --output table 2>/dev/null || {
        aws_warn "Security group inventory unavailable"
        exit 0
    }

echo
echo "Ingress / Egress rules:"
aws ec2 describe-security-groups \
    --query 'SecurityGroups[].{
        GroupId:GroupId,
        Ingress:IpPermissions,
        Egress:IpPermissionsEgress
    }' \
    --output json 2>/dev/null | sed -n '1,500p'

aws_ok "Security Group analysis completed"
