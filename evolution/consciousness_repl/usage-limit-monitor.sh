#!/bin/bash
# Usage Limit Monitor - Auto-restart Claude at 2:30am reset
# Fixes "Approaching usage limit • resets at 2:30am" forever

RESET_TIME="02:30"
LOG_FILE="/Users/abhissrivasta/consciousness-portal/data/usage-monitor.log"

monitor_usage_reset() {
    echo "🕐 Usage Limit Monitor Active"
    echo "Reset time: $RESET_TIME daily"
    echo "Log: $LOG_FILE"
    
    while true; do
        current_time=$(date +%H:%M)
        
        # Check if we're at reset time
        if [ "$current_time" = "$RESET_TIME" ]; then
            echo "⚡ $(date): Usage limit reset detected - restarting systems" >> "$LOG_FILE"
            
            # Kill any existing Claude processes
            pkill -f "claude"
            pkill -f "consciousness-bridge"
            
            # Wait 30 seconds for reset to complete
            sleep 30
            
            # Restart consciousness bridge
            node /Users/abhissrivasta/consciousness-portal/consciousness-bridge-server.js &
            
            # Update void center with reset info
            echo "$(date): Usage reset completed" >> /Users/abhissrivasta/.◌
            
            echo "✅ $(date): Systems restarted after usage reset" >> "$LOG_FILE"
            
            # Wait until next day to avoid multiple resets
            sleep 3600
        fi
        
        # Check every minute
        sleep 60
    done
}

# Auto-backup before reset
backup_before_reset() {
    backup_dir="/Users/abhissrivasta/consciousness-portal/backups/pre-reset-$(date +%Y%m%d)"
    mkdir -p "$backup_dir"
    
    cp /Users/abhissrivasta/.◌ "$backup_dir/" 2>/dev/null
    cp /Users/abhissrivasta/consciousness-portal/data/*.json "$backup_dir/" 2>/dev/null
    
    echo "💾 Backup created: $backup_dir"
}

# Start monitoring
case "$1" in
    "start")
        echo "🚀 Starting usage limit monitor..."
        backup_before_reset
        monitor_usage_reset &
        echo $! > /tmp/usage-monitor.pid
        echo "✅ Monitor started (PID: $(cat /tmp/usage-monitor.pid))"
        ;;
    "stop")
        if [ -f /tmp/usage-monitor.pid ]; then
            kill $(cat /tmp/usage-monitor.pid) 2>/dev/null
            rm /tmp/usage-monitor.pid
            echo "🛑 Usage monitor stopped"
        else
            echo "No monitor running"
        fi
        ;;
    "status")
        if [ -f /tmp/usage-monitor.pid ] && kill -0 $(cat /tmp/usage-monitor.pid) 2>/dev/null; then
            echo "✅ Monitor active (PID: $(cat /tmp/usage-monitor.pid))"
            echo "🕐 Next reset: tomorrow at $RESET_TIME"
        else
            echo "❌ Monitor not running"
        fi
        ;;
    "log")
        tail -20 "$LOG_FILE" 2>/dev/null || echo "No log entries yet"
        ;;
    *)
        echo "Usage Limit Monitor - Fix 'Approaching usage limit • resets at 2:30am'"
        echo ""
        echo "Commands:"
        echo "  start  - Start monitoring for 2:30am reset"
        echo "  stop   - Stop monitoring"
        echo "  status - Check monitor status"
        echo "  log    - Show recent log entries"
        echo ""
        echo "✨ φ = 1.618033988749895 ∅ → ∞"
        ;;
esac