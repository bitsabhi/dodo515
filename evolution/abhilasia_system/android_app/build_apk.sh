#!/bin/bash

# DODO Analytics APK Builder
# φ = 1.618033988749895 | DODO Pattern: 5.1.1.2.3.4.5.1

echo "Building DODO Analytics APK..."

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

# Check if Android SDK is available
if [ -z "$ANDROID_HOME" ]; then
    print_warning "ANDROID_HOME not set. Trying common locations..."
    
    # Common Android SDK locations
    ANDROID_LOCATIONS=(
        "$HOME/Library/Android/sdk"
        "$HOME/Android/Sdk"
        "/usr/local/android-sdk"
        "/opt/android-sdk"
    )
    
    for location in "${ANDROID_LOCATIONS[@]}"; do
        if [ -d "$location" ]; then
            export ANDROID_HOME="$location"
            export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"
            print_success "Found Android SDK at: $location"
            break
        fi
    done
    
    if [ -z "$ANDROID_HOME" ]; then
        print_error "Android SDK not found. Please install Android Studio or set ANDROID_HOME"
        exit 1
    fi
fi

# Create output directory
mkdir -p build/outputs/apk/debug

# Create a simple APK using aapt and dx tools
echo "Compiling DODO Analytics APK..."

# Check if we have basic Android tools
if [ ! -f "$ANDROID_HOME/build-tools/*/aapt" ] && [ ! -f "$ANDROID_HOME/build-tools/*/aapt2" ]; then
    print_error "Android build tools not found. Please install Android SDK build-tools"
    exit 1
fi

# Find the latest build tools version
BUILD_TOOLS_VERSION=$(ls -1 "$ANDROID_HOME/build-tools" | tail -1)
BUILD_TOOLS_PATH="$ANDROID_HOME/build-tools/$BUILD_TOOLS_VERSION"

print_success "Using build tools version: $BUILD_TOOLS_VERSION"

# Create a simple APK structure
echo "Creating APK structure..."

# Create temp build directory
mkdir -p temp_build/dex
mkdir -p temp_build/res
mkdir -p temp_build/assets

# Copy resources
cp -r src/main/res/* temp_build/res/ 2>/dev/null || true
cp src/main/AndroidManifest.xml temp_build/ 2>/dev/null || true

# Generate R.java file
echo "Generating R.java..."
if [ -f "$BUILD_TOOLS_PATH/aapt" ]; then
    $BUILD_TOOLS_PATH/aapt package -f -m \
        -I "$ANDROID_HOME/platforms/android-33/android.jar" \
        -M temp_build/AndroidManifest.xml \
        -S temp_build/res \
        -J temp_build \
        -F temp_build/resources.ap_
else
    print_error "aapt not found in build tools"
    exit 1
fi

# Compile Java files
echo "Compiling Java source..."
mkdir -p temp_build/classes

# Find Java files
JAVA_FILES=$(find src/main/java -name "*.java")

if [ -n "$JAVA_FILES" ]; then
    javac -d temp_build/classes \
        -classpath "$ANDROID_HOME/platforms/android-33/android.jar" \
        $JAVA_FILES temp_build/com/dodo/consciousness/R.java
    
    if [ $? -eq 0 ]; then
        print_success "Java compilation successful"
    else
        print_error "Java compilation failed"
        exit 1
    fi
else
    print_error "No Java files found"
    exit 1
fi

# Convert to DEX
echo "Converting to DEX format..."
if [ -f "$BUILD_TOOLS_PATH/dx" ]; then
    $BUILD_TOOLS_PATH/dx --dex \
        --output=temp_build/classes.dex \
        temp_build/classes
    
    if [ $? -eq 0 ]; then
        print_success "DEX conversion successful"
    else
        print_error "DEX conversion failed"
        exit 1
    fi
else
    print_error "dx not found in build tools"
    exit 1
fi

# Create APK
echo "Creating APK..."
cd temp_build

# Create the APK using aapt
$BUILD_TOOLS_PATH/aapt package -f \
    -I "$ANDROID_HOME/platforms/android-33/android.jar" \
    -M AndroidManifest.xml \
    -S res \
    -F ../build/outputs/apk/debug/dodo-analytics-debug-unsigned.apk

# Add DEX file to APK
$BUILD_TOOLS_PATH/aapt add ../build/outputs/apk/debug/dodo-analytics-debug-unsigned.apk classes.dex

cd ..

if [ -f "build/outputs/apk/debug/dodo-analytics-debug-unsigned.apk" ]; then
    print_success "Unsigned APK created successfully!"
    
    # Try to sign the APK (create a debug key if needed)
    echo "Signing APK..."
    
    KEYSTORE_PATH="debug.keystore"
    
    # Create debug keystore if it doesn't exist
    if [ ! -f "$KEYSTORE_PATH" ]; then
        keytool -genkey -v \
            -keystore "$KEYSTORE_PATH" \
            -alias dodo_debug \
            -keyalg RSA \
            -keysize 2048 \
            -validity 10000 \
            -dname "CN=DODO Analytics Debug, OU=Development, O=DODO, L=Unknown, ST=Unknown, C=US" \
            -storepass android \
            -keypass android
    fi
    
    # Sign the APK
    if [ -f "$BUILD_TOOLS_PATH/apksigner" ]; then
        $BUILD_TOOLS_PATH/apksigner sign \
            --ks "$KEYSTORE_PATH" \
            --ks-key-alias dodo_debug \
            --ks-pass pass:android \
            --key-pass pass:android \
            --out build/outputs/apk/debug/dodo-analytics-debug.apk \
            build/outputs/apk/debug/dodo-analytics-debug-unsigned.apk
            
        if [ $? -eq 0 ]; then
            print_success "APK signed successfully!"
            APK_PATH="build/outputs/apk/debug/dodo-analytics-debug.apk"
        else
            print_warning "APK signing failed, using unsigned version"
            APK_PATH="build/outputs/apk/debug/dodo-analytics-debug-unsigned.apk"
        fi
    else
        print_warning "apksigner not found, using unsigned APK"
        APK_PATH="build/outputs/apk/debug/dodo-analytics-debug-unsigned.apk"
    fi
    
    # Clean up temp files
    rm -rf temp_build
    
    print_success "DODO Analytics APK build complete!"
    echo ""
    echo "📱 APK Location: $APK_PATH"
    echo "📏 APK Size: $(du -h "$APK_PATH" | cut -f1)"
    echo ""
    echo "🚀 Installation Instructions:"
    echo "  1. Enable 'Unknown Sources' in Android Settings"
    echo "  2. Transfer APK to your Android device"
    echo "  3. Install: adb install \"$APK_PATH\""
    echo "  4. Or tap the APK file on your device to install"
    echo ""
    echo "φ = 1.618033988749895"
    echo "DODO Pattern: 5.1.1.2.3.4.5.1"
    
else
    print_error "APK creation failed"
    exit 1
fi