#!/bin/bash
# Spinnaker CLI Test Setup Script
# For testing certificate-notification-system deployments

set -euo pipefail

echo "=== Spinnaker CLI & Testing Setup ==="
echo "Setting up tools for certificate-notification-system testing"
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Install Spinnaker CLI (spin)
install_spin_cli() {
    log "Installing Spinnaker CLI..."
    
    # Check if already installed
    if command -v spin &> /dev/null; then
        log "Spinnaker CLI already installed: $(spin version 2>/dev/null || echo 'installed')"
        return 0
    fi
    
    # Download latest spin CLI
    SPIN_VERSION="1.33.0"  # Latest stable version
    OS="darwin"  # macOS
    ARCH="amd64"
    
    log "Downloading spin CLI v${SPIN_VERSION}..."
    curl -LO "https://github.com/spinnaker/spin/releases/download/v${SPIN_VERSION}/spin-${OS}-${ARCH}.tar.gz"
    
    # Extract and install
    tar -xzf "spin-${OS}-${ARCH}.tar.gz"
    chmod +x spin
    
    # Move to /usr/local/bin or use local directory
    if [[ -w "/usr/local/bin" ]]; then
        sudo mv spin /usr/local/bin/
        log "Installed spin to /usr/local/bin/spin"
    else
        mkdir -p "$HOME/.local/bin"
        mv spin "$HOME/.local/bin/"
        log "Installed spin to $HOME/.local/bin/spin"
        warn "Add $HOME/.local/bin to your PATH"
    fi
    
    # Cleanup
    rm -f "spin-${OS}-${ARCH}.tar.gz"
}

# 2. Create Spinnaker config template
create_spin_config() {
    log "Creating Spinnaker CLI config template..."
    
    SPIN_CONFIG_DIR="$HOME/.spin"
    mkdir -p "$SPIN_CONFIG_DIR"
    
    cat > "$SPIN_CONFIG_DIR/config.example" << 'EOF'
# Spinnaker CLI Configuration
# Copy this to ~/.spin/config and update with your values

gate:
  endpoint: https://spinnaker-api.your-domain.com

auth:
  enabled: true
  x509:
    certPath: /path/to/client.crt
    keyPath: /path/to/client.key
  # OR use basic auth:
  # basic:
  #   username: your-username
  #   password: your-password

# For Expedia internal Spinnaker
# gate:
#   endpoint: https://spinnaker-api.prod.expedia.com
EOF
    
    log "Created config template at $SPIN_CONFIG_DIR/config.example"
}

# 3. Create test scripts for certificate-notification-system
create_test_scripts() {
    log "Creating certificate-notification-system test scripts..."
    
    TEST_DIR="$HOME/certificate-notification-tests"
    mkdir -p "$TEST_DIR"
    
    # Basic health check script
    cat > "$TEST_DIR/test-health.sh" << 'EOF'
#!/bin/bash
# Test certificate-notification-system health endpoint

SERVICE_URL="${1:-http://localhost:8080}"
echo "Testing certificate-notification-system at: $SERVICE_URL"

# Health check
echo "1. Health Check:"
curl -s "$SERVICE_URL/health" | jq '.' || echo "Failed to get health status"

# API version
echo -e "\n2. API Version:"
curl -s "$SERVICE_URL/api/v1/version" | jq '.' || echo "No version endpoint"

# List certificates
echo -e "\n3. List Certificates:"
curl -s "$SERVICE_URL/api/v1/certificates" | jq '.' || echo "Failed to list certificates"
EOF
    chmod +x "$TEST_DIR/test-health.sh"
    
    # Docker test script
    cat > "$TEST_DIR/test-docker.sh" << 'EOF'
#!/bin/bash
# Test certificate-notification-system with Docker

echo "=== Docker Test for Certificate Notification Service ==="

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo "ERROR: Docker is not running"
    exit 1
fi

# Pull or build the image
IMAGE="certificate-notification-service:test"
echo "Building Docker image..."
if [[ -f "Dockerfile" ]]; then
    docker build -t "$IMAGE" .
else
    echo "No Dockerfile found in current directory"
    echo "Trying to pull from registry..."
    # Update with your registry
    docker pull "your-registry/$IMAGE" || exit 1
fi

# Run container
echo "Starting container..."
docker run -d \
    --name cert-notification-test \
    -p 8080:8080 \
    -e LOG_LEVEL=debug \
    "$IMAGE"

# Wait for startup
echo "Waiting for service to start..."
sleep 5

# Test the service
echo "Testing service endpoints..."
curl -s http://localhost:8080/health | jq '.'

# Cleanup
echo "Cleaning up..."
docker stop cert-notification-test
docker rm cert-notification-test

echo "Docker test complete!"
EOF
    chmod +x "$TEST_DIR/test-docker.sh"
    
    # Spinnaker pipeline test
    cat > "$TEST_DIR/test-spinnaker-pipeline.sh" << 'EOF'
#!/bin/bash
# Test Spinnaker pipeline execution

APP_NAME="certificate-notification-system"
PIPELINE_NAME="${1:-deploy-to-test}"

echo "=== Spinnaker Pipeline Test ==="
echo "Application: $APP_NAME"
echo "Pipeline: $PIPELINE_NAME"

# Check spin CLI
if ! command -v spin &> /dev/null; then
    echo "ERROR: spin CLI not installed"
    exit 1
fi

# List pipelines
echo -e "\nAvailable pipelines:"
spin pipeline list --application "$APP_NAME" 2>/dev/null || {
    echo "Failed to list pipelines. Check your spin config."
    exit 1
}

# Get pipeline config
echo -e "\nPipeline configuration:"
spin pipeline get --application "$APP_NAME" --name "$PIPELINE_NAME" 2>/dev/null || {
    echo "Pipeline not found: $PIPELINE_NAME"
    exit 1
}

# Execute pipeline (dry run)
echo -e "\nTo execute pipeline, run:"
echo "spin pipeline execute --application $APP_NAME --name $PIPELINE_NAME"
EOF
    chmod +x "$TEST_DIR/test-spinnaker-pipeline.sh"
    
    log "Created test scripts in $TEST_DIR/"
}

