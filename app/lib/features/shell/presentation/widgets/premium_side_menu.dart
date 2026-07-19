
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../nav_items.dart';

class PremiumSideMenu extends StatelessWidget {
  final User? user;
  final String currentPath;
  final ValueChanged<String> onSelect;
  final VoidCallback onLogout;

  const PremiumSideMenu({
    super.key,
    required this.user,
    required this.currentPath,
    required this.onSelect,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final theme = Theme.of(context);

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: AppColors.glassFill(brightness),
        border: Border(right: BorderSide(color: AppColors.glassBorder(brightness))),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: gradient avatar (initials fallback — no photo backing this yet)
            // + name/description from the signed-in User entity.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: AppColors.primaryGradient),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(user?.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          user?.name ?? '',
                          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.description ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Staggered fade/slide-in, matching the entrance treatment login_screen.dart
              // uses on its heading text via flutter_animate.
            ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1, end: 0),
            Divider(height: 1, color: AppColors.glassBorder(brightness)),
            const SizedBox(height: 12),
            // Nav list — each tile animates in with an increasing delay (60ms * index)
            // so they cascade rather than all appearing at once.
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (var i = 0; i < navItems.length; i++)
                    _NavTile(
                      item: navItems[i],
                      selected: currentPath == navItems[i].path,
                      onTap: () => onSelect(navItems[i].path),
                    )
                        .animate()
                        .fadeIn(delay: (60 * i).ms, duration: 250.ms)
                        .slideX(begin: -0.1, end: 0),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.glassBorder(brightness)),
            // Logout pinned below the divider, separated from ordinary nav items and
            // styled in AppColors.error via isDestructive so it reads as a distinct action.
            Padding(
              padding: const EdgeInsets.all(12),
              child: _NavTile(
                item: const NavItem(
                  icon: Icons.logout_rounded,
                  selectedIcon: Icons.logout_rounded,
                  label: 'Log Out',
                  path: '/login',
                ),
                selected: false,
                onTap: onLogout,
                isDestructive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    return parts.take(2).map((p) => p[0].toUpperCase()).join();
  }
}

class _NavTile extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool isDestructive;

  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? AppColors.error
        : selected
            ? AppColors.primary
            : theme.colorScheme.onSurface.withValues(alpha: 0.75);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          // AnimatedContainer cross-fades the gradient-pill highlight in/out on selection
          // change, instead of it snapping — the "premium" feel the rest of the app has.
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: selected
                  ? LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.secondary.withValues(alpha: 0.15),
                      ],
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(selected ? item.selectedIcon : item.icon, color: color, size: 22),
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}