#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS ROUTE 53 RESOLVER"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Resolver endpoints:"
aws route53resolver list-resolver-endpoints \
    --query 'ResolverEndpoints[].{
        Endpoint:Id,
        Name:Name,
        Direction:Direction,
        Status:Status,
        IPCount:IpAddressCount
    }' \
    --output table 2>/dev/null || true

echo
echo "Resolver rules:"
aws route53resolver list-resolver-rules \
    --query 'ResolverRules[].{
        Rule:Id,
        Name:Name,
        Domain:DomainName,
        Type:RuleType,
        Status:Status
    }' \
    --output table 2>/dev/null || true

aws_ok "Route 53 Resolver analysis completed"
