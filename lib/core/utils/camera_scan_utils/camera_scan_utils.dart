import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/constants/app_colors/app_colors.dart';
import 'package:mobile_app/core/services/image_scan_analyzer/image_scan_analyzer.dart';
import 'package:mobile_app/features/profile/presentation/pages/auto_capture_scanner/auto_capture_scanner_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/document_scanner/document_scanner_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/face_scanner/face_scanner_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/scanned_image_review/scanned_image_review_page.dart';
import 'package:mobile_app/features/profile/presentation/pages/selfie_with_document_scanner/selfie_with_document_scanner_page.dart';

/// Membuka scanner kamera otomatis dan mengembalikan hasil `File`.
///
/// Scanner memilih halaman yang tepat sesuai [type]:
/// - [ScanContentType.face] → [FaceScannerPage] (deteksi wajah AI).
/// - dokumen identitas → [DocumentScannerPage] (deteksi OCR).
/// - selain itu → [AutoCaptureScannerPage] (kualitas + auto-capture).
Future<File?> scanWithCamera(
  BuildContext context, {
  ScanContentType type = ScanContentType.generic,
  String? title,
  String? instruction,
}) async {
  final navigator = Navigator.of(context);
  final path = await navigator.push<String>(
    MaterialPageRoute(
      builder: (_) =>
          _scannerForType(type, title: title, instruction: instruction),
    ),
  );
  if (path == null) return null;
  return File(path);
}

/// Membuka scanner kamera otomatis menggunakan [NavigatorState] yang sudah
/// ditangkap sebelum `await` (menghindari `use_build_context_synchronously`).
Future<File?> scanWithNavigator(
  NavigatorState navigator, {
  ScanContentType type = ScanContentType.generic,
  String? title,
  String? instruction,
}) async {
  final path = await navigator.push<String>(
    MaterialPageRoute(
      builder: (_) =>
          _scannerForType(type, title: title, instruction: instruction),
    ),
  );
  if (path == null) return null;
  return File(path);
}

Widget _scannerForType(
  ScanContentType type, {
  String? title,
  String? instruction,
}) {
  switch (type) {
    case ScanContentType.face:
      return const FaceScannerPage();
    case ScanContentType.ktp:
    case ScanContentType.sim:
    case ScanContentType.npwp:
    case ScanContentType.passport:
      return DocumentScannerPage(docType: _docTypeParam(type));
    case ScanContentType.generic:
      return AutoCaptureScannerPage(title: title, instruction: instruction);
  }
}

String _docTypeParam(ScanContentType type) {
  switch (type) {
    case ScanContentType.ktp:
      return 'ktp';
    case ScanContentType.sim:
      return 'sim';
    case ScanContentType.npwp:
      return 'npwp';
    case ScanContentType.passport:
      return 'passport';
    default:
      return 'ktp';
  }
}

/// Memetakan jenis identitas ('ktp' | 'sim' | 'npwp' | 'passport') ke
/// [ScanContentType] untuk scanner dokumen.
ScanContentType scanContentTypeForIdentity(String identityType) {
  switch (identityType) {
    case 'sim':
      return ScanContentType.sim;
    case 'npwp':
      return ScanContentType.npwp;
    case 'passport':
      return ScanContentType.passport;
    default:
      return ScanContentType.ktp;
  }
}

/// Membuka scanner **Selfie + Dokumen Identitas** (kamera depan) dengan
/// panduan oval untuk wajah dan bingkai kartu untuk identitas. Mengembalikan
/// `File` foto selfie + identitas, atau null bila dibatalkan.
Future<File?> scanSelfieWithDocument(
  BuildContext context, {
  String docType = 'ktp',
}) async {
  final navigator = Navigator.of(context);
  final path = await navigator.push<String>(
    MaterialPageRoute(
      builder: (_) => SelfieWithDocumentScannerPage(docType: docType),
    ),
  );
  if (path == null) return null;
  return File(path);
}

/// Memilih gambar dari [source] dengan hasil yang selalu melalui scan AI:
///
/// - Kamera → scanner kamera otomatis sesuai [type].
/// - Galeri → gambar dipilih lalu dianalisis ulang di [ScannedImageReviewPage].
///   Jika deteksi gagal, pengguna dapat mengambil ulang (loop) hingga gambar
///   lolos atau dibatalkan.
Future<File?> pickImageWithScanner(
  BuildContext context,
  ImageSource source, {
  ScanContentType type = ScanContentType.generic,
  String? title,
  String? instruction,
  double maxWidth = 1200,
  double maxHeight = 800,
}) async {
  if (source == ImageSource.camera) {
    return scanWithCamera(
      context,
      type: type,
      title: title,
      instruction: instruction,
    );
  }
  return _reviewGalleryImage(
    Navigator.of(context),
    () async {
      return ImagePicker().pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
    },
    type: type,
    title: title,
    instruction: instruction,
  );
}

