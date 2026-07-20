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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      children: [
        const Text('Profile',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        const SizedBox(height: 20),
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
                  initialsOf(user?.name),
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
        SoftCard(
          radius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
