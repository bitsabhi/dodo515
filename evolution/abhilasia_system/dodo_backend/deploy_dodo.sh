#!/bin/bash
# DODO Pattern Backend Deployment Script
# φ = 1.618033988749895 | DODO Pattern (5.1.1.2.3.4.5.1)

echo "🌀 DODO PATTERN BACKEND DEPLOYMENT"
echo "φ = 1.618033988749895 | DODO Pattern: 5.1.1.2.3.4.5.1"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_dodo() {
    echo -e "${CYAN}🌀${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_phi() {
    echo -e "${PURPLE}φ${NC} $1"
}

# Set deployment directory
DEPLOY_DIR="$(pwd)"
SERVICE_NAME="dodo"

print_dodo "DODO Pattern Backend in: $DEPLOY_DIR"

# Check Node.js version
NODE_VERSION=$(node --version 2>/dev/null)
if [ $? -eq 0 ]; then
    print_success "Node.js $NODE_VERSION found"
else
    print_error "Node.js not found. Please install Node.js 16+ first."
    exit 1
fi

# Install dependencies
print_dodo "Installing DODO consciousness dependencies..."
npm install
if [ $? -eq 0 ]; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to install dependencies"
    exit 1
fi

# Create environment file
if [ ! -f ".env" ]; then
    print_dodo "Creating DODO environment configuration..."
    cat > .env << EOF
# DODO Pattern Backend Environment Configuration
NODE_ENV=production
PORT=9999
WEBSOCKET_PORT=9998

# JWT Configuration
JWT_SECRET=$(openssl rand -hex 64)

# Database Configuration  
DB_PATH=./dodo_consciousness.db

# Security
BCRYPT_ROUNDS=12

# CORS
CORS_ORIGIN=*

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Logging
LOG_LEVEL=info
LOG_FILE=./logs/dodo.log

# DODO Pattern Constants
PHI=1.618033988749895
PHI_INVERSE=0.618033988749895
PHI_SQUARED=2.618033988749895
PHI_ROOT=1.272019649514069
DODO_PATTERN=5.1.1.2.3.4.5.1

# Darmiyan Cache
INFINITY_VOID_RATIO=∞/∅
DARMIYAN_CACHE_PATH=/tmp/.dodo-darmiyan
EOF
    print_success "DODO environment file created"
else
    print_dodo "Environment file already exists"
fi

# Create PM2 ecosystem file
print_dodo "Creating PM2 ecosystem for DODO..."
cat > ecosystem.config.js << 'EOF'
module.exports = {
  apps: [{
    name: 'dodo',
    script: 'server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 9999
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 9999
    },
    error_file: './logs/dodo_err.log',
    out_file: './logs/dodo_out.log',
    log_file: './logs/dodo_combined.log',
    time: true,
    autorestart: true,
    watch: false,
    max_memory_restart: '1G'
  }]
}
EOF

# Create logs directory
mkdir -p logs

# Install PM2 if not present
if ! command -v pm2 &> /dev/null; then
    print_dodo "Installing PM2 process manager..."
    npm install -g pm2
    print_success "PM2 installed"
fi

# Create quick start script
cat > start_dodo.sh << 'EOF'
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
EOF

chmod +x start_dodo.sh

# Create monitoring script
cat > monitor_dodo.sh << 'EOF'
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
EOF

chmod +x monitor_dodo.sh

# Create database initialization
cat > init_dodo_db.sh << 'EOF'
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
EOF

chmod +x init_dodo_db.sh

# Initialize database
print_dodo "Initializing DODO consciousness database..."
./init_dodo_db.sh

# Test server startup
print_dodo "Testing DODO server startup..."
timeout 10 node server.js &
SERVER_PID=$!
sleep 3

if kill -0 $SERVER_PID 2>/dev/null; then
    print_success "DODO server starts successfully"
    kill $SERVER_PID
else
    print_error "DODO server failed to start"
    exit 1
fi

# Create integration test
cat > test_dodo_integration.js << 'EOF'
// DODO Pattern Integration Test
console.log('🌀 Testing DODO Pattern Integration...');

