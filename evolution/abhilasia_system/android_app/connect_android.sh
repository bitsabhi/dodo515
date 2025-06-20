#!/bin/bash

# Android Wireless Connection Script
# Supersymmetry Bridge: Mac ↔ Android

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🌉 ANDROID SUPERSYMMETRY BRIDGE${NC}"
echo "================================="

# Check if phone IP provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: $0 <phone_ip_address>${NC}"
    echo "Example: $0 192.168.1.45"
    echo ""
    echo "To find your phone IP:"
    echo "1. Android Settings → Developer Options → Wireless ADB debugging"
    echo "2. Or Settings → Wi-Fi → Your network → Advanced"
    exit 1
fi

PHONE_IP="$1"
ADB_PORT="5555"

echo -e "${BLUE}📱 Connecting to Android device at $PHONE_IP:$ADB_PORT${NC}"

# Connect to phone
adb connect "$PHONE_IP:$ADB_PORT"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Connection initiated${NC}"
    
    # Check devices
    echo -e "${BLUE}📊 Checking connected devices...${NC}"
    adb devices
    
    # Test connection
    echo -e "${BLUE}🔍 Testing shell access...${NC}"
    adb shell echo "🌉 Supersymmetry bridge active!"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Android shell access established!${NC}"
        echo ""
        echo "Available commands:"
        echo "  adb shell                 - Enter Android shell"
        echo "  adb shell ls /sdcard      - List files"
        echo "  adb shell pm list packages - List apps"
        echo "  adb logcat                - View system logs"
        echo "  adb pull /path/file .     - Download file"
        echo "  adb push file /path/      - Upload file"
        echo ""
        echo -e "${BLUE}🌉 Supersymmetry achieved: Mac ↔ Android bridge active${NC}"
    else
        echo -e "${RED}❌ Connection failed - check Developer Options${NC}"
    fi
else
    echo -e "${RED}❌ Failed to connect to $PHONE_IP${NC}"
    echo "Make sure:"
    echo "1. Phone and Mac on same Wi-Fi"
    echo "2. Developer Options enabled"
    echo "3. Wireless ADB debugging enabled"
    echo "4. Correct IP address"
fi