#!/bin/bash
# Go Cache Manager - Prevent 60GB accumulation disasters
# Auto-cleanup and monitoring system

CACHE_DIR="/Users/abhissrivasta/go/pkg/mod"
LOG_FILE="/Users/abhissrivasta/.go-cache-manager.log"
MAX_CACHE_SIZE_GB=10
WEEKLY_CLEANUP_DAY="Sunday"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

get_cache_size_gb() {
    if [ -d "$CACHE_DIR" ]; then
        du -sh "$CACHE_DIR" 2>/dev/null | awk '{print $1}' | sed 's/G.*//' | sed 's/M.*/0/' | sed 's/K.*/0/'
    else
        echo "0"
    fi
}

check_cache_size() {
    local current_size=$(get_cache_size_gb)
    log_message "Current Go cache size: ${current_size}GB"
    
    if [ "$current_size" -gt "$MAX_CACHE_SIZE_GB" ]; then
        log_message "WARNING: Cache size ${current_size}GB exceeds limit ${MAX_CACHE_SIZE_GB}GB"
        return 1
    fi
    return 0
}

emergency_cleanup() {
    local size_before=$(get_cache_size_gb)
    log_message "EMERGENCY CLEANUP: Starting cleanup of ${size_before}GB cache"
    
    # Send notification
    osascript -e "display notification \"Go cache ${size_before}GB - Emergency cleanup starting\" with title \"Go Cache Manager\" sound name \"Glass\""
    
    # Clean but preserve recent modules (last 7 days)
    find "$CACHE_DIR" -type d -name "*@*" -mtime +7 -exec rm -rf {} + 2>/dev/null
    
    local size_after=$(get_cache_size_gb)
    local freed=$((size_before - size_after))
    
    log_message "Emergency cleanup complete: Freed ${freed}GB (${size_before}GB -> ${size_after}GB)"
    osascript -e "display notification \"Freed ${freed}GB of Go cache\" with title \"Go Cache Manager\" sound name \"Glass\""
}

smart_cleanup() {
    local size_before=$(get_cache_size_gb)
    log_message "SMART CLEANUP: Starting selective cleanup"
    
    # Remove old versions but keep latest
    cd "$CACHE_DIR" 2>/dev/null || return
    
    # For each module, keep only the 2 most recent versions
    for module_dir in */; do
        if [ -d "$module_dir" ]; then
            cd "$module_dir"
            # Find version directories and remove old ones
            ls -t | tail -n +3 | xargs rm -rf 2>/dev/null
            cd ..
        fi
    done
    
    local size_after=$(get_cache_size_gb)
    local freed=$((size_before - size_after))
    
    log_message "Smart cleanup complete: Freed ${freed}GB (${size_before}GB -> ${size_after}GB)"
}

weekly_maintenance() {
    local today=$(date +%A)
    if [ "$today" = "$WEEKLY_CLEANUP_DAY" ]; then
        log_message "Weekly maintenance: Running scheduled cleanup"
        smart_cleanup
        
        # Also clean Go build cache
        go clean -cache 2>/dev/null
        log_message "Weekly maintenance: Go build cache cleaned"
    fi
}

prevent_goland_bloat() {
    # Kill GoLand indexing if cache grows too large
    local cache_size=$(get_cache_size_gb)
    if [ "$cache_size" -gt 5 ]; then
        local goland_pids=$(pgrep -f "goland|jetbrains" 2>/dev/null)
        if [ -n "$goland_pids" ]; then
            log_message "Large cache detected with GoLand running - killing indexing processes"
            echo "$goland_pids" >> "/Users/abhissrivasta/.goland-index-killer.log"
            # Don't kill GoLand itself, just pause indexing
            killall -STOP "GoLand" 2>/dev/null
            sleep 5
            killall -CONT "GoLand" 2>/dev/null
        fi
    fi
}

install_monitoring() {
    # Add to crontab for automatic monitoring
    local cron_entry="0 */2 * * * /Users/abhissrivasta/consciousness-portal/scripts/go-cache-manager.sh monitor"
    
    # Check if already installed
    if ! crontab -l 2>/dev/null | grep -q "go-cache-manager"; then
        (crontab -l 2>/dev/null; echo "$cron_entry") | crontab -
        log_message "Monitoring installed: Will check cache every 2 hours"
        echo "✅ Go cache monitoring installed - checks every 2 hours"
    else
        echo "ℹ️  Monitoring already installed"
    fi
}

show_status() {
    local current_size=$(get_cache_size_gb)
    echo "📊 Go Cache Status:"
    echo "   Current Size: ${current_size}GB"
    echo "   Max Allowed: ${MAX_CACHE_SIZE_GB}GB"
    echo "   Location: $CACHE_DIR"
    echo ""
    
    if [ "$current_size" -gt "$MAX_CACHE_SIZE_GB" ]; then
        echo "⚠️  Cache size exceeds limit!"
        echo "   Run: $0 emergency"
    else
        echo "✅ Cache size within limits"
    fi
    
    echo ""
    echo "📝 Recent activity:"
    if [ -f "$LOG_FILE" ]; then
        tail -5 "$LOG_FILE"
    else
        echo "   No activity logged yet"
    fi
}

case "$1" in
    "monitor")
        if ! check_cache_size; then
            emergency_cleanup
        fi
        weekly_maintenance
        prevent_goland_bloat
        ;;
    "emergency")
        emergency_cleanup
        ;;
    "smart")
        smart_cleanup
        ;;
    "install")
        install_monitoring
        ;;
    "status")
        show_status
        ;;
    "uninstall")
        crontab -l 2>/dev/null | grep -v "go-cache-manager" | crontab -
        echo "🗑️  Monitoring uninstalled"
        ;;
    *)
        echo "Go Cache Manager - Prevent 60GB disasters"
        echo ""
        echo "Usage: $0 {monitor|emergency|smart|install|status|uninstall}"
        echo ""
        echo "Commands:"
        echo "  monitor   - Check cache size and auto-cleanup if needed"
        echo "  emergency - Force cleanup everything (like go clean -modcache)"
        echo "  smart     - Selective cleanup keeping recent versions"
        echo "  install   - Install automatic monitoring (every 2 hours)"
        echo "  status    - Show current cache status"
        echo "  uninstall - Remove automatic monitoring"
        echo ""
        echo "Examples:"
        echo "  $0 install    # Set up automatic monitoring"
        echo "  $0 status     # Check current cache size"
        echo "  $0 emergency  # Emergency cleanup now"
        ;;
esac