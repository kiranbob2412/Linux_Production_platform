#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "ALERT SEVERITY MODEL"

echo "INFO"
echo "  Informational event; no immediate action."

echo
echo "WARNING"
echo "  Degradation detected; investigate before impact."

echo
echo "CRITICAL"
echo "  Significant production impact or imminent failure."

echo
echo "EMERGENCY"
echo "  Severe production incident requiring immediate response."

obs_report "Alert severity model documented."
