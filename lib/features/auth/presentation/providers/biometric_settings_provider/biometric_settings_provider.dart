import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/app_lock_service/app_lock_service.dart';
import '../auth_provider/auth_provider.dart';

const _fingerprintUnlockKey = 'fingerprint_unlock_enabled';
const _faceUnlockKey = 'face_unlock_enabled';
const _pinUnlockEnabledKey = 'pin_unlock_enabled';
const _pinKey = 'app_lock_pin';

const _storage = FlutterSecureStorage();

/// Singleton service used by notifiers to sync with DB.
final appLockServiceProvider = Provider<AppLockService>(
  (_) => AppLockService(),
);

/// Email of the currently signed-in account. App lock settings (PIN,
/// fingerprint and Face ID) are scoped per account, so each Google account
/// keeps its own configuration.
final currentAccountEmailProvider = Provider<String?>((ref) {
  final auth = ref.watch(authProvider);
  if (auth is AuthAuthenticated && auth.user.email.isNotEmpty) {
    return auth.user.email;
  }
  return null;
});

/// Sanitizes an email into a storage-safe scope suffix. A null/empty email
/// falls back to the shared "default" scope (e.g. during tests or while the
/// auth state is still loading).
String _scopeFor(String? email) {
  final e = (email ?? '').trim().toLowerCase();
  if (e.isEmpty) return 'default';
  return e.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
}

String _scopedKey(String base, String? email) => '$base::${_scopeFor(email)}';

/// While a biometric prompt is in progress (e.g. enabling a lock method in
/// Settings), the app lock must not be triggered by the prompt's own
/// lifecycle resume. This timestamp suppresses the auto lock.
DateTime _suppressAppLockUntil = DateTime.fromMillisecondsSinceEpoch(0);

void suppressAppLock(Duration duration) {
  _suppressAppLockUntil = DateTime.now().add(duration);
}

void clearAppLockSuppression() {
  _suppressAppLockUntil = DateTime.fromMillisecondsSinceEpoch(0);
}

bool isAppLockSuppressed() => DateTime.now().isBefore(_suppressAppLockUntil);

/// Snapshot of the app lock flags read directly from storage.
/// Used to avoid the async provider load race on cold start.
class AppLockFlags {
  const AppLockFlags({
    required this.fingerprint,
    required this.face,
    required this.pin,
  });

  final bool fingerprint;
  final bool face;
  final bool pin;

  bool get any => fingerprint || face || pin;
}

/// Reads the app lock flags directly from storage (avoids async load race).
Future<AppLockFlags> loadAppLockFlags({String? email}) async {
  final prefs = await SharedPreferences.getInstance();
  return AppLockFlags(
    fingerprint:
        prefs.getBool(_scopedKey(_fingerprintUnlockKey, email)) ?? false,
    face: prefs.getBool(_scopedKey(_faceUnlockKey, email)) ?? false,
    pin: prefs.getBool(_scopedKey(_pinUnlockEnabledKey, email)) ?? false,
  );
}

/// Sync app lock flags from DB to local storage.
/// Called on app start after login to ensure DB is the source of truth.
Future<void> syncAppLockFromDb(AppLockService service, {String? email}) async {
  try {
    final data = await service.fetchSettings();
    if (data == null) return;
    final prefs = await SharedPreferences.getInstance();
    if (data.containsKey('fingerprint_enabled')) {
      await prefs.setBool(
        _scopedKey(_fingerprintUnlockKey, email),
        data['fingerprint_enabled'] as bool,
      );
    }
    if (data.containsKey('face_enabled')) {
      await prefs.setBool(
        _scopedKey(_faceUnlockKey, email),
        data['face_enabled'] as bool,
      );
    }
    if (data.containsKey('pin_enabled')) {
      await prefs.setBool(
        _scopedKey(_pinUnlockEnabledKey, email),
        data['pin_enabled'] as bool,
      );
    }
  } catch (_) {
    // Offline or error — local storage remains as fallback.
  }
}

/// True when the user has enabled at least one unlock method
/// (fingerprint, Face ID, or PIN).
final appLockEnabledProvider = Provider<bool>((ref) {
  final fingerprint = ref.watch(fingerprintUnlockProvider);
  final face = ref.watch(faceUnlockProvider);
  final pin = ref.watch(pinUnlockProvider);
  return fingerprint || face || pin;
});

