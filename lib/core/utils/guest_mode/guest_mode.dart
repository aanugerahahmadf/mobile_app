import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Kunci penyimpanan flag mode tamu.
const String kGuestModeKey = 'guest_mode';

bool? _cachedGuestMode;
Future<bool>? _guestModeRead;
final Future<SharedPreferences> _sharedPreferences =
    SharedPreferences.getInstance();

final guestModeProvider =
    StateNotifierProvider<GuestModeController, GuestModeState>((ref) {
      return GuestModeController();
    });

class GuestModeState {
  final bool isGuest;

  const GuestModeState({this.isGuest = false});
}

/// Controller reactive untuk status Guest/Tamu.
/// API `load`, `setGuest`, dan `isGuest` dipertahankan untuk compatibility.
class GuestModeController extends StateNotifier<GuestModeState> {
  GuestModeController() : super(const GuestModeState()) {
    load();
  }

  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final enabled = await isGuestModeEnabled();
    if (mounted) {
      state = GuestModeState(isGuest: enabled);
      _loaded = true;
    }
  }

  Future<void> setGuest(bool enabled) => setEnabled(enabled);

  Future<void> setEnabled(bool enabled) async {
    await setGuestMode(enabled);
    if (mounted) {
      state = GuestModeState(isGuest: enabled);
      _loaded = true;
    }
  }

  Future<void> clear() => setEnabled(false);
}

/// Menandai bahwa pengguna sedang dalam mode tamu.
Future<void> setGuestMode(bool enabled) async {
  _cachedGuestMode = enabled;
  _guestModeRead = Future.value(enabled);
  final prefs = await _sharedPreferences;
  if (enabled) {
    await prefs.setBool(kGuestModeKey, true);
  } else {
    await prefs.remove(kGuestModeKey);
  }
}

/// Membaca status guest dengan cache untuk menghindari pembacaan berulang.
Future<bool> isGuestModeEnabled() async {
  final cached = _cachedGuestMode;
  if (cached != null) return cached;

  final pending = _guestModeRead;
  if (pending != null) return pending;

  final future = _sharedPreferences.then((prefs) {
    final enabled = prefs.getBool(kGuestModeKey) ?? false;
    _cachedGuestMode = enabled;
    _guestModeRead = null;
    return enabled;
  });
  _guestModeRead = future;
  return future;
}

Future<void> clearGuestMode() => setGuestMode(false);
