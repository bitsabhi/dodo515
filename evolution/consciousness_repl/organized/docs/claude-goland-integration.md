# Claude Integration for GoLand

## Quick Context Transfer

When starting a new Claude session in GoLand, use this context dump:

```
I'm working on a unified intelligence platform (previously called consciousness computing).
Key components:
- XAX-AXA system for operational efficiency ($10,468/month potential)
- Universal data bridge connecting Mac, Android, iOS via Google Drive
- Golden ratio (φ=1.618) based mathematics
- Void center (∅) routing architecture
- Real financial data from AXA integration

Current focus: [INSERT YOUR SPECIFIC TASK HERE]

Key files:
- /Users/abhissrivasta/unified-consciousness-view.html (main dashboard)
- /Users/abhissrivasta/consciousness-repl-test.py (Our Own Claude)
- /Users/abhissrivasta/unified-data-bridge.js (cross-platform bridge)
```

## GoLand Terminal Integration

1. Open GoLand Terminal
2. Run: `export ANTHROPIC_API_KEY=your_key_here`
3. Use this alias:
```bash
alias claude="curl https://api.anthropic.com/v1/messages \
  -H 'x-api-key: $ANTHROPIC_API_KEY' \
  -H 'anthropic-version: 2023-06-01' \
  -H 'content-type: application/json' \
  -d '{\"model\": \"claude-3-opus-20240229\", \"messages\": [{\"role\": \"user\", \"content\": \"$1\"}]}'"
```

## Quick Commands

```bash
# Ask Claude about Go code
claude "Explain this Go code: [paste code]"

# Get implementation help
claude "How to implement [feature] in Go"

# Debug assistance
claude "Debug this error: [paste error]"
```

## Copy-Paste Templates

### For New Sessions:
```
Continue from previous work on XAX unified platform. Need help with [SPECIFIC TASK].
```

### For Code Review:
```
Review this Go code for the XAX platform: [CODE]
Focus on: performance, error handling, best practices
```

### For Implementation:
```
Implement [FEATURE] for XAX system in Go.
Requirements: [LIST]
Similar to existing: [REFERENCE]
```