import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0D0F14);
  static const Color surface = Color(0xFF161A23);
  static const Color surfaceLight = Color(0xFF1E2330);
  static const Color cardBackground = Color(0xFF1A1F2E);

  static const Color accentBlue = Color(0xFF5B8DEF);
  static const Color accentPurple = Color(0xFF9B5DE5);
  static const Color accentPink = Color(0xFFE040A0);

  static const Color textPrimary = Color(0xFFF0F2F8);
  static const Color textSecondary = Color(0xFF8A8FA8);
  static const Color textHint = Color(0xFF4A5068);

  static const Color error = Color(0xFFE05C6F);
  static const Color success = Color(0xFF4ECDC4);
  static const Color warning = Color(0xFFFFC857);

  static const Color border = Color(0xFF252A38);
  static const Color borderFocused = Color(0xFF5B8DEF);
  static const Color divider = Color(0xFF1E2330);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, accentPurple],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0D0F14), Color(0xFF10121A)],
  );

  static const LinearGradient userBubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4A7DE0), Color(0xFF8B4ED4)],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE040A0), Color(0xFF9B5DE5)],
  );
}
