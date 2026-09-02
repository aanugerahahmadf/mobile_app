import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/media_viewer.dart';
import '../providers/my_reviews_provider.dart';
import '../widgets/review_photos_grid.dart';

class MyReviewsPage extends ConsumerStatefulWidget {
  const MyReviewsPage({super.key});

  @override
  ConsumerState<MyReviewsPage> createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends ConsumerState<MyReviewsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myReviewsProvider.notifier).fetchMyReviews());
  }

  Future<void> _deleteReview(Map<String, dynamic> r) async {
    final l = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.delete),
        content: Text(l.deleteReviewConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.delete, style: const TextStyle(color: AppColors.errorColor)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    final id = (r['id'] as num?)?.toInt();
    if (id == null) return;
    try {
      await ref.read(myReviewsProvider.notifier).deleteReview(id);
      if (mounted) AppSnackBar.show(context, l.reviewDeleted, type: SnackBarType.success);
    } catch (e) {
      if (mounted) AppSnackBar.show(context, l.failedDeleteReview, type: SnackBarType.error);
    }
  }

  Future<void> _editReview(Map<String, dynamic> r) async {
    final id = (r['id'] as num?)?.toInt();
    if (id == null) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditReviewSheet(
        review: r,
        onSave: (data, photoPaths, {removedPhotoUrls}) => ref.read(myReviewsProvider.notifier).updateReview(id, data, photoPaths: photoPaths, removedPhotoUrls: removedPhotoUrls),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = ref.watch(myReviewsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.myReviews),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l.writeReview,
            icon: const Icon(Icons.rate_review_outlined),
            onPressed: () => context.push('/orders'),
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? AppErrorState(message: LocalizedError.of(l, state.error!), onRetry: () => ref.read(myReviewsProvider.notifier).fetchMyReviews())
              : state.reviews.isEmpty
                  ? AppEmptyState(
                      icon: Icons.star_border,
                      title: l.noReviews,
                      subtitle: l.noReviewsYet,
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(myReviewsProvider.notifier).fetchMyReviews(),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppSizes.md),
                        itemCount: state.reviews.length,
                        itemBuilder: (_, i) => _buildReviewCard(l, state.reviews[i]),
                      ),
                    ),
    );
  }

  Widget _buildReviewCard(AppLocalizations l, Map<String, dynamic> r) {
    final package = r['package'] as Map<String, dynamic>?;
    final product = r['product'] as Map<String, dynamic>?;
    final item = package ?? product;
    final media = item?['media'] as List? ?? [];
    final firstMedia = media.isNotEmpty && media[0] is Map ? media[0] as Map : null;
    final image = firstMedia != null
        ? Formatters.imageUrl((firstMedia['url'] as String?) ?? (firstMedia['original_url'] as String?))
        : '';
    final name = (item?['name'] as String?) ?? 'Paket';
    final rating = (r['rating'] as num?)?.toInt() ?? 0;
    final title = r['title'] as String? ?? '';
    final comment = r['comment'] as String? ?? '';
    final date = r['created_at'] as String? ?? '';
    final reviewPhotos = reviewPhotoUrls(r);
    final busy = ref.watch(myReviewsProvider).submitting;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openItemReviews(r),
        child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: image.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: image,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => AppShimmer(width: 72, height: 72),
                          errorWidget: (_, _, _) => Container(width: 72, height: 72, color: AppColors.secondaryColor, child: const Icon(Icons.broken_image, size: 32)),
                        )
                      : Container(width: 72, height: 72, color: AppColors.secondaryColor, child: const Icon(Icons.inventory_2, size: 32)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: AppTextStyles.titleMedium),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (j) => Icon(
                          j < rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        )),
                      ),
                      if (title.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      ],
                      if (comment.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(comment, style: AppTextStyles.bodySmall, maxLines: 4, overflow: TextOverflow.ellipsis),
                      ],
                      if (date.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(Formatters.date(date), style: AppTextStyles.bodySmall),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (reviewPhotos.isNotEmpty) ...[
              const SizedBox(height: 8),
              ReviewPhotosGrid(urls: reviewPhotos),
            ],
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: busy ? null : () => _editReview(r),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: Text(l.edit),
                ),
                TextButton.icon(
                  onPressed: busy ? null : () => _deleteReview(r),
                  icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.errorColor),
                  label: Text(l.delete, style: const TextStyle(color: AppColors.errorColor)),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _openItemReviews(Map<String, dynamic> r) {
    final package = r['package'] as Map<String, dynamic>?;
    final product = r['product'] as Map<String, dynamic>?;
    final item = package ?? product;
    final id = '${item?['id'] ?? ''}';
    if (id.isEmpty) return;
    final isPackage = package != null;
    context.push('/item-reviews', extra: {
      'package_id': isPackage ? id : '',
      'product_id': isPackage ? '' : id,
      'title': (item?['name'] as String?) ?? '',
    });
  }
}

