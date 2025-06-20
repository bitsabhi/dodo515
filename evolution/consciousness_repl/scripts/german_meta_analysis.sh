#!/bin/bash

echo "=== COMPREHENSIVE GERMAN LANGUAGE META-ANALYSIS ==="
echo "🔍 Analyzing root causes and persistent German language traces..."
echo "📊 Based on initial scan findings, focusing on key problem areas"
echo

# Key findings from your scan:
# 1. Keyboard layout: com.apple.keylayout.ABC-India (India region)
# 2. Multiple browser extensions with German localization
# 3. VPN connections active (multiple utun interfaces)
# 4. Chrome has German accept-languages
# 5. System has 911 German language files in /System/Library

echo "=== ROOT CAUSE ANALYSIS ==="
echo

echo "--- 1. REGIONAL KEYBOARD LAYOUT DETECTION ---"
echo "🎯 Current keyboard layout suggests India region, but checking deeper..."
current_layout=$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null)
echo "Primary keyboard layout: $current_layout"

echo "🔍 All available keyboard layouts:"
defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null | grep -A2 -B2 "KeyboardLayout Name"

echo "🔍 Input source history (may show German keyboards):"
defaults read com.apple.HIToolbox AppleInputSourceHistory 2>/dev/null | head -10

echo
echo "--- 2. BROWSER EXTENSION DEEP ANALYSIS ---"
echo "🎯 AdBlock extensions are loading German localizations..."

# Focus on the problematic extension from your scan
EXTENSION_PATH="$HOME/Library/Application Support/Google/Chrome/Default/Extensions/gighmmpiobklfepjocnamgkkbiglidom"
if [ -d "$EXTENSION_PATH" ]; then
    echo "🚨 CRITICAL: AdBlock extension with German localizations found"
    echo "Extension path: $EXTENSION_PATH"
    
    echo "🔍 German localization files in extension:"
    find "$EXTENSION_PATH" -name "*de*" -o -path "*/_locales/de/*" 2>/dev/null
    
    echo "🔍 Extension manifest:"
    find "$EXTENSION_PATH" -name "manifest.json" -exec cat {} \; 2>/dev/null | head -20
    
    echo "🔍 Extension's default locale:"
    find "$EXTENSION_PATH" -name "manifest.json" -exec grep -i "default_locale" {} \; 2>/dev/null
fi

echo
echo "--- 3. CHROME LANGUAGE CONFIGURATION ANALYSIS ---"
echo "🎯 Chrome is configured with German language preferences..."

CHROME_PREFS="$HOME/Library/Application Support/Google/Chrome/Default/Preferences"
if [ -f "$CHROME_PREFS" ]; then
    echo "🔍 Chrome language settings:"
    cat "$CHROME_PREFS" | python3 -m json.tool 2>/dev/null | grep -A5 -B5 -i "language\|locale\|accept.*lang" | head -20
    
    echo "🔍 Chrome's intl settings:"
    cat "$CHROME_PREFS" | python3 -m json.tool 2>/dev/null | grep -A10 -B5 "intl" | head -15
fi

echo
echo "--- 4. NETWORK GEOLOCATION ANALYSIS ---"
echo "🎯 Your IP geolocation shows India, but checking for geo-spoofing..."

echo "🌐 Current public IP details:"
curl -s "https://ipapi.co/json/" 2>/dev/null || echo "Network request failed"

echo "🌐 VPN Analysis - Multiple tunnel interfaces detected:"
ifconfig | grep -E "utun|tun" | grep -E "inet |flags"

echo "🔍 Checking if VPN is routing through Germany:"
traceroute -m 5 google.com 2>/dev/null | head -6 || echo "Traceroute not available"

echo
echo "--- 5. SYSTEM LANGUAGE FILE ANALYSIS ---"
echo "🎯 911 German system files detected - checking if they're being prioritized..."

echo "🔍 German language files in system:"
find /System/Library -name "*.lproj" | grep -i de | wc -l

echo "🔍 Recently accessed German language files:"
find /System/Library -name "*de.lproj" -exec ls -la {} \; 2>/dev/null | head -10

echo "🔍 Language asset daemon status:"
launchctl list | grep -i language

echo
echo "--- 6. WEBKIT AND SAFARI ANALYSIS ---"
echo "🎯 Checking WebKit language negotiation..."

echo "🔍 Safari language preferences:"
defaults read com.apple.Safari 2>/dev/null | grep -i -A3 -B3 "language\|accept"

