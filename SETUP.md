# Setup Instructions

## Prerequisites

1. **Flutter SDK**: Install Flutter SDK (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Android Studio**: Install Android Studio with:
   - Android SDK (API level 24 or higher)
   - Android SDK Build-Tools
   - Android Emulator or physical device

3. **TensorFlow Lite Model**: You need a trained CNN model for gesture recognition
   - Place your model file at: `Model/gesture_classifier.tflite`
   - Provide a label file at: `Model/labels.txt` (one label per line, in output index order)
   - The default pipeline expects input size `64×64×3` (RGB, normalized to `[0,1]`)

## Installation Steps

### 1. Clone and Setup

```bash
# Navigate to project directory
cd NDprototype

# Get Flutter dependencies
flutter pub get
```

### 2. Model Setup

1. Train or obtain a TensorFlow Lite model for gesture recognition
2. Place the model file at: `Model/gesture_classifier.tflite`
3. Place the label file at: `Model/labels.txt`
4. Update `_runModelOnImage` in `lib/services/flutter_tflite_integration.dart` if your input preprocessing differs

### 3. OpenCV Integration (Optional)

For advanced image preprocessing:

1. Add OpenCV Android SDK to `android/app/build.gradle`:
```gradle
dependencies {
    implementation 'org.opencv:opencv-android:4.8.0'
}
```

2. Initialize OpenCV in native code or use Flutter plugin

### 5. Build and Run

```bash
# Connect Android device or start emulator
flutter devices

# Run the app
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── gesture_result.dart
├── providers/                # State management (Provider pattern)
│   ├── gesture_provider.dart
│   ├── tts_provider.dart
│   └── settings_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   └── training_screen.dart
├── services/                 # Business logic services
│   ├── gesture_recognition_service.dart
│   ├── hand_detection_service.dart
│   ├── gesture_mapping_service.dart
│   └── tts_service.dart
└── widgets/                  # Reusable widgets
    ├── camera_view.dart
    └── gesture_display.dart

Model/                        # TensorFlow Lite model bundle
├── gesture_classifier.tflite
└── labels.txt

assets/
└── gestures/                 # Gesture mappings
    └── gesture_mapping.json

android/                      # Android native code
└── app/
    └── src/main/
        ├── AndroidManifest.xml
        └── kotlin/
            └── MainActivity.kt
```

## Customization

### Adding New Gestures

1. Train your model with new gesture classes
2. Update `assets/gestures/gesture_mapping.json`:
```json
{
  "index_to_name": {
    "10": "new_gesture"
  },
  "gesture_to_text": {
    "new_gesture": "Your Text"
  }
}
```

### Training Custom Gestures

Use the Training Screen in the app:
1. Open the app
2. Tap the training icon (school icon)
3. Enter gesture name and text mapping
4. Record 50+ samples of your gesture
5. Save the gesture

## Troubleshooting

### Camera Permission Issues
- Ensure `android/app/src/main/AndroidManifest.xml` includes camera permission
- Check device settings: Settings > Apps > Gesture to Speech > Permissions

### Model Loading Errors
- Verify model file exists at `Model/gesture_classifier.tflite`
- Confirm `Model/labels.txt` matches your model output order
- Ensure model is optimized for TensorFlow Lite

## Next Steps

1. **Integrate Real MediaPipe**: Replace mock hand detection with actual MediaPipe implementation
2. **Add OpenCV**: Implement advanced image preprocessing
3. **Model Training**: Train your CNN model with diverse gesture datasets
4. **Testing**: Add unit and integration tests
5. **Performance Optimization**: Optimize model inference for real-time processing

## Resources

- Flutter Documentation: https://flutter.dev/docs
- TensorFlow Lite: https://www.tensorflow.org/lite
- MediaPipe: https://mediapipe.dev/
- OpenCV: https://opencv.org/

