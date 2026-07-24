import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Square glassy button for a single social sign-in provider (Google/Apple/
/// Microsoft) — pairs with a glyph from `brand_glyphs.dart`.
// Currently unused on screen (social login is commented out in login_screen.dart)
// but kept ready for when real OAuth is wired up.
// StatefulWidget: needs mutable state (whether it's currently pressed) to drive the press-shrink animation below.
class SocialLoginButton extends StatefulWidget {
  final String label; // not rendered — kept for a11y/tooltip use if this is re-enabled
  final Widget icon; // e.g. GoogleGlyph/AppleGlyph/MicrosoftGlyph from brand_glyphs.dart
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<SocialLoginButton> createState() => _SocialLoginButtonState();
}

class _SocialLoginButtonState extends State<SocialLoginButton> {
  bool _pressed = false; // tracks finger-down state for the scale animation, set via setState() below

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Expanded( // assumes it's a direct child of a Row, sharing width equally with its siblings
      child: GestureDetector( // raw tap callbacks, used instead of a Material button so the glass fill can be fully custom
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale( // press-shrink feedback, same pattern as GradientButton
          scale: _pressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.glassFill(brightness), // same glass treatment as GlassCard, at a smaller radius
              border: Border.all(color: AppColors.glassBorder(brightness)),
            ),
            alignment: Alignment.center,
            child: widget.icon,
          ),
        ),
      ),
    );
  }
}
