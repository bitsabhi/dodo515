#!/bin/bash
# Auto-update session view script

SESSION_JSON="/Users/abhissrivasta/session_meta_database.json"
LIVE_VIEW="/Users/abhissrivasta/session-live-view.html"

# Function to update live view with current session data
update_live_view() {
    # This should be called after each significant interaction
    # to update the HTML with latest session data
    
    # Get current event count
    EVENT_COUNT=$(jq '.session_metadata.total_events // 0' "$SESSION_JSON")
    
    # Update HTML timestamp and event count
    sed -i '' "s/45 events/${EVENT_COUNT} events/" "$LIVE_VIEW"
    
    # Reopen if major update
    if [ "$1" = "major" ]; then
        open "$LIVE_VIEW"
    fi
}

# Call update function
update_live_view "$1"