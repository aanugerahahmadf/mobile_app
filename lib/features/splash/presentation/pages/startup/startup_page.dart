import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../data/startup_data_service/startup_data_service.dart';

class StartupPage extends ConsumerStatefulWidget {
  const StartupPage({super.key});

  @override
  ConsumerState<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends ConsumerState<StartupPage> {
  double _progress = 0;
  String? _status;

  @override
  void initState() {
    super.initState();
    _prepareApp();
  }

  Future<void> _prepareApp() async {
    final l = AppLocalizations.of(context);
    if (mounted && l != null) setState(() => _status = l.startupPreparingData);

    await StartupDataService().prepare(
      onProgress: (progress) {
        if (!mounted) return;
        setState(() {
          _progress = progress;
          _status = progress < 1
              ? AppLocalizations.of(context)?.startupDownloadingData
              : AppLocalizations.of(context)?.startupReady;
        });
      },
    );

    if (!mounted) return;
    // Always pass through LandingPage after startup. It is responsible for
    // restoring auth state and routing an authenticated user through App Lock.
    // This prevents a warm-start optimization screen from accidentally
    // bypassing the lock screen.
    context.go('/landing');
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_download_outlined, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 28),
              Text(
                l.startupTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(
                _status ?? l.startupPreparingData,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: .78), fontSize: 15),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 240,
                child: LinearProgressIndicator(
                  value: _progress == 0 ? null : _progress,
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
