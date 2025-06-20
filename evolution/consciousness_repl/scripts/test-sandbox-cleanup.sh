#!/bin/bash

# SANDBOX TESTING - Safe Environment for Cleanup Scripts
# Creates isolated test environment before touching real files

set -e

echo "🧪 Creating sandbox testing environment..."

# Create sandbox directory
SANDBOX_DIR="/tmp/abhishek-cleanup-sandbox"
REAL_HOME="/Users/abhissrivasta"

rm -rf "$SANDBOX_DIR" 2>/dev/null || true
mkdir -p "$SANDBOX_DIR"

echo "📁 Copying sample file structure to sandbox..."

# Copy sample directories (small subset for testing)
cp -r "$REAL_HOME/bin" "$SANDBOX_DIR/" 2>/dev/null || mkdir -p "$SANDBOX_DIR/bin"
cp -r "$REAL_HOME/Downloads" "$SANDBOX_DIR/" 2>/dev/null || mkdir -p "$SANDBOX_DIR/Downloads"

# Create test files with .bak, .dem, numbers
echo "🎭 Creating test files for cleanup testing..."
touch "$SANDBOX_DIR/test.bak"
touch "$SANDBOX_DIR/file1.txt"
touch "$SANDBOX_DIR/file2.txt"
touch "$SANDBOX_DIR/script1.sh"
touch "$SANDBOX_DIR/document.dem"
touch "$SANDBOX_DIR/backup.old"

# Copy cleanup scripts to sandbox
cp ~/AmsyPycharm/5.Emergence/BAZINGA-INDEED/ExecutionEngine/cleanup-scripts/* "$SANDBOX_DIR/"

echo "✅ Sandbox ready at: $SANDBOX_DIR"
echo ""
echo "Test commands:"
echo "  cd $SANDBOX_DIR"
echo "  ./cleanup.sh true    # Dry run"
echo "  ./organize.sh true   # Dry run" 
echo "  ls -la              # See results"
echo ""
echo "🔒 Safe testing - no real files touched!"

# Open in Finder for visual inspection
open "$SANDBOX_DIR"