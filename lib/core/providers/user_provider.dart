import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';

  String _name = '';
  String _email = '';

  String get name => _name;
  String get email => _email;

  /// Initials for the avatar — up to 2 letters from the name, or first letter
  /// of email if name is empty.
  String get initials {
    if (_name.isNotEmpty) {
      final parts = _name.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return parts[0][0].toUpperCase();
    }
    if (_email.isNotEmpty) return _email[0].toUpperCase();
    return '?';
  }

  UserProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString(_keyName) ?? '';
    _email = prefs.getString(_keyEmail) ?? '';
    notifyListeners();
  }

  Future<void> saveUser({required String name, required String email}) async {
    _name = name.trim();
    _email = email.trim();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, _name);
    await prefs.setString(_keyEmail, _email);
  }

  Future<void> clearUser() async {
    _name = '';
    _email = '';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
  }
}