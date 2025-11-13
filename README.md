# Gesture to Speech - Android App

An Android application that recognizes hand gestures in real-time and converts them to speech, designed with accessibility in mind.

## Features

- **Real-time Hand Gesture Recognition**: Uses MediaPipe, OpenCV, and CNN-based TensorFlow Lite models
- **Text & Speech Conversion**: Maps gestures to text and converts to natural speech
- **Multilingual Support**: Supports multiple languages for text and speech output
- **Accessibility Features**: High-contrast UI, large buttons, adaptive text scaling
- **Custom Gesture Training**: Train the system with your own unique gestures
- **On-Device Processing**: All AI processing happens locally for low latency

## System Requirements

- Android 7.0 (API level 24) or higher
- Camera: 8 MP or higher
- RAM: 4 GB minimum
- Multi-core processor

## Architecture

The app follows a modular architecture:

1. **Camera Module**: Captures real-time video frames
2. **Hand Detection Module**: Uses MediaPipe for hand landmark detection
3. **Preprocessing Module**: OpenCV for image preprocessing
4. **Gesture Recognition Module**: CNN model via TensorFlow Lite
5. **Text Mapping Module**: Maps gestures to text representations
6. **TTS Module**: Converts text to speech
7. **UI Module**: Flutter-based responsive interface

## Setup Instructions

1. Clone the repository
2. Run `flutter pub get`
3. Place your trained TensorFlow Lite model at `Model/gesture_classifier.tflite` and label file at `Model/labels.txt`
4. Build and run on Android device

## License

MIT License

