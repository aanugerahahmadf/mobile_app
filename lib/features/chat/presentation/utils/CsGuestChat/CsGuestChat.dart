import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

const String _kGuestIdKey = 'cs_guest_id';

String _generateGuestId() {
  final rng = Random.secure();
  final bytes = List<int>.generate(32, (_) => rng.nextInt(256));
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}

Future<String> getOrCreateGuestId() async {
  final prefs = await SharedPreferences.getInstance();
  var guestId = prefs.getString(_kGuestIdKey);
  if (guestId == null || guestId.isEmpty) {
    guestId = _generateGuestId();
    await prefs.setString(_kGuestIdKey, guestId);
  }
  return guestId;
}