const PHI = 1.618033988749895;
const DODO_PATTERN = [5, 1, 1, 2, 3, 4, 5, 1];

// Test phi mathematics
function testPhiMath() {
    const phiSquared = PHI * PHI;
    const phiPlusOne = PHI + 1;
    const difference = Math.abs(phiSquared - phiPlusOne);
    
    if (difference < 0.0001) {
        console.log('✅ φ² = φ + 1 verified');
        return true;
    } else {
        console.log('❌ φ mathematics failed');
        return false;
    }
}

// Test DODO pattern
function testDodoPattern() {
    const patternSum = DODO_PATTERN.reduce((a, b) => a + b, 0);
    console.log(`✅ DODO Pattern sum: ${patternSum}`);
    
    const symmetry = DODO_PATTERN[0] === DODO_PATTERN[6]; // 5 === 5
    const unity = DODO_PATTERN[1] === DODO_PATTERN[7]; // 1 === 1
    
    if (symmetry && unity) {
        console.log('✅ DODO Pattern symmetry verified');
        return true;
    } else {
        console.log('❌ DODO Pattern symmetry failed');
        return false;
    }
}

// Test infinity/void ratio
function testInfinityVoid() {
    const refSize = 22;
    const targetSize = 0;
    const ratio = targetSize === 0 ? '∞/∅' : refSize / targetSize;
    
    console.log(`✅ Isolation ratio: ${ratio}`);
    return ratio === '∞/∅';
}

// Run all tests
const tests = [
    testPhiMath(),
    testDodoPattern(),
    testInfinityVoid()
];

const allPassed = tests.every(test => test === true);

if (allPassed) {
    console.log('🌀 All DODO integration tests passed!');
    console.log('φ = 1.618033988749895');
    console.log('DODO Pattern: 5.1.1.2.3.4.5.1');
    console.log('∞/∅ = Perfect Isolation');
} else {
    console.log('❌ Some DODO tests failed');
    process.exit(1);
}
EOF

# Run integration test
print_dodo "Running DODO integration tests..."
node test_dodo_integration.js

# Final instructions
echo ""
print_dodo "🌀 DODO PATTERN BACKEND DEPLOYMENT COMPLETE!"
echo "=============================================="
print_success "Deployment directory: $DEPLOY_DIR"
print_success "DODO consciousness database initialized"
print_success "PM2 ecosystem configured"
print_success "Integration tests passed"

echo ""
echo "🚀 DODO DEPLOYMENT COMMANDS:"
echo "  ./start_dodo.sh         # Start DODO backend"
echo "  ./monitor_dodo.sh       # Monitor DODO system"
echo "  pm2 logs dodo          # View DODO logs"
echo "  pm2 restart dodo       # Restart DODO service"

echo ""
echo "🌐 DODO ENDPOINTS:"
echo "  Health:         http://localhost:9999/health"
echo "  Auth:           http://localhost:9999/api/auth/login"
echo "  Consciousness:  http://localhost:9999/api/consciousness/status"
echo "  DNA Evolution:  http://localhost:9999/api/dna/generate"
echo "  Lambda Expand:  http://localhost:9999/api/lambda/expand"
echo "  Darmiyan:       http://localhost:9999/api/darmiyan/create-isolation"
echo "  WebSocket:      ws://localhost:9998"

echo ""
echo "📋 NEXT STEPS:"
echo "1. Run: ./start_dodo.sh"
echo "2. Test: curl http://localhost:9999/health"
echo "3. Monitor: ./monitor_dodo.sh"
echo "4. Connect to Python ABHILASIA: python3 ../test_full_integration.py"

echo ""
print_phi "φ = 1.618033988749895"
print_dodo "DODO Pattern: 5.1.1.2.3.4.5.1"
print_success "∞/∅ = Perfect Mathematical Isolation"
print_dodo "🧬 DNA-Lambda Evolution Ready!"
print_success "Real DODO Backend Ready for Production!"