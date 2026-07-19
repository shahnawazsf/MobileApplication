import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // static-only class — never instantiated

  static const Color primary = Color(0xFF2563EB); // brand blue
  static const Color secondary = Color(0xFF4F46E5); // brand indigo
  static const Color accent = Color(0xFF06B6D4); // cyan accent
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color lightBackground = Color(0xFFF8FAFC);

  static const List<Color> primaryGradient = [primary, secondary]; // used by GradientButton
  static const List<Color> accentGradient = [secondary, accent]; // currently unused but available

  static const List<Color> darkBackgroundGradient = [ // AnimatedGradientBackground's dark-mode base gradient
    Color(0xFF0F172A),
    Color(0xFF1E1B4B),
    Color(0xFF0F172A),
  ];

  static const List<Color> lightBackgroundGradient = [ // light-mode equivalent
    Color(0xFFF8FAFC),
    Color(0xFFE0E7FF),
    Color(0xFFF8FAFC),
  ];

  // translucent fill for GlassCard/SocialLoginButton — lighter alpha in dark mode since the backdrop is already dark
  static Color glassFill(Brightness brightness) => brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.white.withValues(alpha: 0.55);

  static Color glassBorder(Brightness brightness) => brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.white.withValues(alpha: 0.8);
}
