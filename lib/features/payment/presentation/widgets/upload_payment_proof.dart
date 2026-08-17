import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/utils/camera_scan_utils.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/media_viewer.dart';
import '../providers/payment_provider.dart';

/// Alur unggah bukti pembayaran — mendukung MULTI media:
/// kamera foto (scan AI), kamera video, galeri multi (foto+video), dan
/// file manager multi (foto/video/PDF). Setiap gambar di-review AI dulu.
Future<void> uploadPaymentProof(
  BuildContext context,
  WidgetRef ref,
  String orderId, {
  VoidCallback? onUploaded,
}) async {
  final l = AppLocalizations.of(context)!;
  final selection = await pickProofMedia(
    context,
    title: l.paymentProof,
    instruction: l.autoScanHint,
  );
  if (selection == null || selection.isEmpty || !context.mounted) return;

  final confirm = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (sheetCtx) => Padding(
      padding: EdgeInsets.only(
        left: AppSizes.md,
        right: AppSizes.md,
        top: AppSizes.md,
        bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + AppSizes.md,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.paymentProof, style: AppTextStyles.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.sm),
            Text(
              l.selectedProofMedia(selection.files.length),
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              height: 132,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: selection.files.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
                itemBuilder: (_, index) => _ProofThumb(media: selection.files[index]),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            AppButton(
              label: l.sendProof,
              onPressed: () => Navigator.pop(sheetCtx, true),
            ),
          ],
        ),
      ),
    ),
  );
  if (confirm != true || !context.mounted) return;

  final paths = selection.files.map((m) => m.file.path).toList();
  final ok = await ref.read(paymentProvider.notifier).uploadProof(orderId, paths);
  if (!context.mounted) return;
  if (ok) {
    AppSnackBar.show(context, l.proofSent, type: SnackBarType.success);
    onUploaded?.call();
  } else {
    AppSnackBar.show(context, ref.read(paymentProvider).error ?? l.failedProcessPayment, type: SnackBarType.error);
  }
}

class _ProofThumb extends StatelessWidget {
  final ProofMediaFile media;

  const _ProofThumb({required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.kind == ProofMediaKind.other) {
      return Container(
        width: 120,
        height: 132,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined, size: 40),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                media.file.path.split('.').last.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelMedium,
              ),
            ),
          ],
        ),
      );
    }
    return LocalMediaThumb(
      path: media.file.path,
      width: 120,
      height: 132,
    );
  }
}
