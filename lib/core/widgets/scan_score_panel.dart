import 'package:flutter/material.dart';
import 'package:mobile_app/core/constants/app_colors.dart';
import 'package:mobile_app/core/constants/app_text_styles.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

/// Panel skor deteksi yang ditampilkan di atas kamera scanner.
///
/// Menampilkan:
/// - Persentase kesiapan keseluruhan (`overall`) + progress bar.
/// - Skor OCR dokumen (`ocrScore`/`maxOcrScore`) bila kartu ikut dipindai.
/// - Progress deteksi wajah (`faceScore`) bila wajah ikut dipindai.
///
/// Saat semua siap (`ready == true`) seluruh panel berubah hijau.
class ScanScorePanel extends StatelessWidget {
  /// 0..1 — skor keseluruhan yang dipakai untuk bar & persentase.
  final double overall;

  /// 0..1 — progress deteksi wajah (opsional).
  final double? faceScore;

  /// Skor OCR mentah (opsional, hanya saat kartu ikut dipindai).
  final int? ocrScore;

  /// Skor maksimum yang mungkin untuk dokumen yang dipindai.
  final int? maxOcrScore;

  /// `true` saat semua syarat terpenuhi (siap mengambil foto).
  final bool ready;

  const ScanScorePanel({
    super.key,
    required this.overall,
    this.faceScore,
    this.ocrScore,
    this.maxOcrScore,
    this.ready = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final color = ready ? AppColors.successColor : Colors.white;

    final percent = (overall.clamp(0.0, 1.0) * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l.scanScore,
                style: AppTextStyles.bodySmall.copyWith(
                  color: ready ? AppColors.successColor : Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$percent%',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: overall.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          if (faceScore != null || ocrScore != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                if (faceScore != null) ...[
                  const Icon(Icons.face_outlined, size: 18, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    '${(faceScore!.clamp(0.0, 1.0) * 100).round()}%',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                ],
                if (faceScore != null && ocrScore != null)
                  const SizedBox(width: 16),
                if (ocrScore != null) ...[
                  const Icon(Icons.credit_card_outlined, size: 18, color: Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    maxOcrScore != null ? '$ocrScore/$maxOcrScore' : '$ocrScore',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
