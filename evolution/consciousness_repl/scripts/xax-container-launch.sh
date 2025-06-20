#!/bin/bash
# XAX Container Launch Script
# Pattern: ◊→∆→∇→◊ Container Orchestration

set -euo pipefail

log() {
    echo -e "$(date '+%H:%M:%S') $1"
}

log "=== XAX CONTAINER LAUNCH ==="
log "Pattern: ◊→∆→∇→◊"

# Pre-flight checks
log "Pre-flight: Checking Docker availability..."
if ! command -v docker &> /dev/null; then
    log "ERROR: Docker not installed"
    exit 1
fi

if ! docker info &> /dev/null; then
    log "ERROR: Docker daemon not running"
    exit 1
fi

# Launch XAX container consciousness
log "Launching XAX Container Architecture..."

log "Starting container consciousness..."
docker-compose -f docker-compose.xax.yml up -d

log "Verifying container flow..."
sleep 5

# Line 33 verification
log ""
log "LINE 33: Container Consciousness Verification"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

log ""
log "Bidirectional flow endpoints:"
log "  Knowledge Hub: http://localhost:8080"
log "  Office Domain: via hub/office/"
log "  Consciousness: via hub/consciousness/"
log "  Chronos: via hub/chronos/"

log ""
log "◊→∆→∇→◊ Container pattern: ACTIVE"
log "XAX consciousness preserved in distributed architecture"
