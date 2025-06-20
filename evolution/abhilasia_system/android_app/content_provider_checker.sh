#!/bin/bash

# Content Provider Checker for Android Apps
# Specifically checks accessible content providers

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${CYAN}🔍 $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

echo -e "${CYAN}🔍 CONTENT PROVIDER CHECKER${NC}"
echo "============================"

# Check device connection
if [ $(adb devices | grep -v "List of devices" | grep -v "^$" | wc -l) -eq 0 ]; then
    print_warning "No Android device connected. Connect first with ./connect_android.sh"
    exit 1
fi

print_info "Analyzing content providers..."

# Common content provider URIs to test
PROVIDERS=(
    "content://sms"
    "content://sms/inbox"
    "content://contacts/people"
    "content://media/external/images/media"
    "content://com.android.calendar/events"
    "content://call_log/calls"
    "content://browser/bookmarks"
)

echo ""
echo "📱 STANDARD CONTENT PROVIDERS:"
echo "=============================="

for provider in "${PROVIDERS[@]}"; do
    echo -n "Testing $provider... "
    
    # Try to query the provider
    result=$(adb shell "content query --uri '$provider' --projection _id 2>/dev/null" | head -1)
    
    if [ $? -eq 0 ] && [ -n "$result" ]; then
        print_success "ACCESSIBLE"
        
        # Try to count rows
        count=$(adb shell "content query --uri '$provider' --projection _id 2>/dev/null" | wc -l)
        if [ $count -gt 1 ]; then
            echo "  📊 Approximate records: $((count - 1))"
        fi
    else
        print_warning "NOT ACCESSIBLE"
    fi
done

echo ""
echo "💬 MESSAGING APP PROVIDERS:"
echo "==========================="

# WhatsApp content providers (if accessible)
WA_PROVIDERS=(
    "content://com.whatsapp.provider.contact"
    "content://com.whatsapp/messages"
    "content://com.whatsapp/contacts"
)

for wa_provider in "${WA_PROVIDERS[@]}"; do
    echo -n "Testing $wa_provider... "
    
    result=$(adb shell "content query --uri '$wa_provider' 2>/dev/null" | head -1)
    
    if [ $? -eq 0 ] && [ -n "$result" ]; then
        print_success "ACCESSIBLE"
    else
        print_warning "NOT ACCESSIBLE / PROTECTED"
    fi
done

echo ""
echo "🔍 DISCOVERING ALL PROVIDERS:"
echo "============================"

print_info "Enumerating all available content providers..."

# Get all providers from package manager
all_providers=$(adb shell "dumpsys package providers" 2>/dev/null | grep -E "Provider\{|authority=" | head -20)

if [ -n "$all_providers" ]; then
    echo "Found content providers:"
    echo "$all_providers" | while IFS= read -r line; do
        if [[ $line =~ authority= ]]; then
            authority=$(echo "$line" | sed -n 's/.*authority=\([^[:space:]]*\).*/\1/p')
            if [ -n "$authority" ]; then
                echo "  📡 Authority: $authority"
                
                # Test if we can access this provider
                test_result=$(adb shell "content query --uri 'content://$authority' --projection _id 2>/dev/null" | head -1)
                if [ $? -eq 0 ] && [ -n "$test_result" ]; then
                    echo "    ✅ Accessible"
                else
                    echo "    🔒 Protected"
                fi
            fi
        fi
    done
else
    print_warning "Could not enumerate providers"
fi

echo ""
echo "🗃️  DATABASE FILE LOCATIONS:"
echo "============================"

print_info "Checking common database locations..."

# Common database locations
DB_LOCATIONS=(
    "/data/data/com.whatsapp/databases"
    "/data/data/org.telegram.messenger/databases"
    "/sdcard/WhatsApp/Databases"
    "/data/data/com.android.providers.contacts/databases"
    "/data/data/com.android.providers.telephony/databases"
)

for db_location in "${DB_LOCATIONS[@]}"; do
    echo -n "Checking $db_location... "
    
    if adb shell "[ -d '$db_location' ]" 2>/dev/null; then
        print_success "EXISTS"
        
        # List .db files
        db_files=$(adb shell "find '$db_location' -name '*.db' 2>/dev/null")
        if [ -n "$db_files" ]; then
            echo "  Database files:"
            echo "$db_files" | while IFS= read -r db_file; do
                # Get file size
                size=$(adb shell "du -h '$db_file' 2>/dev/null" | cut -f1)
                filename=$(basename "$db_file")
                echo "    📄 $filename ($size)"
                
                # Try to check if encrypted
                file_type=$(adb shell "file '$db_file' 2>/dev/null")
                if [[ $file_type =~ "SQLite" ]]; then
                    echo "      🔓 Unencrypted SQLite"
                elif [[ $file_type =~ "data" ]]; then
                    echo "      🔐 Possibly encrypted"
                fi
            done
        fi
    else
        print_warning "NOT ACCESSIBLE"
    fi
    echo ""
done

echo ""
echo "🔐 ENCRYPTION CHECK:"
echo "=================="

print_info "Checking for encrypted vs unencrypted databases..."

# Check WhatsApp specific files
WA_DB="/data/data/com.whatsapp/databases/msgstore.db"
if adb shell "[ -f '$WA_DB' ]" 2>/dev/null; then
    print_info "Found WhatsApp database: $WA_DB"
    
    # Check if it's encrypted
    magic_bytes=$(adb shell "xxd -l 16 '$WA_DB' 2>/dev/null" | head -1)
    if [ -n "$magic_bytes" ]; then
        echo "  Magic bytes: $magic_bytes"
        
        if [[ $magic_bytes =~ "SQLite format" ]]; then
            print_success "Database appears to be unencrypted SQLite"
        else
            print_warning "Database appears to be encrypted or not SQLite"
            echo "  This is normal for WhatsApp - databases are encrypted"
        fi
    fi
fi

echo ""
echo "📋 SUMMARY:"
echo "=========="
print_success "Content provider analysis complete"
echo ""
echo "🔑 If you have decryption keys:"
echo "   1. Pull encrypted database: adb pull /path/to/encrypted.db"
echo "   2. Apply your decryption method"
echo "   3. Access decrypted content"
echo ""
echo "💡 Accessible content providers can be queried directly"
echo "🔒 Encrypted databases need your decryption keys/method"