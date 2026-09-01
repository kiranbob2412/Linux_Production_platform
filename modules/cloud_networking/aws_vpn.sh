#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS VPN / HYBRID CONNECTIVITY"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Customer Gateways:"
aws ec2 describe-customer-gateways \
    --query 'CustomerGateways[].{
        Gateway:CustomerGatewayId,
        State:State,
        Type:Type,
        IP:IpAddress,
        ASN:BgpAsn
    }' \
    --output table 2>/dev/null || true

echo
echo "Virtual Private Gateways:"
aws ec2 describe-vpn-gateways \
    --query 'VpnGateways[].{
        VGW:VpnGatewayId,
        State:State,
        Type:Type,
        VPC:VpcAttachments[0].VpcId
    }' \
    --output table 2>/dev/null || true

echo
echo "Site-to-Site VPN connections:"
aws ec2 describe-vpn-connections \
    --query 'VpnConnections[].{
        VPN:VpnConnectionId,
        State:State,
        Type:Type,
        Gateway:VpnGatewayId,
        CustomerGateway:CustomerGatewayId
    }' \
    --output table 2>/dev/null || true

aws_ok "VPN/hybrid connectivity analysis completed"
