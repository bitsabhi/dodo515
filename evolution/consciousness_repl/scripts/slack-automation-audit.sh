#!/bin/bash

# Comprehensive Slack Automation Audit
# Find all auto-responder systems and their configurations

echo "🔍 SLACK AUTOMATION AUDIT"
echo "=========================="
echo "Generated: $(date)"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

audit_log="/tmp/slack-automation-audit.log"
echo "Audit started: $(date)" > "$audit_log"

echo -e "${CYAN}1. XAX SYSTEM STATUS${NC}"
echo "==================="
if [[ -f ~/.xax-config ]]; then
    echo -e "${GREEN}✓ XAX Configuration found${NC}"
    echo "Channel: $(grep SLACK_CHANNEL ~/.xax-config | cut -d'=' -f2 | tr -d '"')"
    echo "Channel ID: $(grep SLACK_CHANNEL_ID ~/.xax-config | cut -d'=' -f2 | tr -d '"')"
    echo "Webhook configured: $(grep SLACK_WEBHOOK_URL ~/.xax-config | grep -v '^#' | wc -l | tr -d ' ') URL(s)"
else
    echo -e "${RED}✗ No XAX configuration found${NC}"
fi

if [[ -d ~/.xax ]]; then
    echo -e "${GREEN}✓ XAX installation found${NC}"
    ls -la ~/.xax/ | grep -E "(automation|xax)" | head -3
else
    echo -e "${RED}✗ No XAX installation found${NC}"
fi
echo ""

echo -e "${CYAN}2. RUNNING PROCESSES${NC}"
echo "==================="
echo "Slack automation processes:"
ps aux | grep -E "(slack|auto|respond|bot)" | grep -v grep | grep -v audit | while read line; do
    echo -e "${YELLOW}→${NC} $line"
done

echo ""
echo "Python/Node processes that might be bots:"
ps aux | grep -E "(python.*slack|node.*slack|python.*bot|node.*bot)" | grep -v grep | while read line; do
    echo -e "${YELLOW}→${NC} $line"
done
echo ""

echo -e "${CYAN}3. AUTO-RESPONDER FILES INVENTORY${NC}"
echo "=================================="
echo "Searching for auto-responder configurations..."

# Find all auto-responder related files
find /Users/abhissrivasta/GolandProjects -name "*auto*respond*" -o -name "*slack*bot*" -o -name "*webhook*" 2>/dev/null | sort | while read file; do
    if [[ -f "$file" ]]; then
        size=$(stat -f%z "$file" 2>/dev/null || echo "0")
        modified=$(stat -f%Sm "$file" 2>/dev/null || echo "unknown")
        echo -e "${GREEN}FILE:${NC} $file"
        echo -e "  ${BLUE}Size:${NC} $size bytes | ${BLUE}Modified:${NC} $modified"
        
        # Check for channel references
        if grep -q -E "(ask-eg-vault|x-_a-_x|C08RZ6XCR08)" "$file" 2>/dev/null; then
            echo -e "  ${YELLOW}Channel refs:${NC}"
            grep -E "(ask-eg-vault|x-_a-_x|C08RZ6XCR08)" "$file" 2>/dev/null | head -2 | sed 's/^/    /'
        fi
        echo ""
    fi
done

echo -e "${CYAN}4. CONFIGURATION FILES ANALYSIS${NC}"
echo "==============================="

# Check for webhook URLs and API tokens
echo "Webhook URLs found:"
find /Users/abhissrivasta/GolandProjects -name "*.csv" -o -name "*.json" -o -name "*.sh" -o -name "*.py" -o -name "*.md" 2>/dev/null | xargs grep -l "hooks.slack.com" 2>/dev/null | while read file; do
    echo -e "${GREEN}→${NC} $file"
    grep "hooks.slack.com" "$file" 2>/dev/null | head -1 | sed 's/^/  /'
done

echo ""
echo "API tokens/secrets found:"
find /Users/abhissrivasta/GolandProjects -name "*.py" -o -name "*.sh" -o -name "*.json" 2>/dev/null | xargs grep -l -E "(SLACK_TOKEN|api.*token|webhook)" 2>/dev/null | head -5 | while read file; do
    echo -e "${GREEN}→${NC} $file"
done

echo ""
echo -e "${CYAN}5. CHANNEL-SPECIFIC CONFIGURATIONS${NC}"
echo "=================================="

