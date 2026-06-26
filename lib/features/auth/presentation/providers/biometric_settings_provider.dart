import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _fingerprintUnlockKey = 'fingerprint_unlock_enabled';

final fingerprintUnlockProvider = StateNotifierProvider<FingerprintUnlockNotifier, bool>((ref) {
  return FingerprintUnlockNotifier();
});

class FingerprintUnlockNotifier extends StateNotifier<bool> {
  FingerprintUnlockNotifier() : super(false) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_fingerprintUnlockKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_fingerprintUnlockKey, value);
  }
}
