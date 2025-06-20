#!/bin/bash

# Google Drive File Reference Fixer
# "I am not where I'm stored. I am where I'm referenced"
# This script analyzes and fixes file extensions and references based on content and relationships

# Color definitions
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Print banner
echo -e "${PURPLE}"
echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓"
echo "┃              GOOGLE DRIVE FILE REFERENCE FIXER                      ┃"
echo "┃         'I am not where I'm stored. I am where I'm referenced'       ┃"
echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛"
echo -e "${NC}"

# Configuration
GDRIVE_REMOTE="gdrive:"
TEMP_DIR="./gdrive_analysis_temp"
ANALYSIS_FILE="file_analysis.json"
REFERENCE_MAP="reference_map.json"
CHANGES_LOG="proposed_changes.txt"

# Print functions
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${CYAN}📊 $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo -e "${BLUE}🔍 $1${NC}"
}

# Initialize analysis
initialize_analysis() {
    print_step "Initializing Google Drive analysis..."
    
    # Clean and create temp directory
    rm -rf "$TEMP_DIR"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Initialize analysis files
    echo "[]" > "$ANALYSIS_FILE"
    echo "{}" > "$REFERENCE_MAP"
    echo "# Google Drive File Reference Analysis Report" > "$CHANGES_LOG"
    echo "Generated: $(date)" >> "$CHANGES_LOG"
    echo "" >> "$CHANGES_LOG"
    
    print_success "Analysis environment initialized"
}

# Get file list from Google Drive
get_gdrive_files() {
    print_step "Scanning Google Drive files..."
    
    # Get all files with details
    rclone lsjson "$GDRIVE_REMOTE" --recursive > raw_files.json
    
    if [ $? -eq 0 ]; then
        local file_count=$(cat raw_files.json | jq length)
        print_success "Found $file_count files in Google Drive"
        return 0
    else
        print_error "Failed to access Google Drive"
        return 1
    fi
}

