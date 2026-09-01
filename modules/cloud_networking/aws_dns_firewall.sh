#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS DNS FIREWALL"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "DNS Firewall rule groups:"
aws route53resolver list-firewall-rule-groups \
    --query 'FirewallRuleGroups[].{
        Group:Id,
        Name:Name,
        Status:Status
    }' \
    --output table 2>/dev/null || true

echo
echo "DNS Firewall domains:"
aws route53resolver list-firewall-domain-lists \
    --query 'FirewallDomainLists[].{
        List:Id,
        Name:Name,
        Status:Status
    }' \
    --output table 2>/dev/null || true

echo
echo "DNS Firewall configurations:"
aws route53resolver list-firewall-configs \
    --query 'FirewallConfigs[].{
        VPC:Id,
        FailOpen:FirewallFailOpen
    }' \
    --output table 2>/dev/null || true

aws_ok "DNS Firewall analysis completed"
