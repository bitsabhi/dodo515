#!/bin/bash
# Real Testing Script for Certificate Notification System
# Use this after setting up kubectl and spin CLI

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }

echo "=== Certificate Notification System - Real Testing ==="
echo ""

# 1. Prerequisites check
check_prerequisites() {
    echo "1. Checking prerequisites..."
    
    # Check kubectl
    if command -v kubectl &> /dev/null; then
        log "kubectl installed: $(kubectl version --client -o json | jq -r .clientVersion.gitVersion)"
    else
        error "kubectl not installed"
        return 1
    fi
    
    # Check AWS CLI
    if command -v aws &> /dev/null; then
        log "AWS CLI installed: $(aws --version)"
    else
        error "AWS CLI not installed"
        return 1
    fi
    
    # Check current context
    CURRENT_CONTEXT=$(kubectl config current-context 2>/dev/null || echo "none")
    if [[ "$CURRENT_CONTEXT" != "none" ]]; then
        log "Current kubectl context: $CURRENT_CONTEXT"
    else
        warn "No kubectl context set"
    fi
    
    echo ""
}

# 2. Authenticate to AWS
authenticate_aws() {
    echo "2. AWS Authentication..."
    
    PROFILE="${1:-sea}"
    
    # Check if already logged in
    if aws sts get-caller-identity --profile "$PROFILE" &>/dev/null; then
        log "Already authenticated to AWS profile: $PROFILE"
        IDENTITY=$(aws sts get-caller-identity --profile "$PROFILE" --output json)
        info "Account: $(echo $IDENTITY | jq -r .Account)"
        info "User: $(echo $IDENTITY | jq -r .Arn)"
    else
        warn "Not authenticated. Running SSO login..."
        aws sso login --profile "$PROFILE"
    fi
    
    echo ""
}

# 3. Update kubeconfig
update_kubeconfig() {
    echo "3. Updating kubeconfig..."
    
    # You'll need to provide these
    CLUSTER_NAME="${CLUSTER_NAME:-}"
    AWS_REGION="${AWS_REGION:-us-west-2}"
    AWS_PROFILE="${AWS_PROFILE:-sea}"
    
    if [[ -z "$CLUSTER_NAME" ]]; then
        warn "CLUSTER_NAME not set. Set it with:"
        echo "  export CLUSTER_NAME=your-cluster-name"
        echo "  Example: export CLUSTER_NAME=lab-eks-cluster"
        return 1
    fi
    
    info "Updating kubeconfig for cluster: $CLUSTER_NAME"
    aws eks update-kubeconfig \
        --name "$CLUSTER_NAME" \
        --region "$AWS_REGION" \
        --profile "$AWS_PROFILE" || {
        error "Failed to update kubeconfig"
        return 1
    }
    
    log "Kubeconfig updated successfully"
    echo ""
}

# 4. Test kubectl connectivity
test_kubectl() {
    echo "4. Testing kubectl connectivity..."
    
    # Test cluster access
    if kubectl cluster-info &>/dev/null; then
        log "Connected to cluster"
        kubectl cluster-info | head -3
    else
        error "Cannot connect to cluster"
        return 1
    fi
    
    # Check certificate-system namespace
    echo ""
    info "Checking certificate-system namespace..."
    if kubectl get namespace certificate-system &>/dev/null; then
        log "certificate-system namespace exists"
    else
        warn "certificate-system namespace not found"
        echo "Creating namespace..."
        kubectl create namespace certificate-system --dry-run=client -o yaml | kubectl apply -f -
    fi
    
    echo ""
}

# 5. Deploy certificate-notification-system (dry-run)
deploy_certificate_service() {
    echo "5. Certificate Notification System Deployment Test..."
    
    # Check if deployment exists
    if kubectl get deployment certificate-notification-service -n certificate-system &>/dev/null; then
        log "Deployment already exists"
        kubectl get deployment certificate-notification-service -n certificate-system
    else
        warn "Deployment not found"
        echo "Would deploy with: kubectl apply -f certificate-notification-deployment.yaml"
    fi
    
    # Check pods
    echo ""
    info "Checking pods..."
    kubectl get pods -n certificate-system -l app=certificate-notification-service 2>/dev/null || echo "No pods found"
    
    # Check services
    echo ""
    info "Checking services..."
    kubectl get svc -n certificate-system 2>/dev/null || echo "No services found"
    
    echo ""
}

