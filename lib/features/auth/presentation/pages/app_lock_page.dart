import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/biometric_settings_provider.dart';
import '../../data/biometric_auth_service.dart';

class AppLockPage extends ConsumerStatefulWidget {
  const AppLockPage({super.key});

  @override
  ConsumerState<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends ConsumerState<AppLockPage> with WidgetsBindingObserver {
  bool _authenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(_authenticate);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final enabled = ref.read(fingerprintUnlockProvider);
      if (enabled && !_authenticating) {
        _authenticate();
      }
    }
  }

  Future<void> _authenticate() async {
    final enabled = ref.read(fingerprintUnlockProvider);
    if (!enabled) {
      context.go('/home');
      return;
    }

    setState(() => _authenticating = true);

    final service = BiometricAuthService();
    final available = await service.isAvailable();
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autentikasi biometrik tidak tersedia di perangkat ini')),
        );
        context.go('/home');
      }
      return;
    }

    final typeName = await service.biometricTypeName;
    final reason = 'Buka aplikasi dengan $typeName';

    final success = await service.authenticate(reason: reason);

    if (mounted) {
      setState(() => _authenticating = false);
      if (success) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F1B33), Color(0xFF1E3050)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.fingerprint, size: 56, color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Buka Aplikasi',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gunakan sidik jari atau Face ID untuk membuka',
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.7)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  if (_authenticating)
                    const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  else
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _authenticate,
                        icon: const Icon(Icons.fingerprint, color: Color(0xFF0F1B33)),
                        label: const Text('Buka dengan Sidik Jari',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F1B33))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
