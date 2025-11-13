# Quick Test Instructions

## Ready to Test! 🚀

Your application is ready for testing. Follow these steps:

## 1. Connect Your Device

**Option A: Physical Android Device**
- Enable USB debugging
- Connect via USB
- Run: `flutter devices` to verify

**Option B: Android Emulator**
- Start an emulator from Android Studio
- Run: `flutter devices` to verify

## 2. Run the App

```bash
cd d:\NDprototype
flutter run
```

## 3. Test Flow

### Step 1: Login
- Enter email: `test@example.com` OR phone: `1234567890`
- Enter password: `test1234` (any 4+ characters)
- Click "Sign In"
- ✅ Should go to Dashboard

### Step 2: Dashboard
- You'll see three options:
  - **Start Gesture Recognition** → Opens Camera
  - **Train Custom Gestures** → Training screen
  - **Settings** → Settings screen

### Step 3: Test Camera
- Click "Start Gesture Recognition"
- Grant camera permission if asked
- ✅ Camera should open
- ✅ Swap button visible (top-right)
- Show hand gesture to camera
- ✅ Should recognize gesture (if MediaPipe working)
- ✅ Text should appear
- Click "Speak" button
- ✅ Should hear TTS output

### Step 4: Test Settings
- Click "Settings" from dashboard
- ✅ Voice dropdown should show available voices
- ✅ Pitch slider should work (0.5-2.0)
- Click "Preview Voice"
- ✅ Should hear preview
- Adjust pitch and test again

### Step 5: Test Logout
- Click account icon (top-right) on dashboard
- Click "Logout"
- ✅ Should return to login screen

## Expected Behavior

✅ **Login Screen**: Email/phone + password login
✅ **Dashboard**: Options to open camera or settings
✅ **Camera**: Real-time gesture recognition with swap option
✅ **TTS**: Text-to-speech with voice and pitch control
✅ **Settings**: All customization options work

## Troubleshooting

**If camera doesn't work:**
- Check camera permission in device settings
- Verify device has working camera

**If gestures not detected:**
- Check MediaPipe initialization in logs
- Verify model file is present
- Ensure good lighting

**If TTS doesn't work:**
- Check device volume
- Verify TTS engine installed
- Try different voice in settings

## Debug Commands

```bash
# View real-time logs
flutter logs

# Check for issues
flutter doctor

# Clean rebuild
flutter clean && flutter pub get && flutter run
```

## What to Test

1. ✅ Login with email
2. ✅ Login with phone
3. ✅ Dashboard navigation
4. ✅ Camera opens
5. ✅ Camera swap works
6. ✅ Gesture recognition (if MediaPipe working)
7. ✅ TTS output
8. ✅ Voice selection
9. ✅ Pitch control
10. ✅ Settings persistence
11. ✅ Logout

---

**Ready to test! Run `flutter run` and follow the flow above.**

