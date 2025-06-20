#!/usr/bin/env python3
"""
Global Emoji and Word Remover
Remove emojis and specific words from entire home directory and GitHub repos
"""

import os
import re
import subprocess
from pathlib import Path

class GlobalCleaner:
    def __init__(self):
        self.emoji_pattern = re.compile("["
            u"\U0001F600-\U0001F64F"  # emoticons
            u"\U0001F300-\U0001F5FF"  # symbols & pictographs
            u"\U0001F680-\U0001F6FF"  # transport & map
            u"\U0001F1E0-\U0001F1FF"  # flags
            u"\U00002702-\U000027B0"
            u"\U000024C2-\U0001F251"
            "]+", flags=re.UNICODE)
        
        self.remove_words = ["", "", ""]
        
    def clean_file(self, filepath):
        """Remove emojis and specified words from file"""
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            # Remove emojis
            content = self.emoji_pattern.sub('', content)
            
            # Remove specified words
            for word in self.remove_words:
                content = content.replace(word, '')
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print(f"Cleaned: {filepath}")
            return True
        except Exception as e:
            print(f"Error cleaning {filepath}: {e}")
            return False
    
    def clean_home_directory(self):
        """Clean entire home directory"""
        home = Path.home()
        
        # File extensions to clean
        extensions = ['.py', '.html', '.js', '.txt', '.md', '.sh', '.json', '.yaml', '.yml']
        
        cleaned_count = 0
        for ext in extensions:
            for filepath in home.rglob(f"*{ext}"):
                # Skip hidden directories and system files
                if any(part.startswith('.') for part in filepath.parts[3:]):
                    continue
                
                if self.clean_file(filepath):
                    cleaned_count += 1
        
        print(f"Cleaned {cleaned_count} files in home directory")
        return cleaned_count
    
    def fetch_and_clean_github_repos(self):
        """Fetch personal GitHub repos and clean them"""
        github_user = "bitsabhi"
        
        # Get list of repos
        try:
            cmd = f"gh repo list {github_user} --limit 100 --json name"
            result = subprocess.run(cmd.split(), capture_output=True, text=True)
            
            if result.returncode != 0:
                print("GitHub CLI not available or not authenticated")
                return 0
            
            import json
            repos = json.loads(result.stdout)
            
            cleaned_repos = 0
            for repo in repos:
                repo_name = repo['name']
                repo_path = f"/tmp/{repo_name}"
                
                # Clone repo to temp
                clone_cmd = f"git clone https://github.com/{github_user}/{repo_name} {repo_path}"
                subprocess.run(clone_cmd.split(), capture_output=True)
                
                # Clean repo files
                repo_dir = Path(repo_path)
                if repo_dir.exists():
                    for ext in ['.py', '.html', '.js', '.txt', '.md', '.sh']:
                        for filepath in repo_dir.rglob(f"*{ext}"):
                            self.clean_file(filepath)
                    
                    # Push changes back
                    os.chdir(repo_path)
                    subprocess.run(["git", "add", "."], capture_output=True)
                    subprocess.run(["git", "commit", "-m", "Remove emojis and cleanup"], capture_output=True)
                    subprocess.run(["git", "push"], capture_output=True)
                    
                    cleaned_repos += 1
                    print(f"Cleaned and updated repo: {repo_name}")
            
            return cleaned_repos
            
        except Exception as e:
            print(f"Error with GitHub repos: {e}")
            return 0

def main():
    print("Creating optimal performance environment")
    print("Setting up global cleaning system")
    
    cleaner = GlobalCleaner()
    
    print("Phase 1: Cleaning home directory")
    home_count = cleaner.clean_home_directory()
    
    print("Phase 2: Cleaning personal GitHub repos")  
    github_count = cleaner.fetch_and_clean_github_repos()
    
    print(f"Complete: {home_count} home files + {github_count} repos cleaned")
    print("Environment optimized for maximum performance")

if __name__ == "__main__":
    main()