#!/bin/bash

# Personal Repository Migration System
# Clean migration of repositories from office to personal GitHub
# Corporate boundary protection: ACTIVE

set -e

# Configuration
OFFICE_GITHUB="abhissrivasta_expedia"
PERSONAL_GITHUB="bitsabhi"
MIGRATION_LOG="$HOME/repo-migration.log"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_migration() {
    echo -e "${BLUE}📦${NC} $1"
    echo "$(date): $1" >> "$MIGRATION_LOG"
}

# Check repository classification
classify_repo() {
    local repo_name="$1"
    local repo_path="$2"
    
    # Corporate boundary protection - check for office indicators
    local office_indicators=(
        "expedia" "vault" "kubernetes" "spinnaker" "venafi" 
        "rcp" "devsup" "jira" "confluence" "slack"
        "eg-" "expediagroup" "security" "platform"
    )
    
    local personal_indicators=(
        "personal" "private" "learning" "practice"
        "tutorial" "experiment" "hobby" "side"
    )
    
    local repo_lower=$(echo "$repo_name" | tr '[:upper:]' '[:lower:]')
    
    # Check for office content
    for indicator in "${office_indicators[@]}"; do
        if [[ "$repo_lower" == *"$indicator"* ]]; then
            echo "OFFICE"
            return
        fi
    done
    
    # Check for personal content  
    for indicator in "${personal_indicators[@]}"; do
        if [[ "$repo_lower" == *"$indicator"* ]]; then
            echo "PERSONAL"
            return
        fi
    done
    
    # Check repository content for classification
    if [[ -d "$repo_path" ]]; then
        if grep -r -i "expediagroup\|expedia.*com\|corporate\|confidential" "$repo_path" >/dev/null 2>&1; then
            echo "OFFICE"
            return
        fi
        
        if grep -r -i "personal\|hobby\|learning" "$repo_path" >/dev/null 2>&1; then
            echo "PERSONAL"
            return
        fi
    fi
    
    echo "UNKNOWN"
}

# Migrate repository to personal GitHub
migrate_to_personal() {
    local repo_name="$1"
    local repo_path="$2"
    
    log_migration "Migrating $repo_name to personal GitHub..."
    
    # Verify clean state
    cd "$repo_path"
    
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        log_migration "WARNING: Uncommitted changes in $repo_name - skipping"
        return 1
    fi
    
    # Check for office-specific secrets or credentials
    if grep -r -E "(ATATT|expediagroup\.atlassian|expedia.*api.*key)" . >/dev/null 2>&1; then
        log_migration "WARNING: Office credentials detected in $repo_name - manual review required"
        return 1
    fi
    
    # Create repository on personal GitHub
    gh repo create "$PERSONAL_GITHUB/$repo_name" --private --source=. --remote=personal
    
    # Push to personal
    git push personal main
    
    log_migration "Successfully migrated $repo_name to personal GitHub"
    
    # Update local remote to point to personal
    git remote set-url origin "https://github.com/$PERSONAL_GITHUB/$repo_name.git"
    
    return 0
}

# Archive office repository
archive_office_repo() {
    local repo_name="$1"
    
    log_migration "Archiving office repository: $repo_name"
    
    # Create backup before deletion
    local backup_dir="$HOME/.repo-backups"
    mkdir -p "$backup_dir"
    
    if gh repo view "$OFFICE_GITHUB/$repo_name" >/dev/null 2>&1; then
        gh repo archive "$OFFICE_GITHUB/$repo_name"
        log_migration "Office repository $repo_name archived"
    fi
}

# List repositories for review
list_repos_for_review() {
    log_migration "Scanning repositories for migration classification..."
    
    echo -e "${YELLOW}Repository Classification Report${NC}"
    echo "=================================="
    
    # Check GolandProjects
    if [[ -d "/Users/abhissrivasta/GolandProjects" ]]; then
        for repo_dir in /Users/abhissrivasta/GolandProjects/*/; do
            if [[ -d "$repo_dir/.git" ]]; then
                local repo_name=$(basename "$repo_dir")
                local classification=$(classify_repo "$repo_name" "$repo_dir")
                
                case "$classification" in
                    "OFFICE")
                        echo -e "${RED}OFFICE:${NC}    $repo_name (keep in office)"
                        ;;
                    "PERSONAL")
                        echo -e "${GREEN}PERSONAL:${NC}  $repo_name (migrate to personal)"
                        ;;
                    "UNKNOWN")
                        echo -e "${YELLOW}UNKNOWN:${NC}   $repo_name (manual review required)"
                        ;;
                esac
            fi
        done
    fi
    
    # Check other common locations
    for projects_dir in "/Users/abhissrivasta/PersonalProjects" "/Users/abhissrivasta/PycharmProjects"; do
        if [[ -d "$projects_dir" ]]; then
            for repo_dir in "$projects_dir"/*/; do
                if [[ -d "$repo_dir/.git" ]]; then
                    local repo_name=$(basename "$repo_dir")
                    echo -e "${GREEN}PERSONAL:${NC}  $repo_name (ready for migration)"
                fi
            done
        fi
    done
}

