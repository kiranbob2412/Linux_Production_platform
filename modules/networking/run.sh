#!/bin/bash

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

exec "$ROOT/modules/networking/network_master.sh" "$@"
