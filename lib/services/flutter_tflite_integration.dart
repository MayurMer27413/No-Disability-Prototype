// Flutter on-device integration using TensorFlow Lite
// This allows you to use the model directly in your app without cloud API

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

const _modelAssetPath = 'Model/gesture_classifier.tflite';
const _labelAssetPath = 'Model/labels.txt';

class GestureRecognizer {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isLoaded = false;
  
  /// Load the TFLite model and labels
  Future<bool> loadModel() async {
    try {
      // Load TFLite model
      _interpreter = await Interpreter.fromAsset(_modelAssetPath);
      
      // Load class labels
      final labelData = await rootBundle.loadString(_labelAssetPath);
      _labels = labelData
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      
      _isLoaded = true;
      print('✓ Model loaded successfully');
      print('✓ Labels: $_labels');
      return true;
    } catch (e) {
      print('✗ Error loading model: $e');
      _isLoaded = false;
      return false;
    }
  }
  
  /// Recognize gesture from image file
  /// Returns the gesture class name and confidence score
  Map<String, dynamic>? recognizeGesture(File imageFile) {
    if (!_isLoaded || _interpreter == null) {
      print('Model not loaded');
      return null;
    }
    
    try {
      // Read and decode image
      final imageBytes = imageFile.readAsBytesSync();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        print('Failed to decode image');
        return null;
      }
      
      return _runModelOnImage(image);
    } catch (e) {
      print('Error recognizing gesture: $e');
      return null;
    }
  }
  
  /// Recognize gesture from image bytes (useful for camera)
  Map<String, dynamic>? recognizeGestureFromBytes(Uint8List imageBytes) {
    if (!_isLoaded || _interpreter == null) {
      return null;
    }
    
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) return null;
      
      return _runModelOnImage(image);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /// Recognize gesture directly from an already decoded image.
  Map<String, dynamic>? recognizeGestureFromImage(img.Image image) {
    if (!_isLoaded || _interpreter == null) {
      return null;
    }

    try {
      return _runModelOnImage(image);
    } catch (e) {
      print('Error running inference: $e');
      return null;
    }
  }
  
  /// Convert image to tensor format
  List<List<List<List<double>>>> _imageToTensor(img.Image image) {
    final tensor = List.generate(
      1,
      (_) => List.generate(
        64,
        (_) => List.generate(
          64,
          (_) => List.filled(3, 0.0),
        ),
      ),
    );
    
    for (int y = 0; y < 64; y++) {
      for (int x = 0; x < 64; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        tensor[0][y][x][0] = r / 255.0;
        tensor[0][y][x][1] = g / 255.0;
        tensor[0][y][x][2] = b / 255.0;
      }
    }
    
    return tensor;
  }
  
  /// Check if model is loaded
  bool get isLoaded => _isLoaded;
  
  /// Get available labels
  List<String> get labels => _labels;
  
  /// Dispose resources
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }

  Map<String, dynamic>? _runModelOnImage(img.Image image) {
    final resized = img.copyResize(image, width: 64, height: 64);
    final input = _imageToTensor(resized);
    final output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter!.run(input, output);

    final predictions = output[0] as List<double>;
    double maxConfidence = 0.0;
    int maxIndex = 0;

    for (int i = 0; i < predictions.length; i++) {
      if (predictions[i] > maxConfidence) {
        maxConfidence = predictions[i];
        maxIndex = i;
      }
    }

    return {
      'gesture': _labels[maxIndex],
      'confidence': maxConfidence,
      'all_predictions': Map.fromIterables(
        _labels,
        predictions,
      ),
    };
  }
}

// Example usage in a Flutter widget:
/*
class GestureRecognitionPage extends StatefulWidget {
  @override
  _GestureRecognitionPageState createState() => _GestureRecognitionPageState();
}

class _GestureRecognitionPageState extends State<GestureRecognitionPage> {
  final GestureRecognizer _recognizer = GestureRecognizer();
  String? _currentGesture;
  double? _confidence;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadModel();
  }
  
  Future<void> _loadModel() async {
    setState(() => _isLoading = true);
    final loaded = await _recognizer.loadModel();
    setState(() => _isLoading = false);
    
    if (!loaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load model')),
      );
    }
  }
  
  Future<void> _recognizeFromFile(File imageFile) async {
    final result = _recognizer.recognizeGesture(imageFile);
    if (result != null) {
      setState(() {
        _currentGesture = result['gesture'];
        _confidence = result['confidence'];
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gesture Recognition')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              CircularProgressIndicator()
            else if (_currentGesture != null) ...[
              Text('Gesture: $_currentGesture'),
              Text('Confidence: ${(_confidence! * 100).toStringAsFixed(1)}%'),
            ],
            ElevatedButton(
              onPressed: () {
                // Pick image and recognize
                // final imageFile = await pickImage();
                // await _recognizeFromFile(imageFile);
              },
              child: Text('Recognize Gesture'),
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }
}
*/

