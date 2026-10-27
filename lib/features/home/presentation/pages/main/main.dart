import '../../../../../core/widgets/app_blur_backdrop/app_blur_backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../../../auth/presentation/widgets/auth_modals/auth_modals.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class MainShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final authState = ref.watch(authProvider);
    final rawAvatar = authState is AuthAuthenticated
        ? authState.user.avatarUrl
        : null;
    final avatarUrl = rawAvatar != null && rawAvatar.isNotEmpty
        ? rawAvatar
        : null;

    // Bottom bar HANYA tampil di halaman utama: Home, Orders, Cart, Profile.
    // Semua halaman lain (detail, chat, checkout, dll) tidak menampilkan bottom bar.
    final location = GoRouterState.of(context).uri.path;
    const allowedPaths = {'/home', '/orders', '/cart', '/profile'};
    final normalized = location.length > 1 && location.endsWith('/')
        ? location.substring(0, location.length - 1)
        : location;
    final showBar = allowedPaths.contains(normalized);

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(bottomNavIndexProvider.notifier).state = 0;
        navigationShell.goBranch(0);
      },
      child: Scaffold(
        extendBody: true, // konten memanjang ke belakang bar agar blur terlihat
        body: navigationShell,
        bottomNavigationBar: !showBar
            ? null
            : Material(
                type: MaterialType.transparency,
                child: _ModernBottomBar(
                  ref: ref,
                  currentIndex: currentIndex,
                  avatarUrl: avatarUrl,
                  onTap: (index) {
                    ref.read(bottomNavIndexProvider.notifier).state = index;
                    navigationShell.goBranch(index);
                  },
                ),
              ),
      ),
    );
  }
}

class _ModernBottomBar extends StatelessWidget {
  final WidgetRef ref;
  final int currentIndex;
  final String? avatarUrl;
  final ValueChanged<int> onTap;

  // Branch yang punya tombol di bar: Home, Orders, Cart, Profile
  static const branchIndices = [0, 1, 3, 4];

  static const _items = [
    _BarItem(Icons.home_outlined, Icons.home),
    _BarItem(Icons.receipt_long_outlined, Icons.receipt_long),
    _BarItem(Icons.shopping_cart_outlined, Icons.shopping_cart),
    _BarItem(Icons.person_outline_rounded, Icons.person_rounded),
  ];

  static List<String> _labels(AppLocalizations l) => [
    l.navHome,
    l.navOrders,
    l.navCart,
    l.navProfile,
  ];

  const _ModernBottomBar({
    required this.ref,
    required this.currentIndex,
    this.avatarUrl,
    required this.onTap,
  });

  void _showAccountSheet(BuildContext context) {
    final notifier = ref.read(authProvider.notifier);
    final accounts = notifier.savedAccounts;
    final activeIdx = notifier.activeAccountIndex;
    final l = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_horiz_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l.switchAccount,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(accounts.length, (i) {
                  final acc = accounts[i];
                  final isActive = i == activeIdx;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Material(
                      color: isActive
                          ? AppColors.primaryColor.withValues(alpha: 0.08)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: isActive
                            ? null
                            : () {
                                Navigator.pop(ctx);
                                notifier.switchToAccount(i);
                              },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: isActive
                                      ? Border.all(
                                          color: AppColors.primaryColor,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: CircleAvatar(
                                  backgroundColor: AppColors.secondaryColor,
                                  backgroundImage: acc.avatarUrl != null
                                      ? CachedNetworkImageProvider(
                                          acc.avatarUrl!,
                                        )
                                      : null,
                                  child: acc.avatarUrl == null
                                      ? Icon(
                                          Icons.person,
                                          size: 22,
                                          color: isActive
                                              ? AppColors.primaryColor
                                              : AppColors.textTertiary,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      acc.fullName,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      acc.email,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isActive)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        Navigator.pop(ctx);
                        showSignInSheet(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.successColor.withValues(
                                  alpha: 0.12,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_add,
                                color: AppColors.successColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l.addAccount,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    // Index branch di router (tetap sama seperti sebelumnya)
    final visibleIndices = branchIndices;
    final visibleItems = _items;
    final visibleLabels = _labels(l);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Bar melayang: ada jarak ke tepi layar (kiri, kanan, bawah)
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Container(
          // Shadow lembut supaya bar terlihat mengambang
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          // Potong blur mengikuti bentuk pill ( )
          child: AppBlurBackdrop(
            borderRadius: 999,
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.10 : 0.35),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(visibleItems.length, (i) {
                  final item = visibleItems[i];
                  final branchIdx = visibleIndices[i];
                  final isSelected = branchIdx == currentIndex;
                  final isProfile = branchIdx == 4;

                  return _buildTab(
                    context,
                    item,
                    visibleLabels[i],
                    isSelected,
                    isProfile,
                    onTap: () => onTap(branchIdx),
                    onDoubleTap: isProfile
                        ? () async {
                            await ref
                                .read(authProvider.notifier)
                                .switchToNextAccount();
                          }
                        : null,
                    onLongPress: isProfile
                        ? () => _showAccountSheet(context)
                        : null,
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    _BarItem item,
    String label,
    bool isSelected,
    bool isProfile, {
    required VoidCallback onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isProfile
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: isSelected
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                        backgroundImage: avatarUrl != null
                            ? CachedNetworkImageProvider(avatarUrl!)
                            : null,
                        child: avatarUrl == null
                            ? Icon(
                                Icons.person,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textTertiary,
                              )
                            : null,
                      ),
                    )
                  : Icon(
                      isSelected ? item.activeIcon : item.icon,
                      key: ValueKey(isSelected),
                      size: 24,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.textTertiary,
                    ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryColor
                      : AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem {
  final IconData icon;
  final IconData activeIcon;
  const _BarItem(this.icon, this.activeIcon);
}