# Analyze file content type
analyze_file_content() {
    local file_path="$1"
    local file_name="$2"
    
    # Download file for analysis (first 1000 bytes)
    rclone cat "$GDRIVE_REMOTE/$file_path" --count 1000 > "sample_$file_name" 2>/dev/null
    
    if [ ! -f "sample_$file_name" ]; then
        echo "unknown"
        return
    fi
    
    local content=$(cat "sample_$file_name")
    local detected_type="unknown"
    
    # Content type detection patterns
    if [[ $content =~ \<\!DOCTYPE[[:space:]]+html\> ]] || [[ $content =~ \<html\> ]]; then
        detected_type="html"
    elif [[ $content =~ import.*React ]] || [[ $content =~ from[[:space:]]+[\'\"]\react[\'\"] ]]; then
        detected_type="react"
    elif [[ $content =~ import.*\{.*\}.*from ]] || [[ $content =~ export.*default ]]; then
        detected_type="javascript"
    elif [[ $content =~ \<\?xml ]] || [[ $content =~ \<[a-zA-Z]+.*\> ]]; then
        detected_type="xml"
    elif [[ $content =~ \{[[:space:]]*[\"\'].*[\"\'][[:space:]]*: ]] || [[ $content =~ ^\[.*\]$ ]]; then
        detected_type="json"
    elif [[ $content =~ ^\#\! ]] || [[ $content =~ function.*\( ]]; then
        detected_type="script"
    elif [[ $content =~ \<style\> ]] || [[ $content =~ .*\{.*\:.*\; ]]; then
        detected_type="css"
    elif [[ $content =~ class.*extends.*Component ]] || [[ $content =~ useState\( ]]; then
        detected_type="react"
    fi
    
    # Clean up sample file
    rm -f "sample_$file_name"
    
    echo "$detected_type"
}

# Extract imports and references
extract_references() {
    local file_path="$1"
    local file_name="$2"
    
    # Download full file for reference analysis
    rclone cat "$GDRIVE_REMOTE/$file_path" > "full_$file_name" 2>/dev/null
    
    if [ ! -f "full_$file_name" ]; then
        echo "[]"
        return
    fi
    
    local references=()
    
    # Extract import statements
    while IFS= read -r line; do
        if [[ $line =~ import.*from[[:space:]]*[\'\"]([^\'\"]+)[\'\"] ]]; then
            references+=("${BASH_REMATCH[1]}")
        elif [[ $line =~ require\([[:space:]]*[\'\"]([^\'\"]+)[\'\"] ]]; then
            references+=("${BASH_REMATCH[1]}")
        elif [[ $line =~ \<script[[:space:]]+src=[[:space:]]*[\'\"]([^\'\"]+)[\'\"] ]]; then
            references+=("${BASH_REMATCH[1]}")
        elif [[ $line =~ \<link[[:space:]]+href=[[:space:]]*[\'\"]([^\'\"]+)[\'\"] ]]; then
            references+=("${BASH_REMATCH[1]}")
        fi
    done < "full_$file_name"
    
    # Clean up full file
    rm -f "full_$file_name"
    
    # Convert to JSON array
    printf '%s\n' "${references[@]}" | jq -R . | jq -s .
}

# Determine correct file extension
determine_correct_extension() {
    local detected_type="$1"
    local current_extension="$2"
    local has_react_imports="$3"
    
    case "$detected_type" in
        "html")
            echo "html"
            ;;
        "react")
            if [[ $has_react_imports == "true" ]]; then
                echo "jsx"
            else
                echo "js"
            fi
            ;;
        "javascript")
            echo "js"
            ;;
        "json")
            echo "json"
            ;;
        "css")
            echo "css"
            ;;
        "xml")
            echo "xml"
            ;;
        "script")
            echo "sh"
            ;;
        *)
            echo "$current_extension"
            ;;
    esac
}

# Analyze all files
analyze_all_files() {
    print_step "Analyzing file content and references..."
    
    local analysis_data="[]"
    local total_files=$(cat raw_files.json | jq length)
    local current_file=0
    
    while IFS= read -r file_info; do
        current_file=$((current_file + 1))
        
        local file_path=$(echo "$file_info" | jq -r '.Path')
        local file_name=$(echo "$file_info" | jq -r '.Name')
        local file_size=$(echo "$file_info" | jq -r '.Size')
        local is_dir=$(echo "$file_info" | jq -r '.IsDir')
        
        # Skip directories and very large files
        if [[ $is_dir == "true" ]] || [[ $file_size -gt 1048576 ]]; then
            continue
        fi
        
        echo -ne "\r${CYAN}📊 Analyzing file $current_file/$total_files: $file_name${NC}"
        
        # Get current extension
        local current_ext="${file_name##*.}"
        if [[ $current_ext == $file_name ]]; then
            current_ext=""
        fi
        
        # Analyze content
        local detected_type=$(analyze_file_content "$file_path" "$file_name")
        local references=$(extract_references "$file_path" "$file_name")
        
        # Check for React imports
        local has_react_imports="false"
        if echo "$references" | jq -r '.[]' | grep -q "react"; then
            has_react_imports="true"
        fi
        
        # Determine correct extension
        local correct_ext=$(determine_correct_extension "$detected_type" "$current_ext" "$has_react_imports")
        
        # Build file analysis object
        local file_analysis=$(jq -n \
            --arg path "$file_path" \
            --arg name "$file_name" \
            --arg current_ext "$current_ext" \
            --arg detected_type "$detected_type" \
            --arg correct_ext "$correct_ext" \
            --argjson references "$references" \
            --arg has_react_imports "$has_react_imports" \
            --arg size "$file_size" \
            '{
                path: $path,
                name: $name,
                current_extension: $current_ext,
                detected_type: $detected_type,
                correct_extension: $correct_ext,
                references: $references,
                has_react_imports: ($has_react_imports == "true"),
                size: ($size | tonumber),
                needs_rename: ($current_ext != $correct_ext and $correct_ext != ""),
                analysis_timestamp: now
            }')
        
        # Add to analysis data
        analysis_data=$(echo "$analysis_data" | jq ". + [$file_analysis]")
        
    done < <(cat raw_files.json | jq -c '.[]')
    
    echo "" # New line after progress
    
    # Save analysis
    echo "$analysis_data" > "$ANALYSIS_FILE"
    
    local total_analyzed=$(echo "$analysis_data" | jq length)
    print_success "Analyzed $total_analyzed files"
}

# Build reference map
build_reference_map() {
    print_step "Building file reference map..."
    
    local reference_map="{}"
    
    while IFS= read -r file_data; do
        local file_path=$(echo "$file_data" | jq -r '.path')
        local references=$(echo "$file_data" | jq -r '.references[]?' 2>/dev/null || echo "")
        
        if [[ -n $references ]]; then
            reference_map=$(echo "$reference_map" | jq --arg path "$file_path" --argjson refs "$(echo "$file_data" | jq '.references')" '. + {($path): $refs}')
        fi
        
    done < <(cat "$ANALYSIS_FILE" | jq -c '.[]')
    
    echo "$reference_map" > "$REFERENCE_MAP"
    
    local files_with_refs=$(echo "$reference_map" | jq 'keys | length')
    print_success "Built reference map for $files_with_refs files"
}

# Generate change recommendations
generate_change_recommendations() {
    print_step "Generating change recommendations..."
    
    echo "" >> "$CHANGES_LOG"
    echo "## FILES NEEDING EXTENSION FIXES" >> "$CHANGES_LOG"
    echo "=================================" >> "$CHANGES_LOG"
    
    local rename_count=0
    local total_files=$(cat "$ANALYSIS_FILE" | jq length)
    
    while IFS= read -r file_data; do
        local needs_rename=$(echo "$file_data" | jq -r '.needs_rename')
        
        if [[ $needs_rename == "true" ]]; then
            local file_path=$(echo "$file_data" | jq -r '.path')
            local current_name=$(echo "$file_data" | jq -r '.name')
            local detected_type=$(echo "$file_data" | jq -r '.detected_type')
            local current_ext=$(echo "$file_data" | jq -r '.current_extension')
            local correct_ext=$(echo "$file_data" | jq -r '.correct_extension')
            
            # Generate new name
            local base_name="${current_name%.*}"
            if [[ $current_ext == "" ]]; then
                base_name="$current_name"
            fi
            local new_name="$base_name.$correct_ext"
            
            echo "" >> "$CHANGES_LOG"
            echo "File: $file_path" >> "$CHANGES_LOG"
            echo "  Current: $current_name" >> "$CHANGES_LOG"
            echo "  Proposed: $new_name" >> "$CHANGES_LOG"
            echo "  Detected Type: $detected_type" >> "$CHANGES_LOG"
            echo "  Extension: $current_ext → $correct_ext" >> "$CHANGES_LOG"
            
            rename_count=$((rename_count + 1))
        fi
        
    done < <(cat "$ANALYSIS_FILE" | jq -c '.[]')
    
    echo "" >> "$CHANGES_LOG"
    echo "## REFERENCE ANALYSIS" >> "$CHANGES_LOG"
    echo "====================" >> "$CHANGES_LOG"
    
    local broken_refs=0
    
    while IFS= read -r entry; do
        local file_path=$(echo "$entry" | jq -r 'keys[0]')
        local references=$(echo "$entry" | jq -r '.[keys[0]][]?' 2>/dev/null)
        
        if [[ -n $references ]]; then
            echo "" >> "$CHANGES_LOG"
            echo "File: $file_path" >> "$CHANGES_LOG"
            echo "  References:" >> "$CHANGES_LOG"
            
            while IFS= read -r ref; do
                if [[ -n $ref ]]; then
                    echo "    - $ref" >> "$CHANGES_LOG"
                    
                    # Check if reference exists in analyzed files
                    local ref_exists=$(cat "$ANALYSIS_FILE" | jq --arg ref "$ref" '.[] | select(.path | contains($ref)) | .path' | wc -l)
                    if [[ $ref_exists -eq 0 ]]; then
                        echo "      ⚠️  BROKEN REFERENCE" >> "$CHANGES_LOG"
                        broken_refs=$((broken_refs + 1))
                    fi
                fi
            done < <(echo "$entry" | jq -r '.[keys[0]][]?' 2>/dev/null)
        fi
        
    done < <(echo "{}" | jq --slurpfile refs "$REFERENCE_MAP" '$refs | to_entries[] | {(.key): .value}')
    
    echo "" >> "$CHANGES_LOG"
    echo "## SUMMARY" >> "$CHANGES_LOG"
    echo "==========" >> "$CHANGES_LOG"
    echo "Total files analyzed: $total_files" >> "$CHANGES_LOG"
    echo "Files needing rename: $rename_count" >> "$CHANGES_LOG"
    echo "Broken references found: $broken_refs" >> "$CHANGES_LOG"
    echo "" >> "$CHANGES_LOG"
    
    print_success "Generated change recommendations"
    print_info "Files needing rename: $rename_count"
    print_warning "Broken references: $broken_refs"
}

# Display summary
display_summary() {
    echo ""
    echo -e "${PURPLE}📊 ANALYSIS COMPLETE${NC}"
    echo -e "${BLUE}=================================${NC}"
    
    local total_files=$(cat "$ANALYSIS_FILE" | jq length)
    local needs_rename=$(cat "$ANALYSIS_FILE" | jq '[.[] | select(.needs_rename == true)] | length')
    local react_files=$(cat "$ANALYSIS_FILE" | jq '[.[] | select(.detected_type == "react")] | length')
    local html_files=$(cat "$ANALYSIS_FILE" | jq '[.[] | select(.detected_type == "html")] | length')
    local js_files=$(cat "$ANALYSIS_FILE" | jq '[.[] | select(.detected_type == "javascript")] | length')
    
    echo -e "${CYAN}📁 Total files analyzed: $total_files${NC}"
    echo -e "${YELLOW}🔄 Files needing rename: $needs_rename${NC}"
    echo -e "${GREEN}⚛️  React components: $react_files${NC}"
    echo -e "${GREEN}🌐 HTML files: $html_files${NC}"
    echo -e "${GREEN}📜 JavaScript files: $js_files${NC}"
    
    echo ""
    echo -e "${BLUE}📋 Analysis files created:${NC}"
    echo -e "   • $ANALYSIS_FILE - Complete file analysis"
    echo -e "   • $REFERENCE_MAP - File reference mapping"
    echo -e "   • $CHANGES_LOG - Proposed changes report"
    
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo -e "   1. Review $CHANGES_LOG for proposed changes"
    echo -e "   2. Run script with --apply flag to execute changes"
    echo -e "   3. Verify all references work after changes"
}

# Apply changes function (placeholder)
apply_changes() {
    print_warning "Change application not implemented yet - analysis only mode"
    print_info "Review the analysis first, then we can implement the changes"
}

# Main execution
main() {
    # Check for rclone
    if ! command -v rclone &> /dev/null; then
        print_error "rclone is required but not installed"
        exit 1
    fi
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        print_error "jq is required but not installed"
        exit 1
    fi
    
    # Check arguments
    if [[ "$1" == "--apply" ]]; then
        print_warning "Apply mode requested"
        read -p "This will make changes to your Google Drive. Continue? (y/N): " confirm
        if [[ $confirm != "y" && $confirm != "Y" ]]; then
            print_info "Cancelled by user"
            exit 0
        fi
    fi
    
    # Execute analysis pipeline
    initialize_analysis || exit 1
    get_gdrive_files || exit 1
    analyze_all_files || exit 1
    build_reference_map || exit 1
    generate_change_recommendations || exit 1
    
    if [[ "$1" == "--apply" ]]; then
        apply_changes
    else
        display_summary
    fi
    
    print_success "Google Drive file reference analysis complete!"
}

# Run main function
main "$@"