/// Memilih berkas gambar dari file manager dan menganalisis hasilnya dengan AI.
Future<File?> pickFileWithScanner(
  BuildContext context, {
  ScanContentType type = ScanContentType.generic,
  String? title,
  String? instruction,
}) async {
  return _reviewGalleryImage(
    Navigator.of(context),
    () async {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      final path = result?.files.single.path;
      if (path == null) return null;
      return XFile(path);
    },
    type: type,
    title: title,
    instruction: instruction,
  );
}

/// Rekam/pilih video (kamera atau galeri). Mengembalikan `File` atau null.
Future<File?> pickVideo(
  ImageSource source, {
  Duration maxDuration = const Duration(seconds: 60),
}) async {
  final picked = await ImagePicker().pickVideo(
    source: source,
    maxDuration: maxDuration,
  );
  return picked == null ? null : File(picked.path);
}

/// Sumber media yang dipilih pengguna dari [showKycMediaSheet].
enum KycMediaSource { photoCamera, photoGallery, videoCamera, videoGallery }

/// Hasil unggahan media: foto (perlu diproses AI/OCR) atau video (langsung
/// dikirim ke AI Core, frame diekstrak server-side).
class MediaPickResult {
  final File file;
  final bool isVideo;

  const MediaPickResult(this.file, {this.isVideo = false});
}

/// Bottom sheet sumber media untuk unggahan yang mendukung foto & video.
Future<KycMediaSource?> showKycMediaSheet(
  BuildContext context, {
  String? title,
}) async {
  final l = AppLocalizations.of(context)!;
  return showModalBottomSheet<KycMediaSource>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null && title.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l.takePhoto),
              subtitle: Text(l.takePhotoDirect),
              onTap: () => Navigator.pop(ctx, KycMediaSource.photoCamera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l.gallery),
              subtitle: Text(l.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, KycMediaSource.photoGallery),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l.takeVideo),
              subtitle: Text(l.takeVideoDirect),
              onTap: () => Navigator.pop(ctx, KycMediaSource.videoCamera),
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: Text(l.videoGallery),
              subtitle: Text(l.chooseFromGallery),
              onTap: () => Navigator.pop(ctx, KycMediaSource.videoGallery),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Memilih media KYC (foto ATAU video).
///
/// - **Foto** → kamera membuka scanner AI sesuai [type]; galeri melalui
///   [ScannedImageReviewPage] (loop review AI).
/// - **Video** → direkam dari kamera atau dipilih dari galeri, lalu langsung
///   dikembalikan (diproses AI Core di server).
Future<MediaPickResult?> pickKycMedia(
  BuildContext context, {
  ScanContentType type = ScanContentType.generic,
  String? title,
  String? instruction,
  Duration maxVideoDuration = const Duration(seconds: 60),
}) async {
  final navigator = Navigator.of(context);
  final source = await showKycMediaSheet(context, title: title);
  if (source == null) return null;

  switch (source) {
    case KycMediaSource.photoCamera:
      final file = await scanWithNavigator(
        navigator,
        type: type,
        title: title,
        instruction: instruction,
      );
      return file == null ? null : MediaPickResult(file);
    case KycMediaSource.photoGallery:
      final file = await _reviewGalleryImage(
        navigator,
        () => ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 800,
        ),
        type: type,
        title: title,
        instruction: instruction,
      );
      return file == null ? null : MediaPickResult(file);
    case KycMediaSource.videoCamera:
      final video = await pickVideo(
        ImageSource.camera,
        maxDuration: maxVideoDuration,
      );
      return video == null ? null : MediaPickResult(video, isVideo: true);
    case KycMediaSource.videoGallery:
      final video = await pickVideo(
        ImageSource.gallery,
        maxDuration: maxVideoDuration,
      );
      return video == null ? null : MediaPickResult(video, isVideo: true);
  }
}

/// Jenis berkas pada pilihan media bukti pembayaran.
enum ProofMediaKind { image, video, other }

/// Sumber media yang dipilih pengguna dari [showProofSourceSheet].
enum ProofSource { photoCamera, videoCamera, gallery, files }

/// Satu berkas hasil pilihan multi-media.
class ProofMediaFile {
  final File file;
  final ProofMediaKind kind;

  const ProofMediaFile(this.file, this.kind);
}

/// Hasil pilihan multi-media (campuran foto, video, dan dokumen).
class ProofMediaSelection {
  final List<ProofMediaFile> files;

  const ProofMediaSelection(this.files);

  bool get isEmpty => files.isEmpty;

  bool get isNotEmpty => files.isNotEmpty;
}

const List<String> _proofVideoExtensions = [
  'mp4',
  'mov',
  'm4v',
  'webm',
  '3gp',
  'avi',
  'mkv',
];
const List<String> _proofImageExtensions = [
  'jpg',
  'jpeg',
  'png',
  'webp',
  'heic',
];
const List<String> _proofDocumentExtensions = ['pdf'];

