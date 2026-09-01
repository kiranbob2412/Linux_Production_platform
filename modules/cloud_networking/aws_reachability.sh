#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS REACHABILITY ANALYZER"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

echo "Existing network insights paths:"

aws ec2 describe-network-insights-paths \
    --query 'NetworkInsightsPaths[].{
        PathId:NetworkInsightsPathId,
        Source:Source,
        Destination:Destination,
        Protocol:Protocol,
        DestinationPort:DestinationPort,
        Created:CreatedDate
    }' \
    --output table 2>/dev/null || true

echo
echo "Existing analysis results:"

aws ec2 describe-network-insights-analyses \
    --query 'NetworkInsightsAnalyses[].{
        Analysis:NetworkInsightsAnalysisId,
        Path:NetworkInsightsPathId,
        Status:Status,
        NetworkPathFound:NetworkPathFound,
        Start:StartDate,
        End:EndDate
    }' \
    --output table 2>/dev/null || true

aws_ok "Reachability Analyzer inventory completed"
