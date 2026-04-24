import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // New Dark Theme Background
  static const Color background = Color(0xFF0B0914);
  
  // Solid card surfaces instead of glassmorphism
  static const Color surface = Color(0xFF151326);
  static const Color surfaceLight = Color(0xFF1D1A31);
  static const Color cardBackground = Color(0xFF151326);

  static const Color accentPurple = Color(0xFF9D44FD);
  static const Color accentPink = Color(0xFFF2439A);
  static const Color accentBlue = Color(0xFF5B8DEF);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8C9F);
  static const Color textHint = Color(0xFF6B697D);

  static const Color error = Color(0xFFE05C6F);
  static const Color success = Color(0xFF4ECDC4);
  static const Color warning = Color(0xFFFFC857);

  // Borders
  static const Color border = Color(0xFF2D2554); // For dashed lines
  static const Color borderFocused = Color(0xFF9D44FD);
  static const Color divider = Color(0xFF1D1A31);

  // The new button gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [accentPurple, accentPink],
  );

  // Report Score Colors
  static const Color scoreConfidence = Color(0xFF9D44FD);
  static const Color scoreNervousness = Color(0xFFF2439A);
  static const Color scoreAccuracy = Color(0xFF4ECDC4);
  static const Color scoreOverall = Color(0xFFFFC857);
}
