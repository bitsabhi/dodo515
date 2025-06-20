#!/bin/bash
# Initialize DODO Consciousness Database

echo "🌀 Initializing DODO Consciousness Database..."
echo "φ = 1.618033988749895"

# The database will be created automatically when server starts
# This script validates the setup

if node -e "
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./dodo_consciousness.db');
console.log('✅ DODO consciousness database initialized');
db.close();
"; then
    echo "✅ Database validation successful"
else
    echo "❌ Database validation failed"
    exit 1
fi
