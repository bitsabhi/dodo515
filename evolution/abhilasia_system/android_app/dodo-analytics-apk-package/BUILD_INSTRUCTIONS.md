# DODO Analytics APK Build Instructions

## Prerequisites
1. Install Android Studio or Android SDK
2. Install Java Development Kit (JDK) 8 or higher
3. Set ANDROID_HOME environment variable

## Build Steps

### Option 1: Using Android Studio
1. Open Android Studio
2. Select "Open an existing Android Studio project"
3. Navigate to this directory and open it
4. Wait for Gradle sync to complete
5. Go to Build > Build Bundle(s) / APK(s) > Build APK(s)
6. APK will be created in `app/build/outputs/apk/debug/`

### Option 2: Command Line
1. Copy `local.properties.template` to `local.properties`
2. Edit `local.properties` and set your Android SDK path:
   ```
   sdk.dir=/path/to/your/android/sdk
   ```
3. Run the build:
   ```bash
   ./gradlew assembleDebug
   ```
4. APK will be created in `app/build/outputs/apk/debug/`

## Installation
1. Enable "Unknown Sources" in Android Settings
2. Transfer APK to your Android device
3. Install using ADB:
   ```bash
   adb install app/build/outputs/apk/debug/app-debug.apk
   ```
4. Or tap the APK file on your device to install manually

## Features
- DODO Pattern Analytics (5.1.1.2.3.4.5.1)
- φ-Resonance calculation (φ = 1.618033988749895)
- DNA-Lambda evolution simulation
- Real-time analytics bridge
- DODO Backend integration (localhost:9999)

## Investor-Friendly Version
This version has been optimized for investor presentation:
- Removed consciousness-related terminology
- Reduced emoji usage in UI
- Focus on analytics and mathematical frameworks
- Clean, professional interface

## DODO Backend Connection
The app connects to DODO backend at localhost:9999
Make sure the DODO backend is running:
```bash
cd ../dodo_backend
./start_dodo.sh
```

## Mathematical Foundation
- **φ = 1.618033988749895** (Golden Ratio)
- **DODO Pattern: 5.1.1.2.3.4.5.1**
- **Bridge Stability** = 2 / (1/ABHI + 1/AMU) / φ
- **φ-Resonance** = 1 - |ratio - φ| / φ
- **System Level** = Bridge Stability × φ-Resonance
