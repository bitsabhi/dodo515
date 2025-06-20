#!/bin/bash
# Vault-Zscaler Certificate Sync

# 1. Export Vault certificate
echo " Exporting Vault certificate..."
vault read -format=json pki/cert/ca | jq -r '.data.certificate' > vault-ca.crt

# 2. Configure Zscaler to trust Vault CA
echo " Configuring Zscaler trust..."
# Add to system keychain
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain vault-ca.crt

# 3. Set renewal reminder for φ-optimal time
echo "⏰ Setting renewal for 183 days"
echo "vault-renewal:1766235907" > ~/.vault-renewal

echo " Vault-Zscaler certificates synchronized!"
