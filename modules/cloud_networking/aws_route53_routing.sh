#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS ROUTE 53 TRAFFIC ROUTING"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Hosted zones:"
aws route53 list-hosted-zones \
    --query 'HostedZones[].{
        Zone:Name,
        ZoneId:Id,
        Private:Config.PrivateZone
    }' \
    --output table 2>/dev/null || true

echo
echo "Health checks:"
aws route53 list-health-checks \
    --query 'HealthChecks[].{
        ID:Id,
        Type:HealthCheckConfig.Type,
        Endpoint:HealthCheckConfig.FullyQualifiedDomainName,
        Port:HealthCheckConfig.Port
    }' \
    --output table 2>/dev/null || true

aws_ok "Route 53 traffic-routing inventory completed"
