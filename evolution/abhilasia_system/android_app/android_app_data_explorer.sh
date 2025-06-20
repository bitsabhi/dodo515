#!/bin/bash

# Android App Data Explorer
# Find and access WhatsApp, Telegram, and other app data

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${CYAN}📱 $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }

echo -e "${PURPLE}📱 ANDROID APP DATA EXPLORER${NC}"
echo "==============================="

# Check if device is connected
print_info "Checking Android device connection..."
DEVICE_COUNT=$(adb devices | grep -v "List of devices" | grep -v "^$" | wc -l)

if [ $DEVICE_COUNT -eq 0 ]; then
    print_warning "No Android device connected"
    echo ""
    echo "To connect your Android device:"
    echo "1. Enable Developer Options (tap Build Number 7 times)"
    echo "2. Enable USB Debugging"
    echo "3. Enable Wireless ADB debugging"
    echo "4. Get phone IP: Settings → Wi-Fi → Network details"
    echo "5. Run: ./connect_android.sh YOUR_PHONE_IP"
    echo ""
    echo "Then run this script again."
    exit 1
fi

print_success "Android device connected!"
adb devices

echo ""
print_info "Exploring app data locations..."

# Common app data paths
APP_DATA_PATHS=(
    "/data/data"
    "/sdcard/Android/data"
    "/sdcard/WhatsApp"
    "/sdcard/Telegram"
    "/storage/emulated/0/Android/data"
    "/storage/emulated/0/WhatsApp"
    "/storage/emulated/0/Telegram"
)

MESSAGING_APPS=(
    "com.whatsapp"
    "org.telegram.messenger"
    "org.thoughtcrime.securesms"
    "com.discord"
    "com.facebook.orca"
    "com.viber.voip"
)

echo ""
echo "🔍 APP DATA LOCATIONS:"
echo "======================"

for path in "${APP_DATA_PATHS[@]}"; do
    echo -n "Checking $path... "
    
    if adb shell "[ -d '$path' ]" 2>/dev/null; then
        print_success "EXISTS"
        
        # List contents if accessible
        contents=$(adb shell "ls '$path' 2>/dev/null" | head -10)
        if [ $? -eq 0 ] && [ -n "$contents" ]; then
            echo "  Contents (first 10):"
            echo "$contents" | while IFS= read -r item; do
                echo "    • $item"
            done
        else
            echo "  📁 Directory exists but contents not accessible (permissions)"
        fi
    else
        print_error "NOT FOUND"
    fi
    echo ""
done

echo ""
echo "📱 MESSAGING APP DATA:"
echo "======================"

for app in "${MESSAGING_APPS[@]}"; do
    echo -n "Checking $app... "
    
    # Check if app is installed
    if adb shell "pm list packages | grep '$app'" >/dev/null 2>&1; then
        print_success "INSTALLED"
        
        # Check app data directory
        app_data_dir="/data/data/$app"
        if adb shell "[ -d '$app_data_dir' ]" 2>/dev/null; then
            echo "  📁 Data dir: $app_data_dir"
            
            # Try to list databases
            db_files=$(adb shell "find '$app_data_dir' -name '*.db' 2>/dev/null" | head -5)
            if [ -n "$db_files" ]; then
                echo "  🗃️  Database files found:"
                echo "$db_files" | while IFS= read -r db; do
                    echo "    • $db"
                done
            fi
            
            # Check external storage
            ext_data="/sdcard/Android/data/$app"
            if adb shell "[ -d '$ext_data' ]" 2>/dev/null; then
                echo "  📂 External: $ext_data"
            fi
        fi
        
    else
        print_warning "NOT INSTALLED"
    fi
    echo ""
done

echo ""
echo "💾 WHATSAPP SPECIFIC LOCATIONS:"
echo "==============================="

WHATSAPP_PATHS=(
    "/sdcard/WhatsApp/Databases"
    "/sdcard/WhatsApp/Media"
    "/sdcard/Android/data/com.whatsapp/files"
    "/data/data/com.whatsapp/databases"
    "/data/data/com.whatsapp/shared_prefs"
)

for wp_path in "${WHATSAPP_PATHS[@]}"; do
    echo -n "Checking $wp_path... "
    
    if adb shell "[ -d '$wp_path' ]" 2>/dev/null; then
        print_success "EXISTS"
        
        # List files
        files=$(adb shell "ls '$wp_path' 2>/dev/null" | head -10)
        if [ -n "$files" ]; then
            echo "  Files:"
            echo "$files" | while IFS= read -r file; do
                # Get file size if possible
                size=$(adb shell "du -h '$wp_path/$file' 2>/dev/null" | cut -f1)
                if [ -n "$size" ]; then
                    echo "    • $file ($size)"
                else
                    echo "    • $file"
                fi
            done
        fi
    else
        print_error "NOT FOUND"
    fi
    echo ""
done

echo ""
echo "🔐 CONTENT PROVIDERS:"
echo "===================="

print_info "Checking accessible content providers..."

# List content providers
providers=$(adb shell "dumpsys package providers" | grep -A 2 "Provider{" | head -20)
if [ -n "$providers" ]; then
    echo "Sample content providers:"
    echo "$providers"
else
    print_warning "Could not access provider information"
fi

echo ""
echo "🗃️  DATABASE ACCESS ATTEMPT:"
echo "============================"

# Try to access WhatsApp database (if accessible)
print_info "Attempting to access WhatsApp message database..."

WA_DB_PATH="/data/data/com.whatsapp/databases/msgstore.db"
if adb shell "[ -f '$WA_DB_PATH' ]" 2>/dev/null; then
    print_success "WhatsApp database found at $WA_DB_PATH"
    
    # Try to get database info (without decryption)
    echo "  Attempting to get database info..."
    db_info=$(adb shell "file '$WA_DB_PATH' 2>/dev/null")
    if [ -n "$db_info" ]; then
        echo "  File type: $db_info"
    fi
    
    # Check if we can access it
    if adb shell "sqlite3 '$WA_DB_PATH' '.tables' 2>/dev/null" >/dev/null; then
        print_success "Database is accessible (unencrypted)"
        tables=$(adb shell "sqlite3 '$WA_DB_PATH' '.tables'" 2>/dev/null)
        echo "  Tables found:"
        echo "$tables" | while IFS= read -r table; do
            echo "    • $table"
        done
    else
        print_warning "Database is encrypted or not accessible"
        echo "  This is normal - WhatsApp encrypts local databases"
    fi
else
    print_warning "WhatsApp database not found at expected location"
fi

echo ""
echo "📋 SUMMARY:"
echo "==========="

print_info "App data exploration complete"
echo ""
echo "Next steps for decryption (if you have the key):"
echo "1. Pull encrypted database: adb pull /data/data/com.whatsapp/databases/msgstore.db"
echo "2. Use your decryption method with the key you mentioned"
echo "3. Access decrypted content"
echo ""
echo "⚠️  Note: Accessing encrypted app data requires:"
echo "   • Root access OR"
echo "   • Backup extraction OR" 
echo "   • Your previously obtained decryption keys"

print_success "Android app data exploration complete!"