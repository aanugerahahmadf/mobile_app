import 'package:shared_preferences/shared_preferences.dart';

class NotificationPrefs {
  NotificationPrefs._();
  static const _prefix = 'notif_';

  static const Map<String, String> keys = {
    'messages': '${_prefix}messages',
    'products': '${_prefix}products',
    'packages': '${_prefix}packages',
    'vouchers': '${_prefix}vouchers',
    'orders': '${_prefix}orders',
    'wishlist': '${_prefix}wishlist',
    'reviews': '${_prefix}reviews',
    'security': '${_prefix}security',
  };

  static const Map<String, bool> defaults = {
    'messages': true,
    'products': true,
    'packages': true,
    'vouchers': true,
    'orders': true,
    'wishlist': true,
    'reviews': true,
    'security': true,
  };

  static Future<Map<String, bool>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return keys.map((k, v) => MapEntry(k, prefs.getBool(v) ?? defaults[k]!));
  }

  static Future<bool> isEnabled(String category) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keys[category] ?? '') ?? defaults[category] ?? true;
  }

  static Future<void> set(String category, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = keys[category];
    if (key != null) await prefs.setBool(key, value);
  }

  static Future<bool> shouldShowNotification(String type) async {
    final all = await getAll();
    if (all.isEmpty) return true;

    final category = _typeToCategory(type);
    return all[category] ?? true;
  }

  static String _typeToCategory(String type) {
    switch (type) {
      case 'message':
      case 'chat':
      case 'new_message':
        return 'messages';
      case 'product':
      case 'admin_product':
      case 'new_product':
        return 'products';
      case 'package':
      case 'admin_package':
      case 'new_package':
        return 'packages';
      case 'promo':
      case 'voucher':
      case 'admin_voucher':
      case 'new_voucher':
        return 'vouchers';
      case 'order':
      case 'payment':
      case 'new_order':
      case 'admin_order':
      case 'transaction':
      case 'admin_transaction':
      case 'new_transaction':
        return 'orders';
      case 'wishlist':
        return 'wishlist';
      case 'review':
      case 'new_review':
      case 'admin_review':
        return 'reviews';
      case 'login':
      case 'new_user':
      case 'admin_user':
      case 'admin':
      case 'system':
        return 'security';
      default:
        return 'messages';
    }
  }
}