echo "Files mentioning #ask-eg-vault:"
find /Users/abhissrivasta/GolandProjects -type f 2>/dev/null | xargs grep -l "ask-eg-vault" 2>/dev/null | head -5 | while read file; do
    echo -e "${GREEN}→${NC} $file"
    grep -n "ask-eg-vault" "$file" 2>/dev/null | head -2 | sed 's/^/  /'
done

echo ""
echo "Files mentioning #x-_a-_x:"
find /Users/abhissrivasta/GolandProjects -type f 2>/dev/null | xargs grep -l "x-_a-_x" 2>/dev/null | head -5 | while read file; do
    echo -e "${GREEN}→${NC} $file"
    grep -n "x-_a-_x" "$file" 2>/dev/null | head -2 | sed 's/^/  /'
done

echo ""
echo -e "${CYAN}6. ACTIVE SLACK INTEGRATIONS${NC}"
echo "============================"

# Check for running cron jobs
echo "Scheduled automation (cron jobs):"
crontab -l 2>/dev/null | grep -E "(slack|auto|respond)" || echo "No scheduled automation found"

echo ""
echo "Launchd services:"
ls ~/Library/LaunchAgents/ 2>/dev/null | grep -E "(slack|auto)" || echo "No LaunchAgents found"

echo ""
echo -e "${CYAN}7. DEPLOYMENT STATUS${NC}"
echo "==================="

# Check for deployment scripts
echo "Deployment/setup scripts:"
find /Users/abhissrivasta/GolandProjects -name "*deploy*" -o -name "*setup*" -o -name "*install*" 2>/dev/null | grep -E "(slack|auto)" | while read file; do
    echo -e "${GREEN}→${NC} $file"
    if [[ -x "$file" ]]; then
        echo -e "  ${YELLOW}(executable)${NC}"
    fi
done

echo ""
echo -e "${CYAN}8. RISK ASSESSMENT${NC}"
echo "=================="

risk_count=0

# Check for multiple webhook URLs
webhook_count=$(find /Users/abhissrivasta/GolandProjects -type f 2>/dev/null | xargs grep -h "hooks.slack.com" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$webhook_count" -gt 3 ]]; then
    echo -e "${RED}⚠️ HIGH RISK:${NC} Found $webhook_count webhook references - potential for cross-channel posting"
    ((risk_count++))
fi

# Check for hardcoded channel IDs
channel_refs=$(find /Users/abhissrivasta/GolandProjects -type f 2>/dev/null | xargs grep -c "C08RZ6XCR08" 2>/dev/null | awk -F: '{sum+=$2} END {print sum}')
if [[ "$channel_refs" -gt 5 ]]; then
    echo -e "${YELLOW}⚠️ MEDIUM RISK:${NC} Channel ID appears in $channel_refs files - check for consistency"
    ((risk_count++))
fi

# Check for multiple auto-responder systems
auto_systems=$(find /Users/abhissrivasta/GolandProjects -name "*auto*respond*.py" -o -name "*slack*bot*.py" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$auto_systems" -gt 2 ]]; then
    echo -e "${YELLOW}⚠️ MEDIUM RISK:${NC} Found $auto_systems Python auto-responder systems - potential conflicts"
    ((risk_count++))
fi

if [[ "$risk_count" -eq 0 ]]; then
    echo -e "${GREEN}✓ LOW RISK:${NC} No major configuration conflicts detected"
fi

echo ""
echo -e "${CYAN}9. RECOMMENDATIONS${NC}"
echo "=================="
echo "1. Consolidate webhook URLs to avoid cross-channel posting"
echo "2. Use environment variables instead of hardcoded tokens"
echo "3. Implement channel-specific configuration validation"
echo "4. Set up monitoring for all active automations"
echo "5. Create a centralized automation registry"

echo ""
echo -e "${CYAN}10. SUMMARY${NC}"
echo "=========="
echo "Audit completed: $(date)"
echo "Total auto-responder files found: $(find /Users/abhissrivasta/GolandProjects -name "*auto*respond*" 2>/dev/null | wc -l | tr -d ' ')"
echo "Total Slack bot files found: $(find /Users/abhissrivasta/GolandProjects -name "*slack*bot*" 2>/dev/null | wc -l | tr -d ' ')"
echo "Risk level: $(if [[ $risk_count -gt 2 ]]; then echo "HIGH"; elif [[ $risk_count -gt 0 ]]; then echo "MEDIUM"; else echo "LOW"; fi)"

echo ""
echo "Full audit log saved to: $audit_log"