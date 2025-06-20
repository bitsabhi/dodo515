#!/bin/bash
# Generic Kubectl & Spinnaker CLI Setup for Testing
# Works with multiple clusters and AWS profiles

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}[$(date '+%H:%M:%S')]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

echo "=== Kubectl & Spinnaker CLI Setup ==="
echo ""

# 1. Check and setup kubectl
setup_kubectl() {
    log "Checking kubectl installation..."
    
    if ! command -v kubectl &> /dev/null; then
        error "kubectl not installed"
        echo "Install with: brew install kubectl"
        return 1
    fi
    
    kubectl version --client --short || true
    echo ""
}

# 2. Configure kubectl contexts
configure_kubectl_contexts() {
    log "Configuring kubectl contexts..."
    
    # Create kubectl config template
    cat > ~/kubectl-config-template.yaml << 'EOF'
# Kubectl Configuration Template
# Copy this to ~/.kube/config and update with your values

apiVersion: v1
kind: Config
preferences: {}

clusters:
- cluster:
    certificate-authority-data: <YOUR_CA_DATA>
    server: https://<YOUR_CLUSTER_ENDPOINT>
  name: lab-cluster
- cluster:
    certificate-authority-data: <YOUR_CA_DATA>
    server: https://<YOUR_CLUSTER_ENDPOINT>
  name: prod-cluster

contexts:
- context:
    cluster: lab-cluster
    namespace: certificate-system
    user: abhissrivasta-lab
  name: lab
- context:
    cluster: prod-cluster
    namespace: certificate-system
    user: abhissrivasta-prod
  name: prod

current-context: lab

users:
- name: abhissrivasta-lab
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - eks
        - get-token
        - --cluster-name=<LAB_CLUSTER_NAME>
        - --region=<AWS_REGION>
        - --profile=<AWS_PROFILE_LAB>
- name: abhissrivasta-prod
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - eks
        - get-token
        - --cluster-name=<PROD_CLUSTER_NAME>
        - --region=<AWS_REGION>
        - --profile=<AWS_PROFILE_PROD>
EOF
    
    info "Created kubectl config template at ~/kubectl-config-template.yaml"
}

# 3. Setup AWS profiles
setup_aws_profiles() {
    log "Checking AWS CLI configuration..."
    
    if ! command -v aws &> /dev/null; then
        error "AWS CLI not installed"
        echo "Install with: brew install awscli"
        return 1
    fi
    
    # Check existing profiles
    echo "Current AWS profiles:"
    aws configure list-profiles || true
    echo ""
    
    # Create AWS config template
    cat > ~/aws-config-template.ini << 'EOF'
# AWS Configuration Template
# Add to ~/.aws/config

[profile sea]
region = us-west-2
output = json
# Add SSO or credential configuration

[profile prod]
region = us-west-2
output = json
# Add SSO or credential configuration

# For SSO:
# sso_start_url = https://expedia.awsapps.com/start
# sso_region = us-west-2
# sso_account_id = <ACCOUNT_ID>
# sso_role_name = <ROLE_NAME>
EOF
    
    info "Created AWS config template at ~/aws-config-template.ini"
}

# 4. Install Spinnaker CLI
install_spin_cli() {
    log "Installing Spinnaker CLI (spin)..."
    
    if command -v spin &> /dev/null; then
        log "Spinnaker CLI already installed"
        spin version || echo "Version check failed"
        return 0
    fi
    
    # Try to install spin CLI
    OS="darwin"
    ARCH="amd64"
    
    log "Downloading spin CLI..."
    curl -LO "https://storage.googleapis.com/spinnaker-artifacts/spin/latest/${OS}_${ARCH}/spin" || {
        warn "Failed to download from primary source"
        # Try alternative method
        brew install spin || error "Failed to install spin CLI"
    }
    
    if [[ -f "spin" ]]; then
        chmod +x spin
        sudo mv spin /usr/local/bin/ || mv spin ~/.local/bin/
        log "Installed spin CLI"
    fi
}

# 5. Configure Spinnaker CLI
configure_spin() {
    log "Configuring Spinnaker CLI..."
    
    mkdir -p ~/.spin
    
    cat > ~/.spin/config << 'EOF'
# Spinnaker CLI Configuration
gate:
  endpoint: https://spinnaker.expedia.biz

auth:
  enabled: true
  # Option 1: X509 certificates
  # x509:
  #   certPath: /path/to/client.crt
  #   keyPath: /path/to/client.key
  
  # Option 2: OAuth2
  # oauth2:
  #   authUrl: https://login.expedia.com/oauth2/authorize
  #   tokenUrl: https://login.expedia.com/oauth2/token
  #   clientId: <CLIENT_ID>
  #   clientSecret: <CLIENT_SECRET>
  #   scopes:
  #   - api
EOF
    
    info "Created Spinnaker config at ~/.spin/config"
}

