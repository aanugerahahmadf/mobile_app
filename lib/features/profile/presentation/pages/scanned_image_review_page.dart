import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/image_scan_analyzer.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';

/// Nilai yang dikembalikan halaman review saat pengguna memilih "Ambil Ulang".
const String kScanRetake = '__scan_retake__';

/// Halaman review hasil scan AI untuk gambar statis (galeri / file manager).
///
/// Menjalankan analisis computer vision pada gambar yang sudah dipilih,
/// menampilkan hasil deteksi (kualitas + konten), lalu meminta konfirmasi
/// **Ambil Ulang** / **Gunakan**.
class ScannedImageReviewPage extends StatefulWidget {
  /// Gambar yang akan dianalisis.
  final File image;

  /// Jenis konten yang diharapkan.
  final ScanContentType type;

  final String? title;

  final String? instruction;

  const ScannedImageReviewPage({
    super.key,
    required this.image,
    required this.type,
    this.title,
    this.instruction,
  });

  @override
  State<ScannedImageReviewPage> createState() => _ScannedImageReviewPageState();
}

class _ScannedImageReviewPageState extends State<ScannedImageReviewPage> {
  final _analyzer = ImageScanAnalyzer();
  ImageScanResult? _result;
  bool _analyzing = true;

  @override
  void initState() {
    super.initState();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    setState(() {
      _analyzing = true;
      _result = null;
    });
    final result = await _analyzer.analyze(widget.image, type: widget.type);
    if (!mounted) return;
    setState(() {
      _analyzing = false;
      _result = result;
    });
  }

  void _retake() {
    Navigator.pop(context, kScanRetake);
  }

  void _accept() {
    Navigator.pop(context, widget.image.path);
  }

  String _issueLabel(String issue, AppLocalizations l) {
    switch (issue) {
      case 'blur':
        return l.scanIssueBlur;
      case 'dark':
        return l.scanIssueDark;
      case 'face':
        return l.scanIssueFace;
      case 'document':
        return l.scanIssueDocument;
      default:
        return l.scanNotDetected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final result = _result;
    final passed = result?.pass ?? false;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.title ?? l.scanResult),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(widget.image, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildStatusCard(l),
            ),
            const SizedBox(height: AppSizes.md),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, MediaQuery.of(context).padding.bottom + 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _analyzing ? null : _retake,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white38),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(l.retake),
                    ),
                  ),
                  SizedBox(width: AppSizes.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _analyzing || !passed ? null : _accept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.check),
                      label: Text(l.use),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(AppLocalizations l) {
    if (_analyzing) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(l.scanAnalyzing, style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    final result = _result!;
    final passed = result.pass;
    final color = passed ? AppColors.successColor : AppColors.errorColor;
    final issues = result.issues;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(24),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(passed ? Icons.verified : Icons.error_outline, color: color, size: 20),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  passed ? l.scanDetected : l.scanNotDetected,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (result.detectedValue != null && result.detectedValue!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l.scanDetectedValuePrefix + result.detectedValue!,
              style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
            ),
          ],
          if (!passed)
            for (final issue in issues)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 14, color: color),
                    SizedBox(width: AppSizes.xs),
                    Expanded(
                      child: Text(
                        _issueLabel(issue, l),
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
