import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) return false;

      // `canCheckBiometrics` is the most reliable indicator: it returns true
      // only when at least one biometric is actually enrolled. On some devices
      // (Xiaomi/MIUI) `getAvailableBiometrics()` returns an empty list even
      // when a fingerprint is enrolled, so we fall back to `canCheckBiometrics`.
      final canCheck = await _localAuth.canCheckBiometrics;
      if (canCheck) return true;

      // Additional fallback: if the device reports support but canCheckBiometrics
      // is false, check if there are any enrolled biometrics.
      final enrolled = await _localAuth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (_) {
      return [];
    }
  }

  /// Some devices (notably Xiaomi/MIUI) report an empty list from
  /// [getAvailableBiometrics] even when a fingerprint or face is enrolled, so
  /// device-level support is used as a fallback for card visibility.
  Future<bool> deviceSupportsBiometrics() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// True when at least one biometric has been enrolled and can be checked.
  /// Unreliable on some devices (Xiaomi/MIUI), so it is NOT used as a gate
  /// before showing the BiometricPrompt; kept only for diagnostics.
  Future<bool> hasEnrolledBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<String> get biometricTypeName async {
    final types = await getAvailableBiometrics();
    if (types.contains(BiometricType.face)) return 'Face ID';
    if (types.contains(BiometricType.fingerprint)) return 'Fingerprint';
    if (types.contains(BiometricType.strong) ||
        types.contains(BiometricType.weak)) {
      return 'Biometric Login';
    }
    return 'Biometric Login';
  }

  /// Android only reports [BiometricType.strong]/[weak], while iOS reports
  /// specific types. This maps "any strong/weak biometric" onto fingerprint
  /// and face so the settings toggles appear on Android.
  Future<bool> hasBiometric(BiometricType type) async {
    final types = await getAvailableBiometrics();
    if (types.contains(type)) return true;
    if (type == BiometricType.fingerprint || type == BiometricType.face) {
      if (types.contains(BiometricType.strong) ||
          types.contains(BiometricType.weak)) {
        return true;
      }
      // Android (e.g. Xiaomi/MIUI) can report an empty list even when a
      // biometric is enrolled. Fall back to device-level support so the
      // settings cards still appear.
      if (types.isEmpty) {
        return deviceSupportsBiometrics();
      }
    }
    return false;
  }

  /// Returns a concrete type used by the lock screen icon/button, preferring
  /// fingerprint, then face, then any strong/weak biometric as a fallback.
  Future<BiometricType?> get primaryBiometricType async {
    final types = await getAvailableBiometrics();
    if (types.contains(BiometricType.fingerprint)) {
      return BiometricType.fingerprint;
    }
    if (types.contains(BiometricType.face)) return BiometricType.face;
    if (types.contains(BiometricType.strong) ||
        types.contains(BiometricType.weak)) {
      return BiometricType.fingerprint;
    }
    if (types.isEmpty && await deviceSupportsBiometrics()) {
      return BiometricType.fingerprint;
    }
    return null;
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          // stickyAuth keeps the auth valid after app goes to background and
          // returns — useful so the lock screen doesn't re-prompt immediately.
          stickyAuth: true,
        ),
      );
    } on Exception catch (e) {
      // Log the error for debugging but don't crash.
      debugPrint('Biometric auth failed: $e');
      return false;
    }
  }
}
