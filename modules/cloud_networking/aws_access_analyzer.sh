#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS NETWORK ACCESS ANALYZER"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Network Access Analyzer scopes:"

aws ec2 describe-network-insights-access-scope \
    --query 'NetworkInsightsAccessScopes[].{
        ScopeId:NetworkInsightsAccessScopeId,
        ARN:NetworkInsightsAccessScopeArn,
        Created:CreatedDate,
        Updated:UpdatedDate
    }' \
    --output table 2>/dev/null || true

echo
echo "Access scope analyses:"

aws ec2 describe-network-insights-access-scope-analyses \
    --query 'NetworkInsightsAccessScopeAnalyses[].{
        Analysis:NetworkInsightsAccessScopeAnalysisId,
        Scope:NetworkInsightsAccessScopeId,
        Status:Status,
        Start:StartDate,
        End:EndDate
    }' \
    --output table 2>/dev/null || true

aws_ok "Network Access Analyzer inventory completed"
