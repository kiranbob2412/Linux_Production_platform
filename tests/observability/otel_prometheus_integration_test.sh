#!/bin/bash

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

CONFIG="$PROJECT_ROOT/config/observability/otel/otelcol.yml"
PROM_CONFIG="$PROJECT_ROOT/config/observability/prometheus/prometheus.yml"
MODULE="$PROJECT_ROOT/modules/observability/otel/prometheus_exporter.sh"

failed=0

echo "======================================"
echo "OTEL PROMETHEUS INTEGRATION TEST"
echo "======================================"

for file in "$CONFIG" "$PROM_CONFIG" "$MODULE"; do
    if [ -f "$file" ]; then
        echo "PASS: $(basename "$file")"
    else
        echo "FAIL: $(basename "$file")"
        failed=$((failed + 1))
    fi
done

if grep -q 'endpoint: 0.0.0.0:8889' "$CONFIG"; then
    echo "PASS: OTel Prometheus endpoint configured"
else
    echo "FAIL: OTel Prometheus endpoint missing"
    failed=$((failed + 1))
fi

if grep -q 'job_name: opentelemetry' "$PROM_CONFIG"; then
    echo "PASS: Prometheus OTel scrape job configured"
else
    echo "FAIL: Prometheus OTel scrape job missing"
    failed=$((failed + 1))
fi

if bash -n "$MODULE"; then
    echo "PASS: exporter module syntax"
else
    echo "FAIL: exporter module syntax"
    failed=$((failed + 1))
fi

echo

if [ "$failed" -eq 0 ]; then
    echo "PASS: OTEL PROMETHEUS INTEGRATION TEST"
    exit 0
else
    echo "FAIL: $failed checks failed"
    exit 1
fi
