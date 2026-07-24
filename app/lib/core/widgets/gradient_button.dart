import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Primary call-to-action button: gradient fill, press-shrink animation, and
/// a built-in loading-spinner state, used for e.g. the login submit button.
// StatefulWidget: needs mutable state (whether it's currently pressed) to drive the scale animation, so it can't be a StatelessWidget.
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed; // null disables the button (also drives the disabled visual state)
  final bool isLoading; // shows a spinner instead of the label and blocks taps

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

// The State object holds `_pressed` across rebuilds and calling setState() here is what tells Flutter to re-run build().
class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false; // tracks finger-down state for the scale animation

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // low-level widget for raw touch callbacks (tap down/up/cancel) — used instead of a Material button so the gradient fill can be fully custom
      onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: _enabled ? () => setState(() => _pressed = false) : null, // e.g. finger dragged off the button
      onTap: _enabled ? widget.onPressed : null, // gated like the other callbacks so a tap can't sneak through while loading/disabled
      child: AnimatedScale( // the "press" shrink effect
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut, // curve: shapes the animation's speed over time — easeOut starts fast and settles gently instead of moving at a constant rate
        child: AnimatedOpacity( // fades the whole button when disabled
          opacity: _enabled ? 1.0 : 0.55,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: AppColors.primaryGradient),
              boxShadow: [
                BoxShadow( // gives the button a floating, lit-from-above look
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: AnimatedSwitcher( // cross-fades between the label and the spinner
              duration: const Duration(milliseconds: 200),
              child: widget.isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'), // distinct keys are required so AnimatedSwitcher detects the swap
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Text(
                      widget.label,
                      key: const ValueKey('label'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
