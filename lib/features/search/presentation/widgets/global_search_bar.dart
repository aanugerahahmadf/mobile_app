import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../data/models/search_suggestion.dart';
import '../../data/search_repository_impl.dart';
import '../../../cbir/presentation/providers/cbir_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class GlobalSearchBar extends ConsumerStatefulWidget {
  final bool translucent;
  final bool compact;
  final bool showChat;

  const GlobalSearchBar({super.key, this.translucent = false, this.compact = false, this.showChat = true});

  @override
  ConsumerState<GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends ConsumerState<GlobalSearchBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  OverlayEntry? _overlay;

  SearchRepositoryImpl get _repo {
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated && authState.user.isAdmin) {
      return SearchRepositoryImpl(endpoint: ApiEndpoints.adminSearch);
    }
    return SearchRepositoryImpl();
  }

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

  void _openSearchResults(String query) {
    _controller.clear();
    _focusNode.unfocus();
    _removeOverlay();
    context.push('/search', extra: {'query': query});
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 1024);
    if (picked != null && mounted) {
      ref.read(cbirProvider.notifier).search(File(picked.path));
      if (mounted) context.push('/cbir-result');
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null && mounted) {
      ref.read(cbirProvider.notifier).search(File(result.files.single.path!));
      if (mounted) context.push('/cbir-result');
    }
  }

  Future<void> _pickFromDrive() async {
    try {
      final googleUser = await GoogleSignIn(
        serverClientId: dotenv.get('GOOGLE_CLIENT_ID'),
        scopes: ['https://www.googleapis.com/auth/drive.readonly'],
      ).signIn();
      if (googleUser == null || !mounted) return;

      final auth = await googleUser.authentication;
      if (auth.accessToken == null) return;

      final response = await Dio().get(
        'https://www.googleapis.com/drive/v3/files',
        queryParameters: {
          'q': "mimeType contains 'image/' and trashed = false",
          'fields': 'files(id, name, mimeType, thumbnailLink)',
          'pageSize': '50',
          'orderBy': 'modifiedTime desc',
        },
        options: Options(headers: {'Authorization': 'Bearer ${auth.accessToken}'}),
      );

      final files = (response.data['files'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      if (files.isEmpty || !mounted) return;

      final l = AppLocalizations.of(context)!;
      final selected = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36, height: 4, margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(l.pickFromGoogleDrive,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.45,
                child: ListView.separated(
                  itemCount: files.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, i) {
                    final f = files[i];
                    final thumb = f['thumbnailLink'] as String?;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: thumb != null
                            ? CachedNetworkImage(imageUrl: thumb, width: 48, height: 48, fit: BoxFit.cover)
                            : Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.cloud, color: Color(0xFF4CAF50), size: 24),
                              ),
                      ),
                      title: Text(f['name'] as String? ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () => Navigator.pop(ctx, f['id'] as String?),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

      if (selected == null || !mounted) return;

      final imageResponse = await Dio().get(
        'https://www.googleapis.com/drive/v3/files/$selected?alt=media',
        options: Options(
          headers: {'Authorization': 'Bearer ${auth.accessToken}'},
          responseType: ResponseType.bytes,
        ),
      );

      final tempDir = await Directory.systemTemp.createTemp('drive_');
      final file = File('${tempDir.path}/drive_image.jpg');
      await file.writeAsBytes(imageResponse.data as List<int>);

      ref.read(cbirProvider.notifier).search(file);
      if (mounted) context.push('/cbir-result');
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failedWithMessage.replaceFirst('%s', e.toString()))),
        );
      }
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
                  width: 36, height: 4,
                  decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(height: 24),
                Text(l.searchByImage,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                _sheetOption(
                  icon: Icons.camera_alt_rounded,
                  title: l.camera,
                  subtitle: l.takePhotoDirect,
                  onTap: () { context.pop(); _pickImage(ImageSource.camera); },
                ),
                _sheetOption(
                  icon: Icons.photo_library,
                  title: l.gallery,
                  subtitle: l.chooseFromGallery,
                  onTap: () { context.pop(); _pickImage(ImageSource.gallery); },
                ),
                _sheetOption(
                  icon: Icons.folder,
                  title: l.fileManager,
                  subtitle: l.chooseFromStorage,
                  onTap: () { context.pop(); _pickFile(); },
                ),
                _sheetOption(
                  icon: Icons.cloud,
                  title: l.googleDrive,
                  subtitle: l.chooseFromDrive,
                  onTap: () { context.pop(); _pickFromDrive(); },
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
          color: isDark ? AppColors.primaryColor.withAlpha(60) : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: isDark ? Colors.white : AppColors.primaryColor, size: 22),
      ),
      title: Text(title, style: AppTextStyles.titleMedium),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      onTap: onTap,
    );
  }

  Color get _textColor => widget.translucent ? Colors.white : AppColors.textPrimary;
  Color get _hintColor => widget.translucent ? Colors.white.withAlpha(170) : AppColors.textSecondary.withAlpha(170);
  Color get _iconColor => widget.translucent ? Colors.white.withAlpha(170) : AppColors.textSecondary;
  Color get _fillColor => widget.translucent ? Colors.white.withAlpha(40) : AppColors.secondaryColor;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final vPadding = widget.compact ? 0.0 : 2.0;
    final cbirState = ref.watch(cbirProvider);
    final authState = ref.watch(authProvider);
    final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: vPadding),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                final q = value.trim();
                if (q.length >= 2) _openSearchResults(q);
              },
              decoration: InputDecoration(
                hintText: l.searchPlaceholder,
                hintStyle: TextStyle(color: _hintColor, fontWeight: FontWeight.w400),
                prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                prefixIcon: cbirState.uploadedImagePath != null
                    ? GestureDetector(
                        onTap: _showPickerOptions,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(cbirState.uploadedImagePath!),
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Icon(Icons.broken_image, color: _iconColor, size: 28),
                                ),
                              ),
                              Positioned(
                                top: -6, right: -6,
                                child: GestureDetector(
                                  onTap: () => ref.read(cbirProvider.notifier).reset(),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(180),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.search_rounded, size: 24, color: _iconColor),
                      ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.camera_alt_rounded, color: _iconColor, size: 20),
                      onPressed: _showPickerOptions,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                    ),
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: _iconColor, size: 20),
                        onPressed: () { _controller.clear(); _removeOverlay(); setState(() {}); },
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        splashRadius: 18,
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
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
          if (widget.showChat && !isAdmin)
            IconButton(
              icon: Icon(Icons.chat_outlined, color: _iconColor, size: 22),
              onPressed: () => context.push('/chat-list'),
              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
              splashRadius: 22,
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
      case SuggestionType.weddingPolicy:
        return _iconBox(const Color(0xFFF3E5F5), Icons.description_rounded, const Color(0xFF7B1FA2));
      case SuggestionType.helps:
        return _iconBox(const Color(0xFFE0F7FA), Icons.help_outline_rounded, const Color(0xFF00838F));
      case SuggestionType.histories:
        return _iconBox(const Color(0xFFECEFF1), Icons.history_rounded, const Color(0xFF546E7A));
      case SuggestionType.users:
        return _iconBox(const Color(0xFFE8F5E9), Icons.people_rounded, const Color(0xFF2E7D32));
      case SuggestionType.transactions:
        return _iconBox(const Color(0xFFFCE4EC), Icons.payments_rounded, const Color(0xFFD32F2F));
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
    final authState = ref.watch(authProvider);
    final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.name != null && item.name!.isNotEmpty)
          Text(item.name!,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            maxLines: item.type == SuggestionType.terms || item.type == SuggestionType.privacy || item.type == SuggestionType.weddingPolicy ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
          const SizedBox(height: 3),
          Text(item.subtitle!,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: item.type == SuggestionType.vouchers || item.type == SuggestionType.orders ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ],
        if (isAdmin && item.subtitle2 != null && item.subtitle2!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(item.subtitle2!,
            style: TextStyle(fontSize: 10, color: AppColors.textTertiary, fontStyle: FontStyle.italic),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildDropdown() {
    final l = AppLocalizations.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return const SizedBox.shrink();
    final offset = renderBox.localToGlobal(Offset.zero);
    final top = offset.dy + renderBox.size.height + 6;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () { _focusNode.unfocus(); _removeOverlay(); },
            child: Container(color: Colors.transparent),
          ),
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
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.elevated,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _loadingSuggestions
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textSecondary)),
                      )
                    : _suggestions.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(l.noResults,
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _suggestions.length,
                            separatorBuilder: (_, _) => const SizedBox.shrink(),
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
