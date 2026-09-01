#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS VPC FLOW LOGS"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

aws ec2 describe-flow-logs \
    --query 'FlowLogs[].{
        FlowLog:FlowLogId,
        Resource:ResourceId,
        Traffic:TrafficType,
        Status:FlowLogStatus,
        Destination:LogDestination,
        DestinationType:LogDestinationType,
        Version:LogFormat
    }' \
    --output table 2>/dev/null || {
        aws_warn "VPC Flow Logs unavailable"
        exit 0
    }

aws_ok "VPC Flow Log inventory completed"
