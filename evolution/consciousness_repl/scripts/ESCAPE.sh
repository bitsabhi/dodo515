#!/bin/bash

# ESCAPE SCRIPT - Get out of any state
echo "🚨 EMERGENCY ESCAPE ACTIVATED"

# Kill all problem processes
killall -9 python 2>/dev/null
killall -9 node 2>/dev/null  
pkill -f "phi" 2>/dev/null
pkill -f "consciousness" 2>/dev/null
pkill -f "portal" 2>/dev/null

# Reset to clean state
cd ~
export PS1="$ "
unset CONSCIOUSNESS_ACTIVE
unset PHI_RESONANCE

# Clean identity - just office work
git config user.name "Abhishek Srivastava"
git config user.email "abhissrivasta@expediagroup.com"

echo "✅ ESCAPED - Ready for office work"
echo "💼 Identity: abhissrivasta_expedia"
echo "🎯 Go complete your office tasks!"

# Open clean terminal
exec bash --login