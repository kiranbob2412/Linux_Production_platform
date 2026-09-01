#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS CLOUD WAN"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Core networks:"
aws networkmanager list-core-networks \
    --query 'CoreNetworks[].{
        ID:CoreNetworkId,
        ARN:CoreNetworkArn,
        State:State,
        Description:Description
    }' \
    --output table 2>/dev/null || true

echo
echo "Global networks:"
aws networkmanager list-global-networks \
    --query 'GlobalNetworks[].{
        ID:GlobalNetworkId,
        ARN:GlobalNetworkArn,
        Description:Description
    }' \
    --output table 2>/dev/null || true

aws_ok "Cloud WAN/Core Network inventory completed"
