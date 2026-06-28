import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/data/biometric_auth_service.dart';
import '../../../auth/presentation/widgets/auth_modals.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final completer = Completer<void>();
    Timer(const Duration(seconds: 3), () {
      if (!completer.isCompleted) completer.complete();
    });

    String? token;
    try {
      token = await _storage.read(key: 'auth_token');
    } catch (_) {}

    await completer.future;

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final fingerprintEnabled = prefs.getBool('fingerprint_unlock_enabled') ?? false;
      if (fingerprintEnabled) {
        final biometric = BiometricAuthService();
        final biometricAvailable = await biometric.isAvailable();
        if (biometricAvailable) {
          final authenticated = await biometric.authenticate(
            reason: 'Buka aplikasi dengan sidik jari',
          );
          if (!mounted) return;
          if (!authenticated) {
            showSignInSheet(context);
            return;
          }
        }
      }
      if (!mounted) return;
      context.go('/home');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    if (!mounted) return;

    if (!onboardingSeen) {
      context.go('/onboarding');
    } else {
      context.go('/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/article/article-4.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          const SafeArea(child: SizedBox.shrink()),
        ],
      ),
    );
  }
}
