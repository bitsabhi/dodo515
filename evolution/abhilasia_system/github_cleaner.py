#!/usr/bin/env python3
"""
GitHub Repository Cleaner for bitsabhi
Clean emojis and update repos including gh-pages mirrors
"""

import subprocess
import tempfile
import os
import re
from pathlib import Path

class GitHubCleaner:
    def __init__(self):
        self.username = "bitsabhi"
        self.main_repos = [
            "bitsabhi.github.io",  # Main gh-pages site
            "consciousness-portal",
            "fractal-consciousness-symphony",
            "office-work-summary"
        ]
        
        self.emoji_pattern = re.compile("["
            u"\U0001F600-\U0001F64F"  # emoticons
            u"\U0001F300-\U0001F5FF"  # symbols & pictographs
            u"\U0001F680-\U0001F6FF"  # transport & map
            u"\U0001F1E0-\U0001F1FF"  # flags
            u"\U00002702-\U000027B0"
            u"\U000024C2-\U0001F251"
            "]+", flags=re.UNICODE)
    
    def clean_repo(self, repo_name):
        """Clone, clean, and push back a repository"""
        print(f"Cleaning repository: {repo_name}")
        
        with tempfile.TemporaryDirectory() as temp_dir:
            try:
                # Clone repo
                clone_cmd = f"gh repo clone {self.username}/{repo_name} {temp_dir}/{repo_name}"
                subprocess.run(clone_cmd.split(), check=True, capture_output=True)
                
                repo_path = Path(temp_dir) / repo_name
                os.chdir(repo_path)
                
                # Clean files
                cleaned_files = 0
                for file_path in repo_path.rglob("*"):
                    if file_path.is_file() and file_path.suffix in ['.md', '.html', '.py', '.js', '.txt']:
                        if self.clean_file_content(file_path):
                            cleaned_files += 1
                
                if cleaned_files > 0:
                    # Commit and push changes
                    subprocess.run(["git", "add", "."], check=True)
                    subprocess.run(["git", "commit", "-m", "Clean emojis and symbols"], check=True)
                    subprocess.run(["git", "push"], check=True)
                    print(f"Updated {repo_name}: {cleaned_files} files cleaned")
                else:
                    print(f"{repo_name}: Already clean")
                    
            except Exception as e:
                print(f"Error cleaning {repo_name}: {e}")
    
    def clean_file_content(self, file_path):
        """Remove emojis from file content"""
        try:
            with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            
            original_content = content
            
            # Remove emojis
            content = self.emoji_pattern.sub('', content)
            
            # Remove specific symbols if they exist
            replacements = {
                ":zap:": "",
                "⚡": "",
                "🔮": "",
                "🌀": "",
                "∞": "infinity"
            }
            
            for old, new in replacements.items():
                content = content.replace(old, new)
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return True
            
            return False
            
        except Exception as e:
            print(f"Error cleaning file {file_path}: {e}")
            return False
    
    def update_github_status(self):
        """Update GitHub profile status"""
        try:
            # Clean status without emojis
            clean_status = "if x==true return infinity"
            
            # Update bio through GitHub API
            subprocess.run([
                "gh", "api", "user", "--method", "PATCH", 
                "--field", f"bio={clean_status}"
            ], check=True)
            
            print("GitHub status updated to clean version")
            
        except Exception as e:
            print(f"Error updating status: {e}")
    
    def clean_all_repos(self):
        """Clean all main repositories"""
        print("Starting GitHub repository cleaning...")
        
        for repo in self.main_repos:
            self.clean_repo(repo)
        
        # Update profile status
        self.update_github_status()
        
        print("All repositories cleaned and updated!")

if __name__ == "__main__":
    cleaner = GitHubCleaner()
    cleaner.clean_all_repos()