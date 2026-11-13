import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../Core/Utils/GuestMode/GuestMode.dart';
import '../../../../Core/Widgets/AppNotification/AppNotification.dart';
import '../Providers/AuthProvider/AuthProvider.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';

/// Rutekan hasil auth (Google maupun email/kata sandi) ke tahap berikutnya
/// sesuai spec alur.
///
/// Dipanggil dari LandingScreen yang memanggil `googleLogin()` langsung
/// tanpa modal. Semua navigasi menggunakan screen-based routing:
///
/// Cabang yang ditangani (urutan = urutan spec):
///   1. `AuthTwoFactorRequired` -> /two-factor-verify (screen)
///   2. `needsOtp`              -> /otp-email-verification (screen)
///   3. `needsCompletion`       -> /complete-profile (screen)
///   4. selain itu              -> Home (diserahkan ke pemanggil lewat listener-nya)
///
/// Mengembalikan `true` kalau handled di sini, `false` kalau bukan salah satu
/// dari empat kasus di atas sehingga pemanggil boleh menanganinya sendiri.
bool handleAuthContinuation({
  required BuildContext context,
  required WidgetRef ref,
  required AuthState state,
  required AppLocalizations l,
}) {
  // Admin & superadmin: selalu langsung ke home, tanpa alur Auth.
  if (state is AuthAuthenticated && state.user.isAdminRole) {
    return false;
  }

  if (state is AuthTwoFactorRequired) {
    // Arahkan ke screen 2FA verification.
    context.push('/two-factor-verify');
    return true;
  }

  if (state is! AuthAuthenticated) return false;

  clearGuestMode();

  if (state.needsOtp) {
    // Arahkan ke screen OTP verification.
    context.push('/otp-email-verification', extra: {
      'email': state.user.email,
      'purpose': 'google_register',
    });
    return true;
  }

  if (state.needsCompletion) {
    AppNotification.show(
      context,
      l.completeYourProfile,
      type: NotificationType.info,
    );
    context.push('/complete-profile');
    return true;
  }

  // Kasus "langsung Home" TIDAK ditangani di sini: pemanggil punya listenernya
  // sendiri yang juga menyinkronkan flag app-lock sebelum ke Home.
  return false;
}
