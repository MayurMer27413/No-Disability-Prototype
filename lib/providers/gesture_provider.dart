import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import '../services/gesture_recognition_service.dart';
import '../models/gesture_result.dart';

class GestureProvider extends ChangeNotifier {
  final GestureRecognitionService _gestureService = GestureRecognitionService();
  
  GestureResult? _currentGesture;
  bool _isProcessing = false;
  bool _isInitialized = false;
  String? _errorMessage;

  GestureResult? get currentGesture => _currentGesture;
  bool get isProcessing => _isProcessing;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    try {
      _isProcessing = true;
      notifyListeners();
      
      await _gestureService.initialize();
      _isInitialized = true;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to initialize gesture recognition: $e';
      _isInitialized = false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // Minimum probability to accept a prediction.
  static const double _confidenceThreshold = 0.3;

  Future<void> processFrame(img.Image image) async {
    if (!_isInitialized || _isProcessing) return;

    try {
      _isProcessing = true;
      notifyListeners();

      final result = await _gestureService.recognizeGesture(image);

      if (result != null) {
        final confidencePct = (result.confidence * 100).toStringAsFixed(1);
        debugPrint('Gesture detected: ${result.gestureName} ($confidencePct%)');

        if (result.confidence >= _confidenceThreshold) {
          final isNewGesture =
              _currentGesture?.gestureName != result.gestureName ||
              (_currentGesture?.confidence ?? 0) < result.confidence;

          if (isNewGesture) {
            _currentGesture = result;
            _errorMessage = null;
          }
        } else {
          debugPrint(
            'Confidence below threshold ($_confidenceThreshold). '
            'Ignoring result ${result.gestureName} ($confidencePct%).',
          );
        }
      } else {
        _currentGesture = null;
      }
    } catch (e) {
      _errorMessage = 'Error processing frame: $e';
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clearGesture() {
    _currentGesture = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _gestureService.dispose();
    super.dispose();
  }
}

