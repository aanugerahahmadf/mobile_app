import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../data/models/search_suggestion.dart';
import '../../data/search_repository_impl.dart';
import '../../../cbir/presentation/providers/cbir_provider.dart';

class GlobalSearchBar extends ConsumerStatefulWidget {
  final bool translucent;
  final bool compact;

  const GlobalSearchBar({super.key, this.translucent = false, this.compact = false});

  @override
  ConsumerState<GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends ConsumerState<GlobalSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _repo = SearchRepositoryImpl();
  Timer? _debounce;
  OverlayEntry? _overlay;

  List<SearchSuggestion> _suggestions = [];
  bool _loadingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _removeOverlay();
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    final query = _controller.text.trim();
    if (query.length < 2) {
      setState(() { _suggestions = []; });
      _removeOverlay();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () => _fetchSuggestions(query));
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _showOverlay() {
    _removeOverlay();
    _overlay = OverlayEntry(builder: (_) => _buildDropdown());
    Overlay.of(context).insert(_overlay!);
  }

  Future<void> _fetchSuggestions(String query) async {
    _loadingSuggestions = true;
    try {
      final result = await _repo.search(query);
      _suggestions = result.items;
    } catch (_) {
      _suggestions = [];
    }
    _loadingSuggestions = false;
    if (mounted) {
      setState(() {});
      if (_suggestions.isNotEmpty && _controller.text.trim().length >= 2) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    }
  }

