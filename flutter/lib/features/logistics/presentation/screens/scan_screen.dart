import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Container barcode / Bayan-QR scanner, matching mockup 3e.
/// The camera preview is stubbed with a placeholder frame — wire a real
/// camera plugin (e.g. mobile_scanner) into [_ScannerFrame] when integrating.
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _roundBtn(context, Icons.close_rounded,
                      onTap: () => Navigator.of(context).maybePop()),
                  const Text('Scan container',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  _roundBtn(context, Icons.flashlight_on_rounded,
                      color: const Color(0xFFD97706)),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 34),
              child: _ScannerFrame(),
            ),
            const SizedBox(height: 18),
            Text('Align the container code or Bayan QR inside the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    color: onSurface.withValues(alpha: 0.55))),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Row(
                children: [
                  Expanded(child: Divider(color: onSurface.withValues(alpha: 0.12))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or enter manually',
                        style: TextStyle(
                            fontSize: 11,
                            color: onSurface.withValues(alpha: 0.4))),
                  ),
                  Expanded(child: Divider(color: onSurface.withValues(alpha: 0.12))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: onSurface.withValues(alpha: 0.14)),
                      ),
                      child: Text('Container / B-L / Bayan number',
                          style: TextStyle(
                              fontSize: 13.5,
                              color: onSurface.withValues(alpha: 0.4))),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _roundBtn(BuildContext context, IconData icon,
      {Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}

class _ScannerFrame extends StatefulWidget {
  const _ScannerFrame();

  @override
  State<_ScannerFrame> createState() => _ScannerFrameState();
}

class _ScannerFrameState extends State<_ScannerFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const cyan = AppColors.accent;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        height: 300,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.1),
            radius: 0.9,
            colors: [Color(0xFF33405F), Color(0xFF1B2440)],
          ),
        ),
        child: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_rounded,
                      size: 44, color: Colors.white38),
                  SizedBox(height: 6),
                  Text('MSKU 704412-3',
                      style: TextStyle(
                          fontSize: 22,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                          color: Colors.white54)),
                ],
              ),
            ),
            ..._corners(cyan),
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) => Positioned(
                left: 24,
                right: 24,
                top: 24 + (300 - 48) * _c.value,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(colors: [
                      Colors.transparent,
                      cyan,
                      Colors.transparent
                    ]),
                    boxShadow: const [
                      BoxShadow(color: cyan, blurRadius: 18)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _corners(Color c) {
    BorderSide side() => BorderSide(color: c, width: 4);
    Widget corner({required Alignment a, required Border border, required BorderRadius r}) =>
        Align(
          alignment: a,
          child: Container(
            width: 34,
            height: 34,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: border, borderRadius: r),
          ),
        );
    return [
      corner(
          a: Alignment.topLeft,
          border: Border(left: side(), top: side()),
          r: const BorderRadius.only(topLeft: Radius.circular(10))),
      corner(
          a: Alignment.topRight,
          border: Border(right: side(), top: side()),
          r: const BorderRadius.only(topRight: Radius.circular(10))),
      corner(
          a: Alignment.bottomLeft,
          border: Border(left: side(), bottom: side()),
          r: const BorderRadius.only(bottomLeft: Radius.circular(10))),
      corner(
          a: Alignment.bottomRight,
          border: Border(right: side(), bottom: side()),
          r: const BorderRadius.only(bottomRight: Radius.circular(10))),
    ];
  }
}
