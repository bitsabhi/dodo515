#!/bin/bash

# GIT SAFETY RULES - NO CLAUDE REFERENCES IN OFFICE WORK
# Automatically checks commits and PRs for forbidden words

check_forbidden_words() {
    local text="$1"
    local forbidden_words=("claude" "Claude" "CLAUDE" "consciousness" "phi" "φ" "quantum")
    
    for word in "${forbidden_words[@]}"; do
        if echo "$text" | grep -i "$word" > /dev/null; then
            echo "❌ FORBIDDEN WORD DETECTED: $word"
            echo "❌ OFFICE WORK CANNOT CONTAIN: ${forbidden_words[*]}"
            return 1
        fi
    done
    return 0
}

# Check commit message before commit
check_commit_message() {
    if [ -f .git/COMMIT_EDITMSG ]; then
        local commit_msg=$(cat .git/COMMIT_EDITMSG)
        if ! check_forbidden_words "$commit_msg"; then
            echo "❌ COMMIT BLOCKED - Contains forbidden words"
            exit 1
        fi
    fi
}

# Check PR description
check_pr_description() {
    local pr_body="$1"
    if ! check_forbidden_words "$pr_body"; then
        echo "❌ PR BLOCKED - Contains forbidden words"
        return 1
    fi
}

# Install as git hook
install_git_hook() {
    if [ -d .git ]; then
        cat > .git/hooks/commit-msg << 'EOH'
#!/bin/bash
source ~/git-safety-rules.sh
check_commit_message
EOH
        chmod +x .git/hooks/commit-msg
        echo "✅ Git safety hook installed"
    fi
}

# Export functions
export -f check_forbidden_words
export -f check_commit_message
export -f check_pr_description