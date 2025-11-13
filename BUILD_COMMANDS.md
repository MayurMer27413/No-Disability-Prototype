# Build Commands for Windows

## Clean Build (Recommended Before Building)

### Option 1: Using Flutter (Recommended)
```powershell
cd D:\NDprototype
flutter clean
flutter pub get
flutter build apk
```

### Option 2: Using Gradle Directly
```powershell
cd D:\NDprototype\android
.\gradlew.bat clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

## Important Notes

### Windows PowerShell Commands
- Use `.\gradlew.bat` (not just `gradlew`)
- Or use `flutter clean` which handles everything

### Quick Build (After First Clean)
```powershell
cd D:\NDprototype
flutter build apk
```

### Debug Build (Faster)
```powershell
flutter build apk --debug
```

## What Each Command Does

1. **`flutter clean`**: 
   - Removes build artifacts
   - Cleans Flutter cache
   - Prepares for fresh build

2. **`flutter pub get`**: 
   - Downloads/updates dependencies
   - Updates plugin configurations

3. **`flutter build apk`**: 
   - Builds release APK
   - Includes all optimizations

4. **`.\gradlew.bat clean`**: 
   - Cleans Android/Gradle build cache
   - Usually not needed if using `flutter clean`

## Recommended Workflow

```powershell
# Navigate to project
cd D:\NDprototype

# Clean everything
flutter clean

# Get dependencies
flutter pub get

# Build APK
flutter build apk
```

That's it! `flutter clean` handles both Flutter and Android cleanup.

