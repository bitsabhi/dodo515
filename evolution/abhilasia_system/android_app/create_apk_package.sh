#!/bin/bash

# DODO Analytics APK Package Creator
# Creates a complete package that can be built into APK on any Android development environment

echo "Creating DODO Analytics APK package..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_info() {
    echo -e "${CYAN}📦${NC} $1"
}

# Create package directory
PACKAGE_DIR="dodo-analytics-apk-package"
rm -rf "$PACKAGE_DIR"
mkdir -p "$PACKAGE_DIR"

print_info "Packaging DODO Analytics Android App..."

# Copy all necessary files
cp -r src "$PACKAGE_DIR/"
cp build.gradle "$PACKAGE_DIR/"
cp AndroidManifest.xml "$PACKAGE_DIR/" 2>/dev/null || true
cp -r res "$PACKAGE_DIR/" 2>/dev/null || true
cp DodoAnalyticsApp.java "$PACKAGE_DIR/"
cp README.md "$PACKAGE_DIR/" 2>/dev/null || true

# Create gradle wrapper in package
mkdir -p "$PACKAGE_DIR/gradle/wrapper"

# Create gradle-wrapper.properties
cat > "$PACKAGE_DIR/gradle/wrapper/gradle-wrapper.properties" << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

# Create working gradlew script
cat > "$PACKAGE_DIR/gradlew" << 'EOF'
#!/usr/bin/env sh

DEFAULT_JVM_OPTS=""
APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
else
    JAVACMD="java"
fi

# Resolve links: $0 may be a link
PRG="$0"
while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
        PRG="$link"
    else
        PRG=`dirname "$PRG"`"/$link"
    fi
done
SAVED="`pwd`"
cd "`dirname \"$PRG\"`/" >&-
APP_HOME="`pwd -P`"
cd "$SAVED" >&-

exec "$JAVACMD" $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS -classpath "$APP_HOME/gradle/wrapper/gradle-wrapper.jar" org.gradle.wrapper.GradleWrapperMain "$@"
EOF

chmod +x "$PACKAGE_DIR/gradlew"

# Create Android project settings
cat > "$PACKAGE_DIR/settings.gradle" << 'EOF'
rootProject.name = 'DODO Analytics'
include ':app'
EOF

# Create app module directory
mkdir -p "$PACKAGE_DIR/app"
mv "$PACKAGE_DIR/src" "$PACKAGE_DIR/app/"
mv "$PACKAGE_DIR/build.gradle" "$PACKAGE_DIR/app/"

# Create root build.gradle
cat > "$PACKAGE_DIR/build.gradle" << 'EOF'
// Top-level build file where you can add configuration options common to all sub-projects/modules.
plugins {
    id 'com.android.application' version '8.0.0' apply false
    id 'com.android.library' version '8.0.0' apply false
}
EOF

# Create local.properties template
cat > "$PACKAGE_DIR/local.properties.template" << 'EOF'
# Location of the Android SDK. This should be set to your Android SDK path.
# Example: sdk.dir=/Users/username/Library/Android/sdk
sdk.dir=YOUR_ANDROID_SDK_PATH_HERE
EOF

# Create gradle.properties
cat > "$PACKAGE_DIR/gradle.properties" << 'EOF'
# Project-wide Gradle settings.
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
EOF

# Create APK build instructions
cat > "$PACKAGE_DIR/BUILD_INSTRUCTIONS.md" << 'EOF'
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
EOF

# Create project structure overview
cat > "$PACKAGE_DIR/PROJECT_STRUCTURE.md" << 'EOF'
# DODO Analytics Android Project Structure

```
dodo-analytics-apk-package/
├── app/
│   ├── src/
│   │   └── main/
│   │       ├── java/com/dodo/consciousness/
│   │       │   ├── DodoAnalyticsApp.java
│   │       │   └── R.java (generated)
│   │       ├── res/
│   │       │   ├── layout/
│   │       │   │   └── dodo_consciousness_layout.xml
│   │       │   ├── values/
│   │       │   │   ├── colors.xml
│   │       │   │   ├── strings.xml
│   │       │   │   └── styles.xml
│   │       │   └── drawable/
│   │       │       └── dodo_icon.xml
│   │       └── AndroidManifest.xml
│   └── build.gradle
├── gradle/
│   └── wrapper/
│       └── gradle-wrapper.properties
├── build.gradle
├── settings.gradle
├── gradle.properties
├── local.properties.template
├── gradlew
├── BUILD_INSTRUCTIONS.md
└── PROJECT_STRUCTURE.md
```

## Key Files

### DodoAnalyticsApp.java
Main Android Activity implementing:
- φ-resonance analytics
- DNA-Lambda evolution simulation
- DODO backend integration
- Real-time system metrics

### Layout XML
Professional UI design with:
- Analytics metrics display
- System resonance controls
- DNA evolution interface
- Backend connection panel

### AndroidManifest.xml
App configuration with:
- Internet permissions for backend connection
- Main activity registration
- App metadata and settings

### build.gradle
Android build configuration with:
- Target SDK 33
- Required dependencies
- DODO pattern constants
- Build variants (debug/release)
EOF

print_success "DODO Analytics APK package created!"
print_info "Package location: $PACKAGE_DIR/"
print_info "Package size: $(du -sh "$PACKAGE_DIR" | cut -f1)"

echo ""
echo "📦 Package Contents:"
echo "   ✓ Complete Android project structure"
echo "   ✓ Investor-friendly source code (no consciousness references)"
echo "   ✓ Professional UI with minimal emojis"
echo "   ✓ Build instructions and documentation"
echo "   ✓ Gradle build system configuration"
echo ""
echo "🚀 Next Steps:"
echo "   1. Transfer package to a machine with Android SDK"
echo "   2. Follow BUILD_INSTRUCTIONS.md"
echo "   3. Build APK using Android Studio or ./gradlew assembleDebug"
echo ""
echo "φ = 1.618033988749895"
echo "DODO Pattern: 5.1.1.2.3.4.5.1"

# Create ZIP archive for easy transfer
if command -v zip >/dev/null 2>&1; then
    print_info "Creating ZIP archive..."
    zip -r "${PACKAGE_DIR}.zip" "$PACKAGE_DIR/" >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        print_success "ZIP archive created: ${PACKAGE_DIR}.zip"
        print_info "Archive size: $(du -sh "${PACKAGE_DIR}.zip" | cut -f1)"
    fi
fi

print_success "DODO Analytics APK package ready for deployment!"