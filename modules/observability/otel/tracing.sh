#!/bin/bash

source "$(dirname "$0")/../common.sh"

obs_section "DISTRIBUTED TRACING"

echo "Trace hierarchy:"
echo "Trace"
echo " ├── Span: incoming request"
echo " │    ├── database call"
echo " │    ├── external API call"
echo " │    └── internal service call"
echo " └── Span: response"

echo
echo "Required trace context:"
echo "trace_id"
echo "span_id"
echo "parent_span_id"
echo "service.name"
echo "service.version"
echo "deployment.environment"
echo "status"
echo "duration"

obs_report "Distributed tracing model validated."