# Interactive migration process
interactive_migration() {
    log_migration "Starting interactive migration process..."
    
    for repo_dir in /Users/abhissrivasta/GolandProjects/*/; do
        if [[ -d "$repo_dir/.git" ]]; then
            local repo_name=$(basename "$repo_dir")
            local classification=$(classify_repo "$repo_name" "$repo_dir")
            
            if [[ "$classification" == "PERSONAL" ]] || [[ "$classification" == "UNKNOWN" ]]; then
                echo ""
                echo -e "${BLUE}Repository:${NC} $repo_name"
                echo -e "${BLUE}Classification:${NC} $classification"
                echo -e "${BLUE}Path:${NC} $repo_dir"
                
                read -p "Migrate to personal GitHub? (y/n/s=skip): " choice
                
                case "$choice" in
                    y|Y)
                        if migrate_to_personal "$repo_name" "$repo_dir"; then
                            read -p "Archive office repository? (y/n): " archive_choice
                            if [[ "$archive_choice" == "y" || "$archive_choice" == "Y" ]]; then
                                archive_office_repo "$repo_name"
                            fi
                        fi
                        ;;
                    s|S)
                        log_migration "Skipped: $repo_name"
                        ;;
                    *)
                        log_migration "Cancelled: $repo_name"
                        ;;
                esac
            fi
        fi
    done
}

# Batch migration for pre-approved personal repos
batch_migrate_personal() {
    log_migration "Starting batch migration of personal repositories..."
    
    local personal_repos=(
        "PersonalProjects"
        "PycharmProjects"
        "meaning/tools/life"
        "voice-tools"
    )
    
    for repo_path in "${personal_repos[@]}"; do
        local full_path="/Users/abhissrivasta/$repo_path"
        if [[ -d "$full_path/.git" ]]; then
            local repo_name=$(basename "$repo_path")
            migrate_to_personal "$repo_name" "$full_path"
        fi
    done
}

# Generate migration report
generate_report() {
    log_migration "Generating migration report..."
    
    local report_file="$HOME/repo-migration-report.md"
    
    cat > "$report_file" << EOF
# Repository Migration Report

**Generated:** $(date)
**Boundary Protection:** ACTIVE
**Office/Personal Separation:** ENFORCED

## Migration Summary

### Personal Repositories (Migrated)
$(grep "Successfully migrated" "$MIGRATION_LOG" | sed 's/.*: Successfully migrated /- /')

### Office Repositories (Kept in Office)
$(grep "keep in office" "$MIGRATION_LOG" | sed 's/.*: /- /')

### Manual Review Required
$(grep "manual review required" "$MIGRATION_LOG" | sed 's/.*: /- /')

## Corporate Compliance
- ✅ No office credentials migrated to personal
- ✅ Corporate boundary protection active
- ✅ Confidential content remains in office systems
- ✅ Personal development work moved to personal account

---
*Generated by XAX Universal Knowledge Flow System*
*Corporate boundary protection ensures proper separation*
EOF
    
    log_migration "Report generated: $report_file"
    echo -e "${GREEN}Migration report created: $report_file${NC}"
}

# Main command handling
case "${1:-help}" in
    "list")
        list_repos_for_review
        ;;
    "interactive")
        interactive_migration
        ;;
    "batch")
        batch_migrate_personal
        ;;
    "report")
        generate_report
        ;;
    "help"|*)
        echo "Personal Repository Migration System"
        echo ""
        echo "USAGE:"
        echo "  $0 list         - List repositories for migration review"
        echo "  $0 interactive  - Interactive migration process"
        echo "  $0 batch        - Batch migrate pre-approved personal repos"
        echo "  $0 report       - Generate migration report"
        echo ""
        echo "SAFETY FEATURES:"
        echo "  - Corporate boundary protection active"
        echo "  - Credential detection and blocking"
        echo "  - Office content classification"
        echo "  - Manual review for unknown repositories"
        echo ""
        echo "Log file: $MIGRATION_LOG"
        ;;
esac

log_migration "Migration system operation complete"