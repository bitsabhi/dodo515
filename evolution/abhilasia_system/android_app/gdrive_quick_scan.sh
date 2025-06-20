#!/bin/bash

# Quick Google Drive File Scanner
# Fast analysis for large file collections

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_info() { echo -e "${CYAN}📊 $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

echo -e "${BLUE}🔍 QUICK GOOGLE DRIVE SCAN${NC}"
echo "================================="

# Get file count first
print_info "Checking Google Drive size..."
TOTAL_FILES=$(rclone lsjson gdrive: --recursive | jq length)
print_info "Found $TOTAL_FILES total files"

# Quick scan for code files only
print_info "Scanning for code/web files..."

# Create temp analysis
mkdir -p quick_scan_temp
cd quick_scan_temp

# Get files with code-related extensions
rclone lsjson gdrive: --recursive | jq -r '.[] | select(.Name | test("\\.(js|jsx|html|css|json|ts|tsx|php|py|sh|md|txt)$"; "i")) | .Path' > code_files.txt

CODE_FILE_COUNT=$(wc -l < code_files.txt)
print_success "Found $CODE_FILE_COUNT potential code files"

echo ""
echo "📋 QUICK ANALYSIS RESULTS:"
echo "=========================="

# Analyze by extension
echo "Files by extension:"
rclone lsjson gdrive: --recursive | jq -r '.[] | .Name' | grep -E '\\.' | sed 's/.*\\.//' | sort | uniq -c | sort -nr | head -20

echo ""
echo "🔍 Code files found:"
while IFS= read -r filepath; do
    filename=$(basename "$filepath")
    echo "  • $filename ($filepath)"
done < code_files.txt | head -20

if [ $CODE_FILE_COUNT -gt 20 ]; then
    echo "  ... and $((CODE_FILE_COUNT - 20)) more files"
fi

echo ""
echo "📊 SUMMARY:"
echo "  Total files: $TOTAL_FILES"
echo "  Code files: $CODE_FILE_COUNT"
echo "  Analysis time: Fast scan completed"

# Quick reference check on a sample
print_info "Checking first 5 code files for content type..."

head -5 code_files.txt | while IFS= read -r filepath; do
    if [ -n "$filepath" ]; then
        filename=$(basename "$filepath")
        echo -n "  $filename: "
        
        # Quick content check
        content=$(rclone cat "gdrive:$filepath" --count 200 2>/dev/null || echo "")
        
        if [[ $content =~ import.*React ]] || [[ $content =~ from.*react ]]; then
            echo "React Component"
        elif [[ $content =~ \<\!DOCTYPE.*html\> ]] || [[ $content =~ \<html\> ]]; then
            echo "HTML Document"
        elif [[ $content =~ export.*default ]] || [[ $content =~ import.*from ]]; then
            echo "JavaScript Module"
        elif [[ $content =~ ^\{.*\}$ ]] || [[ $content =~ ^\[.*\]$ ]]; then
            echo "JSON Data"
        else
            echo "Text/Other"
        fi
    fi
done

cd ..
rm -rf quick_scan_temp

echo ""
print_success "Quick scan complete!"
print_warning "Run full analysis? (y/n)"