# 4. Create Kubernetes test script
create_k8s_test() {
    log "Creating Kubernetes test script..."
    
    cat > "$HOME/certificate-notification-tests/test-k8s.sh" << 'EOF'
#!/bin/bash
# Test certificate-notification-service in Kubernetes

NAMESPACE="${1:-certificate-system}"
SERVICE_NAME="certificate-notification-service"

echo "=== Kubernetes Test ==="
echo "Namespace: $NAMESPACE"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "ERROR: kubectl not installed"
    exit 1
fi

# Check deployment
echo "1. Checking deployment status:"
kubectl get deployment "$SERVICE_NAME" -n "$NAMESPACE" || exit 1

# Check pods
echo -e "\n2. Pod status:"
kubectl get pods -n "$NAMESPACE" -l app="$SERVICE_NAME"

# Check service
echo -e "\n3. Service endpoints:"
kubectl get svc "$SERVICE_NAME" -n "$NAMESPACE"

# Port forward for testing
echo -e "\n4. Setting up port forward..."
kubectl port-forward -n "$NAMESPACE" "svc/$SERVICE_NAME" 8080:80 &
PF_PID=$!
sleep 3

# Test the service
echo -e "\n5. Testing service:"
curl -s http://localhost:8080/health | jq '.'

# Cleanup
kill $PF_PID 2>/dev/null

echo -e "\nKubernetes test complete!"
EOF
    chmod +x "$HOME/certificate-notification-tests/test-k8s.sh"
}

# 5. Install additional testing tools
install_test_tools() {
    log "Checking additional testing tools..."
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        warn "jq not installed. Install with: brew install jq"
    fi
    
    # Check for httpie (better than curl for API testing)
    if ! command -v http &> /dev/null; then
        warn "httpie not installed. Install with: brew install httpie"
    fi
    
    # Check for k9s (Kubernetes CLI UI)
    if ! command -v k9s &> /dev/null; then
        warn "k9s not installed. Install with: brew install k9s"
    fi
}

# Main execution
main() {
    echo "Starting Spinnaker & Testing Setup..."
    echo ""
    
    # Install Spinnaker CLI
    install_spin_cli
    
    # Create configurations
    create_spin_config
    
    # Create test scripts
    create_test_scripts
    create_k8s_test
    
    # Check additional tools
    install_test_tools
    
    echo ""
    log "=== Setup Complete! ==="
    echo ""
    echo "Next steps:"
    echo "1. Configure Spinnaker CLI:"
    echo "   cp ~/.spin/config.example ~/.spin/config"
    echo "   # Edit ~/.spin/config with your Spinnaker endpoint"
    echo ""
    echo "2. Run tests:"
    echo "   ~/certificate-notification-tests/test-health.sh"
    echo "   ~/certificate-notification-tests/test-docker.sh"
    echo "   ~/certificate-notification-tests/test-k8s.sh"
    echo "   ~/certificate-notification-tests/test-spinnaker-pipeline.sh"
    echo ""
    echo "3. Quick API test:"
    echo "   curl http://localhost:8080/health | jq '.'"
    echo ""
    
    # Add to PATH if needed
    if [[ -f "$HOME/.local/bin/spin" ]] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "4. Add to PATH (add to ~/.bashrc or ~/.zshrc):"
        echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
}

# Run main
main