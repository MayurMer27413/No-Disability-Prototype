# Quick Start Guide

## Step 1: Prerequisites Setup

1. **Install Flutter** (if not already installed)
   ```bash
   # Check Flutter installation
   flutter doctor
   ```

2. **Install Android Studio** with:
   - Android SDK (API 24+)
   - Android Emulator or connect a physical device

## Step 2: Project Setup

```bash
# Navigate to project directory
cd NDprototype

# Get dependencies
flutter pub get
```

## Step 3: Add TensorFlow Lite Model

1. Obtain or train a gesture recognition model
2. Convert to TensorFlow Lite format
3. Place the model file at: `Model/gesture_classifier.tflite`
4. Provide label file at: `Model/labels.txt` (one label per line)

**Note**: For initial testing, the app will work with mock data even without a model, but gesture recognition won't function properly.

## Step 4: Run the App

```bash
# List available devices
flutter devices

# Run on connected device/emulator
flutter run
```

## Step 5: First Run

1. **Grant Permissions**: Allow camera access when prompted
2. **Home Screen**: You'll see the camera preview
3. **Show Gestures**: Display hand gestures to the camera
4. **View Results**: Recognized gestures appear in the bottom panel
5. **Speak**: Tap the "Speak" button to hear the text

## Step 6: Configure Settings

1. Tap the **Settings** icon (top right)
2. Adjust:
   - **Accessibility**: High contrast mode, text scale
   - **Audio**: Sound and vibration settings
   - **Speech**: Language, rate, volume, pitch

## Step 7: Train Custom Gestures

1. Tap the **Training** icon (school icon)
2. Enter:
   - Gesture name (e.g., "my_gesture")
   - Text representation (e.g., "Hello")
3. Click **Start Recording**
4. Show your gesture 50+ times
5. Click **Save Gesture**

## Troubleshooting

### Camera Not Working
- Check device permissions: Settings > Apps > Gesture to Speech > Permissions
- Ensure device has a working camera

### Model Loading Error
- Verify `Model/gesture_classifier.tflite` and `Model/labels.txt` exist
- Check model file is valid TensorFlow Lite format
- Review console logs for specific errors

### No Gestures Detected
- Ensure good lighting
- Keep hand in camera frame
- Watch debug logs for prediction confidences (adjust threshold if needed)

### App Crashes
- Check Flutter version: `flutter --version` (should be 3.0+)
- Run `flutter clean` and `flutter pub get`
- Check device meets minimum requirements (4GB RAM, API 24+)

## Next Steps

1. **Fine-tune Thresholds**: Adjust confidence levels in `GestureProvider`
2. **Improve Preprocessing**: Tweak resizing/normalization in `CameraView` or `flutter_tflite_integration.dart`
3. **Train Your Model**: Create custom gesture recognition model
4. **Customize Gestures**: Add your own gesture mappings
5. **Test on Device**: Ensure performance on target devices

## Development Mode

The app currently uses **mock data** for hand detection to enable development without MediaPipe integration. To use real gesture recognition:

1. Integrate MediaPipe SDK (see SETUP.md)
2. Update `lib/services/hand_detection_service.dart`
3. Add your trained TensorFlow Lite model
4. Test with real gestures

## Support

For detailed setup instructions, see `SETUP.md`
For architecture details, see `ARCHITECTURE.md`
For project overview, see `README.md`

