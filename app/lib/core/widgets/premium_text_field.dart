import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // FilteringTextInputFormatter

/// Styled text input used throughout the auth flow (email, password, etc.) —
/// wraps a plain `TextField` with this app's icon/label/error conventions so
/// screens don't repeat the same InputDecoration boilerplate.
class PremiumTextField extends StatelessWidget {
  final String label; // also doubles as the floating label via InputDecoration
  final IconData icon; // leading icon
  final TextEditingController controller;
  final String? errorText; // null = no error shown; set by the caller's validation state
  final bool obscureText; // true for password fields
  final Widget? suffixIcon; // e.g. the password visibility toggle
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints; // enables OS-level autofill suggestions
  final ValueChanged<String> onChanged;
  final TextInputAction textInputAction; // "next" vs "done" on the software keyboard
  final ValueChanged<String>? onSubmitted; // fired on keyboard "done"/enter

  const PremiumTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.onChanged,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField( // Flutter's built-in editable text input; this widget just configures it consistently
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      inputFormatters: keyboardType == TextInputType.emailAddress
          ? [FilteringTextInputFormatter.deny(RegExp(r'\s'))] // blocks accidental spaces in email-shaped fields
          : null,
      decoration: InputDecoration( // border/radius/colors come from AppTheme.inputDecorationTheme
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffixIcon,
        errorText: errorText, // non-null flips the field into its error-styled border automatically
      ),
    );
  }
}
