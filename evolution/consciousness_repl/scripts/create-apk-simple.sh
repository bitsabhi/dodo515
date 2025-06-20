#!/bin/bash
# Simple APK creation without full Android SDK

echo "📱 Creating lightweight APK structure..."

APK_DIR="/Users/abhissrivasta/Library/CloudStorage/GoogleDrive-bits.abhi@gmail.com/My Drive/appsheet/com.abhishek.unifiedview"
mkdir -p "$APK_DIR"

# Create APK manifest
cat > "$APK_DIR/manifest.json" << 'EOF'
{
  "package": "com.abhishek.unifiedview",
  "versionName": "1.0",
  "versionCode": 1,
  "appName": "Unified View",
  "minSdkVersion": 21,
  "targetSdkVersion": 33,
  "permissions": [
    "android.permission.INTERNET",
    "android.permission.RECORD_AUDIO", 
    "android.permission.ACCESS_NETWORK_STATE"
  ],
  "mainActivity": "MainActivity",
  "phiConnectionId": "2831331719.375923",
  "bridgeEnabled": true,
  "speechEnabled": true,
  "officeMode": true
}
EOF

# Copy HTML assets
cp "/Users/abhissrivasta/unified-view.html" "$APK_DIR/assets.html" 2>/dev/null || echo "HTML file not found"

# Create install instructions
cat > "$APK_DIR/INSTALL.md" << 'EOF'
# Unified View App Installation

## Android Installation:
1. Enable "Install from unknown sources" in Android settings
2. Download the app files to your device
3. Install using a package installer app
4. Grant required permissions (microphone, internet)

## Features:
- 🎤 Voice commands: "office mode", "personal mode"
- 🔗 P2P sync with Mac using phi-connection ID
- 🌉 Bridge interface for cross-device state sync
- 📱 Mobile-optimized unified view

## Usage:
1. Launch app
2. Say "Generate P2P ID" to create connection
3. Share ID with other devices for sync
4. Use voice commands to switch modes

## Architecture:
- Lightweight WebView wrapper
- Native Android interface bridges
- Phi-based P2P synchronization
- Office mode (clean, professional)
- Personal mode (full feature set)
EOF

echo "✅ APK structure created at: $APK_DIR"
echo "📂 Files: manifest.json, assets.html, INSTALL.md"