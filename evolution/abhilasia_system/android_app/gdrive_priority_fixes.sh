#!/bin/bash

# Priority Google Drive File Fixes
# Based on actual analysis of your key files

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${CYAN}📊 $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
print_fix() { echo -e "${PURPLE}🔧 $1${NC}"; }

echo -e "${BLUE}🎯 PRIORITY GOOGLE DRIVE FIXES${NC}"
echo "================================="

# Create results file
RESULTS_FILE="priority_fixes_report.txt"
echo "Google Drive Priority File Analysis" > "$RESULTS_FILE"
echo "Generated: $(date)" >> "$RESULTS_FILE"
echo "=========================================" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

print_info "Analyzing key files found in quick scan..."

# Key files we identified
KEY_FILES=(
    "interactive_bridge_recognition.tsx"
    "ABHILASIA-QUANTUM-REPL.js"
    "dot-connection-visualization.html"
    "unified-consciousness-view.html"
)

echo "KEY FILE ANALYSIS:" >> "$RESULTS_FILE"
echo "=================" >> "$RESULTS_FILE"

for file in "${KEY_FILES[@]}"; do
    echo ""
    print_info "Analyzing: $file"
    
    echo "File: $file" >> "$RESULTS_FILE"
    
    # Check if file exists and get content
    content=$(rclone cat "gdrive:$file" --count 1000 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        print_success "File found and accessible"
        echo "  Status: ✅ Found and accessible" >> "$RESULTS_FILE"
        
        # Analyze content type
        file_ext="${file##*.}"
        echo "  Current extension: .$file_ext" >> "$RESULTS_FILE"
        
        # Content analysis
        if [[ $content =~ import.*React ]] || [[ $content =~ from.*[\'\"]\react[\'\"] ]]; then
            content_type="React Component"
            if [[ $file_ext == "js" ]]; then
                echo "  🔧 ISSUE: React component with .js extension should be .jsx" >> "$RESULTS_FILE"
                new_name="${file%.js}.jsx"
                echo "  📝 Recommended: Rename to $new_name" >> "$RESULTS_FILE"
                print_fix "ISSUE: $file should be .jsx (contains React)"
            elif [[ $file_ext == "tsx" ]]; then
                echo "  ✅ CORRECT: TypeScript React component" >> "$RESULTS_FILE"
                print_success "Correct: TSX for TypeScript React"
            fi
        elif [[ $content =~ \<\!DOCTYPE.*html\> ]] || [[ $content =~ \<html\> ]]; then
            content_type="HTML Document"
            echo "  ✅ CORRECT: HTML document" >> "$RESULTS_FILE"
            
            # Check for references in HTML
            refs=$(echo "$content" | grep -E 'src=|href=' | grep -v http)
            if [[ -n $refs ]]; then
                echo "  📎 References found:" >> "$RESULTS_FILE"
                echo "$refs" | while IFS= read -r ref; do
                    echo "    $ref" >> "$RESULTS_FILE"
                done
            fi
        elif [[ $content =~ class.*ABHILASIA ]] || [[ $content =~ QUANTUM.*REPL ]]; then
            content_type="Quantum Processing System"
            echo "  ✅ CORRECT: Advanced JS system" >> "$RESULTS_FILE"
        else
            content_type="Unknown"
            echo "  ⚠️  UNKNOWN: Content type unclear" >> "$RESULTS_FILE"
        fi
        
        echo "  Content type: $content_type" >> "$RESULTS_FILE"
        
        # Extract imports/references
        imports=$(echo "$content" | grep -E "import.*from|require\(|<script.*src|<link.*href" | head -3)
        if [[ -n $imports ]]; then
            echo "  📋 Key imports/references:" >> "$RESULTS_FILE"
            echo "$imports" | while IFS= read -r import_line; do
                echo "    $import_line" >> "$RESULTS_FILE"
            done
        fi
        
        # Check file size
        file_size=$(rclone size "gdrive:$file" --json | jq .bytes 2>/dev/null || echo "unknown")
        if [[ $file_size != "unknown" ]]; then
            echo "  📏 File size: $file_size bytes" >> "$RESULTS_FILE"
        fi
        
    else
        print_warning "File not found or inaccessible"
        echo "  Status: ❌ Not found or inaccessible" >> "$RESULTS_FILE"
    fi
    
    echo "" >> "$RESULTS_FILE"
done

# Generate fix commands
echo ""
print_info "Generating fix recommendations..."

echo "FIX RECOMMENDATIONS:" >> "$RESULTS_FILE"
echo "===================" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Check for JS files that should be JSX
echo "1. EXTENSION FIXES:" >> "$RESULTS_FILE"
echo "   Files that need extension changes based on content" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

js_files_to_fix=()
for file in "${KEY_FILES[@]}"; do
    if [[ $file =~ \.js$ ]]; then
        content=$(rclone cat "gdrive:$file" --count 500 2>/dev/null)
        if [[ $content =~ import.*React ]]; then
            new_name="${file%.js}.jsx"
            echo "   rclone moveto gdrive:\"$file\" gdrive:\"$new_name\"" >> "$RESULTS_FILE"
            js_files_to_fix+=("$file")
            print_fix "Command: Rename $file to $new_name"
        fi
    fi
done

if [ ${#js_files_to_fix[@]} -eq 0 ]; then
    echo "   ✅ No extension fixes needed for key files" >> "$RESULTS_FILE"
    print_success "No critical extension fixes needed"
fi

echo "" >> "$RESULTS_FILE"
echo "2. REFERENCE VALIDATION:" >> "$RESULTS_FILE"
echo "   Checking if HTML files can find their referenced JS/CSS files" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Check HTML references
for file in "${KEY_FILES[@]}"; do
    if [[ $file =~ \.html$ ]]; then
        content=$(rclone cat "gdrive:$file" --count 2000 2>/dev/null)
        refs=$(echo "$content" | grep -E 'src=|href=' | grep -E '\.js|\.css|\.jsx' | grep -v http)
        
        if [[ -n $refs ]]; then
            echo "   File: $file" >> "$RESULTS_FILE"
            echo "$refs" | while IFS= read -r ref_line; do
                # Extract filename from src/href
                ref_file=$(echo "$ref_line" | sed -n 's/.*[src|href]=["'\'']\([^"'\'']*\)["'\''].*/\1/p')
                if [[ -n $ref_file ]]; then
                    # Check if file exists
                    if rclone lsf gdrive: --recursive | grep -q "$(basename "$ref_file")"; then
                        echo "     ✅ $ref_file - Found" >> "$RESULTS_FILE"
                    else
                        echo "     ❌ $ref_file - MISSING" >> "$RESULTS_FILE"
                        print_warning "Broken reference: $file references missing $ref_file"
                    fi
                fi
            done
        fi
    fi
done

echo "" >> "$RESULTS_FILE"
echo "3. SUMMARY:" >> "$RESULTS_FILE"
echo "   Key findings from your Google Drive analysis" >> "$RESULTS_FILE"
echo "" >> "$RESULTS_FILE"

# Count issues
total_issues=0
extension_issues=${#js_files_to_fix[@]}
total_issues=$((total_issues + extension_issues))

echo "   📊 Files analyzed: ${#KEY_FILES[@]}" >> "$RESULTS_FILE"
echo "   🔧 Extension fixes needed: $extension_issues" >> "$RESULTS_FILE"
echo "   📋 Total issues found: $total_issues" >> "$RESULTS_FILE"

if [ $total_issues -eq 0 ]; then
    echo "   🎉 Your key files are properly organized!" >> "$RESULTS_FILE"
    print_success "🎉 Your key files are properly organized!"
else
    echo "   ⚠️  Some fixes recommended - see commands above" >> "$RESULTS_FILE"
    print_warning "Some fixes recommended - check the report"
fi

echo ""
echo -e "${PURPLE}📋 ANALYSIS COMPLETE${NC}"
echo "===================="

# Display key findings
cat "$RESULTS_FILE"

print_success "Complete analysis saved to: $RESULTS_FILE"

# Ask if user wants to apply fixes
if [ $total_issues -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}Apply fixes automatically? (y/n)${NC}"
    read -p "> " apply_fixes
    
    if [[ $apply_fixes == "y" || $apply_fixes == "Y" ]]; then
        print_info "Applying fixes..."
        
        # Apply extension fixes
        for file in "${js_files_to_fix[@]}"; do
            new_name="${file%.js}.jsx"
            print_info "Renaming: $file → $new_name"
            rclone moveto "gdrive:$file" "gdrive:$new_name"
            
            if [ $? -eq 0 ]; then
                print_success "✅ Renamed successfully"
            else
                print_warning "❌ Rename failed"
            fi
        done
        
        print_success "Fixes applied!"
    else
        print_info "No changes made - you can apply fixes manually using the commands in the report"
    fi
fi