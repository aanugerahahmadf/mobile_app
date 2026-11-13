import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Core/Constants/AppColors/AppColors.dart';
import 'Core/Providers/ThemeProvider/ThemeProvider.dart';
import 'Core/Providers/LocaleProvider/LocaleProvider.dart';
import 'Core/Router/AppRouter/AppRouter.dart';
import 'Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import 'Core/Services/NotificationService/NotificationService.dart';
import 'Core/Theme/AppTheme/AppTheme.dart';
import 'Features/Auth/Presentation/Providers/BiometricSettingsProvider/BiometricSettingsProvider.dart';
import './FirebaseOptions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Font aplikasi tersedia dari ASET LOKAL (assets/fonts/), BUKAN unduhan
  // runtime:
  //   - tanpa internet, aplikasi tetap berfont benar (fetch runtime
  //     akan diam-diam gagal dan teks jatuh ke font bawaan);
  //   - unduhan runtime juga menambah latensi teks pertama.
  // Kalau variant yang diminta tidak ada di aset, google_fonts bakal
  // melempar -- sengaja, supaya bobot yang kelupusan instansi TERLIHAT
  // saat development, bukan diam-diam dirender salah.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Firebase hanya dipakai untuk push notification (FCM). Katalog, CBIR, dan
  // pemesanan lewat REST API Laravel, jadi kegagalan Firebase tidak boleh
  // membuat seluruh aplikasi gagal start -- pengguna tetap harus bisa masuk
  // dan tetap bisa memakai fitur utama.
  //
  // Sebelum ini `Firebase.initializeApp` dibiarkan melempar. Akibatnya:
  //   - platform tanpa konfigurasi Firebase (mis. linux) crash saat start;
  //   - config salah atau Firebase tidak terjangkau saat startup -> putih kosong.
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } catch (error, stack) {
    debugPrint('Firebase gagal diinisialisasi: $error');
    debugPrintStack(stackTrace: stack);
  }

  try {
    await initializeDateFormatting();
  } catch (_) {}

  if (firebaseReady) {
    try {
      await NotificationService.instance.initialize();
    } catch (error) {
      // Notifikasi push tidak tersedia, aplikasi tetap jalan.
      debugPrint('NotificationService gagal diinisialisasi: $error');
    }
  } else {
    debugPrint('NotificationService dilewati karena Firebase tidak siap.');
  }

  runApp(const ProviderScope(child: TimelessFloralsApp()));
}

class TimelessFloralsApp extends ConsumerStatefulWidget {
  const TimelessFloralsApp({super.key});

  @override
  ConsumerState<TimelessFloralsApp> createState() => _TimelessFloralsAppState();
}

class _TimelessFloralsAppState extends ConsumerState<TimelessFloralsApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.onNavigate = (route) => appRouter.go(route);
      NotificationService.instance.handleInitialMessage();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _maybeShowLock();
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _maybeShowLock() async {
    if (isAppLockSuppressed()) return;
    // Wait briefly for auth state to settle after resume. Without this delay,
    // `currentAccountEmailProvider` may return null and the lock is skipped.
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    final flags = await loadAppLockFlags(
      email: ref.read(currentAccountEmailProvider),
    );
    if (!flags.any || !mounted) return;
    final routerState = appRouter.routerDelegate.currentConfiguration;
    final uri = routerState.uri.toString();
    // Landing/onboarding handle the cold-start lock themselves; locking here
    // would store "/landing" and loop back to the lock after unlocking.
    if (!uri.contains('/app-lock') &&
        !uri.contains('/landing') &&
        !uri.contains('/onboarding')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pre_lock_route', uri);
      appRouter.go('/app-lock');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final platformBrightness = View.of(context).platformDispatcher.platformBrightness;
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);

    AppColors.updateBrightness(isDark);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? AppColors.darkSurface : Colors.white,
        systemNavigationBarIconBrightness: isDark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF0F2440), Color(0xFF1A1A2E), Color(0xFF121212)]
              : const [Color(0xFFEEF2FF), Color(0xFFF8F6F7), Color(0xFFFFFFFF)],
        ),
      ),
      child: MaterialApp.router(
      title: 'Timeless Florals',
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      builder: (context, child) {
        final path = appRouter.routerDelegate.currentConfiguration.uri.path;
        return AppBreadcrumbRouteView(
          path: path,
          child: child ?? const SizedBox.shrink(),
        );
      },

      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == deviceLocale.languageCode &&
                (supported.countryCode == null ||
                    supported.countryCode == deviceLocale.countryCode)) {
              return supported;
            }
          }
          for (final supported in supportedLocales) {
            if (supported.languageCode == deviceLocale.languageCode) {
              return supported;
            }
          }
        }
        return const Locale('id');
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      ),
    );
  }
}
