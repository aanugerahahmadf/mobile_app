import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../../core/utils/notification_prefs/notification_prefs.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  Map<String, bool> _prefs = {};
  bool _soundEnabled = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final notifPrefs = await NotificationPrefs.getAll();
    if (!mounted) return;
    setState(() {
      _prefs = notifPrefs;
      _soundEnabled = prefs.getBool('notif_sound') ?? true;
      _loaded = true;
    });
  }

  Future<void> _toggle(String category, bool value) async {
    await NotificationPrefs.set(category, value);
    setState(() => _prefs[category] = value);
  }

  Future<void> _toggleAll(bool value) async {
    for (final key in NotificationPrefs.keys.keys) {
      await NotificationPrefs.set(key, value);
    }
    setState(() {
      _prefs = _prefs.map((k, _) => MapEntry(k, value));
    });
  }

  Future<void> _toggleSound(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_sound', value);
    setState(() => _soundEnabled = value);
  }

  bool get _allEnabled => _prefs.values.every((v) => v);

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.notificationSettings),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_loaded)
            TextButton(
              onPressed: () => _toggleAll(!_allEnabled),
              child: Text(
                _allEnabled
                    ? l.disableAllNotifications
                    : l.enableAllNotifications,
                style: TextStyle(
                  color: _allEnabled
                      ? AppColors.errorColor
                      : AppColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
      body: _loaded
          ? ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                _buildSectionHeader(l),
                const SizedBox(height: AppSizes.sm),
                _buildSoundTile(l),
                const SizedBox(height: AppSizes.md),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.chat_bubble_outline,
                  iconColor: const Color(0xFF4CAF50),
                  title: l.chatNotifications,
                  subtitle: l.chatNotificationsDesc,
                  category: 'messages',
                ),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.shopping_bag_outlined,
                  iconColor: const Color(0xFF2196F3),
                  title: l.productNotifications,
                  subtitle: l.productNotificationsDesc,
                  category: 'products',
                ),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.inventory_2_outlined,
                  iconColor: const Color(0xFF9C27B0),
                  title: l.packageNotifications,
                  subtitle: l.packageNotificationsDesc,
                  category: 'packages',
                ),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.card_giftcard_outlined,
                  iconColor: const Color(0xFFFF9800),
                  title: l.voucherNotifications,
                  subtitle: l.voucherNotificationsDesc,
                  category: 'vouchers',
                ),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.receipt_long_outlined,
                  iconColor: const Color(0xFFE91E63),
                  title: l.orderNotifications,
                  subtitle: l.orderNotificationsDesc,
                  category: 'orders',
                ),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.favorite_outline,
                  iconColor: const Color(0xFFF44336),
                  title: l.wishlistNotifications,
                  subtitle: l.wishlistNotificationsDesc,
                  category: 'wishlist',
                ),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.rate_review_outlined,
                  iconColor: const Color(0xFF00BCD4),
                  title: l.reviewNotifications,
                  subtitle: l.reviewNotificationsDesc,
                  category: 'reviews',
                ),
                _buildCategoryTile(
                  l: l,
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF607D8B),
                  title: l.securityNotifications,
                  subtitle: l.securityNotificationsDesc,
                  category: 'security',
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSectionHeader(AppLocalizations l) {
    return Row(
      children: [
        Icon(
          Icons.notifications_outlined,
          size: 20,
          color: AppColors.primaryColor,
        ),
        const SizedBox(width: AppSizes.sm),
        Text(
          l.notifications.toUpperCase(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSoundTile(AppLocalizations l) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Icon(
          _soundEnabled ? Icons.volume_up_outlined : Icons.volume_off_outlined,
          color: AppColors.primaryColor,
        ),
        title: Text(
          l.notificationSoundEnabled,
          style: AppTextStyles.bodyMedium,
        ),
        subtitle: Text(
          l.notificationSoundEnabledDesc,
          style: AppTextStyles.bodySmall,
        ),
        value: _soundEnabled,
        onChanged: _toggleSound,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCategoryTile({
    required AppLocalizations l,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String category,
  }) {
    final enabled = _prefs[category] ?? true;
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: enabled
                ? iconColor.withValues(alpha: 0.12)
                : AppColors.dividerColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: enabled ? iconColor : AppColors.textTertiary,
            size: 22,
          ),
        ),
        title: Text(title, style: AppTextStyles.bodyMedium),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        value: enabled,
        onChanged: (v) => _toggle(category, v),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