class _EditReviewSheet extends StatefulWidget {
  final Map<String, dynamic> review;
  final Future<void> Function(Map<String, dynamic> data, List<String>? photoPaths, {List<String>? removedPhotoUrls}) onSave;

  const _EditReviewSheet({required this.review, required this.onSave});

  @override
  State<_EditReviewSheet> createState() => _EditReviewSheetState();
}

class _EditReviewSheetState extends State<_EditReviewSheet> {
  late final TextEditingController _commentController;
  late final TextEditingController _titleController;
  late int _rating;
  List<String> _newPhotos = [];
  final Set<String> _removedExistingUrls = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _rating = (widget.review['rating'] as num?)?.toInt() ?? 5;
    _commentController = TextEditingController(text: widget.review['comment'] as String? ?? '');
    _titleController = TextEditingController(text: widget.review['title'] as String? ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    _titleController.dispose();
    super.dispose();
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
    final remaining = 6 - _newPhotos.length - _existingVisibleCount;
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
      setState(() {
        _newPhotos = [..._newPhotos, ...accepted];
      });
    }
  }

  int get _existingVisibleCount {
    final all = reviewPhotoUrls(widget.review);
    return all.where((u) => !_removedExistingUrls.contains(u)).length;
  }

  void _removeNewPhoto(int index) {
    setState(() => _newPhotos = List.of(_newPhotos)..removeAt(index));
  }

  void _removeExistingPhoto(String url) {
    setState(() => _removedExistingUrls.add(url));
  }

  Widget _buildPhotoPicker(AppLocalizations l, List<String> existingPhotos) {
    final size = (MediaQuery.of(context).size.width - 48) / 3;
    final visibleExisting = existingPhotos.where((u) => !_removedExistingUrls.contains(u)).toList();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ...visibleExisting.map((u) => Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: u,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(width: size, height: size, color: AppColors.secondaryColor),
                    errorWidget: (_, _, _) => Container(width: size, height: size, color: AppColors.secondaryColor, child: const Icon(Icons.broken_image)),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: InkWell(
                    onTap: () => _removeExistingPhoto(u),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
        ..._newPhotos.asMap().entries.map((e) => Stack(
              children: [
                LocalMediaThumb(path: e.value, width: size, height: size),
                Positioned(
                  top: 2,
                  right: 2,
                  child: InkWell(
                    onTap: () => _removeNewPhoto(e.key),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
        if (_newPhotos.length + visibleExisting.length < 6)
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
                  Text(l.uploadPhoto, style: AppTextStyles.labelSmall),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      await widget.onSave({
        'rating': _rating,
        'title': _titleController.text.trim(),
        'comment': _commentController.text.trim(),
      }, _newPhotos, removedPhotoUrls: _removedExistingUrls.toList());
      if (mounted) {
        AppSnackBar.show(context, l.reviewUpdated, type: SnackBarType.success);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(context, '${l.failedUpdateReview}: ${LocalizedError.of(l, e.toString())}', type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final existingPhotos = reviewPhotoUrls(widget.review);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.editReview, style: AppTextStyles.titleMedium),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: List.generate(5, (i) => IconButton(
                icon: Icon(
                  i < _rating ? Icons.star : Icons.star_border,
                  color: AppColors.warningColor,
                  size: 28,
                ),
                onPressed: () => setState(() => _rating = i + 1),
              )),
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: l.reviewTitleHint,
                border: const OutlineInputBorder(),
              ),
              maxLength: 255,
              buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
            ),
            const SizedBox(height: AppSizes.sm),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: l.writeYourReview,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppSizes.md),
            _buildPhotoPicker(l, existingPhotos),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: Text(l.cancel),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l.save),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
