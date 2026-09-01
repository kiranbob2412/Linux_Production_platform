#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS DIRECT CONNECT"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Direct Connect connections:"
aws directconnect describe-connections \
    --query 'connections[].{
        Connection:connectionId,
        Name:connectionName,
        State:connectionState,
        Location:location,
        Bandwidth:bandwidth
    }' \
    --output table 2>/dev/null || true

echo
echo "Direct Connect gateways:"
aws directconnect describe-direct-connect-gateways \
    --query 'directConnectGateways[].{
        Gateway:directConnectGatewayId,
        Name:name,
        State:directConnectGatewayState
    }' \
    --output table 2>/dev/null || true

echo
echo "Virtual interfaces:"
aws directconnect describe-virtual-interfaces \
    --query 'virtualInterfaces[].{
        VIF:virtualInterfaceId,
        Type:virtualInterfaceType,
        State:virtualInterfaceState,
        VLAN:vlan,
        ASN:bgpAsn,
        Gateway:directConnectGatewayId
    }' \
    --output table 2>/dev/null || true

aws_ok "Direct Connect analysis completed"
