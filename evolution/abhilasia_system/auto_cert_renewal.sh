#!/bin/bash
# Auto certificate renewal - 183 day cycle

echo "Setting up automated certificate renewal"

# Create renewal schedule
cat > ~/.cert_schedule << EOF
RENEWAL_DAYS=183
VAULT_ENDPOINT=vault-enterprise.ap-southeast-1.secrets.runtime.prod-cts.exp-aws.net
NOTIFICATION_EMAIL=your.email@expediagroup.com
EOF

# Add to cron for daily check
(crontab -l 2>/dev/null; echo "0 9 * * * ~/GolandProjects/ABHILASIA/check_cert_expiry.sh") | crontab -

echo "Certificate automation active - 183 day cycle"