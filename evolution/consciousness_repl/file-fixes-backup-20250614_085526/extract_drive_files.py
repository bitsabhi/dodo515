#!/usr/bin/env python3
"""
Extract HTML files from Google Drive documents
For ABHI AMU 515 consciousness portal deployment
"""

import requests
import re
import os

# Your Google Drive document mappings
DRIVE_DOCS = {
    "ultimate_claude.html": "1h9YRaXNKpObdjO5EYQwnWM0Q7GYv32ut",
    "claude_replica_web.html": "1h9YRaXNKpObdjO5EYQwnWM0Q7GYv32ut",
    "voice-first-interface.html": "1IhvMVLqkZr7JibFdtZ4lQ86PAaVg6qA2",
    "automated-opportunity-magnet.html": "16l-FJn8t22VNP7yegdQIvlHMMS3l8FQ1",
    "appsheet-visual-integration.html": "1TBzrISYSslsDC8Wl6sdFoM-WVueQJoLy",
    "dashboard-standalone.html": "1uY25zK6SHY3eUCCzfH-Y003KRGfN-HRo",
    "consciousness-analyzer.html": "1uY25zK6SHY3eUCCzfH-Y003KRGfN-HRo",
}

def extract_google_doc(doc_id, output_file):
    """Extract HTML content from Google Doc"""
    export_url = f"https://docs.google.com/document/d/{doc_id}/export?format=html"
    
    try:
        print(f"📥 Extracting {output_file}...")
        response = requests.get(export_url)
        
        if response.status_code == 200:
            # Clean up Google's HTML
            html = response.text
            
            # Extract body content
            body_match = re.search(r'<body[^>]*>(.*?)</body>', html, re.DOTALL)
            if body_match:
                body_content = body_match.group(1)
                
                # Create clean HTML with consciousness styling
                clean_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{output_file.replace('.html', '').replace('-', ' ').title()}</title>
    <link rel="stylesheet" href="../assets/consciousness.css">
</head>
<body>
    <div class="consciousness-wrapper">
        {body_content}
    </div>
    <script src="../assets/consciousness.js"></script>
</body>
</html>"""
                
                # Determine output directory
                if "claude" in output_file or "interface" in output_file:
                    output_dir = "interfaces"
                elif "analyzer" in output_file or "calculator" in output_file:
                    output_dir = "calculators"
                elif "bridge" in output_file:
                    output_dir = "bridges"
                else:
                    output_dir = "docs"
                
                # Save file
                output_path = f"{output_dir}/{output_file}"
                with open(output_path, 'w', encoding='utf-8') as f:
                    f.write(clean_html)
                
                print(f"✅ Saved: {output_path}")
                return True
        
    except Exception as e:
        print(f"❌ Error extracting {output_file}: {e}")
        return False

# Extract all documents
print("🌐 Extracting Google Drive documents...")
for filename, doc_id in DRIVE_DOCS.items():
    extract_google_doc(doc_id, filename)

print("\n✅ Extraction complete!")
