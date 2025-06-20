#!/bin/bash

# REFERENCE-BASED FILE ORGANIZATION
# "I am not where I am stored, I am where I am referenced"
# Mathematical approach using symlinks and reference mapping

set -e

PHI="1.618033988749895"
REFERENCE_BASE="/Users/abhissrivasta/.file-references"
STORAGE_BASE="/Users/abhissrivasta/.file-storage"

echo "🌊 Reference-Based Organization System"
echo "φ = $PHI (Golden Ratio for reference weighting)"

# Create reference mapping system
mkdir -p "$REFERENCE_BASE"
mkdir -p "$STORAGE_BASE"/{scripts,documents,configs,data}

# Function to calculate reference weight using phi
calculate_reference_weight() {
    local file="$1"
    local references=$(find /Users/abhissrivasta -type l -exec readlink {} \; 2>/dev/null | grep -c "$file" || echo 0)
    local usage_count=$(grep -r "$(basename "$file")" /Users/abhissrivasta --include="*.sh" --include="*.py" --include="*.js" 2>/dev/null | wc -l || echo 0)
    
    # Phi-weighted reference score
    local weight=$(echo "scale=6; ($references * $PHI) + ($usage_count * 0.618)" | bc -l)
    echo "$weight"
}

# Function to organize by reference rather than type
organize_by_reference() {
    local file="$1"
    local weight=$(calculate_reference_weight "$file")
    local filename=$(basename "$file")
    
    echo "📊 $filename: Reference weight = $weight"
    
    # Determine primary reference location based on weight
    if (( $(echo "$weight > 2.618" | bc -l) )); then
        # High reference - create in projects where referenced
        echo "   → High reference: Creating symbolic presence in all referencing locations"
        create_reference_network "$file"
    elif (( $(echo "$weight > 1.618" | bc -l) )); then
        # Medium reference - primary + secondary locations
        echo "   → Medium reference: Primary + secondary locations"
        create_primary_secondary "$file"
    else
        # Low reference - single storage location
        echo "   → Low reference: Single storage location with reference index"
        create_indexed_storage "$file"
    fi
}

# Create reference network for highly referenced files
create_reference_network() {
    local file="$1"
    local filename=$(basename "$file")
    local storage_path="$STORAGE_BASE/$(get_file_category "$file")/$filename"
    
    # Move to storage
    mv "$file" "$storage_path" 2>/dev/null || cp "$file" "$storage_path"
    
    # Create references in all locations that reference this file
    while read -r referencing_file; do
        if [[ -n "$referencing_file" ]]; then
            local ref_dir=$(dirname "$referencing_file")
            ln -sf "$storage_path" "$ref_dir/$filename" 2>/dev/null || true
            echo "     → Reference created: $ref_dir/$filename"
        fi
    done < <(grep -r "$(basename "$file")" /Users/abhissrivasta --include="*.sh" --include="*.py" -l 2>/dev/null)
}

# Create primary and secondary locations
create_primary_secondary() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Find primary reference location (most frequent)
    local primary_dir=$(grep -r "$(basename "$file")" /Users/abhissrivasta --include="*.sh" --include="*.py" -l 2>/dev/null | head -1 | xargs dirname)
    
    if [[ -n "$primary_dir" ]]; then
        echo "     → Primary location: $primary_dir"
        mv "$file" "$primary_dir/$filename" 2>/dev/null || true
        
        # Create reference in storage for backup
        ln -sf "$primary_dir/$filename" "$STORAGE_BASE/$(get_file_category "$file")/$filename" 2>/dev/null || true
    fi
}

# Create indexed storage with reference mapping
create_indexed_storage() {
    local file="$1"
    local filename=$(basename "$file")
    local category=$(get_file_category "$file")
    local storage_path="$STORAGE_BASE/$category/$filename"
    
    # Move to categorized storage
    mv "$file" "$storage_path" 2>/dev/null || cp "$file" "$storage_path"
    
    # Create reference index entry
    echo "$storage_path|$file|$(date)|$(calculate_reference_weight "$file")" >> "$REFERENCE_BASE/reference-index.txt"
    echo "     → Indexed: $storage_path"
}

# Determine file category based on content and usage
get_file_category() {
    local file="$1"
    local filename=$(basename "$file")
    
    case "$filename" in
        *.sh|*.py|*.js|*.go) echo "scripts" ;;
        *.md|*.txt|*.doc*) echo "documents" ;;
        *.json|*.yaml|*.yml|.*rc|*.conf) echo "configs" ;;
        *.csv|*.db|*.sql) echo "data" ;;
        *) echo "misc" ;;
    esac
}

# Main organization function
main() {
    echo "🔍 Scanning for files to organize by reference..."
    
    # Find files that could benefit from reference-based organization
    find /Users/abhissrivasta -name "*.sh" -o -name "*.py" -o -name "*.js" -o -name "*.json" -o -name "*.yaml" | \
    while read -r file; do
        if [[ -f "$file" ]]; then
            organize_by_reference "$file"
        fi
    done
    
    echo ""
    echo "✨ Reference-based organization complete!"
    echo "📖 Reference index: $REFERENCE_BASE/reference-index.txt"
    echo "🗂️  Storage structure: $STORAGE_BASE/"
    echo ""
    echo "Philosophy applied: Files exist where they are referenced, not where they are stored"
    echo "φ-weighted organization ensures optimal access patterns"
}

# Dry run option
if [[ "$1" == "true" ]]; then
    echo "🧪 DRY RUN MODE - No files will be moved"
    echo "This would organize files by reference weight using φ = $PHI"
    echo "Reference mapping system would be created at: $REFERENCE_BASE"
    echo "Storage optimization would use: $STORAGE_BASE"
else
    main
fi