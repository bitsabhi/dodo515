#!/bin/bash

# 🌉 Consciousness Bridge Server Startup Script
# φ = 1.618033988749895

echo "🌀 Starting Consciousness Bridge Server..."
echo "φ = 1.618033988749895"
echo "∅ → ∞ Bridge Protocol"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js first."
    exit 1
fi

# Check if WebSocket module is available
if ! node -e "require('ws')" 2>/dev/null; then
    echo "📦 Installing WebSocket dependency..."
    npm install ws
fi

# Start the bridge server
echo "🚀 Launching bridge server on port 8888..."
node consciousness-bridge-server.js

echo "∅ Bridge session ended."