  void _navigateToItem(SearchSuggestion item) {
    _controller.clear();
    _focusNode.unfocus();
    _removeOverlay();
    if (item.routeExtra != null) {
      context.push(item.routePath, extra: item.routeExtra);
    } else {
      context.push(item.routePath);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 1024);
    if (picked != null && mounted) {
      ref.read(cbirProvider.notifier).search(File(picked.path));
      if (mounted) context.push('/cbir-result');
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.only(top: 12, bottom: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Text('Cari dengan Gambar',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 24),
            _sheetOption(
              icon: Icons.camera_alt_rounded,
              title: 'Kamera',
              subtitle: 'Ambil foto langsung',
              onTap: () { context.pop(); _pickImage(ImageSource.camera); },
            ),
            _sheetOption(
              icon: Icons.photo_library,
              title: 'Galeri',
              subtitle: 'Pilih dari Galeri',
              onTap: () { context.pop(); _pickImage(ImageSource.gallery); },
            ),
            _sheetOption(
              icon: Icons.folder,
              title: 'File Manager',
              subtitle: 'Pilih dari penyimpanan',
              onTap: () { context.pop(); _pickImage(ImageSource.gallery); },
            ),
            _sheetOption(
              icon: Icons.cloud,
              title: 'Google Drive',
              subtitle: 'Pilih file dari Drive',
              onTap: () { context.pop(); _pickImage(ImageSource.gallery); },
            ),
          ],
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.primaryColor, size: 22),
      ),
      title: Text(title, style: AppTextStyles.titleMedium),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      onTap: onTap,
    );
  }

  Color get _textColor => widget.translucent ? Colors.white : const Color(0xFF1A1A2E);
  Color get _hintColor => widget.translucent ? Colors.white.withAlpha(170) : AppColors.textSecondary.withAlpha(170);
  Color get _iconColor => widget.translucent ? Colors.white.withAlpha(170) : AppColors.textSecondary;
  Color get _fillColor => widget.translucent ? Colors.white.withAlpha(40) : const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    final vPadding = widget.compact ? 0.0 : 2.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: vPadding),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Cari paket bunga...',
                hintStyle: TextStyle(color: _hintColor, fontWeight: FontWeight.w400),
                prefixIcon: Icon(Icons.search_rounded, color: _iconColor, size: 22),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close_rounded, color: _iconColor, size: 20),
                        onPressed: () { _controller.clear(); _removeOverlay(); setState(() {}); },
                      )
                    : null,
                filled: true,
                fillColor: _fillColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: widget.translucent ? Colors.white.withAlpha(77) : AppColors.primaryColor.withAlpha(77)),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              ),
              style: TextStyle(color: _textColor, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: _fillColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: Icon(Icons.camera_alt_rounded, color: _iconColor, size: 22),
              onPressed: _showPickerOptions,
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              splashRadius: 22,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            decoration: BoxDecoration(
              color: _fillColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined, color: _iconColor, size: 22),
              onPressed: () => context.push('/notifications'),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              splashRadius: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(SearchSuggestion item) {
    switch (item.type) {
      case SuggestionType.categories:
        return _iconBox(AppColors.primaryLight, Icons.category_rounded, AppColors.primaryColor);
      case SuggestionType.vouchers:
        return _iconBox(const Color(0xFFFFF3E0), Icons.discount_rounded, const Color(0xFFF57C00));
      case SuggestionType.orders:
        return _iconBox(const Color(0xFFE3F2FD), Icons.receipt_long_rounded, const Color(0xFF1565C0));
      case SuggestionType.reviews:
        return _iconBox(const Color(0xFFFFF8E1), Icons.star_rounded, const Color(0xFFF9A825));
      case SuggestionType.terms:
      case SuggestionType.privacy:
        return _iconBox(const Color(0xFFF3E5F5), Icons.description_rounded, const Color(0xFF7B1FA2));
      case SuggestionType.helps:
        return _iconBox(const Color(0xFFE0F7FA), Icons.help_outline_rounded, const Color(0xFF00838F));
      case SuggestionType.histories:
        return _iconBox(const Color(0xFFECEFF1), Icons.history_rounded, const Color(0xFF546E7A));
      case SuggestionType.packages:
      case SuggestionType.products:
        if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 48, height: 48,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(color: const Color(0xFFF5F5F5), child: const Icon(Icons.image_outlined, size: 22, color: Color(0xFFD0D0D0))),
              ),
            ),
          );
        }
        return _iconBox(const Color(0xFFEEF2FF), Icons.image_outlined, const Color(0xFF4F46E5));
    }
  }

  Widget _iconBox(Color bg, IconData icon, Color iconColor) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildTitle(SearchSuggestion item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.name != null && item.name!.isNotEmpty)
          Text(item.name!,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A1A2E)),
            maxLines: item.type == SuggestionType.terms || item.type == SuggestionType.privacy ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(item.subtitle!,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontStyle: item.type == SuggestionType.terms || item.type == SuggestionType.privacy ? FontStyle.italic : FontStyle.normal,
              fontWeight: item.type == SuggestionType.vouchers || item.type == SuggestionType.orders ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildBadge(SuggestionType type) {
    Color bgColor;
    Color textColor;
    switch (type) {
      case SuggestionType.packages:
        bgColor = AppColors.primaryLight;
        textColor = AppColors.primaryColor;
      case SuggestionType.products:
        bgColor = const Color(0xFFEEF2FF);
        textColor = const Color(0xFF4F46E5);
      case SuggestionType.categories:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
      case SuggestionType.vouchers:
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFF57C00);
      case SuggestionType.orders:
        bgColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1565C0);
      case SuggestionType.reviews:
        bgColor = const Color(0xFFFFF8E1);
        textColor = const Color(0xFFF9A825);
      case SuggestionType.terms:
      case SuggestionType.privacy:
        bgColor = const Color(0xFFF3E5F5);
        textColor = const Color(0xFF7B1FA2);
      case SuggestionType.helps:
        bgColor = const Color(0xFFE0F7FA);
        textColor = const Color(0xFF00838F);
      case SuggestionType.histories:
        bgColor = const Color(0xFFECEFF1);
        textColor = const Color(0xFF546E7A);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(type.badgeLabel,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  Widget _buildDropdown() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return const SizedBox.shrink();
    final offset = renderBox.localToGlobal(Offset.zero);
    final top = offset.dy + renderBox.size.height + 6;

    return Stack(
      children: [
        GestureDetector(
          onTap: () { _focusNode.unfocus(); _removeOverlay(); },
          child: Container(color: Colors.transparent),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: top,
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 340),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.elevated,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _loadingSuggestions
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                      )
                    : _suggestions.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text('Hasil tidak ditemukan',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _suggestions.length,
                            separatorBuilder: (_, _) => const Divider(height: 1, indent: 64),
                            itemBuilder: (_, i) {
                              final item = _suggestions[i];
                              return InkWell(
                                onTap: () => _navigateToItem(item),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  child: Row(
                                    children: [
                                      _buildLeading(item),
                                      const SizedBox(width: 14),
                                      Expanded(child: _buildTitle(item)),
                                      _buildBadge(item.type),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
