import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class AdminDashboard extends StatelessWidget {
  final bool embedded;
  const AdminDashboard({super.key, this.embedded = false});

  static List<_AdminMenuItem> _menuItems(AppLocalizations l) => [
    _AdminMenuItem(l.adminUsers, Icons.people, const Color(0xFF4CAF50), 'users'),
    _AdminMenuItem(l.adminPackages, Icons.card_giftcard, const Color(0xFF2196F3), 'packages'),
    _AdminMenuItem(l.adminProducts, Icons.local_florist, const Color(0xFFFF5722), 'products'),
    _AdminMenuItem(l.adminCategories, Icons.category, const Color(0xFF9C27B0), 'categories'),
    _AdminMenuItem(l.adminOrders, Icons.receipt_long, const Color(0xFF3F51B5), 'orders'),
    _AdminMenuItem(l.adminReviews, Icons.star, const Color(0xFFFF9800), 'reviews'),
    _AdminMenuItem(l.adminDiscounts, Icons.currency_exchange, const Color(0xFF00BCD4), 'discounts'),
    _AdminMenuItem(l.adminVouchers, Icons.discount, const Color(0xFFE91E63), 'vouchers'),
    _AdminMenuItem(l.adminTransactions, Icons.account_balance, const Color(0xFF607D8B), 'transactions'),
    _AdminMenuItem(l.adminHelps, Icons.help, const Color(0xFF00BCD4), 'helps'),
    _AdminMenuItem(l.adminLegalPages, Icons.description, const Color(0xFF795548), 'legal-pages'),
    _AdminMenuItem(l.adminTerms, Icons.article, const Color(0xFF3F51B5), 'terms'),
    _AdminMenuItem(l.adminPrivacyPolicies, Icons.privacy_tip, const Color(0xFF009688), 'privacy-policies'),
    _AdminMenuItem(l.adminWeddingPolicies, Icons.card_travel, const Color(0xFF673AB7), 'wedding-policies'),
    _AdminMenuItem(l.adminInboxes, Icons.inbox, const Color(0xFF2196F3), 'inboxes'),
    _AdminMenuItem(l.adminBanks, Icons.account_balance, const Color(0xFF4CAF50), 'banks'),
    _AdminMenuItem(l.adminPaymentMethods, Icons.payment, const Color(0xFFFF5722), 'payment-methods'),
    _AdminMenuItem(l.adminNotifications, Icons.notifications, const Color(0xFFE91E63), 'notifications'),
    _AdminMenuItem(l.adminWishlists, Icons.favorite, const Color(0xFFFF9800), 'wishlists'),
    _AdminMenuItem('Vendor', Icons.store, const Color(0xFF795548), 'vendors'),
    _AdminMenuItem(l.adminCbirEvaluation, Icons.analytics, const Color(0xFF9C27B0), 'cbir-evaluation'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final items = _menuItems(l);

    final menuContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text(l.adminManagement, style: AppTextStyles.titleLarge),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 76,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox.shrink(),
            itemBuilder: (_, i) {
              final item = items[i];
              return GestureDetector(
                onTap: () => context.push('/admin/${item.route}'),
                child: Container(
              width: 58,
              margin: const EdgeInsets.symmetric(horizontal: 3),
                  child: Column(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: item.color.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(item.icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );

    final wrapped = Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: menuContent,
          ),
        ),
      ),
    );

    if (embedded) {
      return wrapped;
    }

    return Scaffold(
      body: ListView(
        children: [wrapped],
      ),
    );
  }
}

class _AdminMenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _AdminMenuItem(this.label, this.icon, this.color, this.route);
}
