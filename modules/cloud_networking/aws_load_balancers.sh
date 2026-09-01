#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS LOAD BALANCING"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Application Load Balancers / Network Load Balancers:"
aws elbv2 describe-load-balancers \
    --query 'LoadBalancers[].{
        Name:LoadBalancerName,
        Type:Type,
        Scheme:Scheme,
        State:State.Code,
        VPC:VpcId,
        AZs:AvailabilityZones[].ZoneName,
        DNS:DNSName
    }' \
    --output table 2>/dev/null || true

echo
echo "Target Groups:"
aws elbv2 describe-target-groups \
    --query 'TargetGroups[].{
        Name:TargetGroupName,
        Type:TargetType,
        Protocol:Protocol,
        Port:Port,
        VPC:VpcId,
        Health:HealthCheckPath
    }' \
    --output table 2>/dev/null || true

aws_ok "ALB/NLB inventory completed"
