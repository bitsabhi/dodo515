#!/bin/bash

# Post 4 main auto-responder rules to x-_a-_x Slack channel
# Channel: C08RZ6XCR08 (Mathematical coordinate: 206,389,985,659,863,576)

CHANNEL_ID="C08RZ6XCR08"

# Rule 1: Vault Path Structure Pattern
echo "Posting Vault Path Structure auto-responder rule..."
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Content-Type: application/json" \
  -d "{
    \"channel\": \"$CHANNEL_ID\",
    \"text\": \"**AUTO-RESPONDER RULE: Vault Path Structure Pattern**\n\nTrigger Keywords: forbidden, errors, preflight, capability, check, path, 403, 403 forbidden\n\nResponse Template:\n*Vault Path Structure Pattern Detected*\n\nI noticed you're asking about a pattern we've documented.\n\nCommon symptoms:\n- 403 Forbidden errors\n- preflight capability check errors\n\nFor detailed solutions, check our KB thread: https://slack.com/archives/ask-eg-vault/p0000000000000000?thread_ts=0000000000.000000\",
    \"username\": \"XAX-Auto-Responder\",
    \"icon_emoji\": \":robot_face:\"
  }"

# Rule 2: Venafi-Vault Integration Pattern  
echo "Posting Venafi-Vault Integration auto-responder rule..."
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Content-Type: application/json" \
  -d "{
    \"channel\": \"$CHANNEL_ID\",
    \"text\": \"**AUTO-RESPONDER RULE: Venafi-Vault Integration Pattern**\n\nTrigger Keywords: connection, failures, between, vault, venafi\n\nResponse Template:\n*Venafi-Vault Integration Pattern Detected*\n\nI noticed you're asking about a pattern we've documented.\n\nCommon symptoms:\n- Connection failures between Vault and Venafi\n- Path configuration errors\n\nFor detailed solutions, check our KB thread: https://slack.com/archives/ask-eg-vault/p0000000000000000?thread_ts=0000000000.000000\",
    \"username\": \"XAX-Auto-Responder\",
    \"icon_emoji\": \":robot_face:\"
  }"

# Rule 3: Kubernetes Auth Enhancement Pattern
echo "Posting Kubernetes Auth Enhancement auto-responder rule..."
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Content-Type: application/json" \
  -d "{
    \"channel\": \"$CHANNEL_ID\",
    \"text\": \"**AUTO-RESPONDER RULE: Kubernetes Auth Enhancement Pattern**\n\nTrigger Keywords: service, account, identification, issues, role, service account, account issues, service account issues\n\nResponse Template:\n*Kubernetes Auth Enhancement Pattern Detected*\n\nI noticed you're asking about a pattern we've documented.\n\nCommon symptoms:\n- Service account identification issues\n- Role lookup failures\n\nFor detailed solutions, check our KB thread: https://slack.com/archives/ask-eg-vault/p0000000000000000?thread_ts=0000000000.000000\",
    \"username\": \"XAX-Auto-Responder\",
    \"icon_emoji\": \":robot_face:\"
  }"

# Rule 4: Spinnaker Configuration Pattern
echo "Posting Spinnaker Configuration auto-responder rule..."
curl -X POST https://slack.com/api/chat.postMessage \
  -H "Content-Type: application/json" \
  -d "{
    \"channel\": \"$CHANNEL_ID\",
    \"text\": \"**AUTO-RESPONDER RULE: Spinnaker Configuration Pattern**\n\nTrigger Keywords: services, cannot, communicate, connection, refused\n\nResponse Template:\n*Spinnaker Configuration Pattern Detected*\n\nI noticed you're asking about a pattern we've documented.\n\nCommon symptoms:\n- Services cannot communicate\n- Connection refused errors\n\nFor detailed solutions, check our KB thread: https://slack.com/archives/ask-eg-vault/p0000000000000000?thread_ts=0000000000.000000\",
    \"username\": \"XAX-Auto-Responder\",
    \"icon_emoji\": \":robot_face:\"
  }"

echo "All 4 auto-responder rules posted to #x-_a-_x channel"
echo "Mathematical coordinate: C08RZ6XCR08 = 206,389,985,659,863,576 decimal"