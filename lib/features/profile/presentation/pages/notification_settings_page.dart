import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _orderUpdates = true;
  bool _promotions = false;
  bool _chatMessages = true;
  bool _wishlistAlerts = true;
  bool _loaded = false;

  static const _keyOrder = 'notif_order';
  static const _keyPromo = 'notif_promo';
  static const _keyChat = 'notif_chat';
  static const _keyWishlist = 'notif_wishlist';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _orderUpdates = prefs.getBool(_keyOrder) ?? true;
      _promotions = prefs.getBool(_keyPromo) ?? false;
      _chatMessages = prefs.getBool(_keyChat) ?? true;
      _wishlistAlerts = prefs.getBool(_keyWishlist) ?? true;
      _loaded = true;
    });
  }

  Future<void> _save(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengaturan Notifikasi')),
      body: _loaded
          ? ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                _buildSwitchTile('Notifikasi Pesanan', 'Terima notifikasi status pesanan', _orderUpdates, (v) {
                  setState(() => _orderUpdates = v);
                  _save(_keyOrder, v);
                }),
                _buildSwitchTile('Notifikasi Promosi', 'Terima informasi promo dan diskon', _promotions, (v) {
                  setState(() => _promotions = v);
                  _save(_keyPromo, v);
                }),
                _buildSwitchTile('Notifikasi Chat', 'Terima notifikasi pesan baru', _chatMessages, (v) {
                  setState(() => _chatMessages = v);
                  _save(_keyChat, v);
                }),
                _buildSwitchTile('Notifikasi Favorit', 'Terima notifikasi wishlist', _wishlistAlerts, (v) {
                  setState(() => _wishlistAlerts = v);
                  _save(_keyWishlist, v);
                }),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: AppTextStyles.bodyMedium),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        value: value,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
