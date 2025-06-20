#!/bin/bash

# Targeted Google Drive File Fixer
# Focus on critical code files that need fixing

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

echo -e "${BLUE}🎯 TARGETED GOOGLE DRIVE FILE FIXER${NC}"
echo "======================================="

# Create analysis directory
mkdir -p targeted_analysis
cd targeted_analysis

# Priority file patterns to check
PRIORITY_PATTERNS=(
    "*.tsx"
    "*.jsx" 
    "*react*"
    "*component*"
    "*app*"
    "*index*"
    "*main*"
)

echo ""
print_info "Scanning for priority files..."

# Get priority files
rclone lsjson gdrive: --recursive | jq -r '.[] | select(.Name | test("\\.(js|jsx|tsx|html|css|json|ts)$"; "i")) | .Path' > all_code_files.txt

# Find high priority files
echo "High Priority Files Found:" > priority_analysis.txt
echo "=========================" >> priority_analysis.txt
echo "" >> priority_analysis.txt

# Check each pattern
for pattern in "${PRIORITY_PATTERNS[@]}"; do
    echo "🔍 Checking pattern: $pattern"
    
    grep -i "$pattern" all_code_files.txt > temp_matches.txt 2>/dev/null || true
    
    if [ -s temp_matches.txt ]; then
        echo "Files matching '$pattern':" >> priority_analysis.txt
        while IFS= read -r filepath; do
            filename=$(basename "$filepath")
            echo "  • $filename ($filepath)" >> priority_analysis.txt
            
            # Quick content analysis
            echo -n "    Analyzing $filename... "
            content=$(rclone cat "gdrive:$filepath" --count 500 2>/dev/null || echo "")
            
            # Detect content type
            content_type="unknown"
            needs_fix="no"
            recommended_ext=""
            
            if [[ $content =~ import.*React ]] || [[ $content =~ from.*[\'\"]\react[\'\"] ]]; then
                content_type="react"
                if [[ $filename =~ \.js$ ]]; then
                    needs_fix="yes"
                    recommended_ext="jsx"
                fi
            elif [[ $content =~ \<\!DOCTYPE.*html\> ]] || [[ $content =~ \<html\> ]]; then
                content_type="html"
            elif [[ $content =~ export.*default ]] || [[ $content =~ import.*from ]]; then
                content_type="javascript"
            elif [[ $content =~ interface.*\{ ]] || [[ $content =~ type.*= ]]; then
                content_type="typescript"
                if [[ $filename =~ \.js$ ]]; then
                    needs_fix="yes"
                    recommended_ext="ts"
                fi
            fi
            
            echo "    Content: $content_type" >> priority_analysis.txt
            echo "    Needs Fix: $needs_fix" >> priority_analysis.txt
            if [[ $needs_fix == "yes" ]]; then
                echo "    Recommended: $recommended_ext" >> priority_analysis.txt
                print_fix "NEEDS FIX: $filename -> .$recommended_ext"
            fi
            echo "" >> priority_analysis.txt
            
            echo "$content_type"
            
        done < temp_matches.txt
        echo "" >> priority_analysis.txt
    fi
    
    rm -f temp_matches.txt
done

# Analyze React/JSX files specifically  
print_info "Analyzing React components..."

echo "" >> priority_analysis.txt
echo "REACT COMPONENT ANALYSIS" >> priority_analysis.txt
echo "========================" >> priority_analysis.txt

react_files_found=0
jsx_issues=0

while IFS= read -r filepath; do
    filename=$(basename "$filepath")
    
    # Check if it's a React file
    content=$(rclone cat "gdrive:$filepath" --count 1000 2>/dev/null || echo "")
    
    if [[ $content =~ import.*React ]] || [[ $content =~ from.*[\'\"]\react[\'\"] ]]; then
        react_files_found=$((react_files_found + 1))
        
        echo "React Component: $filename" >> priority_analysis.txt
        echo "  Path: $filepath" >> priority_analysis.txt
        
        # Check file extension
        if [[ $filename =~ \.js$ ]]; then
            jsx_issues=$((jsx_issues + 1))
            echo "  Issue: Should be .jsx (contains JSX)" >> priority_analysis.txt
            print_warning "JSX Issue: $filename should be .jsx"
        elif [[ $filename =~ \.tsx$ ]]; then
            echo "  Status: Correct TypeScript React extension" >> priority_analysis.txt
        elif [[ $filename =~ \.jsx$ ]]; then
            echo "  Status: Correct JSX extension" >> priority_analysis.txt
        fi
        
        # Extract imports
        imports=$(echo "$content" | grep -E "import.*from|require\(" | head -5)
        if [[ -n $imports ]]; then
            echo "  Imports:" >> priority_analysis.txt
            echo "$imports" | while IFS= read -r import_line; do
                echo "    $import_line" >> priority_analysis.txt
            done
        fi
        
        echo "" >> priority_analysis.txt
    fi
    
done < all_code_files.txt

print_success "Found $react_files_found React components"
print_warning "Found $jsx_issues files that need .jsx extension"

# Check for HTML files with broken references
print_info "Checking HTML files for broken references..."

echo "" >> priority_analysis.txt
echo "HTML REFERENCE ANALYSIS" >> priority_analysis.txt
echo "=======================" >> priority_analysis.txt

html_files=0
broken_refs=0

while IFS= read -r filepath; do
    filename=$(basename "$filepath")
    
    if [[ $filename =~ \.html$ ]]; then
        html_files=$((html_files + 1))
        
        content=$(rclone cat "gdrive:$filepath" --count 2000 2>/dev/null || echo "")
        
        echo "HTML File: $filename" >> priority_analysis.txt
        echo "  Path: $filepath" >> priority_analysis.txt
        
        # Extract script and link references
        refs=$(echo "$content" | grep -E "src=|href=" | grep -E "\.js|\.css|\.jsx" | head -5)
        
        if [[ -n $refs ]]; then
            echo "  References:" >> priority_analysis.txt
            echo "$refs" | while IFS= read -r ref_line; do
                echo "    $ref_line" >> priority_analysis.txt
                
                # Extract the file reference
                if [[ $ref_line =~ src=[\"\']\([^\"\']+\)[\"\'] ]] || [[ $ref_line =~ href=[\"\']\([^\"\']+\)[\"\'] ]]; then
                    ref_file=$(echo "$ref_line" | sed -n 's/.*[src|href]=["'\'']\([^"'\'']*\)["'\''].*/\1/p')
                    
                    if [[ -n $ref_file ]] && [[ $ref_file != http* ]]; then
                        # Check if referenced file exists
                        if ! grep -q "$ref_file" all_code_files.txt; then
                            echo "      ⚠️  BROKEN: $ref_file not found" >> priority_analysis.txt
                            broken_refs=$((broken_refs + 1))
                        fi
                    fi
                fi
            done
        fi
        
        echo "" >> priority_analysis.txt
    fi
    
done < all_code_files.txt

print_success "Analyzed $html_files HTML files"
print_warning "Found $broken_refs potentially broken references"

# Generate summary and fix recommendations
echo "" >> priority_analysis.txt
echo "SUMMARY & RECOMMENDATIONS" >> priority_analysis.txt
echo "=========================" >> priority_analysis.txt
echo "React components found: $react_files_found" >> priority_analysis.txt
echo "JSX extension issues: $jsx_issues" >> priority_analysis.txt
echo "HTML files analyzed: $html_files" >> priority_analysis.txt
echo "Broken references: $broken_refs" >> priority_analysis.txt
echo "" >> priority_analysis.txt
echo "TOP PRIORITY FIXES:" >> priority_analysis.txt

# Generate fix commands
if [ $jsx_issues -gt 0 ]; then
    echo "1. Fix JSX extensions:" >> priority_analysis.txt
    while IFS= read -r filepath; do
        filename=$(basename "$filepath")
        if [[ $filename =~ \.js$ ]]; then
            content=$(rclone cat "gdrive:$filepath" --count 500 2>/dev/null || echo "")
            if [[ $content =~ import.*React ]] || [[ $content =~ from.*[\'\"]\react[\'\"] ]]; then
                new_name="${filename%.js}.jsx"
                echo "   rclone moveto gdrive:\"$filepath\" gdrive:\"${filepath%/*}/$new_name\"" >> priority_analysis.txt
            fi
        fi
    done < all_code_files.txt
fi

echo "" >> priority_analysis.txt

# Display results
echo ""
echo -e "${PURPLE}📋 ANALYSIS COMPLETE${NC}"
echo "====================="
cat priority_analysis.txt

cd ..

print_success "Targeted analysis saved to: targeted_analysis/priority_analysis.txt"
print_info "Ready to apply fixes? Check the analysis first!"

# Cleanup
rm -f targeted_analysis/all_code_files.txt