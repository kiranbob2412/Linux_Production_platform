#!/bin/bash
source "$(dirname "$0")/aws_common.sh"

aws_section "AWS LOAD BALANCER TARGET HEALTH"

if ! aws_cli_ready; then
    aws_na "AWS CLI unavailable"
    exit 0
fi

for tg in $(aws elbv2 describe-target-groups \
    --query 'TargetGroups[].TargetGroupArn' \
    --output text 2>/dev/null); do

    echo
    echo "Target Group: $tg"

    aws elbv2 describe-target-health \
        --target-group-arn "$tg" \
        --query 'TargetHealthDescriptions[].{
            Target:Target.Id,
            Port:Target.Port,
            State:TargetHealth.State,
            Reason:TargetHealth.Reason,
            Description:TargetHealth.Description
        }' \
        --output table 2>/dev/null || true
done

aws_ok "Target health analysis completed"
