import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/utils/formatters.dart';
import '../providers/review_provider.dart';

class ReviewListPage extends ConsumerStatefulWidget {
  final String packageId;
  final String packageName;

  const ReviewListPage({
    super.key,
    required this.packageId,
    this.packageName = '',
  });

  @override
  ConsumerState<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends ConsumerState<ReviewListPage> {
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewProvider.notifier).fetchReviews(widget.packageId);
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    try {
      await ref.read(reviewProvider.notifier).createReview({
        'package_id': widget.packageId,
        'rating': _rating,
        'comment': comment,
      });
      _commentController.clear();
      setState(() => _showForm = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ulasan berhasil dikirim')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim ulasan: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan'),
      ),
      body: Column(
        children: [
          if (!_showForm)
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: AppButton(
                label: 'Tulis Ulasan',
                icon: Icons.edit,
                onPressed: () => setState(() => _showForm = true),
                type: ButtonType.outline,
              ),
            ),
          if (_showForm) _buildReviewForm(),
          Expanded(
            child: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(child: Text(state.error!, style: AppTextStyles.bodyMedium))
                    : state.reviews.isEmpty
                        ? AppEmptyState(
                            title: 'Belum ada ulasan',
                            subtitle: 'Jadilah yang pertama memberikan ulasan',
                            icon: Icons.star_outline,
                          )
                        : RefreshIndicator(
                            onRefresh: () => ref.read(reviewProvider.notifier).fetchReviews(widget.packageId),
                            child: ListView.builder(
                              padding: const EdgeInsets.all(AppSizes.md),
                              itemCount: state.reviews.length,
                              itemBuilder: (context, index) {
                                final review = state.reviews[index];
                                final userName = review['user_name'] as String? ?? 'Pengguna';
                                final rating = (review['rating'] as num?)?.toInt() ?? 0;
                                final comment = review['comment'] as String? ?? '';
                                final time = review['created_at'] as String? ?? '';

                                return Card(
                                  margin: const EdgeInsets.only(bottom: AppSizes.sm),
                                  child: Padding(
                                    padding: const EdgeInsets.all(AppSizes.md),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 16,
                                              backgroundColor: AppColors.secondaryColor,
                                              child: Text(
                                                userName[0].toUpperCase(),
                                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryColor),
                                              ),
                                            ),
                                            SizedBox(width: AppSizes.sm),
                                            Expanded(
                                              child: Text(userName, style: AppTextStyles.bodyMedium),
                                            ),
                                            Row(
                                              children: List.generate(
                                                5,
                                                (i) => Icon(
                                                  Icons.star,
                                                  size: 14,
                                                  color: i < rating ? AppColors.warningColor : Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (comment.isNotEmpty) ...[
                                          SizedBox(height: AppSizes.sm),
                                          Text(comment, style: AppTextStyles.bodySmall),
                                        ],
                                        SizedBox(height: AppSizes.xs),
                                        Text(
                                          Formatters.timeAgo(time),
                                          style: AppTextStyles.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewForm() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rating', style: AppTextStyles.bodyMedium),
              Row(
                children: List.generate(
                  5,
                  (i) => IconButton(
                    icon: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      color: AppColors.warningColor,
                      size: 28,
                    ),
                    onPressed: () => setState(() => _rating = i + 1),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.sm),
          TextField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: 'Tulis ulasan Anda...',
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: AppSizes.sm),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Batal',
                  onPressed: () => setState(() => _showForm = false),
                  type: ButtonType.outline,
                ),
              ),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: AppButton(
                  label: 'Kirim',
                  loading: ref.watch(reviewProvider).submitting,
                  onPressed: _submitReview,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
