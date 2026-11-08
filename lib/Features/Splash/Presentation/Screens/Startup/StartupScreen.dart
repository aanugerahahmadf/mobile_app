import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/Core/Providers/LocaleProvider/LocaleProvider.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../Data/StartupDataService/StartupDataService.dart';

class StartupScreen extends ConsumerStatefulWidget {
  const StartupScreen({super.key});

  @override
  ConsumerState<StartupScreen> createState() => _StartupPageState();
}

class _StartupPageState extends ConsumerState<StartupScreen> {
  double _progress = 0.0;
  StartupPhase _phase = StartupPhase.preparing;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prepareApp();
    });
  }

  Future<void> _prepareApp() async {
    await StartupDataService().prepare(
      onProgress: (progress, phase) {
        if (!mounted) return;
        setState(() {
          _progress = progress;
          _phase = phase;
        });
      },
    );

    if (!mounted) return;
    setState(() {
      _progress = 1.0;
      _phase = StartupPhase.ready;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Always pass through LandingScreen after startup. It is responsible for
    // restoring auth state and routing an authenticated user through App Lock.
    // This prevents a warm-start optimization screen from accidentally
    // bypassing the lock screen.
    context.go('/landing');
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(localeProvider);
    final l = AppLocalizations.of(context)!;

    final String statusText;
    switch (_phase) {
      case StartupPhase.preparing:
        statusText = l.startupPreparingData;
        break;
      case StartupPhase.downloading:
        statusText = l.startupDownloadingData;
        break;
      case StartupPhase.ready:
        statusText = l.startupReady;
        break;
    }

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                l.startupTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .78),
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 240,
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(8),
                  backgroundColor: Colors.white24,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${(_progress * 100).round()}%',
                style: TextStyle(color: Colors.white.withValues(alpha: .7)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
