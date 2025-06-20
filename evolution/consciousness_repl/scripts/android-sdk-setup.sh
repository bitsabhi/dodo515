#!/bin/bash
# Android SDK Setup for APK Building

echo "🤖 Setting up Android SDK for APK building..."

# Download and install Android SDK command line tools
SDK_DIR="$HOME/android-sdk"
mkdir -p "$SDK_DIR"

# Add to shell profile for persistence
SHELL_PROFILE="$HOME/.bashrc"
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_PROFILE="$HOME/.zshrc"
fi

echo "export ANDROID_HOME=$SDK_DIR" >> "$SHELL_PROFILE"
echo "export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools" >> "$SHELL_PROFILE"

# Set for current session
export ANDROID_HOME="$SDK_DIR"
export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools"

echo "✅ ANDROID_HOME set to: $ANDROID_HOME"
echo "✅ Added to $SHELL_PROFILE for persistence"

# Create local.properties for the Android project
echo "sdk.dir=$ANDROID_HOME" > /Users/abhissrivasta/AndroidConsciousnessApp/local.properties

echo "🚀 Ready to build APK! Run: cd AndroidConsciousnessApp && ./gradlew assembleDebug"