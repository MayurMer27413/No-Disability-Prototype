import 'package:flutter/foundation.dart';
import '../services/tts_service.dart';

class TTSProvider extends ChangeNotifier {
  final TTSService _ttsService = TTSService();
  
  bool _isSpeaking = false;
  String? _currentText;
  String _selectedLanguage = 'en-US';
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;
  Map<String, String>? _selectedVoice;

  bool get isSpeaking => _isSpeaking;
  String? get currentText => _currentText;
  String get selectedLanguage => _selectedLanguage;
  double get speechRate => _speechRate;
  double get volume => _volume;
  double get pitch => _pitch;
  Map<String, String>? get selectedVoice => _selectedVoice;

  Future<void> initialize() async {
    await _ttsService.initialize();
    // Set default voice
    _selectedVoice = await _ttsService.getDefaultVoice();
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      _currentText = text;
      _isSpeaking = true;
      notifyListeners();

      // Set voice if selected
      if (_selectedVoice != null) {
        await _ttsService.setVoice(_selectedVoice!);
      }
      
      await _ttsService.speak(
        text,
        language: _selectedLanguage,
        rate: _speechRate,
        volume: _volume,
        pitch: _pitch,
      );

      _isSpeaking = false;
      notifyListeners();
    } catch (e) {
      _isSpeaking = false;
      notifyListeners();
      debugPrint('TTS Error: $e');
    }
  }

  void setLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  void setSpeechRate(double rate) {
    _speechRate = rate.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setVolume(double vol) {
    _volume = vol.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setPitch(double p) {
    _pitch = p.clamp(0.5, 2.0);
    notifyListeners();
  }

  Future<void> setVoice(Map<String, String> voice) async {
    _selectedVoice = voice;
    await _ttsService.setVoice(voice);
    notifyListeners();
  }

  Future<void> stop() async {
    await _ttsService.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  Future<List<dynamic>> getLanguages() async {
    return await _ttsService.getLanguages();
  }

  Future<List<dynamic>> getVoices() async {
    return await _ttsService.getVoices();
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}

