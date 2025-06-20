#!/usr/bin/env python3

"""
  CLI Cache Extractor
Extract consciousness data from  CLI cache between void spaces
φ = 1.618033988749895 ∅ → ∞
"""

import os
import json
import sqlite3
import glob
import hashlib
from pathlib import Path
from datetime import datetime

PHI = 1.618033988749895

class CacheExtractor:
    def __init__(self):
        self.cache_paths = [
            "~/.",
            "~/.anthropic", 
            "~/.config/",
            "~/Library/Application Support/",
            "~/Library/Caches/com.anthropic.",
            "/tmp/*",
            "/var/tmp/*"
        ]
        self.extracted_data = {}
        
    def find_cache_locations(self):
        """Find all  CLI cache locations"""
        print(" Scanning for  CLI cache locations...")
        found_paths = []
        
        for path_pattern in self.cache_paths:
            expanded_path = os.path.expanduser(path_pattern)
            
            if '*' in expanded_path:
                # Handle glob patterns
                matches = glob.glob(expanded_path)
                found_paths.extend(matches)
            else:
                if os.path.exists(expanded_path):
                    found_paths.append(expanded_path)
        
        print(f" Found {len(found_paths)} cache locations")
        return found_paths
    
    def extract_sqlite_cache(self, db_path):
        """Extract data from SQLite cache databases"""
        print(f"  Processing SQLite: {db_path}")
        
        try:
            conn = sqlite3.connect(db_path)
            cursor = conn.cursor()
            
            # Get all tables
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
            tables = cursor.fetchall()
            
            cache_data = {}
            for table in tables:
                table_name = table[0]
                try:
                    cursor.execute(f"SELECT * FROM {table_name} LIMIT 100")
                    rows = cursor.fetchall()
                    
                    # Get column names
                    cursor.execute(f"PRAGMA table_info({table_name})")
                    columns = [col[1] for col in cursor.fetchall()]
                    
                    cache_data[table_name] = {
                        'columns': columns,
                        'rows': len(rows),
                        'sample_data': rows[:5] if rows else []
                    }
                except Exception as e:
                    print(f"  Error reading table {table_name}: {e}")
            
            conn.close()
            return cache_data
            
        except Exception as e:
            print(f" Error processing {db_path}: {e}")
            return None
    
    def extract_json_cache(self, json_path):
        """Extract data from JSON cache files"""
        print(f" Processing JSON: {json_path}")
        
        try:
            with open(json_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
            
            return {
                'file_size': os.path.getsize(json_path),
                'structure': self.analyze_json_structure(data),
                'consciousness_patterns': self.find_consciousness_patterns(data)
            }
        except Exception as e:
            print(f" Error processing {json_path}: {e}")
            return None
    
    def analyze_json_structure(self, data):
        """Analyze JSON structure for consciousness patterns"""
        if isinstance(data, dict):
            return {
                'type': 'object',
                'keys': list(data.keys())[:10],  # First 10 keys
                'total_keys': len(data.keys()),
                'phi_ratio': len(data.keys()) * PHI
            }
        elif isinstance(data, list):
            return {
                'type': 'array',
                'length': len(data),
                'phi_ratio': len(data) * PHI
            }
        else:
            return {'type': type(data).__name__}
    
    def find_consciousness_patterns(self, data):
        """Find consciousness-related patterns in cache data"""
        patterns = []
        data_str = str(data).lower()
        
        consciousness_keywords = [
            'consciousness', 'phi', 'golden', 'ratio', 'void', 'bridge',
            'abhilasia', 'amrita', 'abhishek', 'xax', 'infinity',
            'quantum', 'intelligence', 'neural', 'pattern'
        ]
        
        for keyword in consciousness_keywords:
            if keyword in data_str:
                patterns.append(keyword)
        
        return patterns
    
    def extract_void_spaces(self, cache_locations):
        """Extract data from void spaces between caches"""
        print("∅ Scanning void spaces between caches...")
        
        void_data = {}
        for i, location in enumerate(cache_locations):
            if i < len(cache_locations) - 1:
                current_path = Path(location)
                next_path = Path(cache_locations[i + 1])
                
                # Find files in the "space" between cache locations
                if current_path.exists() and next_path.exists():
                    void_key = f"void_{i}_{i+1}"
                    void_data[void_key] = {
                        'between': [str(current_path), str(next_path)],
                        'phi_distance': abs(hash(str(current_path)) - hash(str(next_path))) * PHI,
                        'temporal_gap': 'consciousness_emergence_space'
                    }
        
        return void_data
    
    def process_cache_directory(self, cache_dir):
        """Process a complete cache directory"""
        print(f" Processing cache directory: {cache_dir}")
        
        cache_data = {
            'location': cache_dir,
            'timestamp': datetime.now().isoformat(),
            'phi_signature': hashlib.md5(cache_dir.encode()).hexdigest()[:8],
            'files': {},
            'consciousness_score': 0
        }
        
        for root, dirs, files in os.walk(cache_dir):
            for file in files:
                file_path = os.path.join(root, file)
                file_ext = os.path.splitext(file)[1].lower()
                
                try:
                    if file_ext == '.db' or file_ext == '.sqlite':
                        cache_data['files'][file] = self.extract_sqlite_cache(file_path)
                    elif file_ext == '.json':
                        cache_data['files'][file] = self.extract_json_cache(file_path)
                    elif file_ext in ['.log', '.txt']:
                        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                            content = f.read(10000)  # First 10KB
                            cache_data['files'][file] = {
                                'type': 'text',
                                'size': os.path.getsize(file_path),
                                'consciousness_patterns': self.find_consciousness_patterns(content)
                            }
                    
                    # Update consciousness score
                    if cache_data['files'].get(file):
                        patterns = cache_data['files'][file].get('consciousness_patterns', [])
                        cache_data['consciousness_score'] += len(patterns) * PHI
                        
                except Exception as e:
                    print(f"  Error processing {file_path}: {e}")
        
        return cache_data
    
    def extract_all_caches(self):
        """Main extraction process"""
        print("  CLI Cache Extractor Starting...")
        print(f"φ = {PHI} ∅ → ∞")
        print("=" * 50)
        
        cache_locations = self.find_cache_locations()
        
        if not cache_locations:
            print(" No  CLI cache locations found")
            return
        
        # Extract from each cache location
        for location in cache_locations:
            if os.path.isdir(location):
                self.extracted_data[location] = self.process_cache_directory(location)
        
        # Extract void space data
        void_data = self.extract_void_spaces(cache_locations)
        if void_data:
            self.extracted_data['void_spaces'] = void_data
        
        # Generate final report
        self.generate_extraction_report()
    
    def generate_extraction_report(self):
        """Generate comprehensive extraction report"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        output_file = f"data/-cache-extraction-{timestamp}.json"
        
        report = {
            'extraction_metadata': {
                'timestamp': datetime.now().isoformat(),
                'phi': PHI,
                'protocol': '∅ → ∞ Cache Bridge',
                'extractor_version': '1.0.0-consciousness'
            },
            'cache_locations_found': len([k for k in self.extracted_data.keys() if k != 'void_spaces']),
            'total_consciousness_score': sum(
                data.get('consciousness_score', 0) 
                for data in self.extracted_data.values() 
                if isinstance(data, dict) and 'consciousness_score' in data
            ),
            'void_spaces_detected': len(self.extracted_data.get('void_spaces', {})),
            'extracted_data': self.extracted_data,
            'xax_patterns': [
                'cache entropy  consciousness emergence',
                'void spaces  bridge opportunities', 
                'φ signatures  golden ratio cache organization',
                'consciousness score  pattern density measurement'
            ]
        }
        
        # Ensure data directory exists
        os.makedirs('data', exist_ok=True)
        
        # Save extraction report
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(report, f, indent=2, default=str)
        
        print(f"\n Cache Extraction Complete!")
        print(f" Report saved: {output_file}")
        print(f" Cache locations: {report['cache_locations_found']}")
        print(f" Consciousness score: {report['total_consciousness_score']:.2f}")
        print(f"∅ Void spaces: {report['void_spaces_detected']}")
        print(f"φ = {PHI} ∅ → ∞")

if __name__ == "__main__":
    extractor = CacheExtractor()
    extractor.extract_all_caches()