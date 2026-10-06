import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/widgets/app_shimmer/app_shimmer.dart';
import '../../../../../core/widgets/app_empty_state/app_empty_state.dart';
import '../../../../../core/widgets/app_error_state/app_error_state.dart';
import '../../../../../core/utils/camera_scan_utils/camera_scan_utils.dart';
import '../../widgets/global_search_bar/global_search_bar.dart';
import '../../../data/models/search_suggestion/search_suggestion.dart';
import '../../providers/search_provider/search_provider.dart';
import '../../../../cbir/presentation/providers/cbir_provider/cbir_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  final String initialQuery;
  const SearchPage({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late String _query;
  bool _isRecording = false;
  final AudioRecorder _audioRecorder = AudioRecorder();

  SearchNotifier get _searchNotifier => ref.read(searchProvider.notifier);
  SearchState get _searchState => ref.watch(searchProvider);

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    if (_query.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchNotifier.search(_query);
      });
    }
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await pickImageWithScanner(
      context,
      source,
      title: AppLocalizations.of(context)!.searchByImage,
      instruction: AppLocalizations.of(context)!.autoScanHint,
      maxWidth: 1024,
    );
    if (file != null && mounted) {
      ref.read(cbirProvider.notifier).search(file);
      if (mounted) context.push('/cbir-result');
    }
  }

  void _showPickerOptions() {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 12, bottom: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l.searchByImage,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                _sheetOption(
                  icon: Icons.camera_alt_rounded,
                  title: l.camera,
                  subtitle: l.takePhotoDirect,
                  onTap: () {
                    context.pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                _sheetOption(
                  icon: Icons.photo_library,
                  title: l.gallery,
                  subtitle: l.chooseFromGallery,
                  onTap: () {
                    context.pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sheetOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.primaryColor.withAlpha(60)
              : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : AppColors.primaryColor,
          size: 22,
        ),
      ),
      title: Text(title, style: AppTextStyles.titleMedium),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      onTap: onTap,
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _audioRecorder.stop();
      if (path != null && mounted) {
        final file = File(path);
        ref.read(cbirProvider.notifier).search(file);
        if (mounted) context.push('/cbir-result');
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        await _audioRecorder.start(
          const RecordConfig(),
          path: '${dir.path}/voice_search_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );
        setState(() => _isRecording = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final state = _searchState;

    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.md,
                AppSizes.sm,
                AppSizes.md,
                AppSizes.md,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.primaryColor),
                    onPressed: () => context.pop(),
                  ),
                  // showCamera: false — halaman ini sudah punya tombol kamera
                  // sendiri di sebelah kolom pencarian. Tanpa flag itu dua
                  // tombol identik dengan aksi sama tampil bersamaan.
                  const Expanded(
                    child: GlobalSearchBar(showChat: false, showCamera: false),
                  ),
                  const SizedBox(width: 8),
                  _buildCameraButton(),
                  const SizedBox(width: 4),
                  _buildVoiceButton(),
                ],
              ),
            ),
          ),
          Expanded(child: _buildBody(context, state, l)),
        ],
      ),
    );
  }

  Widget _buildCameraButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withAlpha(30),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          Icons.camera_alt_rounded,
          color: AppColors.textSecondary,
          size: 22,
        ),
        onPressed: _showPickerOptions,
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        splashRadius: 22,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildVoiceButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _isRecording
            ? AppColors.primaryColor.withAlpha(30)
            : AppColors.textSecondary.withAlpha(30),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
          color: _isRecording ? AppColors.primaryColor : AppColors.textSecondary,
          size: 22,
        ),
        onPressed: _toggleRecording,
        constraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        splashRadius: 22,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildBody(BuildContext context, SearchState state, AppLocalizations l) {
    if (_query.isEmpty) {
      return _buildEmptyQueryState(l);
    }

    if (state.loading && state.results == null) {
      return const CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(AppSizes.md),
            sliver: AppShimmerGrid(itemCount: 6, crossAxisCount: 2),
          ),
        ],
      );
    }

    if (state.error != null && state.results == null) {
      return AppErrorState(
        message: LocalizedError.of(l, state.error ?? ''),
        onRetry: () => _searchNotifier.search(_query),
      );
    }

    if (state.results == null || state.results!.items.isEmpty) {
      return AppEmptyState(
        title: l.noResults,
        subtitle: '${l.tryDifferentKeyword} "$_query"',
      );
    }

    return RefreshIndicator(
      onRefresh: () => _searchNotifier.search(_query),
      child: _buildGroupedResults(state.results!.items),
    );
  }

  Widget _buildEmptyQueryState(AppLocalizations l) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              l.searchPlaceholder,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedResults(List<SearchSuggestion> items) {
    final l = AppLocalizations.of(context)!;
    final visibleItems = items
        .where((i) => i.type != SuggestionType.vendors)
        .toList();
    final grouped = <String, List<SearchSuggestion>>{};
    for (final item in visibleItems) {
      grouped.putIfAbsent(item.type.badgeLabel(l), () => []).add(item);
    }

    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) => grouped[b]!.length.compareTo(grouped[a]!.length));

    return ListView(
      padding: const EdgeInsets.all(AppSizes.md),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSizes.sm),
          child: Text(
            l.resultsFor(visibleItems.length, _query),
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...sortedKeys.map(
          (key) => _buildSection(
            l,
            key,
            grouped[key]!,
            items.firstWhere((i) => i.type.badgeLabel(l) == key).type,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    AppLocalizations l,
    String label,
    List<SearchSuggestion> sectionItems,
    SuggestionType type,
  ) {
    final displayItems = sectionItems.take(5).toList();
    final hasMore = sectionItems.length > 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: AppSizes.md, bottom: AppSizes.sm),
          child: Row(
            children: [
              Text(
                type.localizedLabel(l),
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${sectionItems.length}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ...displayItems.map((item) => _buildResultItem(l, item)),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TextButton(
              onPressed: () => _navigateToType(type),
              child: Text(l.seeAllCount(sectionItems.length, label)),
            ),
          ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildResultItem(AppLocalizations l, SearchSuggestion item) {
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        dense: true,
        leading: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl!,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.secondaryColor,
                      child: Icon(
                        Icons.image_outlined,
                        size: 20,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              )
            : _iconBox(item.type),
        title: Text(
          item.name ?? '',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: (item.subtitle != null
            ? Text(
                item.subtitle!,
                style: const TextStyle(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item.type.localizedLabel(l),
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
          ),
        ),
        onTap: () => _navigateToItem(item),
      ),
    );
  }

  Widget _iconBox(SuggestionType type) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(_iconForType(type), size: 20, color: AppColors.primaryColor),
    );
  }

  IconData _iconForType(SuggestionType type) {
    switch (type) {
      case SuggestionType.categories:
        return Icons.category_rounded;
      case SuggestionType.vouchers:
        return Icons.discount_rounded;
      case SuggestionType.orders:
        return Icons.receipt_long;
      case SuggestionType.reviews:
        return Icons.star_rounded;
      case SuggestionType.terms:
      case SuggestionType.privacy:
      case SuggestionType.weddingPolicy:
        return Icons.description_rounded;
      case SuggestionType.helps:
        return Icons.help_outline_rounded;
      case SuggestionType.histories:
        return Icons.history_rounded;
      case SuggestionType.packages:
      case SuggestionType.products:
        return Icons.image_outlined;
      case SuggestionType.vendors:
        return Icons.store;
    }
  }

  void _navigateToType(SuggestionType type) {
    switch (type) {
      case SuggestionType.packages:
      case SuggestionType.products:
        context.push('/catalog');
      case SuggestionType.categories:
        context.push('/catalog');
      case SuggestionType.vouchers:
        context.push('/vouchers');
      case SuggestionType.orders:
        context.push('/orders');
      case SuggestionType.reviews:
        context.push('/my-reviews');
      case SuggestionType.histories:
        context.push('/history');
      case SuggestionType.terms:
        context.push('/terms-of-service');
      case SuggestionType.privacy:
        context.push('/privacy-policy');
      case SuggestionType.helps:
        context.push('/help-center');
      case SuggestionType.weddingPolicy:
        context.push('/wedding-policy');
      case SuggestionType.vendors:
        break;
    }
  }

  void _navigateToItem(SearchSuggestion item) {
    if (item.routeExtra != null) {
      context.push(item.routePath, extra: item.routeExtra);
    } else {
      context.push(item.routePath);
    }
  }
}
