import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../utils/chat_text_normalizer/chat_text_normalizer.dart';

/// Renderer teks percakapan yang terstruktur: mendukung
/// `#`/`##` header, `-`/`1.` list, `**bold**`, `*italic*`, `` `code` ``,
/// `key: value`, serta deteksi link otomatis.
class StructuredChatText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Color? accentColor;

  const StructuredChatText({
    super.key,
    required this.text,
    required this.style,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedText = ChatTextNormalizer.normalize(text);
    if (normalizedText.trim().isEmpty) return const SizedBox.shrink();
    final accent = accentColor ?? AppColors.primaryColor;
    final lines = normalizedText.split('\n');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < lines.length; i++) _buildLine(lines[i], accent),
      ],
    );
  }

  Widget _buildLine(String raw, Color accent) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return const SizedBox(height: 6);
    }
    final indent = raw.length - raw.indexOf(trimmed);

    // ─── Header ─────────────────────────────────────────────
    if (trimmed.startsWith('### ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Text(
          trimmed.substring(4),
          style: style.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
            fontSize: (style.fontSize ?? 14) + 3,
          ),
        ),
      );
    }
    if (trimmed.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Text(
          trimmed.substring(3),
          style: style.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
            fontSize: (style.fontSize ?? 14) + 2,
          ),
        ),
      );
    }
    if (trimmed.startsWith('# ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Text(
          trimmed.substring(2),
          style: style.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
            fontSize: (style.fontSize ?? 14) + 1,
          ),
        ),
      );
    }

    // ─── Horizontal rule ────────────────────────────────────
    if (trimmed == '---' || trimmed == '___' || trimmed == '***') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          height: 1,
          color: accent.withAlpha(60),
          margin: const EdgeInsets.symmetric(vertical: 2),
        ),
      );
    }

    final isSub = indent >= 2;

    // ─── Bullet list ────────────────────────────────────────
    if (trimmed.startsWith('- ') ||
        trimmed.startsWith('• ') ||
        trimmed.startsWith('· ')) {
      final content = trimmed.substring(2);
      return _buildListItem(accent, content, bullet: true, sub: isSub);
    }
    if (trimmed.startsWith('* ')) {
      final content = trimmed.substring(2);
      return _buildListItem(accent, content, bullet: true, sub: isSub);
    }

    // ─── Numbered list ──────────────────────────────────────
    final numMatch = RegExp(r'^(\d+)[.)]\s+(.*)$').firstMatch(trimmed);
    if (numMatch != null) {
      return _buildListItem(
        accent,
        numMatch.group(2)!,
        number: numMatch.group(1),
        sub: isSub,
      );
    }

    // ─── Key: value ─────────────────────────────────────────
    final kvMatch = RegExp(r'^([^:\n]{2,40}):\s+(.*)$').firstMatch(trimmed);
    if (kvMatch != null && !trimmed.toLowerCase().startsWith('http')) {
      final key = kvMatch.group(1)!;
      final value = kvMatch.group(2)!;
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$key: ',
              style: style.copyWith(fontWeight: FontWeight.w700, color: accent),
            ),
            ..._buildSpans(value, style, accent),
          ],
        ),
      );
    }

    // ─── Plain / inline-styled text ─────────────────────────
    return RichText(
      text: TextSpan(children: _buildSpans(trimmed, style, accent)),
    );
  }

  Widget _buildListItem(
    Color accent,
    String content, {
    String? number,
    bool bullet = false,
    bool sub = false,
  }) {
    final marker = bullet ? '•' : number ?? '';
    final leftPadding = sub ? 24.0 : 4.0;
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: 1, bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 14,
            child: Text(
              marker,
              style: style.copyWith(color: accent, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(children: _buildSpans(content, style, accent)),
            ),
          ),
        ],
      ),
    );
  }

  List<InlineSpan> _buildSpans(String text, TextStyle base, Color accent) {
    final spans = <InlineSpan>[];
    final pattern = RegExp(
      r'\*\*.+?\*\*|\bhttps?://[^\s]+|`[^`]+`|\*[^*\s][^*]*\*',
    );
    var last = 0;
    for (final m in pattern.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start), style: base));
      }
      final token = m.group(0)!;
      if (token.startsWith('**') && token.endsWith('**')) {
        spans.add(
          TextSpan(
            text: token.substring(2, token.length - 2),
            style: base.copyWith(fontWeight: FontWeight.w700, color: accent),
          ),
        );
      } else if (token.startsWith('`') && token.endsWith('`')) {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(
              fontFamily: 'monospace',
              backgroundColor: accent.withAlpha(30),
              color: accent,
            ),
          ),
        );
      } else if (token.startsWith('*') &&
          token.endsWith('*') &&
          token.length > 2) {
        spans.add(
          TextSpan(
            text: token.substring(1, token.length - 1),
            style: base.copyWith(fontStyle: FontStyle.italic),
          ),
        );
      } else if (token.startsWith('http')) {
        spans.add(
          TextSpan(
            text: token,
            style: base.copyWith(
              color: accent,
              decoration: TextDecoration.underline,
            ),
            recognizer: _urlTapper(token),
          ),
        );
      } else {
        spans.add(TextSpan(text: token, style: base));
      }
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: base));
    }
    return spans;
  }

  TapGestureRecognizer? _urlTapper(String url) {
    return TapGestureRecognizer()
      ..onTap = () async {
        try {
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          }
        } catch (_) {}
      };
  }
}
