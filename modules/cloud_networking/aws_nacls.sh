#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS NETWORK ACL ANALYSIS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws ec2 describe-network-acls \
    --query 'NetworkAcls[].{
        NACL:NetworkAclId,
        VPC:VpcId,
        Default:IsDefault,
        Associations:Associations,
        Entries:Entries
    }' \
    --output json 2>/dev/null |
    sed -n '1,600p' || {
        aws_warn "NACL inventory unavailable"
        exit 0
    }

aws_ok "Network ACL analysis completed"
