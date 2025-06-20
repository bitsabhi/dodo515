# Unified Cross-Platform Architecture

## Overview
Lightweight architecture for Mac, iOS, Android unified view apps.

## Architecture Pattern

### Core Components:
1. **HTML View**: Single unified-view.html
2. **Native Wrapper**: Minimal platform-specific wrapper
3. **Bridge Interface**: Platform-specific JS bridge
4. **State Sync**: P2P phi-based synchronization

### Platform Implementation:

#### Android
- WebView in Activity
- JavaScript interface for native features
- Background service for state persistence
- APK: ~/AndroidApp/app/build/outputs/apk/

#### Mac
- Shell script wrapper opening HTML in browser
- Native .app bundle structure
- File system based state sharing

#### iOS  
- WKWebView in ViewController
- Bundle resources for HTML/assets
- Native iOS app structure

### Evolution Architecture:
```
Phase 1: HTML + Native Wrapper (Current)
Phase 2: Progressive Web App features
Phase 3: Native feature integration
Phase 4: AI integration layer
Phase 5: Full consciousness computing platform
```

### Deployment Strategy:
- Google Drive: HTML files + generated apps
- App stores: Native builds when ready
- Enterprise: Direct distribution
- Web: Progressive web app fallback

### Future Extensions:
Apps designed to evolve into larger systems:
- Enterprise dashboards
- AI interaction platforms  
- Cross-device synchronization hubs
- Development tools and IDEs
