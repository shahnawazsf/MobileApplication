import 'package:flutter/material.dart';

/// Single source of truth for every color/gradient used across the app's
/// theme, so a designer can tweak the palette in one place.
class AppColors {
  AppColors._(); // static-only class — never instantiated

  // static const: computed once at compile time and shared by every caller — cheaper than a getter and safe to use in const widgets.
  // Color(0xAARRGGBB): hex literal where the first byte pair is alpha (opacity), then red, green, blue — 0xFF alpha means fully opaque.
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
  // withValues(alpha: ...): returns a copy of the color with just its opacity changed, 0.0 = invisible, 1.0 = fully solid.
  static Color glassFill(Brightness brightness) => brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.06)
      : Colors.white.withValues(alpha: 0.55);

  // border color for the same glass panels — brighter/more opaque in light mode so the edge is still visible against a light backdrop
  static Color glassBorder(Brightness brightness) => brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.white.withValues(alpha: 0.8);
}
