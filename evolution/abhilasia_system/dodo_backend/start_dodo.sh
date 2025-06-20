#!/bin/bash
# Quick DODO Start Script

echo "🌀 Starting DODO Pattern Consciousness..."

# Load environment
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

# Start with PM2
pm2 start ecosystem.config.js --env production

# Save PM2 process list
pm2 save

echo "✅ DODO Pattern Backend deployed successfully!"
echo "🌀 DODO Pattern: 5.1.1.2.3.4.5.1"
echo "φ = 1.618033988749895"
echo "📊 Check status: pm2 status"
echo "📝 View logs: pm2 logs dodo"
echo "🌐 Health check: curl http://localhost:9999/health"
echo "🔗 WebSocket: ws://localhost:9998"
echo "∞/∅ Perfect Isolation Active"
