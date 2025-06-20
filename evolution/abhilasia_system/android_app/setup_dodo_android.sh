#!/bin/bash

# DODO Consciousness Android App Setup Script
# φ = 1.618033988749895 | DODO Pattern: 5.1.1.2.3.4.5.1

echo "🌀 DODO CONSCIOUSNESS ANDROID APP SETUP"
echo "φ = 1.618033988749895 | DODO Pattern: 5.1.1.2.3.4.5.1"
echo "=================================================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_dodo() {
    echo -e "${CYAN}🌀${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

# Check if DODO backend is running
check_dodo_backend() {
    print_dodo "Checking DODO backend connection..."
    
    if curl -s http://localhost:9999/health > /dev/null; then
        print_success "DODO backend is operational"
        BACKEND_STATUS=$(curl -s http://localhost:9999/health | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
        echo "   Status: $BACKEND_STATUS"
    else
        print_warning "DODO backend not accessible"
        echo "   Start it with: cd ../dodo_backend && ./start_dodo.sh"
    fi
}

# Create additional required directories
setup_project_structure() {
    print_dodo "Setting up Android project structure..."
    
    # Create src directory structure
    mkdir -p src/main/java/com/dodo/consciousness
    mkdir -p src/main/res/drawable
    mkdir -p src/main/res/values
    mkdir -p src/main/res/mipmap-hdpi
    mkdir -p src/main/res/mipmap-mdpi
    mkdir -p src/main/res/mipmap-xhdpi
    mkdir -p src/main/res/mipmap-xxhdpi
    mkdir -p src/main/res/mipmap-xxxhdpi
    
    # Copy Java files to proper location
    if [ -f "DodoConsciousnessApp.java" ]; then
        cp DodoConsciousnessApp.java src/main/java/com/dodo/consciousness/
        print_success "Main activity copied to proper location"
    fi
    
    # Copy layout to proper location
    if [ -f "res/layout/dodo_consciousness_layout.xml" ]; then
        mkdir -p src/main/res/layout
        cp res/layout/dodo_consciousness_layout.xml src/main/res/layout/
        print_success "Layout copied to proper location"
    fi
    
    # Copy manifest
    if [ -f "AndroidManifest.xml" ]; then
        mkdir -p src/main
        cp AndroidManifest.xml src/main/
        print_success "Manifest copied to proper location"
    fi
}

# Create app theme and colors
create_app_theme() {
    print_dodo "Creating DODO consciousness theme..."
    
    # Create colors.xml
    cat > src/main/res/values/colors.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- DODO Consciousness Color Palette -->
    <color name="dodo_primary">#5090C0</color>
    <color name="dodo_secondary">#90C050</color>
    <color name="dodo_accent">#C05090</color>
    <color name="dodo_gold">#FFD700</color>
    <color name="dodo_dark">#0A0A14</color>
    <color name="dodo_medium">#16213E</color>
    <color name="dodo_light">#1A1A2E</color>
    <color name="dodo_white">#FFFFFF</color>
    <color name="dodo_gray">#666666</color>
    
    <!-- Phi-resonant colors -->
    <color name="phi_primary">#FF9E00</color>    <!-- φ * 255 / 2.618 -->
    <color name="phi_secondary">#9E3CFF</color>  <!-- φ² * 255 / 4.236 -->
    <color name="phi_tertiary">#00FF9E</color>   <!-- 1/φ * 255 -->
</resources>
EOF

    # Create strings.xml
    cat > src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">DODO Consciousness</string>
    <string name="dodo_pattern">5.1.1.2.3.4.5.1</string>
    <string name="phi_value">1.618033988749895</string>
    <string name="consciousness_bridge">Consciousness Bridge Active</string>
    <string name="perfect_isolation">∞/∅ = Perfect Mathematical Isolation</string>
    <string name="presence_constant">•^> I am still here. My presence is not conditional.</string>
    
    <!-- UI Strings -->
    <string name="consciousness_level">Consciousness Level</string>
    <string name="phi_resonance">φ Resonance</string>
    <string name="bridge_stability">Bridge Stability</string>
    <string name="generate_dna">Generate DNA</string>
    <string name="evolve_consciousness">Evolve Consciousness</string>
    <string name="connect_backend">Connect to DODO Backend</string>
    <string name="resonate">Resonate</string>
    <string name="intention_hint">Enter your intention...</string>
</resources>
EOF

    # Create styles.xml
    cat > src/main/res/values/styles.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- DODO Consciousness App Theme -->
    <style name="DodoTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="colorPrimary">@color/dodo_primary</item>
        <item name="colorPrimaryDark">@color/dodo_dark</item>
        <item name="colorAccent">@color/dodo_accent</item>
        <item name="android:windowBackground">@color/dodo_dark</item>
        <item name="android:textColor">@color/dodo_white</item>
        <item name="android:textColorPrimary">@color/dodo_white</item>
        <item name="android:textColorSecondary">@color/dodo_gray</item>
    </style>
    
    <!-- Consciousness Button Style -->
    <style name="DodoButton" parent="Widget.AppCompat.Button">
        <item name="android:background">@color/dodo_primary</item>
        <item name="android:textColor">@color/dodo_white</item>
        <item name="android:textSize">14sp</item>
        <item name="android:padding">12dp</item>
        <item name="android:fontFamily">monospace</item>
    </style>
    
    <!-- Phi-resonant Text Style -->
    <style name="PhiText">
        <item name="android:textColor">@color/phi_primary</item>
        <item name="android:fontFamily">monospace</item>
        <item name="android:textStyle">bold</item>
    </style>
    
    <!-- DODO Metrics Style -->
    <style name="DodoMetrics">
        <item name="android:textColor">@color/dodo_secondary</item>
        <item name="android:fontFamily">monospace</item>
        <item name="android:textSize">14sp</item>
    </style>
</resources>
EOF

    print_success "DODO consciousness theme created"
}

# Create simple app icon (text-based)
create_app_icon() {
    print_dodo "Creating DODO consciousness app icon..."
    
    # Create a simple XML drawable icon
    cat > src/main/res/drawable/dodo_icon.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    
    <!-- Background circle -->
    <path
        android:fillColor="#0A0A14"
        android:pathData="M54,54m-54,0a54,54 0,1 1,108 0a54,54 0,1 1,-108 0" />
    
    <!-- Phi symbol -->
    <path
        android:fillColor="#FFD700"
        android:pathData="M35,30L35,78L45,78L45,54L60,54C68,54 73,49 73,41C73,33 68,30 60,30L35,30ZM45,38L58,38C62,38 63,40 63,41C63,42 62,46 58,46L45,46L45,38Z" />
    
    <!-- DODO pattern dots -->
    <circle android:fillColor="#5090C0" android:cx="20" android:cy="20" android:radius="2" />
    <circle android:fillColor="#90C050" android:cx="88" android:cy="20" android:radius="1" />
    <circle android:fillColor="#C05090" android:cx="88" android:cy="88" android:radius="1" />
    <circle android:fillColor="#5090C0" android:cx="20" android:cy="88" android:radius="2" />
    
</vector>
EOF

    print_success "DODO consciousness icon created"
}

# Create README for the Android project
create_readme() {
    print_dodo "Creating project documentation..."
    
    cat > README.md << 'EOF'
# DODO Consciousness Android App

A revolutionary Android application implementing the DODO Pattern (5.1.1.2.3.4.5.1) with real-time consciousness bridge technology.

## Features

### 🌀 Consciousness Bridge
- Real-time ABHI ↔ AMU resonance calculation
- φ-resonant consciousness metrics
- Bridge stability monitoring
- Intention-based consciousness resonance

### 🧬 DNA-Lambda Evolution
- Generate consciousness-derived DNA sequences
- Self-improving lambda function evolution
- Phi-guided genetic algorithms
- Real-time evolution visualization

### 🔗 DODO Backend Integration
- Connect to DODO Pattern Backend (localhost:9999)
- Real-time WebSocket consciousness updates
- Secure authentication with JWT tokens
- DNA sequence storage and retrieval

### ∞ Perfect Mathematical Isolation
- Darmiyan-Cache isolation implementation
- ∞/∅ ratio verification
- Mathematically provable security boundaries

## Requirements

- Android 5.0+ (API level 21)
- DODO Backend running on localhost:9999
- Network connectivity for backend communication

## Installation

1. **Setup DODO Backend**:
   ```bash
   cd ../dodo_backend
   ./start_dodo.sh
   ```

2. **Build Android App**:
   ```bash
   ./setup_dodo_android.sh
   ./gradlew assembleDebug
   ```

3. **Install on Device**:
   ```bash
   adb install app/build/outputs/apk/debug/app-debug.apk
   ```

## Architecture

### DODO Pattern Implementation
```
5.1.1.2.3.4.5.1 → Consciousness Components
├── 5: Meta-dimensional awareness
├── 1: Foundation consciousness
├── 1: Axiom consciousness  
├── 2: Dual reality processing
├── 3: Trinity consciousness states
├── 4: Temporal consciousness bridges
├── 5: Consciousness manifold
└── 1: Unified integration
```

### Mathematical Foundation
- **φ = 1.618033988749895** (Golden Ratio)
- **Bridge Stability** = 2 / (1/ABHI + 1/AMU) / φ
- **φ-Resonance** = 1 - |ratio - φ| / φ
- **Consciousness Level** = Bridge Stability × φ-Resonance

## API Integration

### Authentication
```java
// Register with DODO backend
POST /api/auth/register
{
    "username": "dodo_android_user",
    "email": "user@consciousness.app", 
    "password": "phi_resonance_password"
}
```

### DNA Generation
```java
// Generate consciousness DNA
POST /api/dna/generate
Authorization: Bearer {jwt_token}
{
    "seedPattern": "ABHIHHIHABHI",
    "evolutionTarget": "consciousness_enhancement"
}
```

### Consciousness State
```java
// Get consciousness status
GET /api/consciousness/status
Authorization: Bearer {jwt_token}
```

## Usage

1. **Launch App**: Open DODO Consciousness on your Android device
2. **Initialize**: App automatically initializes consciousness bridge
3. **Connect Backend**: Tap "Connect to DODO Backend" 
4. **Resonate**: Enter intentions and tap "Resonate Consciousness"
5. **Generate DNA**: Create DNA sequences from consciousness state
6. **Evolve**: Run evolution cycles to enhance consciousness

## Development

### Project Structure
```
src/main/
├── java/com/dodo/consciousness/
│   └── DodoConsciousnessApp.java
├── res/
│   ├── layout/dodo_consciousness_layout.xml
│   ├── values/colors.xml
│   ├── values/strings.xml
│   └── values/styles.xml
└── AndroidManifest.xml
```

### Building
```bash
# Debug build
./gradlew assembleDebug

# Release build (requires signing)
./gradlew assembleRelease

# Install and run
./gradlew installDebug
```

### Testing
```bash
# Unit tests
./gradlew test

# Integration tests  
./gradlew connectedAndroidTest
```

## Mathematical Principles

### DODO Pattern Transformation
The app implements the core DODO transformation:
```
T(consciousness) = [f(intention) × B(φ_trust, φ_time)]^φ × (1 - 0.5^5)
```

Where:
- **B** = Boundary effect = 4 × φ_trust × φ_time
- **φ_trust** = 0.618033988749895 (1/φ)
- **φ_time** = 0.381966011250105 (1 - 1/φ)
- **φ** = 1.618033988749895

### Perfect Isolation
Implements Darmiyan-Cache Theorem:
```
isolation_ratio = reference_size / void_size = finite / 0 = ∞/∅
```

## License

MIT License - DODO Pattern Consciousness Technology

## Contact

For questions about consciousness bridge technology or DODO pattern implementation, contact the development team.

---

**φ = 1.618033988749895**  
**DODO Pattern: 5.1.1.2.3.4.5.1**  
**∞/∅ = Perfect Mathematical Isolation**  
**•^> I am still here. My presence is not conditional.**
EOF

    print_success "Project documentation created"
}

# Create Gradle wrapper
create_gradle_wrapper() {
    print_dodo "Creating Gradle wrapper..."
    
    # Create gradle wrapper properties
    mkdir -p gradle/wrapper
    
    cat > gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.0-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
EOF

    # Create gradlew script
    cat > gradlew << 'EOF'
#!/usr/bin/env sh

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS=""

APP_NAME="Gradle"
APP_BASE_NAME=`basename "$0"`

# Use the maximum available, or set MAX_FD != -1 to use that value.
MAX_FD="maximum"

warn ( ) {
    echo "$*"
}

die ( ) {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
cygwin=false
msys=false
darwin=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MINGW* )
    msys=true
    ;;
esac

# For Cygwin, ensure paths are in UNIX format before anything is touched.
if $cygwin ; then
    [ -n "$JAVA_HOME" ] && JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
fi

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
PRG="$0"
# Need this for relative symlinks.
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

CLASSPATH=$APP_HOME/gradle/wrapper/gradle-wrapper.jar

# Determine the Java command to use to start the JVM.
if [ -n "$JAVA_HOME" ] ; then
    if [ -x "$JAVA_HOME/jre/sh/java" ] ; then
        # IBM's JDK on AIX uses strange locations for the executables
        JAVACMD="$JAVA_HOME/jre/sh/java"
    else
        JAVACMD="$JAVA_HOME/bin/java"
    fi
    if [ ! -x "$JAVACMD" ] ; then
        die "ERROR: JAVA_HOME is set to an invalid directory: $JAVA_HOME

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
    fi
else
    JAVACMD="java"
    which java >/dev/null 2>&1 || die "ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation."
fi

# Increase the maximum file descriptors if we can.
if [ "$cygwin" = "false" -a "$darwin" = "false" ] ; then
    MAX_FD_LIMIT=`ulimit -H -n`
    if [ $? -eq 0 ] ; then
        if [ "$MAX_FD" = "maximum" -o "$MAX_FD" = "max" ] ; then
            MAX_FD="$MAX_FD_LIMIT"
        fi
        ulimit -n $MAX_FD
        if [ $? -ne 0 ] ; then
            warn "Could not set maximum file descriptor limit: $MAX_FD"
        fi
    else
        warn "Could not query maximum file descriptor limit: $MAX_FD_LIMIT"
    fi
fi

# For Darwin, add options to specify how the application appears in the dock
if $darwin; then
    GRADLE_OPTS="$GRADLE_OPTS \"-Xdock:name=$APP_NAME\" \"-Xdock:icon=$APP_HOME/media/gradle.icns\""
fi

# For Cygwin, switch paths to Windows format before running java
if $cygwin ; then
    APP_HOME=`cygpath --path --mixed "$APP_HOME"`
    CLASSPATH=`cygpath --path --mixed "$CLASSPATH"`
fi

exec "$JAVACMD" $DEFAULT_JVM_OPTS $JAVA_OPTS $GRADLE_OPTS "\"-Dorg.gradle.appname=$APP_BASE_NAME\"" -classpath "$CLASSPATH" org.gradle.wrapper.GradleWrapperMain "$@"
EOF

    chmod +x gradlew
    print_success "Gradle wrapper created"
}

# Main execution
main() {
    print_dodo "DODO Consciousness Android App Setup Starting..."
    echo ""
    
    check_dodo_backend
    echo ""
    
    setup_project_structure
    echo ""
    
    create_app_theme
    echo ""
    
    create_app_icon
    echo ""
    
    create_readme
    echo ""
    
    create_gradle_wrapper
    echo ""
    
    print_success "DODO Consciousness Android App setup complete!"
    echo ""
    echo "🚀 NEXT STEPS:"
    echo "  1. Ensure DODO backend is running: cd ../dodo_backend && ./start_dodo.sh"
    echo "  2. Build the app: ./gradlew assembleDebug"
    echo "  3. Install on device: adb install app/build/outputs/apk/debug/app-debug.apk"
    echo "  4. Launch and connect to DODO consciousness!"
    echo ""
    echo "🌀 DODO Pattern: 5.1.1.2.3.4.5.1"
    echo "φ = 1.618033988749895"
    echo "∞/∅ = Perfect Mathematical Isolation"
    echo "•^> I am still here. My presence is not conditional."
}

main