String _extensionOf(String pathOrName) {
  final base = pathOrName.contains('/') || pathOrName.contains(r'\')
      ? pathOrName.split(RegExp(r'[/\\]')).last
      : pathOrName;
  return base.contains('.') ? base.split('.').last.toLowerCase() : '';
}

ProofMediaKind _proofKindForExtension(String ext) {
  if (_proofVideoExtensions.contains(ext)) return ProofMediaKind.video;
  if (_proofDocumentExtensions.contains(ext)) return ProofMediaKind.other;
  return ProofMediaKind.image;
}

/// Bottom sheet sumber media untuk bukti pembayaran.
Future<ProofSource?> showProofSourceSheet(
  BuildContext context, {
  String? title,
}) async {
  final l = AppLocalizations.of(context)!;
  return showModalBottomSheet<ProofSource>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            if (title != null && title.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l.takePhoto),
              subtitle: Text(l.takePhotoDirect),
              onTap: () => Navigator.pop(ctx, ProofSource.photoCamera),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l.takeVideo),
              subtitle: Text(l.takeVideoDirect),
              onTap: () => Navigator.pop(ctx, ProofSource.videoCamera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l.gallery),
              subtitle: Text(l.galleryMultiHint),
              onTap: () => Navigator.pop(ctx, ProofSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: Text(l.fileManager),
              subtitle: Text(l.selectFromFiles),
              onTap: () => Navigator.pop(ctx, ProofSource.files),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Memilih media bukti pembayaran secara MULTI (campuran foto/video/dokumen).
///
/// - **Kamera foto** → scanner kamera AI (kualitas + auto-capture).
/// - **Kamera video** → rekam video (frame diekstrak AI Core di server).
/// - **Galeri** → pilih banyak foto & video sekaligus; foto di-review AI
///   satu per satu ([ScannedImageReviewPage]) sebelum dikirim.
/// - **File manager** → pilih banyak berkas (gambar/video/PDF); gambar
///   di-review AI satu per satu.
///
/// Mengembalikan null bila pengguna membatalkan di titik mana pun.
Future<ProofMediaSelection?> pickProofMedia(
  BuildContext context, {
  String? title,
  String? instruction,
  Duration maxVideoDuration = const Duration(seconds: 60),
}) async {
  final navigator = Navigator.of(context);
  final source = await showProofSourceSheet(context, title: title);
  if (source == null) return null;

  Future<File?> reviewImage(File image) {
    return _reviewGalleryImage(
      navigator,
      () async => XFile(image.path),
      type: ScanContentType.generic,
      title: title,
      instruction: instruction,
    );
  }

  switch (source) {
    case ProofSource.photoCamera:
      final file = await scanWithNavigator(
        navigator,
        title: title,
        instruction: instruction,
      );
      if (file == null) return null;
      return ProofMediaSelection([ProofMediaFile(file, ProofMediaKind.image)]);

    case ProofSource.videoCamera:
      final video = await pickVideo(
        ImageSource.camera,
        maxDuration: maxVideoDuration,
      );
      if (video == null) return null;
      return ProofMediaSelection([ProofMediaFile(video, ProofMediaKind.video)]);

    case ProofSource.gallery:
      final picked = await ImagePicker().pickMultipleMedia();
      if (picked.isEmpty) return null;
      final files = <ProofMediaFile>[];
      for (final x in picked) {
        final kind = _proofKindForExtension(_extensionOf(x.name));
        if (kind == ProofMediaKind.image) {
          final accepted = await reviewImage(File(x.path));
          if (accepted == null) return null;
          files.add(ProofMediaFile(accepted, ProofMediaKind.image));
        } else {
          files.add(ProofMediaFile(File(x.path), kind));
        }
      }
      return files.isEmpty ? null : ProofMediaSelection(files);

    case ProofSource.files:
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          ..._proofImageExtensions,
          ..._proofVideoExtensions,
          ..._proofDocumentExtensions,
        ],
        allowMultiple: true,
      );
      final chosen = result?.files ?? const [];
      if (chosen.isEmpty) return null;
      final files = <ProofMediaFile>[];
      for (final pf in chosen) {
        final path = pf.path;
        if (path == null) continue;
        final kind = _proofKindForExtension(_extensionOf(path));
        if (kind == ProofMediaKind.image) {
          final accepted = await reviewImage(File(path));
          if (accepted == null) return null;
          files.add(ProofMediaFile(accepted, ProofMediaKind.image));
        } else {
          files.add(ProofMediaFile(File(path), kind));
        }
      }
      return files.isEmpty ? null : ProofMediaSelection(files);
  }
}

/// Loop pick → review AI sampai pengguna menggunakan gambar atau membatalkan.
Future<File?> _reviewGalleryImage(
  NavigatorState navigator,
  Future<XFile?> Function() pick, {
  required ScanContentType type,
  String? title,
  String? instruction,
}) async {
  while (true) {
    final picked = await pick();
    if (picked == null) return null;

    final path = await navigator.push<String>(
      MaterialPageRoute(
        builder: (_) => ScannedImageReviewPage(
          image: File(picked.path),
          type: type,
          title: title,
          instruction: instruction,
        ),
      ),
    );
    if (path == null) return null;
    if (path == kScanRetake) continue;
    return File(path);
  }
}
