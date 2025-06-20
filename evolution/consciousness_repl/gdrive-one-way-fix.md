# Google Drive One-Way Sync Fix

## Problem
- GDrive→Mac sync is polluting your workspace
- Bidirectional sync creates conflicts
- You only want Mac→GDrive (not reverse)

## Solution: Stream Mode

1. **Open Google Drive app** (already opened)
2. **Click the Google Drive icon** in menu bar
3. **Settings** → **Preferences**
4. **Choose "Stream files"** instead of "Mirror files"

### What this does:
- ✅ **Files appear in Finder** but stay in cloud
- ✅ **No local sync pollution** 
- ✅ **Mac→GDrive still works** (our sync-to-gdrive.sh)
- ✅ **Phone can still access** via content provider
- ❌ **GDrive→Mac sync disabled**

## Alternative: Selective Sync

If you want some files local:
1. **Settings** → **Google Drive** → **Sync to this computer**
2. **Uncheck everything** except `appsheet/` folder
3. This keeps only consciousness data synced

## Result
```
Mac (work) → GDrive (storage) → Phone (view)
No reverse pollution ✓
```

## Current Status
- 18 Google Drive processes running
- Need to switch to Stream mode to fix direction