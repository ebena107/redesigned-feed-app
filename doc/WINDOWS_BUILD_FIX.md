# Windows Build SQLite3 DLL Issue - Fix Guide

## Problem

When running the app on Windows desktop (debug or release), you get:
```
Initialization Error
Invalid argument(s): Couldn't resolve native function 'sqlite3_initialize'
Failed to load dynamic library 'sqlite3.x64.windows.dll'
The specified module could not be found. (error code: 126)
```

## Root Cause

The `sqlite3_flutter_libs` native library package for Windows is either:
1. Not properly downloaded and integrated into the build
2. DLL not being copied to the correct location
3. Missing system dependencies

## Solutions

### Solution 1: Clean Rebuild (RECOMMENDED - Try First)

```bash
cd redesigned-feed-app

# Clean everything
flutter clean

# Delete build artifacts
rmdir /s /q build
rmdir /s /q windows\flutter\generated_plugins.cmake

# Get fresh dependencies
flutter pub get

# Rebuild native assets
flutter pub global deactivate fvm  # if using FVM
flutter pub get

# Run on Windows
flutter run -d windows
```

### Solution 2: Rebuild with Native Assets

```bash
flutter run -d windows --verbose

# If that fails, try building explicitly:
flutter build windows --verbose
```

### Solution 3: Manual DLL Placement (Advanced)

If the above doesn't work, you may need to manually ensure the DLL is in the right place:

1. Find where sqlite3_flutter_libs downloaded the DLL:
   - Usually in: `.dart_tool/flutter_plugins/sqlite3_flutter_libs/windows/` or similar

2. Copy the DLL to the build output:
   ```bash
   copy <source_dll> build\windows\Debug\app\sqlite3.x64.windows.dll
   copy <source_dll> build\windows\Release\app\sqlite3.x64.windows.dll
   ```

## Prevention

### For CI/CD or Fresh Installs

Add to your build script:

```bash
# Ensure pubspec.yaml is correct
flutter pub get

# Pre-download native assets
flutter pub get --offline || flutter pub get

# Build with native assets resolution
flutter build windows --verbose
```

### Check pubspec.yaml Dependencies

Ensure you have these in your `pubspec.yaml`:

```yaml
dependencies:
  sqflite: ^2.3.3+1
  sqflite_common_ffi: ^2.3.3
  sqflite_common_ffi_web: ^0.4.5+3
  sqlite3_flutter_libs: ^0.5.24    # IMPORTANT for Windows
```

**Note**: The `sqlite3_flutter_libs` package is ESSENTIAL for Windows/Linux desktop builds.

## Debugging Steps

### Step 1: Verify Package Installation

```bash
flutter pub upgrade sqlite3_flutter_libs
flutter pub get
```

### Step 2: Check Build Output

```bash
flutter build windows --verbose 2>&1 | findstr /i "sqlite3"
```

This will show if the native library is being found/compiled.

### Step 3: Verify DLL Exists

```bash
# Check if DLL was downloaded
dir %USERPROFILE%\.pub-cache\hosted\pub.dartlang.org\sqlite3_flutter_libs*

# Check if it's in the build output
dir build\windows\Debug\app\*.dll
dir build\windows\Release\app\*.dll
```

### Step 4: Check Windows SDK

Ensure you have the Windows SDK and Visual C++ build tools:
```bash
flutter doctor -v
```

Look for "Visual Studio" - you need "Build Tools" or "Community Edition" with C++ workload.

## Alternative: Use Release APK Instead

If Windows desktop build is blocking development, remember that:
- ✅ Android APK builds work fine
- ✅ iOS builds work fine
- ✅ Web builds work fine
- ❌ Windows desktop requires additional native library setup

For development, consider testing on Android device (v2318) or using the web version.

## Code Changes Made

Added better error handling in `app_db.dart`:
- Catches sqfliteFfiInit() errors
- Provides platform-specific helpful error messages
- Guides users to run `flutter pub get` again

## If Still Failing

1. **Check Flutter version**:
   ```bash
   flutter --version
   ```
   Should be 3.5.0 or higher

2. **Run flutter doctor**:
   ```bash
   flutter doctor -v
   ```

3. **Delete and reconfigure**:
   ```bash
   rmdir /s /q .dart_tool
   rmdir /s /q windows\flutter\generated_plugins.cmake
   flutter clean
   flutter pub get
   ```

4. **Last resort**: File an issue with:
   - Flutter version
   - Windows version
   - Full error message
   - Output of `flutter doctor -v`

## References

- [sqlite3_flutter_libs](https://pub.dev/packages/sqlite3_flutter_libs)
- [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)
- [Flutter Desktop Setup](https://docs.flutter.dev/platform-integration/windows/building)

## Current Status

- ✅ Android APK: Working fine (tested on v2318)
- ✅ App functionality: All features work on mobile
- ❌ Windows Desktop: Native library loading issue
- ⏳ Recommended: Use Android device for testing, Windows can be resolved later

For v1.1.5+14 release, the Android APK/App Bundle are production-ready.
