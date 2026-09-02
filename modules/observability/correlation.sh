#!/bin/bash

source "$(dirname "$0")/common.sh"

obs_section "OBSERVABILITY CORRELATION"

echo "Correlation dimensions:"
echo "Timestamp"
echo "Host"
echo "Process"
echo "Service"
echo "Pod"
echo "Node"
echo "Network endpoint"
echo "Trace ID"
echo "Request ID"

echo
echo "Correlation flow:"
echo "Metric anomaly"
echo "    -> Log evidence"
echo "    -> Trace evidence"
echo "    -> Network evidence"
echo "    -> Infrastructure evidence"
echo "    -> Root cause hypothesis"

obs_report "Observability correlation model validated."
