#!/bin/bash
# Extract all speech-to-text and raw speech data

echo "=== SPEECH DATA EXTRACTION ==="

# Check macOS speech recognition locations
echo "Checking macOS speech data..."
find ~/Library -name "*speech*" -o -name "*dictation*" -o -name "*voice*" 2>/dev/null

# Check for transcription apps data
echo "Checking transcription apps..."
find ~/Library/Application\ Support -name "*transcript*" -o -name "*speech*" 2>/dev/null

# Check for voice memo transcriptions
echo "Checking Voice Memos..."
find ~/Library/Application\ Support/com.apple.voicememos -name "*.transcript" 2>/dev/null

# Check for WhatsApp voice message transcripts
echo "Checking WhatsApp voice data..."
find ~/Library/Containers/net.whatsapp.WhatsApp -name "*transcript*" -o -name "*audio*" 2>/dev/null

# Check for Claude conversation speech patterns
echo "Extracting speech patterns from Claude JSONL..."
find ~/.claude/projects -name "*.jsonl" -exec grep -l "speaking\|voice\|speech" {} \; 2>/dev/null

# Extract raw speech from current session
echo "Current session speech extractions:"
echo "Input: 'uh okay bro so here is the thing so 18 major views okay which means first of all how many views do i need'"
echo "Input: 'i will tell you just this so it so one is my life which so actually don't go into that okay'"
echo "Input: 'checkpoint this also this is checkpoint number two okay'"
echo "Input: 'do you have a solution or i have one solution but what do you think is the solution first'"
echo "Input: 'i'm speaking by the way so the translation errors could have happened'"
echo "Input: 'speech to text whatever i speak is also somewhere uh dumbed i can't remember'"

echo "=== EXTRACTION COMPLETE ==="