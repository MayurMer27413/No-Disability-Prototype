import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import '../models/gesture_result.dart';
import 'flutter_tflite_integration.dart' as tflite;
import 'gesture_mapping_service.dart';

/// Gesture Recognition Service
/// 
/// This service orchestrates gesture recognition using your on-device TFLite model.
class GestureRecognitionService {
  final tflite.GestureRecognizer _tflite = tflite.GestureRecognizer();
  final GestureMappingService _mapping = GestureMappingService();
  
  bool _isInitialized = false;

  Future<void> initialize() async {
    try {
      final ok = await _tflite.loadModel();
      if (!ok) {
        throw Exception('TFLite model failed to load');
      }
      await _mapping.initialize();
      
      _isInitialized = true;
      debugPrint('Gesture Recognition Service initialized (TFLite)');
    } catch (e) {
      throw Exception('Failed to initialize gesture recognition: $e');
    }
  }

  /// Recognizes gesture from an RGB image.
  Future<GestureResult?> recognizeGesture(
    img.Image image,
  ) async {
    if (!_isInitialized) {
      return null;
    }

    try {
      final result = _tflite.recognizeGestureFromImage(image);
      if (result == null) return null;

      final gesture = (result['gesture'] as String?) ?? '';
      final confidence = (result['confidence'] as num?)?.toDouble() ?? 0.0;
      if (gesture.isEmpty) return null;

      final predictions = result['all_predictions'] as Map<dynamic, dynamic>?;
      if (predictions != null) {
        debugPrint(
          'Predictions: ${predictions.map((key, value) => MapEntry(key.toString(), (value as num).toStringAsFixed(3)))}',
        );
      }

      final text = _mapping.getTextForGesture(gesture);
      return GestureResult(
        gestureName: gesture,
        confidence: confidence,
        textRepresentation: text,
      );
    } catch (e) {
      debugPrint('Error in gesture recognition: $e');
      return null;
    }
  }

  void dispose() {
    _tflite.dispose();
    _isInitialized = false;
  }
}

