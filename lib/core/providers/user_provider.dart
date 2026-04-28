import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider extends ChangeNotifier {
  static const _keyName = 'user_name';
  static const _keyEmail = 'user_email';

  String _name = '';
  String _email = '';

  String get name => _name;
  String get email => _email;

  String get initials {
    if (_name.trim().isNotEmpty) {
      final parts = _name.trim().split(RegExp(r'\s+'));
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return parts[0][0].toUpperCase();
    }

    if (_email.trim().isNotEmpty) {
      return _email.trim()[0].toUpperCase();
    }

    return '?';
  }

  UserProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString(_keyName) ?? '';
    _email = prefs.getString(_keyEmail) ?? '';

    debugPrint('LOADED USER NAME: $_name');
    debugPrint('LOADED USER EMAIL: $_email');

    notifyListeners();
  }

  Future<void> saveUser({
    required String name,
    required String email,
  }) async {
    final cleanName = name.trim();
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty) {
      debugPrint('ERROR: Email is empty. User was not saved correctly.');
      return;
    }

    _name = cleanName.isNotEmpty ? cleanName : cleanEmail.split('@').first;
    _email = cleanEmail;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyName, _name);
    await prefs.setString(_keyEmail, _email);
    await prefs.setString('user_db_$_email', _name);

    debugPrint('SAVED USER NAME: $_name');
    debugPrint('SAVED USER EMAIL: $_email');

    notifyListeners();
  }

  Future<void> loginUser({
    required String email,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty) {
      debugPrint('ERROR: Email is empty. Login user failed.');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    _email = cleanEmail;

    final savedName = prefs.getString('user_db_$_email');

    if (savedName != null && savedName.trim().isNotEmpty) {
      _name = savedName.trim();
    } else {
      _name = _email.split('@').first;
    }

    await prefs.setString(_keyName, _name);
    await prefs.setString(_keyEmail, _email);

    debugPrint('LOGIN USER NAME: $_name');
    debugPrint('LOGIN USER EMAIL: $_email');

    notifyListeners();
  }

  Future<void> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();
    final cleanName = name.trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
          code: 'invalid-input', message: 'Email and password cannot be empty.');
    }

    // 1. Create user in Firebase
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: cleanEmail, password: password);

    // 2. Update display name in Firebase
    await userCredential.user?.updateDisplayName(cleanName);

    // 3. Save locally using existing logic
    await saveUser(name: cleanName, email: cleanEmail);
  }

  Future<void> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim();

    if (cleanEmail.isEmpty || password.isEmpty) {
      throw FirebaseAuthException(
          code: 'invalid-input', message: 'Email and password cannot be empty.');
    }

    // 1. Log in with Firebase
    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: cleanEmail, password: password);

    // 2. Update local state
    final user = userCredential.user;
    if (user != null) {
      final displayName = user.displayName ?? cleanEmail.split('@').first;
      await saveUser(name: displayName, email: cleanEmail);
    }
  }

  Future<void> clearUser() async {
    _name = '';
    _email = '';

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);

    debugPrint('USER CLEARED');

    notifyListeners();
  }

  Future<bool> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(authProvider);
        final user = userCredential.user;

        if (user != null) {
          await saveUser(
            name: user.displayName ?? '',
            email: user.email ?? '',
          );
          return true;
        }
        return false;
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          return false; // The user canceled the sign-in
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final user = userCredential.user;

        if (user != null) {
          await saveUser(
            name: user.displayName ?? '',
            email: user.email ?? '',
          );
          return true;
        }
        return false;
      }
    } catch (e) {
      debugPrint('Google Sign In Error: $e');
      return false;
    }
  }
}
