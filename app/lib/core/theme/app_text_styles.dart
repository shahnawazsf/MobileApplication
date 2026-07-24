import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // loads Poppins without bundling font files

/// Builds the app's Material `TextTheme` — the named set of text styles
/// (displayLarge, bodyMedium, etc.) that widgets like `Text` pick up
/// automatically from `Theme.of(context)`.
class AppTextStyles {
  AppTextStyles._();

  /// Returns a Poppins-based TextTheme with this app's custom sizes/weights,
  /// tinted for whichever brightness is active (light vs dark text color).
  static TextTheme textTheme(Color onBackground) {
    final base = GoogleFonts.poppinsTextTheme(); // starts from Poppins at Material's default sizes/weights
    // copyWith: TextTheme (like most Flutter style objects) is immutable, so this returns a new TextTheme with only the listed styles replaced.
    return base.copyWith( // override just the sizes/weights/color the design calls for
      displayLarge: base.displayLarge?.copyWith( // used for the "Welcome back" heading
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: onBackground,
        letterSpacing: -0.5, // tightened slightly for a large heading
      ),
      headlineSmall: base.headlineSmall?.copyWith( // section-title scale
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      bodyLarge: base.bodyLarge?.copyWith( // primary body text
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onBackground,
      ),
      bodyMedium: base.bodyMedium?.copyWith( // secondary/caption text
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onBackground,
      ),
      labelLarge: base.labelLarge?.copyWith( // button label scale
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
    );
  }
}
