#!/usr/bin/env python3
import subprocess
import sys

def record_and_transcribe():
    # Record audio using Mac's built-in recorder
    print(" Recording... (speak now)")
    subprocess.run(["rec", "-r", "16000", "-c", "1", "temp_audio.wav", "silence", "1", "0.1", "3%", "1", "3.0", "3%"])
    
    # Use Whisper to transcribe
    result = subprocess.run(["/opt/homebrew/bin/whisper", "temp_audio.wav", "--output_format", "txt"], capture_output=True, text=True)
    
    # Read transcription
    with open("temp_audio.txt", "r") as f:
        text = f.read().strip()
    
    print(f" You said: {text}")
    return text

if __name__ == "__main__":
    text = record_and_transcribe()