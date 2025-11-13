# Custom TFLite Gesture Recognizer Integration

## Overview

The app runs gesture recognition fully on-device using your custom TensorFlow Lite model (`Model/gesture_classifier.tflite`).

## Required Assets

| File | Purpose | pubspec.yaml entry |
| ---- | ------- | ------------------ |
| `Model/gesture_classifier.tflite` | Trained gesture classifier | `Model/gesture_classifier.tflite` |
| `Model/labels.txt` | Gesture labels in index order | `Model/labels.txt` |
| `assets/gestures/gesture_mapping.json` | Optional gesture → text overrides | `assets/gestures/` |

## Runtime Flow

1. `CameraView` captures camera frames (YUV420), converts them to RGB, rotates/flips them to match device orientation, and resizes to 64×64.
2. `GestureProvider` feeds the processed frame to `GestureRecognitionService`.
3. `GestureRecognitionService` uses `flutter_tflite_integration.GestureRecognizer` to run inference.
4. The most probable gesture is mapped to display text (via `GestureMappingService`) and published to the UI and text-to-speech layer.

## Model Requirements

- Input tensor: `1 × 64 × 64 × 3`, float32, values normalized to `[0, 1]`.
- Output tensor: `1 × N` probabilities aligned with `labels.txt`.
- If your model uses a different input size or normalization, update `_runModelOnImage` in `lib/services/flutter_tflite_integration.dart`.

## Updating the Model

1. Replace `Model/gesture_classifier.tflite` with your new model file.
2. Update `Model/labels.txt` so each line matches the class index order produced by the model.
3. Run `flutter pub get` to refresh asset fingerprints.
4. Rebuild or run the app.

## Confidence Threshold

`lib/providers/gesture_provider.dart` exposes `_confidenceThreshold` (default `0.3`). Raise/lower it to control how confident the model must be before updating the current gesture.

## Troubleshooting

- **Model fails to load**  
  Check that both asset files are present and listed in `pubspec.yaml`.

- **Gestures not detected**  
  - Inspect debug logs; each frame prints the predicted label and confidence.  
  - Verify lighting and hand visibility.  
  - Ensure the model was trained on RGB images with similar preprocessing.

- **Incorrect text output**  
  Edit `assets/gestures/gesture_mapping.json` or update the default mappings in `lib/services/gesture_mapping_service.dart`.

## Related Files

- `lib/services/flutter_tflite_integration.dart`
- `lib/services/gesture_recognition_service.dart`
- `lib/widgets/camera_view.dart`
- `lib/providers/gesture_provider.dart`

