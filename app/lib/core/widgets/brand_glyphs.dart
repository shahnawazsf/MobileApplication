import 'package:flutter/material.dart';

/// Lightweight brand glyphs so social login buttons don't need bundled logo
/// assets. Swap for official SVG/PNG brand marks before shipping.
class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key});

  @override
  Widget build(BuildContext context) => const Text(
        'G', // stand-in for the real Google "G" logo mark
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF4285F4), // Google's brand blue
        ),
      );
}

class AppleGlyph extends StatelessWidget {
  const AppleGlyph({super.key});

  @override
  Widget build(BuildContext context) => Icon(
        Icons.apple, // Material's built-in Apple glyph — close enough to the real mark
        size: 24,
        color: Theme.of(context).colorScheme.onSurface, // adapts to light/dark automatically
      );
}

class MicrosoftGlyph extends StatelessWidget {
  const MicrosoftGlyph({super.key});

  static const _colors = [ // the four squares of Microsoft's logo, in their brand colors
    Color(0xFFF25022), // red
    Color(0xFF7FBA00), // green
    Color(0xFF00A4EF), // blue
    Color(0xFFFFB900), // yellow
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: GridView.count( // 2x2 grid of solid-color squares approximating the logo
        crossAxisCount: 2,
        physics: const NeverScrollableScrollPhysics(), // it's a fixed icon, not a scrollable list
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: _colors.map((c) => ColoredBox(color: c)).toList(),
      ),
    );
  }
}