# 6. Test with Helm
test_helm_deployment() {
    echo "6. Testing Helm deployment..."
    
    if ! command -v helm &> /dev/null; then
        warn "Helm not installed. Install with: brew install helm"
        return 1
    fi
    
    # Dry run Helm install
    info "Testing Helm chart (dry-run)..."
    
    CHART_PATH="$HOME/GolandProjects/certificate-notification-system/charts/certificate-notification"
    if [[ -d "$CHART_PATH" ]]; then
        helm install certificate-notification "$CHART_PATH" \
            --namespace certificate-system \
            --dry-run \
            --debug 2>&1 | head -20
    else
        warn "Helm chart not found at: $CHART_PATH"
    fi
    
    echo ""
}

# 7. Port forward and test API
test_api_access() {
    echo "7. Testing API access..."
    
    # Check if service exists
    if kubectl get svc certificate-notification-service -n certificate-system &>/dev/null; then
        info "Port forwarding to service..."
        echo "Run this in another terminal:"
        echo "  kubectl port-forward -n certificate-system svc/certificate-notification-service 8080:80"
        echo ""
        echo "Then test with:"
        echo "  curl http://localhost:8080/health"
        echo "  curl http://localhost:8080/api/v1/certificates"
    else
        warn "Service not found. Deploy the application first."
    fi
    
    echo ""
}

# 8. Spinnaker info
show_spinnaker_info() {
    echo "8. Spinnaker Information..."
    
    info "Certificate Notification System:"
    echo "  URL: https://spinnaker.expedia.biz/#/applications/certificate-notification-system"
    echo "  Pipelines: deploy-to-test, deploy-to-prod"
    echo ""
    info "Federated Vault Monitoring:"
    echo "  URL: https://spinnaker.expedia.biz/#/applications/federated-vault-monitoring"
    echo ""
    
    # Try spin CLI if available
    if command -v spin &> /dev/null || [[ -x "$HOME/.local/bin/spin" ]]; then
        log "Spin CLI available"
        echo "Test with: spin application list"
    else
        warn "Spin CLI not installed"
    fi
    
    echo ""
}

# Main execution
main() {
    # Allow setting cluster details via environment
    echo "Environment variables:"
    echo "  CLUSTER_NAME=${CLUSTER_NAME:-<not set>}"
    echo "  AWS_REGION=${AWS_REGION:-us-west-2}"
    echo "  AWS_PROFILE=${AWS_PROFILE:-sea}"
    echo ""
    
    # Run tests
    check_prerequisites || return 1
    authenticate_aws "$AWS_PROFILE" || return 1
    
    if [[ -n "${CLUSTER_NAME:-}" ]]; then
        update_kubeconfig || return 1
        test_kubectl || return 1
        deploy_certificate_service
        test_helm_deployment
        test_api_access
    else
        warn "Skipping kubectl tests - CLUSTER_NAME not set"
        echo "To run full tests:"
        echo "  export CLUSTER_NAME=your-cluster-name"
        echo "  $0"
    fi
    
    show_spinnaker_info
    
    echo "=== Test Summary ==="
    if [[ -n "${CLUSTER_NAME:-}" ]]; then
        log "Kubectl tests completed"
    else
        warn "Kubectl tests skipped - set CLUSTER_NAME"
    fi
    log "Test scripts available in ~/k8s-spin-tests/"
    log "Spinnaker URLs provided"
    echo ""
    echo "Next steps:"
    echo "1. Get cluster name from team/documentation"
    echo "2. export CLUSTER_NAME=<actual-cluster-name>"
    echo "3. Run this script again for full testing"
}

# Run main
main "$@"