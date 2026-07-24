import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../nav_items.dart';

/// Bottom nav bar with a centered scan FAB, matching the logistics mockups.
/// Renders items[0], items[1], the scan FAB, items[2], items[3] — expects
/// exactly 4 entries from nav_items.dart, the same list PremiumSideMenu uses.
class AppBottomNavBar extends StatelessWidget {
  final List<NavItem> items; // expected to be exactly nav_items.dart's 4 entries, see class doc above
  final String currentPath; // current route path — used to highlight the matching tab
  final ValueChanged<String> onSelect; // called with a NavItem's path when a tab (not the FAB) is tapped
  final VoidCallback onScan; // called when the centered scan button is tapped

  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentPath,
    required this.onSelect,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness; // light/dark mode, drives the glassy fill/border colors below
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20), // floats the bar off the screen edges rather than docking flush
      decoration: BoxDecoration(
        color: AppColors.glassFill(brightness), // translucent "glass" background matching the app's premium theme
        borderRadius: BorderRadius.circular(26), // fully-rounded pill shape
        border: Border.all(color: AppColors.glassBorder(brightness)),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: brightness == Brightness.dark ? 0.25 : 0.1), // stronger shadow needed in dark mode to stay visible
            blurRadius: 30,
            offset: const Offset(0, 14), // shadow cast downward, giving the bar a "floating" look
          ),
        ],
      ),
      child: Row(
        children: [
          // Left pair of tabs, then a centered scan FAB, then the right pair —
          // items[0]/[1] and items[2]/[3] straddle the FAB per the class doc above.
          _tab(context, items[0]),
          _tab(context, items[1]),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: onScan,
                child: Container(
                  width: 52,
                  height: 52,
                  margin: const EdgeInsets.only(bottom: 22), // lifts the FAB above the bar so it "pops out" of the pill
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient, // brand gradient makes the scan action stand out from plain tabs
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

  /// Renders one nav item as an equally-spaced tab, swapping icon/color when it's the active route.
  Widget _tab(BuildContext context, NavItem item) {
    final selected = item.path == currentPath;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final off = isDark
        ? Colors.white.withValues(alpha: 0.45) // dimmed white for unselected icons/text on dark backgrounds
        : const Color(0x66000000); // dimmed black (40% alpha) for unselected icons/text on light backgrounds
    final color = selected ? AppColors.primary : off;
    return Expanded( // each tab takes equal width within the Row
      child: InkWell(
        onTap: () => onSelect(item.path),
        borderRadius: BorderRadius.circular(16), // clips the tap ripple to rounded corners
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? item.selectedIcon : item.icon, size: 23, color: color), // filled icon only when active
            const SizedBox(height: 3),
            Text(item.label,
                style: TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400, // bolder label for the active tab
                    color: color)),
          ],
        ),
      ),
    );
  }
}