final fingerprintUnlockProvider =
    StateNotifierProvider<FingerprintUnlockNotifier, bool>((ref) {
      return FingerprintUnlockNotifier(
        ref.watch(currentAccountEmailProvider),
        ref.watch(appLockServiceProvider),
      );
    });

class FingerprintUnlockNotifier extends StateNotifier<bool> {
  FingerprintUnlockNotifier(this._email, this._service) : super(false) {
    _load();
  }

  final String? _email;
  final AppLockService _service;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value =
        prefs.getBool(_scopedKey(_fingerprintUnlockKey, _email)) ?? false;
    if (value != state) state = value;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_scopedKey(_fingerprintUnlockKey, _email), value);
    // Sync to DB (fire and forget — local storage is always up to date).
    _service.updateFlags(fingerprintEnabled: value);
  }
}

final faceUnlockProvider = StateNotifierProvider<FaceUnlockNotifier, bool>((
  ref,
) {
  return FaceUnlockNotifier(
    ref.watch(currentAccountEmailProvider),
    ref.watch(appLockServiceProvider),
  );
});

class FaceUnlockNotifier extends StateNotifier<bool> {
  FaceUnlockNotifier(this._email, this._service) : super(false) {
    _load();
  }

  final String? _email;
  final AppLockService _service;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_scopedKey(_faceUnlockKey, _email)) ?? false;
    if (value != state) state = value;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_scopedKey(_faceUnlockKey, _email), value);
    _service.updateFlags(faceEnabled: value);
  }
}

final pinUnlockProvider = StateNotifierProvider<PinUnlockNotifier, bool>((ref) {
  return PinUnlockNotifier(
    ref.watch(currentAccountEmailProvider),
    ref.watch(appLockServiceProvider),
  );
});

class PinUnlockNotifier extends StateNotifier<bool> {
  PinUnlockNotifier(this._email, this._service) : super(false) {
    _load();
  }

  final String? _email;
  final AppLockService _service;

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value =
        prefs.getBool(_scopedKey(_pinUnlockEnabledKey, _email)) ?? false;
    if (value != state) state = value;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_scopedKey(_pinUnlockEnabledKey, _email), value);
    _service.updateFlags(pinEnabled: value);
  }
}

/// Returns true when a PIN has been stored on this device.
Future<bool> hasStoredPin({String? email}) async {
  final pin = await _storage.read(key: _scopedKey(_pinKey, email));
  return pin != null && pin.isNotEmpty;
}

/// True when the stored PIN is a valid 6-digit lock PIN. Older builds stored
/// 4-digit PINs which can never match the 6-digit lock screen.
Future<bool> hasValidStoredPin({String? email}) async {
  final pin = await _storage.read(key: _scopedKey(_pinKey, email));
  return pin != null && RegExp(r'^\d{6}$').hasMatch(pin);
}

/// Removes the stored PIN (used to clear an invalid/legacy PIN).
Future<void> clearStoredPin({String? email}) async {
  await _storage.delete(key: _scopedKey(_pinKey, email));
}

/// Saves the PIN used to unlock the app.
Future<void> savePin(String pin, {String? email}) async {
  await _storage.write(key: _scopedKey(_pinKey, email), value: pin);
}

/// Verifies the given [pin] against the stored PIN.
Future<bool> verifyPin(String pin, {String? email}) async {
  final stored = await _storage.read(key: _scopedKey(_pinKey, email));
  if (stored == null) return false;
  return stored == pin;
}

/// Disables every app lock method (fingerprint, Face ID, PIN) and removes the
/// stored PIN. Used by the "forgot PIN" reset on the lock screen.
Future<void> resetAppLock({String? email, AppLockService? service}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_scopedKey(_fingerprintUnlockKey, email), false);
  await prefs.setBool(_scopedKey(_faceUnlockKey, email), false);
  await prefs.setBool(_scopedKey(_pinUnlockEnabledKey, email), false);
  await _storage.delete(key: _scopedKey(_pinKey, email));
  // Sync to DB so the server doesn't re-enable locks on next sync.
  service?.updateFlags(
    fingerprintEnabled: false,
    faceEnabled: false,
    pinEnabled: false,
  );
}
