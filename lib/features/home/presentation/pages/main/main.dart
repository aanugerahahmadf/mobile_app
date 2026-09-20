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
    final activeBranch = navigationShell.currentIndex;
    final authState = ref.watch(authProvider);
    final rawAvatar = authState is AuthAuthenticated
        ? authState.user.avatarUrl
        : null;
    final avatarUrl = rawAvatar != null && rawAvatar.isNotEmpty
        ? rawAvatar
        : null;

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(bottomNavIndexProvider.notifier).state = 0;
        navigationShell.goBranch(0);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: activeBranch == 2
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

  static const _allItems = [
    _BarItem(Icons.home_outlined, Icons.home),
    _BarItem(Icons.receipt_long_outlined, Icons.receipt_long),
    _BarItem(Icons.chat_outlined, Icons.chat),
    _BarItem(Icons.shopping_cart_outlined, Icons.shopping_cart),
    _BarItem(Icons.person_outline_rounded, Icons.person_rounded),
  ];

  static List<String> _allLabels(AppLocalizations l) => [
    l.navHome,
    l.navOrders,
    l.navChat,
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
    final visibleIndices = [0, 1, 3, 4];
    final visibleItems = visibleIndices.map((i) => _allItems[i]).toList();
    final visibleLabels = visibleIndices.map((i) => _allLabels(l)[i]).toList();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withAlpha(8)
                : Colors.black.withAlpha(16),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(visibleItems.length, (i) {
              final item = visibleItems[i];
              final branchIdx = visibleIndices[i];
              final isSelected = branchIdx == currentIndex;
              final isChat = branchIdx == 2;
              final isProfile = branchIdx == 4;

              if (isChat) {
                return _buildCenterButton(
                  item,
                  isSelected,
                  onTap: () => onTap(branchIdx),
                );
              }
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
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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

  Widget _buildCenterButton(
    _BarItem item,
    bool isSelected, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSelected
                ? [
                    AppColors.primaryColor,
                    AppColors.primaryColor.withAlpha(200),
                  ]
                : [
                    AppColors.primaryColor.withAlpha(180),
                    AppColors.primaryColor.withAlpha(120),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? Icons.chat : Icons.chat_outlined,
          color: Colors.white,
          size: 26,
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
