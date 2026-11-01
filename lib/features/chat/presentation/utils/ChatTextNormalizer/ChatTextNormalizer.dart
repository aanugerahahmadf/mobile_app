/// Normalizes text received from chat APIs before it is shown in the UI.
abstract final class ChatTextNormalizer {
  /// Converts escaped line separators into display newlines and removes
  /// excessive blank lines without changing the message payload.
  ///
  /// Aturan trim: spasi di ujung SETIAP baris dibuang, tapi tab dan newline
  /// sengaja dipertahankan.
  ///
  /// - Spasi hanya padding; membiarkannya bikin baris terlihat bergeser,
  ///   terutama di Android yang merender spasi agak lebar.
  /// - Tab dipakai sebagai indentasi di dalam pesan, jadi harus utuh.
  /// - Newline adalah struktur baris pesan. `String.trim()` tidak boleh dipakai
  ///   di sini karena ikut menghapus baris kosong di awal/akhir.
  static String normalize(String value) {
    if (value.isEmpty) return value;

    var normalized = value.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    normalized = normalized.replaceAll(r'\n', '\n');
    normalized = normalized.replaceAll('/n', '\n');
    normalized = normalized.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // Buang spasi di ujung tiap baris. Sengaja TIDAK memakai String.trim()
    // (menghapus newline) dan TIDAK menyentuh tab (indentasi).
    normalized = normalized
        .split('\n')
        .map((line) => line.replaceAll(RegExp(r'^ +'), '').replaceAll(RegExp(r' +$'), ''))
        .join('\n');

    return normalized;
  }
}
