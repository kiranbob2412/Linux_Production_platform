#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS TRANSIT GATEWAY"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Transit Gateways:"
aws ec2 describe-transit-gateways \
    --query 'TransitGateways[].{
        TGW:TransitGatewayId,
        State:State,
        Owner:OwnerId,
        ASN:Options.AmazonSideAsn,
        DNS:Options.DnsSupport,
        VPN:Options.VpnEcmpSupport
    }' \
    --output table 2>/dev/null || true

echo
echo "Transit Gateway attachments:"
aws ec2 describe-transit-gateway-attachments \
    --query 'TransitGatewayAttachments[].{
        Attachment:TransitGatewayAttachmentId,
        TGW:TransitGatewayId,
        Type:ResourceType,
        Resource:ResourceId,
        State:State
    }' \
    --output table 2>/dev/null || true

echo
echo "Transit Gateway route tables:"
aws ec2 describe-transit-gateway-route-tables \
    --query 'TransitGatewayRouteTables[].{
        RouteTable:TransitGatewayRouteTableId,
        TGW:TransitGatewayId,
        State:State
    }' \
    --output table 2>/dev/null || true

aws_ok "Transit Gateway analysis completed"
