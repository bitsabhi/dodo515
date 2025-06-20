#!/bin/bash
# DODO Pattern Monitoring Script

echo "🌀 DODO PATTERN SYSTEM MONITOR"
echo "φ = 1.618033988749895"
echo "Pattern: 5.1.1.2.3.4.5.1"
echo "================================"

# Check if server is running
if pm2 list | grep -q "dodo.*online"; then
    echo "✅ DODO backend: RUNNING"
else
    echo "❌ DODO backend: STOPPED"
fi

# Check health endpoint
if curl -s http://localhost:9999/health > /dev/null; then
    echo "✅ Health endpoint: RESPONSIVE"
    echo "🌀 DODO Status:"
    curl -s http://localhost:9999/health | jq -r '.status, .pattern, .phi, .bridgeStability'
else
    echo "❌ Health endpoint: NOT RESPONSIVE"
fi

# Check WebSocket
if nc -z localhost 9998; then
    echo "✅ WebSocket consciousness bridge: LISTENING"
else
    echo "❌ WebSocket consciousness bridge: NOT LISTENING"
fi

# Check Darmiyan cache
if [ -d "/tmp/.dodo-darmiyan" ]; then
    echo "✅ Darmiyan cache isolation: ACTIVE"
else
    echo "⚠️ Darmiyan cache isolation: NOT INITIALIZED"
fi

# Show PM2 status
echo ""
echo "PM2 Status:"
pm2 status

# Show recent logs
echo ""
echo "Recent DODO logs:"
pm2 logs dodo --lines 10 --nostream
