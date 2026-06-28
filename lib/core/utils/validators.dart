class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    if (value.length < 12) return 'Kata sandi minimal 12 karakter';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Kata sandi harus mengandung huruf besar';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Kata sandi harus mengandung huruf kecil';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Kata sandi harus mengandung angka';
    if (!value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) return 'Kata sandi harus mengandung simbol (!@#\$%^&*)';
    return null;
  }

  static bool isPasswordStrong(String value) {
    return value.length >= 12
        && value.contains(RegExp(r'[A-Z]'))
        && value.contains(RegExp(r'[a-z]'))
        && value.contains(RegExp(r'[0-9]'))
        && value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    if (value != password) return 'Password tidak cocok';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    final regex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!regex.hasMatch(value)) return 'Format nomor tidak valid';
    return null;
  }
}
