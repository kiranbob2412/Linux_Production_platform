#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS RESOURCE ACCESS MANAGER"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws ram get-resource-shares \
    --resource-owner SELF \
    --query 'resourceShares[].{
        Name:name,
        ARN:resourceShareArn,
        Status:status,
        AllowExternal:allowExternalPrincipals
    }' \
    --output table 2>/dev/null || true

echo
echo "Shared resources:"
aws ram list-resources \
    --resource-owner SELF \
    --query 'resources[].{
        ARN:arn,
        Type:resourceType,
        Status:status
    }' \
    --output table 2>/dev/null || true

aws_ok "AWS RAM networking inventory completed"
