#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS NETWORK DISASTER RECOVERY READINESS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "VPC count:"
VPCS="$(aws ec2 describe-vpcs \
    --query 'length(Vpcs)' \
    --output text 2>/dev/null || echo 0)"
echo "$VPCS"

echo
echo "Availability Zones:"
aws ec2 describe-availability-zones \
    --filters Name=state,Values=available \
    --query 'AvailabilityZones[].ZoneName' \
    --output table 2>/dev/null || true

echo
echo "NAT Gateway distribution:"
aws ec2 describe-nat-gateways \
    --query 'NatGateways[].{
        NAT:NatGatewayId,
        AZ:AvailabilityZone,
        State:State
    }' \
    --output table 2>/dev/null || true

echo
echo "Transit Gateway attachments:"
aws ec2 describe-transit-gateway-attachments \
    --query 'TransitGatewayAttachments[].{
        TGW:TransitGatewayId,
        Type:ResourceType,
        Resource:ResourceId,
        State:State
    }' \
    --output table 2>/dev/null || true

echo
echo "VPN connections:"
aws ec2 describe-vpn-connections \
    --query 'VpnConnections[].{
        VPN:VpnConnectionId,
        State:State
    }' \
    --output table 2>/dev/null || true

aws_ok "Network DR readiness inventory completed"
