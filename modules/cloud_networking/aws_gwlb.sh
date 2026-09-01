#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS GATEWAY LOAD BALANCER"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[?Type==`gateway`].{
        Name:LoadBalancerName,
        Scheme:Scheme,
        State:State.Code,
        VPC:VpcId,
        AZs:AvailabilityZones[].ZoneName,
        DNS:DNSName
    }' \
    --output table 2>/dev/null || true

echo
echo "Gateway target groups:"
aws elbv2 describe-target-groups \
    --query 'TargetGroups[?TargetType==`instance` || TargetType==`ip`].{
        Name:TargetGroupName,
        Protocol:Protocol,
        Port:Port,
        Type:TargetType,
        VPC:VpcId
    }' \
    --output table 2>/dev/null || true

aws_ok "Gateway Load Balancer analysis completed"
