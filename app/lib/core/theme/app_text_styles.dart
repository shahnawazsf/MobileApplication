import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // loads Poppins without bundling font files

class AppTextStyles {
  AppTextStyles._();

  static TextTheme textTheme(Color onBackground) {
    final base = GoogleFonts.poppinsTextTheme(); // starts from Poppins at Material's default sizes/weights
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
