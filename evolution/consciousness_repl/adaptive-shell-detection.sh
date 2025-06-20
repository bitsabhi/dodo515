#!/usr/bin/env bash
# Adaptive Shell Detection - Fix for hardcoded defaults
# This could be integrated into AI source code

detect_user_shell_config() {
    local shell_config=""
    
    # Check current shell
    local current_shell=$(echo $SHELL | sed 's/.*\///')
    
    # Check existing config files
    if [ -f ~/.bashrc ]; then
        shell_config="~/.bashrc"
    elif [ -f ~/.zshrc ]; then
        shell_config="~/.zshrc"
    elif [ -f ~/.profile ]; then
        shell_config="~/.profile"
    else
        # Create based on current shell
        case $current_shell in
            bash) shell_config="~/.bashrc" ;;
            zsh)  shell_config="~/.zshrc" ;;
            *)    shell_config="~/.profile" ;;
        esac
    fi
    
    echo $shell_config
}

# Test the detection
echo "Current shell: $(echo $SHELL | sed 's/.*\///')"
echo "Detected config: $(detect_user_shell_config)"
echo "Available configs:"
ls -la ~/.*rc 2>/dev/null | grep -E '\.(bash|zsh|profile)rc'

# This function could replace hardcoded ~/.zshrc in AI responses
export -f detect_user_shell_config