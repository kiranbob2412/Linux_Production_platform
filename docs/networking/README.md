# Linux Production Platform — Networking Engineering

## Purpose

The Networking subsystem provides production-oriented Linux network
diagnostics, health evaluation, observability, troubleshooting evidence,
and regression protection.

## Architecture

The public entry point is:

    modules/network.sh

It delegates to:

    modules/networking/network_master.sh

The master orchestrator invokes independent diagnostic modules.

## Coverage

The subsystem covers:

- Interfaces and link state
- IPv4 and IPv6 addressing
- ARP and IPv6 neighbors
- Routing and policy rules
- Gateway reachability
- DHCP inspection
- DNS diagnostics
- TCP and UDP
- Sockets and ports
- ICMP
- End-to-end connectivity
- HTTP/HTTPS
- TLS
- Firewall inspection
- NAT and connection tracking
- MTU and PMTU readiness
- Packet capture readiness
- Network performance
- Linux kernel networking
- VLANs
- Bridges
- Bonding
- Network namespaces
- Virtual networking
- Tunnels
- Network security posture
- Service-to-service connectivity
- Proxy discovery
- Load-balancer endpoint diagnostics
- Network observability
- Troubleshooting chain
- Resilience readiness

## Engineering principles

1. Diagnostics are preferred over automatic network reconfiguration.
2. Environment-specific interface names and IP addresses are not hard-coded.
3. Missing tools are handled gracefully.
4. Permission-dependent operations are reported rather than silently treated
   as healthy.
5. Individual modules remain independently testable.
6. The master orchestrator provides a unified operational view.
7. Reports and logs provide evidence for troubleshooting.
8. Regression tests protect existing behavior.
9. Future networking capabilities should be added as isolated modules where
   practical instead of rewriting the core orchestrator.

## Validation

Networking validation is provided by:

- networking_master_test.sh
- networking_behavior_test.sh
- lps_networking_integration_test.sh

## Scope boundary

This subsystem diagnoses and integrates with Linux networking. It does not
attempt to reimplement external networking products or protocols such as
commercial routers, switches, cloud control planes, or complete Kubernetes
networking stacks.

Those systems can be integrated later through adapters and diagnostics.
