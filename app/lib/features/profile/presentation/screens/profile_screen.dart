import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/initials.dart';
import '../../../../core/widgets/soft_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Signed-in user's account screen — the only place to log out on the
/// narrow/mobile layout, since that layout has no side menu.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // ConsumerWidget (Riverpod): like StatelessWidget, but build() also
  // receives a WidgetRef used to read/watch providers — app-wide state
  // managed outside this widget, such as the logged-in user.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch() subscribes this widget to authProvider — the screen rebuilds
    // automatically whenever the signed-in user's data changes.
    final user = ref.watch(authProvider).user;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        const Text('Profile',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
        // identity card: avatar with initials, name, description
        SoftCard(
          radius: 24,
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: AppColors.primaryGradient),
                ),
                alignment: Alignment.center,
                child: Text(
                  initialsOf(user?.name), // derives "JS"-style initials from the full name
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.name ?? '',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(user?.description ?? '',
                        style: const TextStyle(
                            fontSize: 12.5, color: Color(0x8C000000))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // account details card: employee code, user group
        SoftCard(
          radius: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Employee code', user?.empCode ?? '—'),
              const SizedBox(height: 12),
              _infoRow('User group', user?.groupId ?? '—'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // log out row
        SoftCard(
          radius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          // read() (not watch()) fetches the notifier once to call a method
          // on it — used for one-off actions rather than rebuilding on change.
          onTap: () => ref.read(authProvider.notifier).logout(),
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
              const SizedBox(width: 12),
              Text('Log out',
                  style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  /// A label/value pair used for the account-details rows (employee code,
  /// user group).
  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12.5, color: Color(0x73000000))),
        Text(value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
