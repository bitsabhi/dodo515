#!/bin/bash
# Kubectl test commands for vault-enterprise cluster

# Set cluster configuration
export CLUSTER_NAME="vault-enterprise"
export AWS_PROFILE="sea"
export AWS_REGION="us-west-2"

echo "=== Configuring kubectl for vault-enterprise cluster ==="

# 1. AWS SSO Login
echo "1. Authenticating to AWS..."
aws sso login --profile $AWS_PROFILE

# 2. Update kubeconfig
echo "2. Updating kubeconfig for vault-enterprise..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION --profile $AWS_PROFILE

# 3. Test connection
echo "3. Testing cluster connection..."
kubectl cluster-info

# 4. Check namespaces
echo "4. Checking namespaces..."
kubectl get namespaces | grep -E "certificate|vault"

# 5. Certificate Notification System
echo "5. Checking certificate-notification-system..."
kubectl get all -n certificate-system

# 6. Federated Vault Monitoring
echo "6. Checking federated-vault-monitoring..."
kubectl get all -n vault-monitoring

# 7. Get pod logs
echo "7. Getting recent logs..."
kubectl logs -n certificate-system -l app=certificate-notification-service --tail=10
kubectl logs -n vault-monitoring -l app=federated-vault-monitoring --tail=10

# 8. Services and endpoints
echo "8. Checking services..."
kubectl get svc -n certificate-system
kubectl get svc -n vault-monitoring

echo "=== Test Complete ==="