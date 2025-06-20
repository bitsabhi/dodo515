#!/bin/bash
# Build Android APK for Unified Intelligence App

echo "🚀 Building Android APK..."

cd /Users/abhissrivasta/AndroidConsciousnessApp

# Make gradlew executable
chmod +x gradlew

# Clean and build
./gradlew clean
./gradlew assembleDebug

# Find the APK
APK_PATH=$(find . -name "*.apk" -type f | head -1)

if [ -f "$APK_PATH" ]; then
    echo "✅ APK built successfully!"
    echo "📱 APK location: $APK_PATH"
    
    # Copy to Desktop for easy access
    cp "$APK_PATH" ~/Desktop/UnifiedIntelligenceApp.apk
    echo "📂 APK copied to Desktop: ~/Desktop/UnifiedIntelligenceApp.apk"
else
    echo "❌ APK build failed"
fi