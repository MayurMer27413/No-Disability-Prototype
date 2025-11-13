import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  Future<void> initialize() async {
    _flutterTts = FlutterTts();
    
    // Set up TTS parameters
    await _flutterTts!.setLanguage('en-US');
    await _flutterTts!.setSpeechRate(0.5);
    await _flutterTts!.setVolume(1.0);
    await _flutterTts!.setPitch(1.0);
    
    // Set completion handler
    _flutterTts!.setCompletionHandler(() {
      // TTS completed
    });
    
    _isInitialized = true;
  }

  Future<void> speak(
    String text, {
    String? language,
    double? rate,
    double? volume,
    double? pitch,
  }) async {
    if (!_isInitialized || _flutterTts == null) {
      await initialize();
    }

    if (language != null) {
      await _flutterTts!.setLanguage(language);
    }
    if (rate != null) {
      await _flutterTts!.setSpeechRate(rate);
    }
    if (volume != null) {
      await _flutterTts!.setVolume(volume);
    }
    if (pitch != null) {
      await _flutterTts!.setPitch(pitch);
    }

    await _flutterTts!.speak(text);
  }

  Future<void> stop() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
    }
  }

  Future<List<dynamic>> getLanguages() async {
    if (_flutterTts == null) {
      await initialize();
    }
    return await _flutterTts!.getLanguages ?? [];
  }

  Future<List<dynamic>> getVoices() async {
    if (_flutterTts == null) {
      await initialize();
    }
    return await _flutterTts!.getVoices ?? [];
  }

  Future<void> setVoice(Map<String, String> voice) async {
    if (_flutterTts == null) {
      await initialize();
    }
    await _flutterTts!.setVoice(voice);
  }

  Future<Map<String, String>?> getDefaultVoice() async {
    if (_flutterTts == null) {
      await initialize();
    }
    // Get the default voice for the current language
    final voices = await getVoices();
    if (voices.isEmpty) return null;
    
    // Try to find a voice matching the current language
    // Note: FlutterTts doesn't have getLanguage getter, we'll use a default
    final currentLanguage = 'en-US';
    for (var voice in voices) {
      if (voice is Map) {
        final locale = voice['locale']?.toString() ?? '';
        if (locale.startsWith(currentLanguage.split('-')[0])) {
          return Map<String, String>.from(
            voice.map((key, value) => 
              MapEntry(key.toString(), value.toString())
            )
          );
        }
      }
    }
    
    // Return first available voice if no match
    if (voices.isNotEmpty && voices[0] is Map) {
      return Map<String, String>.from(
        (voices[0] as Map).map((key, value) => 
          MapEntry(key.toString(), value.toString())
        )
      );
    }
    
    return null;
  }

  void dispose() {
    _flutterTts = null;
    _isInitialized = false;
  }
}

