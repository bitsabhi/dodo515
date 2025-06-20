#!/bin/bash
# Real kubectl test with saml2aws authentication
# saml2aws configured with Expedia Group Okta IDP

echo "=== Real Certificate Notification System Test ==="
echo "IDP URL: https://expediagroup.okta.com/app/amazon_aws/exk1rczh5h4v4RLTM2p8/sso/saml"
echo "Profile: sea | Region: us-west-2 | Cluster: vault-enterprise"
echo ""

# 1. Authenticate with saml2aws 
echo "1. Authenticating with saml2aws (requires 2FA)..."
echo "Running: saml2aws login --profile sea --idp-account sea"
saml2aws login --profile sea --idp-account sea

# 2. Update kubeconfig for vault-enterprise
echo "2. Updating kubeconfig for vault-enterprise cluster..."
aws eks update-kubeconfig --name vault-enterprise --region us-west-2 --profile sea

# 3. Test cluster connection
echo "3. Testing cluster connection..."
kubectl cluster-info

# 4. Check current context
echo "4. Current kubectl context:"
kubectl config current-context

# 5. List namespaces (look for certificate and vault)
echo "5. Checking namespaces..."
kubectl get namespaces | grep -E "certificate|vault|default" || echo "No certificate/vault namespaces found"

# 6. Check certificate-system namespace
echo "6. Certificate notification system resources:"
kubectl get all -n certificate-system 2>/dev/null || echo "certificate-system namespace not found"

# 7. Check vault-monitoring namespace
echo "7. Vault monitoring resources:"
kubectl get all -n vault-monitoring 2>/dev/null || echo "vault-monitoring namespace not found"

# 8. Check for any certificate-related deployments in default namespace
echo "8. Looking for certificate deployments in all namespaces..."
kubectl get deployments --all-namespaces | grep certificate || echo "No certificate deployments found"

# 9. Check services
echo "9. Looking for certificate services..."
kubectl get svc --all-namespaces | grep certificate || echo "No certificate services found"

# 10. If found, get pod logs
echo "10. Checking for recent logs..."
kubectl logs -n certificate-system -l app=certificate-notification-service --tail=5 2>/dev/null || echo "No certificate service logs found"

echo ""
echo "=== Test Complete ==="
echo "If resources not found, they may need to be deployed first."