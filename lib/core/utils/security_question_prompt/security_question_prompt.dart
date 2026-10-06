import 'package:shared_preferences/shared_preferences.dart';

/// Penanda satu kali "Pertanyaan Keamanan sudah dijawab".
///
/// Padanan dari `session()->pull('security_question_answered')` milik
/// Filament. Bedanya hanya tempat penyimpanan: web memakai session, jadi
/// hilang saat browser ditutup; di mobile tidak ada session, jadi memakai
/// SharedPreferences.
///
/// Kenapa perlu ada, dan kenapa per-akun:
///
///   Halaman Security Question hanya dituju dua kali -- setelah OTP
///   verifikasi dan setelah Complete Profile. Tanpa penanda ini, keduanya
///   akan menanyakan hal yang sama, dan pengguna yang sudah consciously
///   memilih "Ya, Perkuat Akun Saya" akan ditanya lagi di langkah
///   berikutnya.
///
///   Kuncinya per email, bukan satu flag global: aplikasi ini mendukung
///   banyak akun tersimpan (lihat SavedAccount). Satu flag global
///   berarti akun kedua yang baru daftar akan ikut melewati pertanyaan
///   karena akun pertama pernah menjawab.
class SecurityQuestionPrompt {
  SecurityQuestionPrompt._();

  static String _keyFor(String accountKey) =>
      'security_question_answered_$accountKey';

  /// Kunci akun yang dipakai untuk menyimpan penanda.
  ///
  /// Email dipakai, bukan user id: penanda ini hanya perlu bertahan
  /// selama akun itu ada, dan email sudah tersedia di kedua titik
  /// pemanggilan (dari AuthAuthenticated.user dan dari UserModel) tanpa
  /// perlu menunggu profil ter-load.
  static String accountKey(String email) =>
      email.trim().toLowerCase();

  /// Sudah dijawab pada sesi/perangkat ini?
  ///
  /// Email kosong dianggap belum menjawab, dan tidak pernah menulis
  /// penanda: tanpa identitas akun, penandanya tidak bisa lagi
  /// diributorsikan ke siapa pun, jadi lebih baik tidak disimpan.
  static Future<bool> isAnswered(String email) async {
    final key = email.trim();
    if (key.isEmpty) return false;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFor(accountKey(key))) ?? false;
  }

  /// Tandai sudah dijawab, supaya tidak ditanyakan lagi.
  static Future<void> markAnswered(String email) async {
    final key = email.trim();
    if (key.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFor(accountKey(key)), true);
  }

  /// Hapus penanda -- dipakai saat akun dihapus.
  static Future<void> reset(String email) async {
    final key = email.trim();
    if (key.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFor(accountKey(key)));
  }
}
