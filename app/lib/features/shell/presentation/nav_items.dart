import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.path,
  });
}

// Every route wrapped in the ShellRoute (see app_router.dart) should have an
// entry here so PremiumSideMenu can list and highlight it.
const List<NavItem> navItems = [
  NavItem(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    label: 'Home',
    path: '/home',
  ),
  // Add Profile/Settings entries here once their routes exist, e.g.:
  // NavItem(icon: Icons.person_outline, selectedIcon: Icons.person_rounded, label: 'Profile', path: '/profile'),
];