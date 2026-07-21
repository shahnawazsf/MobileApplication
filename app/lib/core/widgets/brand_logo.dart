import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // .animate().scaleXY() pop-in below

/// The circular gradient app-icon mark — shared by the login screen and the
/// splash screen so both show the exact same brand treatment.
class BrandLogo extends StatelessWidget {
  final double size;

  const BrandLogo({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2563EB), Color(0xFF4F46E5)], // same brand blue/indigo pair as AppColors.primaryGradient
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 12), // glow falls downward, matching the card's shadow direction
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.19), // keeps the mark's inset proportional at any size
      child: Image.asset('assets/images/logo.png', fit: BoxFit.contain), // brand mark
    ).animate().scaleXY(begin: 0.6, end: 1, duration: 500.ms, curve: Curves.easeOutBack); // pops in with a slight overshoot
  }
}
