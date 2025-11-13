import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;
  String? _userPhone;

  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;

  AuthProvider() {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
    _userId = prefs.getString('user_id');
    _userEmail = prefs.getString('user_email');
    _userPhone = prefs.getString('user_phone');
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    try {
      // Validate input
      if (identifier.isEmpty || password.isEmpty) {
        return false;
      }

      // Simple validation - in production, this would call an authentication API
      // For now, we'll do basic validation and store locally
      
      // Check if identifier is email or phone
      final isEmail = identifier.contains('@');
      final isPhone = RegExp(r'^[0-9+\-\s()]+$').hasMatch(identifier);

      if (!isEmail && !isPhone) {
        return false;
      }

      // In production, verify credentials with backend API
      // For demo purposes, accept any non-empty password
      if (password.length < 4) {
        return false;
      }

      // Store authentication state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_authenticated', true);
      await prefs.setString('user_id', identifier);
      
      if (isEmail) {
        await prefs.setString('user_email', identifier);
        _userEmail = identifier;
      } else {
        await prefs.setString('user_phone', identifier);
        _userPhone = identifier;
      }

      _isAuthenticated = true;
      _userId = identifier;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_authenticated');
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_phone');

    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    _userPhone = null;
    notifyListeners();
  }
}