# 6. Create test scripts
create_test_scripts() {
    log "Creating kubectl & spin test scripts..."
    
    TEST_DIR="$HOME/k8s-spin-tests"
    mkdir -p "$TEST_DIR"
    
    # Kubectl test script
    cat > "$TEST_DIR/test-kubectl.sh" << 'EOF'
#!/bin/bash
# Test kubectl connectivity

echo "=== Kubectl Connection Test ==="

# Test current context
echo "Current context:"
kubectl config current-context

# Test cluster access
echo -e "\nTesting cluster access:"
kubectl cluster-info || echo "Failed to connect"

# List namespaces
echo -e "\nNamespaces:"
kubectl get namespaces | grep -E "certificate|vault|default" || echo "No namespaces found"

# Check certificate-notification-system
echo -e "\nChecking certificate-notification-system:"
kubectl get deployments -n certificate-system 2>/dev/null || echo "Namespace not found"

# Check pods
echo -e "\nPods in certificate-system:"
kubectl get pods -n certificate-system 2>/dev/null || echo "No pods found"
EOF
    chmod +x "$TEST_DIR/test-kubectl.sh"
    
    # Spin CLI test script
    cat > "$TEST_DIR/test-spin.sh" << 'EOF'
#!/bin/bash
# Test Spinnaker CLI

echo "=== Spinnaker CLI Test ==="

# Check spin installation
if ! command -v spin &> /dev/null; then
    echo "ERROR: spin CLI not installed"
    exit 1
fi

# Test connection
echo "Testing Spinnaker connection..."
spin application list 2>/dev/null | grep -E "certificate-notification|federated-vault" || {
    echo "Failed to connect to Spinnaker"
    echo "Check your ~/.spin/config"
    exit 1
}

# List pipelines for certificate-notification-system
echo -e "\nCertificate Notification System pipelines:"
spin pipeline list --application certificate-notification-system 2>/dev/null || echo "App not found"

# List pipelines for federated-vault-monitoring
echo -e "\nFederated Vault Monitoring pipelines:"
spin pipeline list --application federated-vault-monitoring 2>/dev/null || echo "App not found"
EOF
    chmod +x "$TEST_DIR/test-spin.sh"
    
    # Combined test script
    cat > "$TEST_DIR/test-all.sh" << 'EOF'
#!/bin/bash
# Test both kubectl and spin

echo "=== Complete K8s & Spinnaker Test ==="
echo ""

# Switch context if needed
CONTEXT="${1:-lab}"
echo "Using context: $CONTEXT"
kubectl config use-context "$CONTEXT"
echo ""

# Run kubectl tests
./test-kubectl.sh
echo ""

# Run spin tests
./test-spin.sh
echo ""

echo "=== Test Complete ==="
EOF
    chmod +x "$TEST_DIR/test-all.sh"
    
    log "Created test scripts in $TEST_DIR"
}

# 7. Create auth helper script
create_auth_helper() {
    log "Creating authentication helper..."
    
    cat > ~/k8s-spin-tests/auth-helper.sh << 'EOF'
#!/bin/bash
# Authentication Helper

echo "=== K8s & Spinnaker Authentication Helper ==="
echo ""

# AWS SSO Login
aws_login() {
    local profile="${1:-sea}"
    echo "Logging into AWS profile: $profile"
    aws sso login --profile "$profile"
}

# Update kubeconfig
update_kubeconfig() {
    local cluster_name="$1"
    local region="${2:-us-west-2}"
    local profile="${3:-sea}"
    
    echo "Updating kubeconfig for cluster: $cluster_name"
    aws eks update-kubeconfig \
        --name "$cluster_name" \
        --region "$region" \
        --profile "$profile"
}

# Main menu
echo "1. Login to AWS SSO"
echo "2. Update kubeconfig"
echo "3. Test kubectl connection"
echo "4. Test Spinnaker connection"
echo ""
echo "Example commands:"
echo "  aws_login sea"
echo "  update_kubeconfig lab-cluster us-west-2 sea"
echo "  kubectl get pods -n certificate-system"
echo "  spin application list"
EOF
    chmod +x ~/k8s-spin-tests/auth-helper.sh
}

# Main execution
main() {
    echo "Starting Kubectl & Spinnaker Setup..."
    echo ""
    
    # Setup components
    setup_kubectl
    configure_kubectl_contexts
    setup_aws_profiles
    install_spin_cli
    configure_spin
    create_test_scripts
    create_auth_helper
    
    echo ""
    log "=== Setup Complete! ==="
    echo ""
    echo "Next steps:"
    echo "1. Update kubectl config:"
    echo "   - Review: ~/kubectl-config-template.yaml"
    echo "   - Get cluster details from your team/documentation"
    echo "   - Update ~/.kube/config"
    echo ""
    echo "2. Configure AWS profiles:"
    echo "   - Review: ~/aws-config-template.ini"
    echo "   - Add to ~/.aws/config"
    echo "   - Run: aws sso login --profile sea"
    echo ""
    echo "3. Update Spinnaker config:"
    echo "   - Edit: ~/.spin/config"
    echo "   - Add authentication details"
    echo ""
    echo "4. Run tests:"
    echo "   ~/k8s-spin-tests/test-kubectl.sh    # Test kubectl"
    echo "   ~/k8s-spin-tests/test-spin.sh       # Test Spinnaker CLI"
    echo "   ~/k8s-spin-tests/test-all.sh        # Test everything"
    echo ""
    echo "5. Use auth helper:"
    echo "   source ~/k8s-spin-tests/auth-helper.sh"
}

# Run main
main