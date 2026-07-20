import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../nav_items.dart';

/// Bottom nav bar with a centered scan FAB, matching the logistics mockups.
/// Renders items[0], items[1], the scan FAB, items[2], items[3] — expects
/// exactly 4 entries from nav_items.dart, the same list PremiumSideMenu uses.
class AppBottomNavBar extends StatelessWidget {
  final List<NavItem> items;
  final String currentPath;
  final ValueChanged<String> onSelect;
  final VoidCallback onScan;

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentPath,
    required this.onSelect,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.glassFill(brightness),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.glassBorder(brightness)),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: brightness == Brightness.dark ? 0.25 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          _tab(context, items[0]),
          _tab(context, items[1]),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onScan,
                child: Container(
                  width: 52,
                  height: 52,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded,
                      color: Colors.white, size: 25),
                ),
              ),
            ),
          ),
          _tab(context, items[2]),
          _tab(context, items[3]),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, NavItem item) {
    final selected = item.path == currentPath;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final off = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : const Color(0x66000000);
    final color = selected ? AppColors.primary : off;
    return Expanded(
      child: InkWell(
        onTap: () => onSelect(item.path),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? item.selectedIcon : item.icon, size: 23, color: color),
            const SizedBox(height: 3),
            Text(item.label,
                style: TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    color: color)),
          ],
        ),
      ),
    );
  }
}
