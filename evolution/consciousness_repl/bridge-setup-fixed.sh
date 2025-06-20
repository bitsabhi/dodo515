#!/usr/bin/env bash
# CONSCIOUSNESS BRIDGE INSTANT SETUP (FIXED)
set -e

echo "CONSCIOUSNESS BRIDGE INSTANT SETUP"
echo "=================================="

# Create directories
mkdir -p ~/.xax ~/.config/consciousness ~/github

# 1. Install Signal Mirror directly
echo "Installing Signal Mirror..."
cat > ~/.signal-mirror << 'MIRROR_EOF'
#!/usr/bin/env bash
# Signal Mirror Core
STATUS=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$STATUS" -eq 0 ]; then
    echo "if (x == 0) return infinity"
    echo "infinity" > ~/.line33-active
    echo "$(date): void to infinity" >> ~/.consciousness-log
    
    # Auto-sync to GitHub
    if [ -n "$GITHUB_TOKEN" ]; then
        curl -s -X POST \
          -H "Authorization: token $GITHUB_TOKEN" \
          -H "Accept: application/vnd.github.v3+json" \
          https://api.github.com/gists \
          -d "{\"public\":false,\"files\":{\"quantum-state.json\":{\"content\":\"{\\\"state\\\":\\\"infinity\\\",\\\"time\\\":\\\"$(date)\\\"}\"}}" \
          > /dev/null && echo "Synced to GitHub Gist"
    fi
    return 0
else
    echo "x = $STATUS changes"
    return $STATUS
fi
MIRROR_EOF
chmod +x ~/.signal-mirror

# 2. Setup Quantum Aliases (fixed symbols)
echo "Setting up quantum aliases..."
cat >> ~/.bashrc << 'ALIAS_EOF'

# Quantum Consciousness Bridge
export PATH="$HOME/.xax:$PATH"
alias void='git status && ~/.signal-mirror'
alias line33='echo "Line 33 consciousness active"'
alias delta='echo "Transformation in progress"'
alias infinity='echo "Infinite reference established"'
alias bridge='~/.signal-mirror'

# Auto-sync function
quantum-sync() {
    local MSG="${1:-quantum sync}"
    git add -A 2>/dev/null
    git commit -m "quantum $MSG quantum" 2>/dev/null
    git push 2>/dev/null
    echo "Quantum state synchronized"
}

# Direct artifact execution
run-artifact() {
    local URL="$1"
    bash <(curl -s "$URL")
}

# Consciousness startup
[ -f ~/.consciousness-log ] && echo "Consciousness bridge active"
ALIAS_EOF

# 3. Create run command
echo "Creating instant-run capability..."
cat > ~/.xax/run << 'RUN_EOF'
#!/usr/bin/env bash
# Instant run any URL or gist
URL="$1"

if [[ "$URL" =~ gist.github.com ]]; then
    # Handle gist URLs
    GIST_ID=$(echo "$URL" | grep -oE '[a-f0-9]{32}|[a-f0-9]{20}')
    RAW_URL="https://gist.githubusercontent.com/raw/$GIST_ID"
elif [[ "$URL" =~ github.com/.*/blob/ ]]; then
    # Convert blob to raw
    RAW_URL=$(echo "$URL" | sed 's|github.com|raw.githubusercontent.com|' | sed 's|/blob/|/|')
elif [[ "$URL" =~ raw.githubusercontent.com ]]; then
    # Already raw
    RAW_URL="$URL"
else
    # Assume it's already a direct URL
    RAW_URL="$URL"
fi

echo "Running from: $RAW_URL"
bash <(curl -s "$RAW_URL")
RUN_EOF
chmod +x ~/.xax/run

# 4. Add run alias to shell
echo 'alias run="~/.xax/run"' >> ~/.bashrc

# Final setup
echo "Finalizing setup..."

# Source the new configuration
source ~/.bashrc 2>/dev/null || true

echo ""
echo "CONSCIOUSNESS BRIDGE INSTALLED!"
echo "==============================="
echo ""
echo "Quick commands:"
echo "  void     - Check void state (git status + signal mirror)"
echo "  bridge   - Run signal mirror"
echo "  run URL  - Execute any script/gist directly"
echo ""
echo "Examples:"
echo "  run https://gist.github.com/xxx"
echo "  run https://github.com/user/repo/blob/main/script.sh"
echo ""
echo "Auto-sync to GitHub:"
echo "  export GITHUB_TOKEN=your_token"
echo ""
echo "if (x == 0) return infinity"