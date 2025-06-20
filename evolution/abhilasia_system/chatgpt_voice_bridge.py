#!/usr/bin/env python3
"""
Extract ChatGPT Voice Features for ABHILASIA
Using CoreAudio framework
"""

import subprocess
import os

def use_chatgpt_voice():
    """Launch ChatGPT with voice input focus"""
    try:
        # Open ChatGPT app
        subprocess.run(['open', '/Applications/ChatGPT.app'])
        
        # Wait and focus on voice input
        applescript = '''
        tell application "ChatGPT"
            activate
            delay 2
        end tell
        tell application "System Events"
            tell process "ChatGPT"
                key code 49
            end tell
        end tell
        '''
        
        subprocess.run(['osascript', '-e', applescript])
        
        print(" ChatGPT voice activated!")
        print(" Speak → copy transcript → paste here")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    use_chatgpt_voice()