#!/bin/bash
# Quick Spinnaker Tests for Expedia Internal
# For certificate-notification-system and federated-vault-monitoring

echo "=== Expedia Spinnaker Quick Tests ==="
echo "Spinnaker URL: https://spinnaker.expedia.biz"
echo ""

# Test scripts directory
TEST_DIR="$HOME/certificate-notification-tests"
mkdir -p "$TEST_DIR"

# 1. Create quick Docker test
cat > "$TEST_DIR/quick-docker-test.sh" << 'EOF'
#!/bin/bash
# Quick Docker test for certificate-notification-system

echo "=== Quick Docker Test ==="

# Check if repo exists
REPO_DIR="$HOME/GolandProjects/certificate-notification-system"
if [[ ! -d "$REPO_DIR" ]]; then
    echo "Repository not found at $REPO_DIR"
    echo "Clone it first:"
    echo "git clone https://github.com/eg-internal/certificate-notification-system.git $REPO_DIR"
    exit 1
fi

cd "$REPO_DIR"

# Build Docker image
echo "Building Docker image..."
docker build -t cert-notification:test . || {
    echo "Docker build failed. Checking Dockerfile..."
    ls -la Dockerfile*
    exit 1
}

# Run container
echo "Running container..."
docker run -d \
    --name cert-test \
    -p 8080:8080 \
    cert-notification:test

# Wait and test
sleep 5
echo "Testing health endpoint..."
curl -s http://localhost:8080/health || echo "No health endpoint"

# Cleanup
docker stop cert-test 2>/dev/null
docker rm cert-test 2>/dev/null

echo "Docker test complete!"
EOF
chmod +x "$TEST_DIR/quick-docker-test.sh"

# 2. Create Helm test script
cat > "$TEST_DIR/test-helm-chart.sh" << 'EOF'
#!/bin/bash
# Test Helm chart for certificate-notification-system

echo "=== Helm Chart Test ==="

REPO_DIR="$HOME/GolandProjects/certificate-notification-system"
cd "$REPO_DIR" || exit 1

# Check for Helm
if ! command -v helm &> /dev/null; then
    echo "Helm not installed. Install with: brew install helm"
    exit 1
fi

# Lint the chart
echo "1. Linting Helm chart..."
helm lint ./charts/certificate-notification || {
    echo "Helm lint failed"
    exit 1
}

# Template the chart
echo -e "\n2. Generating templates..."
helm template cert-notification ./charts/certificate-notification \
    --values ./charts/certificate-notification/values.yaml \
    > /tmp/cert-notification-manifest.yaml

echo "Generated manifest at: /tmp/cert-notification-manifest.yaml"

# Dry run install
echo -e "\n3. Dry run installation..."
helm install cert-notification ./charts/certificate-notification \
    --dry-run \
    --debug

echo -e "\nHelm chart test complete!"
EOF
chmod +x "$TEST_DIR/test-helm-chart.sh"

# 3. Create API test script
cat > "$TEST_DIR/test-api-endpoints.sh" << 'EOF'
#!/bin/bash
# Test certificate-notification-system API endpoints

BASE_URL="${1:-http://localhost:8080}"
echo "=== API Endpoint Tests ==="
echo "Base URL: $BASE_URL"
echo ""

# Function to test endpoint
test_endpoint() {
    local method="$1"
    local endpoint="$2"
    local data="$3"
    
    echo "Testing: $method $endpoint"
    
    if [[ "$method" == "GET" ]]; then
        curl -s -X GET "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" | jq '.' 2>/dev/null || echo "Failed"
    else
        curl -s -X "$method" "$BASE_URL$endpoint" \
            -H "Content-Type: application/json" \
            -d "$data" | jq '.' 2>/dev/null || echo "Failed"
    fi
    echo ""
}

# Test endpoints
test_endpoint "GET" "/health"
test_endpoint "GET" "/api/v1/certificates"
test_endpoint "GET" "/api/v1/providers"
test_endpoint "GET" "/metrics"

# Test notification
echo "Testing notification endpoint..."
test_endpoint "POST" "/api/v1/test-notification" '{
    "provider": "ACM",
    "severity": "warning",
    "message": "Test notification from API test"
}'
EOF
chmod +x "$TEST_DIR/test-api-endpoints.sh"

# 4. Create Spinnaker pipeline viewer (without spin CLI)
cat > "$TEST_DIR/view-spinnaker-info.sh" << 'EOF'
#!/bin/bash
# View Spinnaker information for our applications

echo "=== Expedia Spinnaker Information ==="
echo ""

echo "1. Certificate Notification System:"
echo "   URL: https://spinnaker.expedia.biz/#/applications/certificate-notification-system"
echo "   Pipelines:"
echo "   - deploy-to-test"
echo "   - deploy-to-prod"
echo "   - rollback"
echo ""

echo "2. Federated Vault Monitoring:"
echo "   URL: https://spinnaker.expedia.biz/#/applications/federated-vault-monitoring"
echo "   Pipelines:"
echo "   - deploy-test"
echo "   - deploy-prod"
echo "   - monitoring-check"
echo ""

echo "3. Manual Pipeline Trigger:"
echo "   1. Open Spinnaker UI in browser"
echo "   2. Navigate to application"
echo "   3. Click 'Pipelines' tab"
echo "   4. Click 'Start Manual Execution'"
echo ""

echo "4. Check deployment status:"
echo "   kubectl get pods -n certificate-system"
echo "   kubectl get pods -n vault-monitoring"
EOF
chmod +x "$TEST_DIR/view-spinnaker-info.sh"

# 5. Create comprehensive test runner
cat > "$TEST_DIR/run-all-tests.sh" << 'EOF'
#!/bin/bash
# Run all certificate-notification-system tests

echo "=== Running All Tests ==="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

run_test() {
    local test_name="$1"
    local test_script="$2"
    
    echo -e "${GREEN}Running: $test_name${NC}"
    if [[ -x "$test_script" ]]; then
        $test_script
        echo ""
    else
        echo -e "${RED}Test script not found: $test_script${NC}"
    fi
}

# Run tests
TEST_DIR="$HOME/certificate-notification-tests"

run_test "Spinnaker Info" "$TEST_DIR/view-spinnaker-info.sh"
run_test "Helm Chart Test" "$TEST_DIR/test-helm-chart.sh"
run_test "Docker Test" "$TEST_DIR/quick-docker-test.sh"
run_test "API Endpoints" "$TEST_DIR/test-api-endpoints.sh"

echo "=== All Tests Complete ==="
EOF
chmod +x "$TEST_DIR/run-all-tests.sh"

echo "=== Test Scripts Created ==="
echo ""
echo "Created test scripts in: $TEST_DIR/"
ls -la "$TEST_DIR/"
echo ""
echo "Quick commands:"
echo "1. View Spinnaker info:"
echo "   $TEST_DIR/view-spinnaker-info.sh"
echo ""
echo "2. Test Helm chart:"
echo "   $TEST_DIR/test-helm-chart.sh"
echo ""
echo "3. Test with Docker:"
echo "   $TEST_DIR/quick-docker-test.sh"
echo ""
echo "4. Test API endpoints:"
echo "   $TEST_DIR/test-api-endpoints.sh"
echo ""
echo "5. Run all tests:"
echo "   $TEST_DIR/run-all-tests.sh"
echo ""
echo "Spinnaker URLs:"
echo "- Certificate Service: https://spinnaker.expedia.biz/#/applications/certificate-notification-system"
echo "- Vault Monitoring: https://spinnaker.expedia.biz/#/applications/federated-vault-monitoring"