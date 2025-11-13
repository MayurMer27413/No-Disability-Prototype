import 'dart:convert';
import 'package:flutter/services.dart';

/// Service that maps gesture indices to gesture names and text representations
class GestureMappingService {
  Map<int, String> _gestureIndexToName = {};
  Map<String, String> _gestureToText = {};
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load gesture mapping from assets
      final String jsonString = await rootBundle.loadString('assets/gestures/gesture_mapping.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      // Parse gesture index to name mapping
      final indexMap = data['index_to_name'] as Map<String, dynamic>;
      _gestureIndexToName = indexMap.map((key, value) => MapEntry(int.parse(key), value.toString()));
      
      // Parse gesture to text mapping
      final textMap = data['gesture_to_text'] as Map<String, dynamic>;
      _gestureToText = textMap.map((key, value) => MapEntry(key, value.toString()));
      
      _isInitialized = true;
    } catch (e) {
      // Use default mappings if file not found
      _loadDefaultMappings();
      _isInitialized = true;
    }
  }

  void _loadDefaultMappings() {
    // Default gesture mappings
    _gestureIndexToName = {
      0: 'thumbs_up',
      1: 'thumbs_down',
      2: 'open_palm',
      3: 'closed_fist',
      4: 'pointing',
      5: 'ok_sign',
      6: 'peace',
      7: 'rock',
      8: 'wave',
      9: 'stop',
    };

    _gestureToText = {
      'thumbs_up': 'Yes',
      'thumbs_down': 'No',
      'open_palm': 'Hello',
      'closed_fist': 'Stop',
      'pointing': 'Look',
      'ok_sign': 'Okay',
      'peace': 'Peace',
      'rock': 'Rock',
      'wave': 'Hello',
      'stop': 'Stop',
    };
  }

  String getGestureName(int index) {
    return _gestureIndexToName[index] ?? 'unknown';
  }

  String getTextForGesture(String gestureName) {
    return _gestureToText[gestureName] ?? gestureName;
  }

  int getGestureCount() {
    return _gestureIndexToName.length;
  }

  Map<String, String> getAllMappings() {
    return Map.from(_gestureToText);
  }
}

