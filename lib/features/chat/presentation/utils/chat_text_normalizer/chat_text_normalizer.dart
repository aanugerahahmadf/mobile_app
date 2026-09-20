/// Normalizes text received from chat APIs before it is shown in the UI.
abstract final class ChatTextNormalizer {
  /// Converts escaped line separators into display newlines and removes
  /// excessive blank lines without changing the message payload.
  static String normalize(String value) {
    if (value.isEmpty) return value;

    var normalized = value.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    normalized = normalized.replaceAll(r'\n', '\n');
    normalized = normalized.replaceAll('/n', '\n');
    normalized = normalized.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return normalized.trim();
  }
}
