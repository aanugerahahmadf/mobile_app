import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/errors/localized_error.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/media_viewer.dart';
import '../providers/review_provider.dart';

class ReviewListPage extends ConsumerStatefulWidget {
  final String packageId;
  final String productId;
  final String packageName;

  const ReviewListPage({
    super.key,
    this.packageId = '',
    this.productId = '',
    this.packageName = '',
  });

  @override
  ConsumerState<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends ConsumerState<ReviewListPage> {
  final _commentController = TextEditingController();
  final _titleController = TextEditingController();
  final _maxChars = 1000;
  int _rating = 5;
  List<String> _photoPaths = [];

  String _ratingLabel(AppLocalizations l) {
    switch (_rating) {
      case 1: return l.reviewStar1;
      case 2: return l.reviewStar2;
      case 3: return l.reviewStar3;
      case 4: return l.reviewStar4;
      default: return l.reviewStar5;
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final l = AppLocalizations.of(context)!;
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      AppSnackBar.show(context, l.writeYourReview, type: SnackBarType.warning);
      return;
    }
    if (widget.packageId.isEmpty && widget.productId.isEmpty) {
      AppSnackBar.show(context, l.reviewFailed, type: SnackBarType.error);
      return;
    }

    try {
      await ref.read(reviewProvider.notifier).createReview({
        if (widget.packageId.isNotEmpty) 'package_id': widget.packageId,
        if (widget.productId.isNotEmpty) 'product_id': widget.productId,
        'rating': _rating,
        'title': _titleController.text.trim(),
        'comment': comment,
      }, photoPaths: _photoPaths);
      if (mounted) {
        AppSnackBar.show(context, l.reviewSubmitted, type: SnackBarType.success);
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, '${l.reviewFailed}: ${LocalizedError.of(l, e.toString())}', type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final submitting = ref.watch(reviewProvider).submitting;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.writeReview),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.packageName.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(widget.packageName, style: AppTextStyles.titleMedium),
              ),
              const SizedBox(height: AppSizes.lg),
            ],
            Text(l.rating, style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSizes.xs),
            Row(
              children: List.generate(
                5,
                (i) => IconButton(
                  icon: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.warningColor,
                    size: 32,
                  ),
                  onPressed: () => setState(() => _rating = i + 1),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _ratingLabel(l),
                key: ValueKey(_rating),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.warningColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: l.reviewTitleHint,
                border: const OutlineInputBorder(),
              ),
              maxLength: 255,
              buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                return null;
              },
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: l.writeYourReview,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: _maxChars,
              maxLines: 4,
              buildCounter: (context, {required currentLength, required isFocused, required maxLength}) {
                final maxLen = maxLength ?? 1000;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4, right: 4),
                  child: Text(
                    '$currentLength / $maxLen',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: currentLength >= maxLen ? AppColors.errorColor : AppColors.textTertiary,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.md),
            _buildPhotoPicker(l),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              label: l.send,
              loading: submitting,
              onPressed: submitting ? null : _submitReview,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhotos() async {
    final l = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(l.camera),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: Text(l.takeVideo),
              onTap: () => Navigator.pop(context, 'camera_video'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(l.gallery),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: Text(l.file),
              onTap: () => Navigator.pop(context, 'file'),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    final remaining = 6 - _photoPaths.length;
    if (remaining <= 0) return;

    final picker = ImagePicker();
    final List<String> accepted = [];
    switch (choice) {
      case 'camera':
        final shot = await picker.pickImage(source: ImageSource.camera, maxWidth: 1280, imageQuality: 85);
        if (shot != null) accepted.add(shot.path);
      case 'camera_video':
        final video = await picker.pickVideo(source: ImageSource.camera, maxDuration: const Duration(minutes: 5));
        if (video != null) accepted.add(video.path);
      case 'gallery':
        final picked = await picker.pickMultipleMedia(limit: remaining);
        for (final p in picked) {
          if (accepted.length >= remaining) break;
          accepted.add(p.path);
        }
      case 'file':
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp', 'gif', 'heic', 'mp4', 'mov', 'm4v', 'webm', '3gp'],
          allowMultiple: true,
        );
        for (final f in result?.files ?? <PlatformFile>[]) {
          if (accepted.length >= remaining) break;
          if (f.path != null) accepted.add(f.path!);
        }
    }
    if (accepted.isNotEmpty && mounted) {
      setState(() => _photoPaths = [..._photoPaths, ...accepted]);
    }
  }

  void _removePhoto(int index) {
    setState(() => _photoPaths = List.of(_photoPaths)..removeAt(index));
  }

  Widget _buildPhotoPicker(AppLocalizations l) {
    final size = (MediaQuery.of(context).size.width - 32) / 3;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            ..._photoPaths.asMap().entries.map((e) => Stack(
                  children: [
                    LocalMediaThumb(path: e.value, width: size, height: size),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: InkWell(
                        onTap: () => _removePhoto(e.key),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )),
            if (_photoPaths.length < 6)
              InkWell(
                onTap: _pickPhotos,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, color: AppColors.textTertiary),
                      const SizedBox(height: 4),
                      Text(l.uploadPhoto, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
