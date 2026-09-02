# Fluent Bit Integration

## Current Runtime

Fluent Bit is currently installed through Snap and managed by systemd.

Current process:

    /snap/fluent-bit/17/bin/fluent-bit

Current configuration:

    /snap/fluent-bit/17/etc/fluent-bit/fluent-bit.conf

Current pipeline:

    CPU input -> stdout

## Compatibility Finding

The Snap binary cannot be manually executed from the current Ubuntu
environment because it requires:

    libssl.so.1.1

The required legacy OpenSSL library is not available.

Therefore the existing Snap runtime must not be modified blindly.

## Production Direction

Use a current Fluent Bit build compatible with the host OS and configure:

    Linux logs
        ->
    Fluent Bit
        ->
    OpenTelemetry Collector
        ->
    Logs backend

The existing OpenTelemetry -> Prometheus metrics pipeline must remain
untouched.
