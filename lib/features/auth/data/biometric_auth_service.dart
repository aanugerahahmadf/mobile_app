import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
    } on PlatformException {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  Future<String> get biometricTypeName async {
    final types = await getAvailableBiometrics();
    if (types.contains(BiometricType.face)) return 'biometric_face'.tr();
    if (types.contains(BiometricType.fingerprint)) return 'biometric_fingerprint'.tr();
    return 'biometric_login'.tr();
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on PlatformException {
      return false;
    }
  }
}
