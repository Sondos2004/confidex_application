import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bg => isDark ? AppColors.background : const Color(0xFFF8F9FA);
  Color get surface => isDark ? AppColors.surface : Colors.white;
  Color get surfaceLight => isDark ? AppColors.surfaceLight : const Color(0xFFF1F3F5);
  Color get cardBackground => isDark ? AppColors.cardBackground : Colors.white;
  Color get textPrimary => isDark ? AppColors.textPrimary : AppColors.accentPurple;
  Color get textSecondary => isDark ? AppColors.textSecondary : const Color(0xFF757575);
  Color get textHint => isDark ? AppColors.textHint : const Color(0xFF9E9E9E);
  Color get border => isDark ? AppColors.border : const Color(0xFFE0E0E0);
  Color get divider => isDark ? AppColors.divider : const Color(0xFFEEEEEE);

  /// Returns the pink-purple gradient for light theme, null for dark.
  Gradient? get textGradient =>
      isDark ? null : AppColors.lightTextGradient;

  /// Wraps [child] in a ShaderMask with the pink-purple gradient in light mode.
  /// In dark mode, returns [child] unchanged.
  Widget applyTextGradient(Widget child) {
    if (isDark) return child;
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => AppColors.lightTextGradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: child,
    );
  }
}