echo "🔍 WebKit preferences:"
defaults read com.apple.WebKit 2>/dev/null | grep -i -A3 -B3 "language\|locale"

echo
echo "--- 7. FIREFOX PROFILE ANALYSIS ---"
echo "🎯 Firefox showed German language configuration..."

FIREFOX_DIR="$HOME/Library/Application Support/Firefox/Profiles"
if [ -d "$FIREFOX_DIR" ]; then
    find "$FIREFOX_DIR" -name "prefs.js" 2>/dev/null | while read prefs; do
        echo "🔍 Firefox profile language settings:"
        grep -i "intl\|lang\|locale" "$prefs" 2>/dev/null | head -10
    done
fi

echo
echo "--- 8. SYSTEM PREFERENCE DEEP DIVE ---"
echo "🎯 Checking for hidden language preferences..."

echo "🔍 Global language order:"
defaults read -g AppleLanguages 2>/dev/null

echo "🔍 Preferred languages (full list):"
defaults read -g NSPreferredLanguages 2>/dev/null

echo "🔍 International preferences:"
defaults read com.apple.internationalsettings 2>/dev/null | head -20

echo
echo "--- 9. FONT AND TEXT RENDERING ---"
echo "🎯 Checking if German fonts are being prioritized..."

echo "🔍 Font language preferences:"
defaults read com.apple.ATS 2>/dev/null | grep -i -A3 -B3 "language\|locale\|german"

echo
echo "--- 10. REAL-TIME PROCESS ANALYSIS ---"
echo "🎯 Checking running processes that might influence language..."

echo "🔍 Language-related processes:"
ps aux | grep -i -E "(language|locale|intl|l10n)" | grep -v grep

echo "🔍 Browser processes and their language settings:"
ps aux | grep -E "(chrome|firefox|safari)" | grep -v grep

echo
echo "=== TARGETED SOLUTION MATRIX ==="
echo

echo "🎯 PRIORITY FIXES (based on your specific findings):"
echo

echo "1. BROWSER EXTENSION CLEANUP:"
echo "   # Remove problematic AdBlock extension"
echo "   rm -rf '$HOME/Library/Application Support/Google/Chrome/Default/Extensions/gighmmpiobklfepjocnamgkkbiglidom'"
echo

echo "2. CHROME LANGUAGE RESET:"
echo "   # Reset Chrome language preferences"
echo "   defaults delete com.google.Chrome AppleLanguages"
echo "   # Edit Chrome preferences file to remove German language codes"
echo "   # Location: ~/Library/Application Support/Google/Chrome/Default/Preferences"
echo "   # Look for 'intl.accept_languages' and remove any 'de' entries"
echo

echo "3. KEYBOARD LAYOUT FIX:"
echo "   # Set keyboard to US English specifically"
echo "   defaults write com.apple.HIToolbox AppleEnabledInputSources -array '<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>0</integer><key>KeyboardLayout Name</key><string>U.S.</string></dict>'"
echo

echo "4. VPN LANGUAGE ROUTING CHECK:"
echo "   # Check if your VPN is routing through German servers"
echo "   curl -s 'https://ipapi.co/json/' | jq '.country_code, .city, .region'"
echo "   # If showing German location, change VPN server"
echo

echo "5. FIREFOX CLEANUP:"
echo "   # Reset Firefox language preferences"
echo "   find '$HOME/Library/Application Support/Firefox/Profiles' -name 'prefs.js' -exec sed -i '' '/intl.*de/d' {} +"
echo

echo "6. SYSTEM LANGUAGE ASSET RESET:"
echo "   # Reset language asset daemon"
echo "   sudo launchctl unload /System/Library/LaunchAgents/com.apple.languageassetd.plist"
echo "   sudo launchctl load /System/Library/LaunchAgents/com.apple.languageassetd.plist"
echo

echo "=== VERIFICATION PROTOCOL ==="
echo

echo "After applying fixes, verify with:"
echo "1. curl -s 'https://ipapi.co/json/' | jq '.country_name'"
echo "2. defaults read -g AppleLanguages"
echo "3. Open Chrome → Settings → Languages"
echo "4. Test German content in browsers"
echo "5. Check System Preferences → Language & Region"
echo

echo "🚨 REBOOT REQUIRED after applying all fixes!"
echo "🔍 If issue persists, run this script again to see changes"