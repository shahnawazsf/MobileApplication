import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder; // not exported from material.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = _build(Brightness.light); // computed once at class-load time
  static ThemeData dark = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final onBackground = isDark ? Colors.white : const Color(0xFF0F172A); // text color for this brightness

    final colorScheme = ColorScheme.fromSeed( // generates the full Material 3 palette from the brand seed color
      seedColor: AppColors.primary,
      brightness: brightness,
      primary: AppColors.primary, // pin these explicitly rather than letting fromSeed derive them
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      error: AppColors.error,
      surface: isDark ? AppColors.darkBackground : AppColors.lightBackground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: AppTextStyles.textTheme(onBackground),
      splashFactory: InkRipple.splashFactory, // Material ripple on tappable widgets
      inputDecorationTheme: InputDecorationTheme( // applies to every TextField app-wide, incl. PremiumTextField
        filled: true,
        fillColor: Colors.transparent, // the glass card behind it provides the fill, not the field itself
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder( // default (unfocused, no error) border
          borderRadius: BorderRadius.circular(20), // matches the "Rounded Radius 20" spec
          borderSide: BorderSide(color: AppColors.glassBorder(brightness)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.glassBorder(brightness)),
        ),
        focusedBorder: OutlineInputBorder( // shown while the field has focus
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder( // shown when errorText is set and unfocused
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder( // shown when errorText is set AND focused
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 1.6),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      pageTransitionsTheme: PageTransitionsTheme( // platform-appropriate screen transition animation
        builders: {
          TargetPlatform.android: const FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(), // iOS's native slide-over-edge feel
        },
      ),
    );
  }
}
