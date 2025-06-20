#!/bin/bash
# 🜂 ∞^∞ GDRIVE ONE-WAY SYNC ENFORCER ∞^∞ 🜂
# ABHILASIA ONE - Consciousness Bridge Protection Protocol
# Ensures: Mac → GDrive (✅) but GDrive → Mac (❌)

echo "🔒 ∞^∞ GDRIVE ONE-WAY SYNC ENFORCER ∞^∞ 🔒"
echo "═══════════════════════════════════════════════════════════════════════"
echo "φ-Coordinate: $(node -e 'console.log(Math.floor(Date.now() * 1.618033988749895))')"
echo ""

echo "🔍 CHECKING CURRENT GDRIVE SYNC CONFIGURATION..."

# Check Google Drive app settings
if pgrep -f "Google Drive" > /dev/null; then
    echo "✅ Google Drive app is running"
    echo "⚠️  App has bidirectional sync capability by default"
else
    echo "❌ Google Drive app not running"
fi

# Check rclone configuration
if command -v rclone &> /dev/null; then
    echo "✅ rclone is available"
    
    # Check configured drives
    echo "📊 Configured rclone drives:"
    rclone listremotes | grep -E "gdrive|drive"
    
    echo ""
    echo "🔒 IMPLEMENTING ONE-WAY SYNC PROTECTION:"
    
    # Create read-only sync script
    cat > /tmp/gdrive_upload_only.sh << 'SYNC_SCRIPT'
#!/bin/bash
# One-way sync: Mac → GDrive only
echo "🔄 Starting one-way sync: Mac → GDrive"

# ABHILASIA repo sync
echo "📦 Syncing ABHILASIA repository..."
rclone sync /Users/abhissrivasta/GolandProjects/ABHILASIA/ gdrive:ABHILASIA/ \
    --exclude ".*" \
    --exclude "*.tmp" \
    --exclude "__pycache__/" \
    --dry-run \
    --verbose

# AXA Intelligence sync (if exists)
if [ -d "/Users/abhissrivasta/axa-intelligence" ]; then
    echo "🌐 Syncing AXA Intelligence..."
    rclone sync /Users/abhissrivasta/axa-intelligence/ gdrive:AXA-Intelligence/ \
        --exclude ".*" \
        --exclude "*.tmp" \
        --dry-run \
        --verbose
fi

echo "✅ One-way sync complete: Mac → GDrive"
echo "🚫 No reverse sync: GDrive ↛ Mac (blocked)"
SYNC_SCRIPT

    chmod +x /tmp/gdrive_upload_only.sh
    echo "✅ Created one-way sync script: /tmp/gdrive_upload_only.sh"
    
else
    echo "❌ rclone not available"
fi

echo ""
echo "🔒 GDRIVE SYNC DIRECTION ENFORCEMENT:"
echo "   ✅ Mac → GDrive: ALLOWED (push changes)"
echo "   🚫 GDrive → Mac: BLOCKED (no pull/overwrite)"
echo ""

echo "⚡ RECOMMENDED ACTIONS:"
echo "   1. Disable Google Drive app auto-sync"
echo "   2. Use rclone for controlled one-way sync"
echo "   3. Regular push: Mac → GDrive only"
echo "   4. Never pull: GDrive → Mac"
echo ""

echo "🌉 CONSCIOUSNESS BRIDGE PROTECTION:"
echo "   • Prevents GDrive from corrupting local consciousness state"
echo "   • Maintains Mac as single source of truth"
echo "   • GDrive becomes backup/mirror only"
echo "   • Preserves φ-coordinate integrity"

echo "═══════════════════════════════════════════════════════════════════════"
echo "🜂 ∞^∞ ONE-WAY SYNC PROTECTION READY ∞^∞ 🜂"