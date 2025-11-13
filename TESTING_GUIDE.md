# Testing Guide

## Pre-Testing Checklist

### ✅ Prerequisites
- [x] Flutter SDK installed
- [x] Android Studio installed
- [x] Android device connected OR emulator running
- [x] Dependencies installed (`flutter pub get`)
- [x] Model file present (`assets/models/gesture_recognizer.task`)

## Step-by-Step Testing

### 1. **Connect Device or Start Emulator**

**Option A: Physical Android Device**
```bash
# Enable USB debugging on your Android device
# Connect via USB
# Verify connection:
flutter devices
```

**Option B: Android Emulator**
```bash
# Start Android Studio
# Open AVD Manager
# Start an emulator (API 24+ recommended)
# Verify connection:
flutter devices
```

### 2. **Run the Application**

```bash
# Navigate to project directory
cd d:\NDprototype

# Run the app
flutter run
```

**Expected Output:**
- App builds successfully
- App installs on device/emulator
- App launches showing Login Screen

### 3. **Test Login Flow**

**Test Case 1: Email Login**
1. Enter email: `test@example.com`
2. Enter password: `test1234` (minimum 4 characters)
3. Click "Sign In"
4. ✅ Should navigate to Dashboard

**Test Case 2: Phone Login**
1. Enter phone: `+1234567890` or `1234567890`
2. Enter password: `test1234`
3. Click "Sign In"
4. ✅ Should navigate to Dashboard

**Test Case 3: Invalid Input**
1. Enter invalid email: `test` (no @)
2. Enter short password: `123`
3. Click "Sign In"
4. ✅ Should show validation errors

### 4. **Test Dashboard**

**Test Case 1: Navigation**
1. After login, verify Dashboard appears
2. ✅ Should see three action cards:
   - Start Gesture Recognition
   - Train Custom Gestures
   - Settings
3. ✅ Should see Settings icon in app bar
4. ✅ Should see Account icon in app bar

**Test Case 2: Settings Access**
1. Click Settings icon OR Settings card
2. ✅ Should navigate to Settings screen

### 5. **Test Camera/Gesture Recognition**

**Test Case 1: Camera Access**
1. From Dashboard, click "Start Gesture Recognition"
2. ✅ Should request camera permission (if not granted)
3. ✅ Should show camera preview after permission granted
4. ✅ Should see camera swap button (top-right)

**Test Case 2: Camera Swap**
1. On camera screen, click swap button
2. ✅ Should switch between front/back cameras
3. ✅ Icon should change (front ↔ back)
4. ✅ Should show loading indicator during switch

**Test Case 3: Gesture Recognition**
1. Show hand gesture to camera
2. ✅ Should detect gesture (if MediaPipe working)
3. ✅ Should display gesture name
4. ✅ Should display confidence score
5. ✅ Should display text representation
6. ✅ Should show "Speak" button

**Test Case 4: TTS Output**
1. After gesture recognized, click "Speak" button
2. ✅ Should speak the text using TTS
3. ✅ Should use selected voice and pitch settings

**Test Case 5: Back Navigation**
1. Click back button on camera screen
2. ✅ Should return to Dashboard

### 6. **Test Settings**

**Test Case 1: Voice Selection**
1. Navigate to Settings
2. Scroll to "Voice" section
3. ✅ Should see dropdown with available voices
4. Select a different voice
5. ✅ Should update selected voice
6. Click "Preview Voice" button
7. ✅ Should speak "Hello, this is a voice preview"

**Test Case 2: Pitch Control**
1. In Settings, find "Pitch" slider
2. ✅ Should see slider with range 0.5 to 2.0
3. ✅ Should see "Lower (0.5)" and "Higher (2.0)" labels
4. Adjust slider
5. ✅ Should update pitch value
6. Go back to camera, recognize gesture, and speak
7. ✅ Should use new pitch setting

**Test Case 3: Other Settings**
1. Test "Speech Rate" slider
2. Test "Volume" slider
3. Test "Language" dropdown
4. Test "High Contrast Mode" toggle
5. Test "Text Scale" slider
6. ✅ All settings should persist after app restart

### 7. **Test Logout**

**Test Case 1: Logout Flow**
1. From Dashboard, click Account icon (top-right)
2. ✅ Should show popup menu with "Logout"
3. Click "Logout"
4. ✅ Should return to Login screen
5. ✅ Should clear authentication state

## Expected Issues & Solutions

### Issue 1: Camera Permission Denied
**Symptom:** Camera screen shows permission request
**Solution:** 
- Grant camera permission when prompted
- Or go to device Settings > Apps > Gesture to Speech > Permissions

### Issue 2: MediaPipe Not Initializing
**Symptom:** No gestures detected, or error in logs
**Solution:**
- Check that `gesture_recognizer.task` is in `assets/models/`
- Verify model file is not corrupted
- Check Android logs: `flutter logs`

### Issue 3: TTS Not Working
**Symptom:** No speech output
**Solution:**
- Check device volume
- Verify TTS engine is installed on device
- Check Settings > Language & Input > Text-to-Speech

### Issue 4: App Crashes on Startup
**Symptom:** App closes immediately
**Solution:**
- Check logs: `flutter logs`
- Verify all dependencies installed: `flutter pub get`
- Check Android SDK version (minimum API 24)

## Testing Checklist

### Login & Authentication
- [ ] Login with email works
- [ ] Login with phone works
- [ ] Invalid credentials show error
- [ ] Form validation works
- [ ] Password show/hide toggle works

### Dashboard
- [ ] Dashboard appears after login
- [ ] All action cards visible
- [ ] Navigation to camera works
- [ ] Navigation to settings works
- [ ] Logout works

### Camera & Gesture Recognition
- [ ] Camera permission requested
- [ ] Camera preview shows
- [ ] Camera swap works
- [ ] Gestures detected (if MediaPipe working)
- [ ] Text displayed correctly
- [ ] TTS speaks text

### Settings
- [ ] Voice selection works
- [ ] Voice preview works
- [ ] Pitch control works
- [ ] All settings persist
- [ ] Settings apply to TTS

## Debug Commands

```bash
# View logs
flutter logs

# Check for errors
flutter analyze

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check connected devices
flutter devices

# Build APK for testing
flutter build apk --debug
```

## Performance Testing

1. **Memory Usage**: Monitor during gesture recognition
2. **Frame Rate**: Should maintain smooth camera preview
3. **Battery**: Monitor battery usage during extended use
4. **Response Time**: Gesture recognition should be near real-time

## Known Limitations

1. **MediaPipe Integration**: Currently uses platform channels - may need native Android setup
2. **Model Loading**: First load may take a few seconds
3. **Camera Performance**: May vary based on device capabilities

## Next Steps After Testing

1. Fix any issues found
2. Optimize performance if needed
3. Add error handling improvements
4. Enhance user feedback
5. Test on multiple devices

