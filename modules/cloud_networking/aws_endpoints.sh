#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS VPC ENDPOINTS / PRIVATELINK"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "VPC endpoints:"

aws ec2 describe-vpc-endpoints \
    --query 'VpcEndpoints[].{
        Endpoint:VpcEndpointId,
        VPC:VpcId,
        Type:VpcEndpointType,
        Service:ServiceName,
        State:State,
        Policy:PolicyDocument
    }' \
    --output json 2>/dev/null |
    sed -n '1,600p' || true

echo
echo "Endpoint services:"
aws ec2 describe-vpc-endpoint-services \
    --query 'ServiceNames[0:30]' \
    --output text 2>/dev/null || true

aws_ok "VPC endpoint analysis completed"
