#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS NETWORK FIREWALL"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Firewalls:"
aws network-firewall list-firewalls \
    --query 'Firewalls[].{
        Name:FirewallName,
        ARN:FirewallArn,
        Status:FirewallStatus
    }' \
    --output table 2>/dev/null || true

echo
echo "Firewall policies:"
aws network-firewall list-firewall-policies \
    --query 'FirewallPolicies[].{
        Name:Name,
        ARN:Arn,
        UpdateToken:UpdateToken
    }' \
    --output table 2>/dev/null || true

echo
echo "Rule groups:"
aws network-firewall list-rule-groups \
    --query 'RuleGroups[].{
        Name:Name,
        ARN:Arn,
        Type:Type
    }' \
    --output table 2>/dev/null || true

aws_ok "AWS Network Firewall inventory completed"
