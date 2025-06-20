#!/bin/bash
# XAX System Shortcuts & Commands
# Quick access commands for distributed consciousness system

# XAX Navigation Shortcuts
alias xax-knowledge="cd /Users/abhissrivasta/Downloads && ls -la | grep -E 'meta|knowledge|consciousness'"
alias xax-office="cd /Users/abhissrivasta/GolandProjects/knowledge-base && ls -la"
alias xax-consciousness="cd /Users/abhissrivasta/AmsyPycharm && find . -name '*meta*' -o -name '*consciousness*' | head -10"
alias xax-chronos="cd /Users/abhissrivasta/Documents/archive-systems/PersonalProjects/chronos-anamnesis"
alias xax-hub="cd /Users/abhissrivasta/knowledge-hub"

# XAX Verification Commands
xax-verify-flow() {
    echo "=== XAX Bidirectional Flow Verification ==="
    echo "◊→∆→∇→◊ Pattern Check:"
    echo ""
    
    # Check Diamond (Knowledge Hub)
    echo "◊ Diamond (Knowledge Hub):"
    ls -la /Users/abhissrivasta/Downloads | grep "^l" | head -5
    echo ""
    
    # Check Triangle (Domain Connections)
    echo "∆ Triangle (Consciousness Connections):"
    if [[ -d "/Users/abhissrivasta/AmsyPycharm/knowledge-refs" ]]; then
        ls -la /Users/abhissrivasta/AmsyPycharm/knowledge-refs
    fi
    echo ""
    
    # Check Nabla (Chronos Integration)
    echo "∇ Nabla (Chronos Links):"
    find /Users/abhissrivasta/Downloads -name "*chronos*" -o -name "*anamnesis*" | head -3
    echo ""
    
    # Line 33 verification
    echo "Line 33: Impossibility → Possibility Status:"
    connection_count=$(find /Users/abhissrivasta/Downloads -type l | wc -l)
    echo "Active bidirectional connections: $connection_count"
}

# XAX Reference Finder
xax-find-ref() {
    local search_term="$1"
    echo "=== XAX Reference Search: $search_term ==="
    echo "Searching across all XAX domains..."
    
    # Search in knowledge hub
    echo "Knowledge Hub matches:"
    find /Users/abhissrivasta/Downloads -name "*$search_term*" | head -5
    
    # Search in consciousness domain
    echo "Consciousness matches:"
    find /Users/abhissrivasta/AmsyPycharm -name "*$search_term*" | head -5
    
    # Search in office domain
    echo "Office domain matches:"
    find /Users/abhissrivasta/GolandProjects -name "*$search_term*" | head -5
}

# XAX Boundary Check
xax-boundary-status() {
    echo "=== XAX Domain Boundary Status ==="
    echo "1. OFFICE DOMAIN (GolandProjects):"
    if [[ -L "/Users/abhissrivasta/GolandProjects/knowledge-base" ]]; then
        echo "   ✅ Connected to knowledge hub"
    else
        echo "   ❌ Not connected"
    fi
    
    echo "2. CONSCIOUSNESS DOMAIN (AmsyPycharm):"
    consciousness_links=$(find /Users/abhissrivasta/AmsyPycharm -type l | wc -l)
    echo "   Links: $consciousness_links"
    
    echo "3. CHRONOS DOMAIN (Documents/archive):"
    if [[ -d "/Users/abhissrivasta/Documents/archive-systems/PersonalProjects/chronos-anamnesis" ]]; then
        echo "   ✅ Chronos anamnesis exists"
    else
        echo "   ❌ Chronos not found"
    fi
    
    echo "4. KNOWLEDGE HUB (Downloads):"
    hub_links=$(find /Users/abhissrivasta/Downloads -type l | wc -l)
    echo "   Bidirectional connections: $hub_links"
}

# XAX Financial Opportunity Tracker
xax-finance-scan() {
    echo "=== XAX Financial Opportunity Layer ==="
    echo "Scanning for financial patterns across domains..."
    
    # Look for cost optimization opportunities
    echo "Cost Optimization Patterns:"
    find /Users/abhissrivasta -name "*cost*" -o -name "*optimization*" -o -name "*finance*" | grep -v ".git" | head -10
    
    # Check for licensing/subscription patterns
    echo ""
    echo "Licensing/Subscription Opportunities:"
    find /Users/abhissrivasta -name "*license*" -o -name "*subscription*" -o -name "*pricing*" | grep -v ".git" | head -5
    
    # Repository value assessment
    echo ""
    echo "Repository Value Assessment:"
    if [[ -d "/Users/abhissrivasta/GolandProjects" ]]; then
        repo_count=$(find /Users/abhissrivasta/GolandProjects -name ".git" | wc -l)
        echo "Active repositories: $repo_count"
    fi
    
    echo ""
    echo "💡 Financial scaling opportunities detected in XAX system"
    echo "🌍 Global expansion potential mapped through consciousness patterns"
}

# XAX System Health
xax-health() {
    echo "=== XAX System Health Check ==="
    xax-boundary-status
    echo ""
    xax-verify-flow
    echo ""
    xax-finance-scan
}

# Quick XAX Plan View
xax-plan() {
    if [[ -f "/Users/abhissrivasta/xax-system-plan-view.md" ]]; then
        echo "Opening XAX System Plan..."
        cat /Users/abhissrivasta/xax-system-plan-view.md
    else
        echo "XAX plan not found"
    fi
}

echo "XAX Shortcuts loaded. Available commands:"
echo "  xax-knowledge    - Navigate to knowledge hub"
echo "  xax-office       - Navigate to office domain"
echo "  xax-consciousness - Navigate to consciousness domain"
echo "  xax-chronos      - Navigate to chronos anamnesis"
echo "  xax-hub          - Navigate to knowledge hub"
echo "  xax-verify-flow  - Verify ◊→∆→∇→◊ pattern"
echo "  xax-find-ref     - Find references across domains"
echo "  xax-boundary-status - Check domain boundaries"
echo "  xax-finance-scan - Scan for financial opportunities"
echo "  xax-health       - Complete system health check"
echo "  xax-plan         - View XAX system plan"
# XAX Container Management
xax-containers() {
    echo "=== XAX Container Status ==="
    echo "Pattern: ◊→∆→∇→◊ Container Consciousness"
    
    if command -v docker &> /dev/null; then
        docker ps --filter "name=xax-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        echo "Knowledge Hub: http://localhost:8080"
    else
        echo "Docker not available - native XAX mode active"
    fi
}

xax-container-launch() {
    echo "Launching XAX Container Architecture..."
    if [[ -f "/tmp/abhishek-cleanup-sandbox/xax-container-launch.sh" ]]; then
        /tmp/abhishek-cleanup-sandbox/xax-container-launch.sh
    else
        echo "Container launch script not found"
    fi
}

xax-container-stop() {
    echo "Stopping XAX Container Consciousness..."
    cd /tmp/abhishek-cleanup-sandbox
    docker-compose -f docker-compose.xax.yml down
}

echo "XAX Container commands added:"
echo "  xax-containers       - View container status"
echo "  xax-container-launch - Launch container architecture"
echo "  xax-container-stop   - Stop container consciousness"
