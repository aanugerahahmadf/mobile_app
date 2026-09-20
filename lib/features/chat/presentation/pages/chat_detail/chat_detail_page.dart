import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../../core/widgets/media_viewer/media_viewer.dart';
import '../../../../../core/widgets/app_action_sheet/app_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../utils/chat_text_normalizer/chat_text_normalizer.dart';
import '../../utils/cs_guest_chat/cs_guest_chat.dart';
import '../../widgets/account_recovery_form_sheet/account_recovery_form_sheet.dart';
import '../../widgets/structured_chat_text/structured_chat_text.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final String id;
  final String? csCategory;
  final String? guestId;

  const ChatDetailPage({
    super.key,
    required this.id,
    this.csCategory,
    this.guestId,
  });

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _pollTimer;
  bool _categorySent = false;
  String? _guestId;
  Map<String, dynamic>? _replyToMessage;
  bool _isTranslating = false;
  bool _isSearching = false;
  String _searchQuery = '';
  bool _accountRecoveryActive = false;
  String? _recoveryEmail;

  static const _reactionEmojis = ['👍', '❤️', '😂', '😮', '😢', '😡'];

  static const _recoveryKeywords = [
    'lupa password',
    'lupa kata sandi',
    'lupa sandi',
    'forgot password',
    'forgot my password',
    'forgot pw',
    'ganti password',
    'ganti kata sandi',
    'ganti sandi',
    'change password',
    'reset password',
    'reset my password',
    'cari akun',
    'find my account',
    'cari akun saya',
    'akun saya hilang',
    'akun hilang',
    'akun tidak aktif',
    'my account',
    'account lost',
    'account disabled',
    'tidak bisa masuk',
    'tidak bisa login',
    'gak bisa masuk',
    'gak bisa login',
    "can't login",
    'cannot login',
    'login failed',
    'login gagal',
    'masuk gagal',
    'verifikasi akun',
    'verify account',
    'verify email',
    'reset akun',
    'recover account',
    'pulihkan akun',
    'lupa email',
    'forgot email',
    'butuh bantuan akun',
    'need account help',
    'email tidak aktif',
    'email not working',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(guestModeProvider.notifier).load();
      if (!mounted) return;
      final extra = GoRouter.of(context).state.extra as Map<String, dynamic>?;
      _guestId = widget.guestId ?? (extra?['guestId'] as String?);
      final isGuest =
          _guestId != null ||
          ref.read(guestModeProvider).isGuest ||
          ref.read(authProvider) is! AuthAuthenticated;
      if (_guestId == null && isGuest) {
        _guestId = await getOrCreateGuestId();
      }
      if (!mounted) return;
      if (_guestId != null) {
        ref
            .read(chatProvider.notifier)
            .loadGuestMessages(widget.id, guestId: _guestId!);
        _startPolling();
        if (widget.csCategory != null && !_categorySent) {
          _categorySent = true;
          _sendCsCategoryMessage(widget.csCategory!);
        }
      } else {
        ref.read(chatProvider.notifier).loadMessages(widget.id);
        _startPolling();
        if (widget.csCategory != null && !_categorySent) {
          _categorySent = true;
          _sendCsCategoryMessage(widget.csCategory!);
        }
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool get _isGuestSession =>
      _guestId != null ||
      ref.read(guestModeProvider).isGuest ||
      ref.read(authProvider) is! AuthAuthenticated;

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final notifier = ref.read(chatProvider.notifier);
      if (_guestId != null) {
        notifier.refreshGuestMessages(widget.id, guestId: _guestId!);
      } else {
        notifier.refreshMessages(widget.id);
      }
    });
  }

  String _senderName() {
    final l = AppLocalizations.of(context)!;
    if (_guestId != null) {
      return l.guestName;
    }
    final auth = ref.read(authProvider);
    if (auth is AuthAuthenticated) {
      return auth.user.fullName.isNotEmpty
          ? auth.user.fullName
          : auth.user.username;
    }
    return l.me;
  }

  int? _currentUserId() {
    final auth = ref.read(authProvider);
    if (auth is AuthAuthenticated) return auth.user.id;
    return null;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _cancelReply() => setState(() => _replyToMessage = null);

  void _setReplyTo(Map<String, dynamic> msg) {
    setState(() => _replyToMessage = msg);
    _scrollToBottom();
  }

  // ─── AI Intent Detection ──────────────────────────────────────────────

  void _detectIntentAndRespond(String message) {
    if (_accountRecoveryActive) return;
    final lower = message.toLowerCase();
    final isIntent = _recoveryKeywords.any((kw) => lower.contains(kw));
    if (isIntent) {
      _accountRecoveryActive = true;
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _openAccountRecoveryForm();
      });
    }
  }

  Future<void> _openAccountRecoveryForm() async {
    final l = AppLocalizations.of(context)!;
    final data = await showAccountRecoveryFormSheet(context);
    if (data == null || !mounted) {
      _resetRecoveryState();
      return;
    }
    final email = data['email'] ?? '';
    if (email.isEmpty) {
      _resetRecoveryState();
      return;
    }
    _recoveryEmail = email;
    final message = _buildAccountFormMessage(data, l);
    _messageController.text = message;
    await _sendMessage();
    if (!mounted) return;
    _triggerForgotPassword(email);
  }

  String _buildAccountFormMessage(
    Map<String, String> data,
    AppLocalizations l,
  ) {
    final parts = <String>[
      '1. **${l.email}:** ${data['email'] ?? ''}',
      '2. **${l.username}:** ${data['username'] ?? ''}',
      '3. **${l.fullName}:** ${data['fullName'] ?? ''}',
      '4. **${data['identityType'] ?? ''}:** ${data['identityNumber'] ?? ''}',
      '5. **${l.placeAndDateOfBirth}:** ${data['birthPlace'] ?? ''}, ${data['birthDate'] ?? ''}',
      '6. **${l.motherName}:** ${data['motherName'] ?? ''}',
      '7. **${l.whatsappNumber}:** ${data['whatsapp'] ?? ''}',
      '8. **${l.gender}:** ${data['gender'] ?? ''}',
      '9. **${l.religionLabel}:** ${data['religion'] ?? ''}',
      '10. **${l.maritalStatus}:** ${data['maritalStatus'] ?? ''}',
      '11. **${l.occupation}:** ${data['occupation'] ?? ''}',
      '12. **${l.incomeRange}:** ${data['incomeRange'] ?? ''}',
      '13. **${l.sourceOfFunds}:** ${data['sourceOfFunds'] ?? ''}',
      '14. **${l.country}:** ${data['country'] ?? ''}',
      '15. **${l.province}:** ${data['province'] ?? ''}',
      '16. **${l.city}:** ${data['city'] ?? ''}',
      '17. **${l.district}:** ${data['district'] ?? ''}',
      '18. **${l.village}:** ${data['village'] ?? ''}',
      '19. **${l.fullAddress}:** ${data['address'] ?? ''}',
      '20. **${l.postalCode}:** ${data['postalCode'] ?? ''}',
    ];
    return parts.join('\n');
  }

  void _detectFormAndProcess(String message) {
    if (!_accountRecoveryActive || _recoveryEmail != null) return;
    final emailRegex = RegExp(
      r'[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}',
    );
    final match = emailRegex.firstMatch(message);
    if (match == null) return;
    final email = match.group(0)!;
    final lower = message.toLowerCase();
    final hasFormIndicators =
        lower.contains('email') ||
        lower.contains('username') ||
        lower.contains('nama') ||
        lower.contains('tanggal') ||
        lower.contains('lahir') ||
        lower.contains('alamat') ||
        lower.contains('whatsapp') ||
        lower.contains('kode pos') ||
        lower.contains('mother') ||
        lower.contains('ibu');
    if (!hasFormIndicators) return;
    _recoveryEmail = email;
    _triggerForgotPassword(email);
  }

  Future<void> _triggerForgotPassword(String email) async {
    if (!mounted) return;
    final l = AppLocalizations.of(context)!;
    setState(() {
      _messageController.text = l.csFormDetected;
    });
    await _sendAutoMessage(l.csFormDetected);
    try {
      final dio = DioClient.instance;
      await dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
      if (!mounted) return;
      _showOtpAndPasswordSheet(email);
    } catch (e) {
      if (!mounted) return;
      await _sendAutoMessage(l.csPasswordChangeFailed);
      _resetRecoveryState();
    }
  }

  Future<void> _sendAutoMessage(String text) async {
    _messageController.text = text;
    await _sendMessage();
  }

  void _resetRecoveryState() {
    _accountRecoveryActive = false;
    _recoveryEmail = null;
  }

  void _showOtpAndPasswordSheet(String email) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _OtpAndPasswordSheet(
        email: email,
        onSuccess: () async {
          _resetRecoveryState();
          if (mounted) {
            await _sendAutoMessage(l.csPasswordChangedSuccess);
          }
        },
        onFailed: (error) async {
          _resetRecoveryState();
          if (mounted) {
            await _sendAutoMessage(error);
          }
        },
      ),
    );
  }

  List<Map<String, dynamic>> _filteredMessages(
    List<Map<String, dynamic>> messages,
  ) {
    if (_searchQuery.isEmpty) return messages;
    return messages.where((m) {
      final content = ChatTextNormalizer.normalize(
        m['message'] as String? ?? '',
      ).toLowerCase();
      final sender = (m['sender_name'] as String? ?? '').toLowerCase();
      return content.contains(_searchQuery.toLowerCase()) ||
          sender.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<dynamic> _groupByDate(List<Map<String, dynamic>> messages) {
    final items = <dynamic>[];
    String? lastDate;
    for (final msg in messages) {
      final createdAt = msg['created_at'] as String? ?? '';
      final date = createdAt.isNotEmpty ? createdAt.substring(0, 10) : '';
      if (date != lastDate) {
        lastDate = date;
        items.add({'_type': 'date', 'date': date});
      }
      items.add({'_type': 'message', 'msg': msg});
    }
    return items;
  }

  String _formatDateHeader(String dateStr, AppLocalizations l) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final target = DateTime(date.year, date.month, date.day);
      if (target == today) return l.today;
      if (target == today.subtract(const Duration(days: 1))) return l.yesterday;
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _sendCsCategoryMessage(String category) async {
    final l = AppLocalizations.of(context)!;
    // Di mode guest, kategori berbau katalog/paket/transaksi dilarang:
    // fallback ke Pertanyaan Umum supaya tidak memicu alur order/payment/dekorasi.
    if (_guestId != null &&
        (category == 'order_help' ||
            category == 'payment_issue' ||
            category == 'decor_consultation')) {
      category = 'general_question';
    }
    String message;
    switch (category) {
      case 'bug_report':
        message = '\ud83d\udc1b ${l.csQuickBugReport}';
        break;
      case 'account_issue':
        _accountRecoveryActive = true;
        await _openAccountRecoveryForm();
        return;
      case 'order_help':
        message = '\ud83d\udce6 ${l.csQuickOrderHelp}';
        break;
      case 'payment_issue':
        message = '\ud83d\udcb3 ${l.csQuickPaymentIssue}';
        break;
      case 'decor_consultation':
        message = '\ud83c\udf38 ${l.csQuickDecorConsult}';
        break;
      case 'general_question':
        message = '\u2753 ${l.csQuickGeneralQuestion}';
        break;
      default:
        message = 'Halo, saya butuh bantuan.';
    }
    _messageController.text = message;
    await _sendMessage(csCategory: category);
  }

  Future<void> _sendMessage({String? filePath, String? csCategory}) async {
    final text = _messageController.text.trim();
    if (text.isEmpty && filePath == null) return;
    if (_isGuestSession && _guestId == null) {
      _guestId = await getOrCreateGuestId();
      if (!mounted) return;
    }
    _messageController.clear();
    final replyId = _replyToMessage?['id'] as int?;
    final replyName = _replyToMessage?['sender_name'] as String?;
    setState(() => _replyToMessage = null);
    try {
      if (_guestId != null) {
        if (filePath != null) {
          if (mounted) {
            final l = AppLocalizations.of(context)!;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l.csGuestNoAttachments)));
          }
          return;
        }
        await ref
            .read(chatProvider.notifier)
            .sendGuestMessage(
              inboxId: int.parse(widget.id),
              message: text,
              guestId: _guestId!,
              senderName: _senderName(),
              csCategory: csCategory,
            );
        _scrollToBottom();
        if (text.isNotEmpty) {
          _detectIntentAndRespond(text);
          _detectFormAndProcess(text);
        }
        return;
      }
      await ref
          .read(chatProvider.notifier)
          .sendMessage(
            inboxId: int.parse(widget.id),
            message: text,
            senderName: _senderName(),
            filePath: filePath,
            csCategory: csCategory,
            replyToId: replyId,
            replyToName: replyName,
          );
      _scrollToBottom();
      if (filePath == null && text.isNotEmpty) {
        _detectIntentAndRespond(text);
        _detectFormAndProcess(text);
      }
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.failedSendMessage)));
      }
    }
  }

  void _showAttachmentOptions() {
    final l = AppLocalizations.of(context)!;
    if (_isGuestSession) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.csGuestNoAttachments)));
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                  l.attachment,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                _attachmentOption(
                  icon: Icons.camera_alt_rounded,
                  title: l.camera,
                  subtitle: l.csAttachScreenshot,
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _attachmentOption(
                  icon: Icons.videocam_rounded,
                  title: l.takeVideo,
                  subtitle: l.takeVideoDirect,
                  onTap: () {
                    Navigator.pop(context);
                    _pickVideo(ImageSource.camera);
                  },
                ),
                _attachmentOption(
                  icon: Icons.photo_library,
                  title: l.gallery,
                  subtitle: l.chooseFromGallery,
                  onTap: () {
                    Navigator.pop(context);
                    _pickMedia();
                  },
                ),
                _attachmentOption(
                  icon: Icons.folder_open_rounded,
                  title: l.file,
                  subtitle: l.chooseFromStorage,
                  onTap: () {
                    Navigator.pop(context);
                    _pickFile();
                  },
                ),
                _attachmentOption(
                  icon: Icons.category_rounded,
                  title: l.catalog,
                  subtitle: l.shareProduct,
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromCatalog();
                  },
                ),
                _attachmentOption(
                  icon: Icons.receipt_long_rounded,
                  title: l.order,
                  subtitle: l.shareOrderDetail,
                  onTap: () {
                    Navigator.pop(context);
                    _pickFromOrders();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await ImagePicker().pickImage(source: source, maxWidth: 1024);
    if (file != null && mounted) {
      await _sendMessage(filePath: file.path);
      _scrollToBottom();
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    final file = await ImagePicker().pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 5),
    );
    if (file != null && mounted) {
      await _sendMessage(filePath: file.path);
      _scrollToBottom();
    }
  }

  Future<void> _pickMedia() async {
    final picked = await ImagePicker().pickMultipleMedia();
    if (picked.isEmpty || !mounted) return;
    for (final media in picked) {
      await _sendMessage(filePath: media.path);
    }
    _scrollToBottom();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'gif',
        'heic',
        'mp4',
        'mov',
        'm4v',
        'webm',
        '3gp',
      ],
      allowMultiple: true,
    );
    final files = result?.files ?? const [];
    if (files.isEmpty || !mounted) return;
    for (final f in files) {
      if (f.path != null) await _sendMessage(filePath: f.path);
    }
    _scrollToBottom();
  }

  Future<void> _pickFromCatalog() async {
    if (_guestId != null) return;
    try {
      final dio = DioClient.instance;
      final results = await Future.wait([
        dio.get(ApiEndpoints.packages, queryParameters: {'per_page': 20}),
        dio.get(ApiEndpoints.products, queryParameters: {'per_page': 20}),
      ]);
      final packages = ((results[0].data['data'] as List?) ?? [])
          .map((e) => e as Map<String, dynamic>..['_type'] = 'package')
          .toList();
      final products = ((results[1].data['data'] as List?) ?? [])
          .map((e) => e as Map<String, dynamic>..['_type'] = 'product')
          .toList();
      final items = [...packages, ...products];
      if (items.isEmpty || !mounted) return;
      final l = AppLocalizations.of(context)!;
      final selected = await showModalBottomSheet<Map<String, dynamic>>(
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
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  l.chooseProduct,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.45,
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 70),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final imageUrl = _fixImageUrl(
                      item['image_url'] as String? ??
                          (() {
                            final images =
                                item['media'] as List? ??
                                item['images'] as List? ??
                                [];
                            if (images.isEmpty) return '';
                            final first = images.first;
                            return first is String
                                ? first
                                : (first['url'] as String? ??
                                      first['original_url'] as String? ??
                                      '');
                          })(),
                    );
                    final name = item['name'] as String? ?? '';
                    final price = item['price'];
                    final type = item['_type'] as String? ?? '';
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textTertiary,
                                ),
                              ),
                      ),
                      title: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '$type \u00b7 ${Formatters.currency((price is num ? price.toInt() : 0))}',
                      ),
                      onTap: () => Navigator.pop(ctx, item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
      if (selected == null || !mounted) return;
      await ref
          .read(chatProvider.notifier)
          .sendMessage(
            inboxId: int.parse(widget.id),
            message: '',
            senderName: _senderName(),
            itemContext: {
              'type': selected['_type'] as String? ?? 'product',
              'item_id': selected['id'],
              'item_name': selected['name'] as String? ?? '',
              'item_price': selected['price'],
              'item_image': _fixImageUrl(
                selected['image_url'] as String? ??
                    (() {
                      final images =
                          selected['media'] as List? ??
                          selected['images'] as List? ??
                          [];
                      if (images.isEmpty) return '';
                      final first = images.first;
                      return first is String
                          ? first
                          : (first['url'] as String? ??
                                first['original_url'] as String? ??
                                '');
                    })(),
              ),
            },
          );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.failedLoadCatalog)));
      }
    }
  }

  Future<void> _pickFromOrders() async {
    if (_guestId != null) return;
    try {
      final dio = DioClient.instance;
      final response = await dio.get(
        ApiEndpoints.bookings,
        queryParameters: {'per_page': 20},
      );
      final orders = (response.data['data'] as List?) ?? [];
      if (orders.isEmpty || !mounted) return;
      final l = AppLocalizations.of(context)!;
      final selected = await showModalBottomSheet<Map<String, dynamic>>(
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
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: AppColors.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Text(
                  l.chooseOrder,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.45,
                child: ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 16),
                  itemBuilder: (_, i) {
                    final order = orders[i];
                    final orderNumber = order['order_number'] as String? ?? '';
                    final status = order['status'] as String? ?? '';
                    final title = order['title'] as String? ?? '';
                    return ListTile(
                      title: Text(
                        '#$orderNumber',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        status.isNotEmpty ? '$status \u00b7 $title' : title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.pop(ctx, order),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
      if (selected == null || !mounted) return;
      await ref
          .read(chatProvider.notifier)
          .sendMessage(
            inboxId: int.parse(widget.id),
            message: '',
            senderName: _senderName(),
            itemContext: {'order_id': selected['id']},
          );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.failedLoadOrders)));
      }
    }
  }

  Widget _attachmentOption({
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

  String _fixImageUrl(String url) => url.replaceAll('/storage/', '/media/');

  // ─── Message Actions (Long Press) ──────────────────────────────────────────
  void _showMessageActions(Map<String, dynamic> msg) {
    final l = AppLocalizations.of(context)!;
    final isMe = msg['is_me'] == true;
    final isDeleted =
        msg['is_deleted'] == true || (msg['message'] as String? ?? '').isEmpty;
    final content = msg['message'] as String? ?? '';
    final meta = msg['meta'] as Map<String, dynamic>?;
    final isStarred =
        (meta?['starred_by'] as List<dynamic>?)?.isNotEmpty ?? false;
    final isGuest = _guestId != null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            if (!isGuest) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _reactionEmojis
                        .map(
                          (emoji) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(ctx);
                                _addReaction(msg['id'].toString(), emoji);
                              },
                              child: Text(
                                emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              const Divider(),
            ],
            if (!isDeleted && content.isNotEmpty) ...[
              _actionTile(Icons.reply_rounded, l.reply, () {
                Navigator.pop(ctx);
                _setReplyTo(msg);
              }),
              _actionTile(Icons.copy_rounded, l.copyMessage, () {
                Navigator.pop(ctx);
                Clipboard.setData(ClipboardData(text: content));
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.messageCopied),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                }
              }),
              if (!isGuest) ...[
                _actionTile(Icons.translate_rounded, l.translateMessage, () {
                  Navigator.pop(ctx);
                  _translateMessage(content);
                }),
                _actionTile(Icons.share_rounded, l.forwardMessage, () {
                  Navigator.pop(ctx);
                  _forwardMessage(msg);
                }),
              ],
            ],
            if (!isGuest) ...[
              _actionTile(
                isStarred ? Icons.star_rounded : Icons.star_border_rounded,
                isStarred ? l.unstarMessage : l.starMessage,
                () {
                  Navigator.pop(ctx);
                  _toggleStar(msg['id'].toString());
                },
                color: isStarred ? Colors.amber : null,
              ),
            ],
            _actionTile(Icons.info_outline_rounded, l.messageInfo, () {
              Navigator.pop(ctx);
              _showMessageInfo(msg);
            }),
            if (!isGuest && !isDeleted)
              _actionTile(
                Icons.delete_outline_rounded,
                l.deleteForMe,
                () {
                  Navigator.pop(ctx);
                  _deleteMessage(msg['id'].toString(), 'me');
                },
                color: AppColors.errorColor,
              ),
            if (!isGuest && isMe)
              _actionTile(
                Icons.delete_forever_rounded,
                l.deleteForEveryone,
                () {
                  Navigator.pop(ctx);
                  _confirmDeleteForEveryone(msg['id'].toString());
                },
                color: AppColors.errorColor,
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? color,
  }) {
    final tileColor = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, color: tileColor, size: 22),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(color: tileColor),
      ),
      onTap: onTap,
    );
  }

  void _confirmDeleteForEveryone(String messageId) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.confirmDeleteMessage),
        content: Text(l.confirmDeleteForEveryone),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteMessage(messageId, 'everyone');
            },
            child: Text(
              l.delete,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMessage(String messageId, String deleteType) async {
    final l = AppLocalizations.of(context)!;
    try {
      await ref
          .read(chatProvider.notifier)
          .deleteMessage(messageId, deleteType: deleteType);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.failedDeleteMessage)));
      }
    }
  }

  Future<void> _addReaction(String messageId, String emoji) async {
    try {
      await ref.read(chatProvider.notifier).addReaction(messageId, emoji);
    } catch (_) {}
  }

  Future<void> _toggleStar(String messageId) async {
    try {
      await ref.read(chatProvider.notifier).toggleStarMessage(messageId);
    } catch (_) {}
  }

  void _forwardMessage(Map<String, dynamic> msg) {
    final l = AppLocalizations.of(context)!;
    final chatState = ref.read(chatProvider);
    if (chatState is! ChatMessagesLoaded) return;
    showModalBottomSheet(
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
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l.forwardTo, style: AppTextStyles.titleMedium),
            ),
            ListTile(
              leading: Icon(
                Icons.support_agent_rounded,
                color: AppColors.primaryColor,
              ),
              title: Text(l.conversationWithAdmin),
              onTap: () {
                Navigator.pop(ctx);
                _doForward(msg['id'].toString(), int.parse(widget.id));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doForward(String messageId, int targetInboxId) async {
    try {
      final dio = DioClient.instance;
      await dio.post(
        ApiEndpoints.messageForward(messageId),
        data: {'target_inbox_id': targetInboxId},
      );
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.messageForwarded)));
      }
    } catch (_) {}
  }

  void _showMessageInfo(Map<String, dynamic> msg) {
    final l = AppLocalizations.of(context)!;
    final time = msg['created_at'] as String? ?? '';
    final readBy = (msg['read_by'] as List<dynamic>?) ?? [];
    final senderName = msg['sender_name'] as String? ?? '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(l.messageInfoTitle, style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              _infoRow(
                Icons.person_outline_rounded,
                l.csHumanSenderName,
                senderName,
              ),
              _infoRow(
                Icons.access_time_rounded,
                l.sentAt,
                Formatters.timeAgo(time),
              ),
              _infoRow(
                Icons.done_all_rounded,
                l.readBy,
                '${readBy.length} ${l.read}',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              Text(value, style: AppTextStyles.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _translateMessage(String text) async {
    final l = AppLocalizations.of(context)!;
    if (text.isEmpty) return;
    setState(() => _isTranslating = true);
    try {
      final currentLocale = Localizations.localeOf(context).languageCode;
      final targetLang = currentLocale == 'id' ? 'en' : 'id';
      final encoded = Uri.encodeComponent(text);
      final url =
          'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$targetLang&dt=t&q=$encoded';
      final dio = DioClient.instance;
      final response = await dio.get(url);
      final List<dynamic> data = response.data;
      final translated = (data[0] as List)
          .map((e) => (e as List)[0] as String)
          .join('');
      if (mounted) _showTranslatedResult(translated, text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.failedSendMessage)));
      }
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  void _showTranslatedResult(String translated, String original) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.translate_rounded,
                    size: 20,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(l.translatedResult, style: AppTextStyles.titleMedium),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withAlpha(15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  translated,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l.copyMessage,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                original,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Clipboard.setData(ClipboardData(text: translated));
                  },
                  child: Text(l.copyMessage),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRatingDialog() {
    final l = AppLocalizations.of(context)!;
    if (_isGuestSession) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.csGuestNoAttachments)));
      return;
    }
    int rating = 0;
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l.rateExperience),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l.rateExperienceHint, style: AppTextStyles.bodySmall),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => GestureDetector(
                    onTap: () => setDialogState(() => rating = i + 1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        i < rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 36,
                        color: i < rating
                            ? Colors.amber
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: l.rateExperienceHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: rating == 0
                  ? null
                  : () async {
                      Navigator.pop(ctx);
                      try {
                        final dio = DioClient.instance;
                        await dio.post(
                          ApiEndpoints.messageRate(widget.id),
                          data: {
                            'rating': rating,
                            'comment': commentController.text,
                          },
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l.ratingSubmitted)),
                          );
                        }
                      } catch (_) {}
                    },
              child: Text(l.send),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final chatState = ref.watch(chatProvider);

    final otherUser = chatState is ChatMessagesLoaded
        ? chatState.otherUser
        : null;
    final otherName = otherUser?['name'] as String? ?? l.csHumanSenderName;
    final otherPhoto = otherUser?['profile_photo'] as String?;
    final isTyping = chatState is ChatMessagesLoaded && chatState.isTyping;
    final messages = chatState is ChatMessagesLoaded
        ? chatState.messages
        : <Map<String, dynamic>>[];
    final filteredMessages = _filteredMessages(messages);
    final groupedItems = _groupByDate(filteredMessages);
    final showWelcome = messages.isEmpty && chatState is ChatMessagesLoaded;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/chat-list'),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: otherPhoto != null
                  ? CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(otherPhoto),
                    )
                  : Icon(
                      Icons.support_agent_rounded,
                      size: 18,
                      color: AppColors.primaryColor,
                    ),
            ),
            const SizedBox(width: AppSizes.sm),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherName,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ClipRect(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            l.csOnlineNow,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.green,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close_rounded : Icons.search_rounded,
              size: 22,
            ),
            onPressed: () => setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) _searchQuery = '';
            }),
          ),
          IconButton(
            icon: const Icon(Icons.star_rounded, size: 22),
            onPressed: _showRatingDialog,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, size: 20),
            onPressed: () async {
              final value = await showAppActionSheet<String>(
                context,
                actions: [
                  AppSheetAction(
                    value: 'rate',
                    label: l.rateExperience,
                    icon: Icons.star_rounded,
                  ),
                ],
              );
              if (value == 'rate') _showRatingDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.surfaceColor,
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l.searchMessages,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),
          Expanded(
            child: chatState is ChatLoading
                ? const Center(child: CircularProgressIndicator())
                : chatState is ChatError
                ? Center(child: Text(LocalizedError.of(l, chatState.message)))
                : showWelcome
                ? const SizedBox.shrink()
                : groupedItems.isEmpty
                ? Center(
                    child: Text(
                      l.noMessagesYet,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.md,
                    ),
                    itemCount: groupedItems.length + (isTyping ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == groupedItems.length) {
                        return _buildTypingIndicator(l);
                      }
                      final item = groupedItems[i];
                      if (item is Map<String, dynamic> &&
                          item['_type'] == 'date') {
                        return _buildDateSeparator(
                          _formatDateHeader(item['date'] as String, l),
                        );
                      }
                      final msg =
                          (item as Map<String, dynamic>)['msg']
                              as Map<String, dynamic>;
                      return _buildMessage(msg, l);
                    },
                  ),
          ),
          _buildReplyPreviewBar(),
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isTranslating)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l.translating,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.add_rounded,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                        onPressed: _showAttachmentOptions,
                        constraints: const BoxConstraints(
                          minWidth: 44,
                          minHeight: 44,
                        ),
                        splashRadius: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: _replyToMessage != null
                                ? l.reply
                                : l.typeMessage,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: AppColors.primaryColor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => _sendMessage(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(String dateText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            dateText,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReplyPreviewBar() {
    if (_replyToMessage == null) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;
    final name = _replyToMessage!['sender_name'] as String? ?? '';
    final message = ChatTextNormalizer.normalize(
      _replyToMessage!['message'] as String? ?? '',
    );
    final isMe = _replyToMessage!['is_me'] == true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withAlpha(15),
        border: Border(
          left: BorderSide(color: AppColors.primaryColor, width: 3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.replyingTo(isMe ? l.me : name),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            onPressed: _cancelReply,
            color: AppColors.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(AppLocalizations l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [_typingDot(0), _typingDot(1), _typingDot(2)],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l.csBotTyping,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _typingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (_, value, _) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withAlpha(
            (120 + (value * 135)).toInt(),
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildContextCard(Map<String, dynamic> meta) {
    final l = AppLocalizations.of(context)!;
    final isOrder = meta['is_order'] == true;
    if (isOrder) return _buildOrderContextCard(meta);
    final name = meta['name'] as String? ?? '';
    final price = meta['price'];
    final image = _fixImageUrl(meta['image'] as String? ?? '');
    final type = meta['type'] as String? ?? 'product';
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withAlpha(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 60,
                height: 60,
                child: image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Container(
                          color: AppColors.dividerColor,
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.dividerColor,
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.textTertiary,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type == 'package' ? l.packageLabel : l.productLabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(
                        (num.tryParse(price.toString()) ?? 0).toInt(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderContextCard(Map<String, dynamic> meta) {
    final l = AppLocalizations.of(context)!;
    final orderNumber = meta['order_number'] as String? ?? '';
    final orderStatus = meta['order_status'] as String? ?? '';
    final paymentStatus = meta['payment_status'] as String? ?? '';
    final name = meta['name'] as String? ?? '';
    final image = _fixImageUrl(meta['image'] as String? ?? '');
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.infoColor.withAlpha(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_rounded,
                size: 16,
                color: AppColors.infoColor,
              ),
              const SizedBox(width: 6),
              Text(
                l.order,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.infoColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '#$orderNumber',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (name.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) =>
                            Container(color: AppColors.secondaryColor),
                      ),
                    ),
                  ),
                if (image.isNotEmpty) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _orderBadge(
                orderStatus.isNotEmpty ? orderStatus : '-',
                AppColors.infoColor,
                AppColors.infoColor.withAlpha(25),
              ),
              _orderBadge(
                paymentStatus.isNotEmpty ? paymentStatus : '-',
                AppColors.warningColor,
                AppColors.warningColor.withAlpha(25),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatCurrency(int amount) => Formatters.currency(amount);

  // ─── Message Bubble ────────────────────────────────────────────────────
  Widget _buildMessage(Map<String, dynamic> msg, AppLocalizations l) {
    final isMe = msg['is_me'] == true;
    final content = ChatTextNormalizer.normalize(
      msg['message'] as String? ?? '',
    );
    final time = msg['created_at'] as String? ?? '';
    final senderName = msg['sender_name'] as String? ?? '';
    final attachments = msg['attachments'] as List<dynamic>? ?? [];
    final meta = msg['meta'] as Map<String, dynamic>?;
    final isBot = meta?['is_bot'] == true;
    final isDeleted = msg['is_deleted'] == true;
    final replyTo = meta?['reply_to'] as Map<String, dynamic>?;
    final reactions = (meta?['reactions'] as List<dynamic>?) ?? [];
    final readBy = (msg['read_by'] as List<dynamic>?) ?? [];
    final isForwarded = meta?['forwarded'] == true;
    final cardMeta =
        (meta != null &&
            meta['type'] != null &&
            meta['id'] != null &&
            meta['name'] != null &&
            meta['is_order'] != true)
        ? meta
        : (meta != null && meta['is_order'] == true && meta['order_id'] != null)
        ? meta
        : null;
    final displaySenderName = isBot ? l.csBotSenderName : senderName;

    final messageBubble = Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isMe && displaySenderName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isBot)
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.smart_toy_rounded,
                          size: 10,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    if (isBot) const SizedBox(width: 4),
                    Text(
                      displaySenderName,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isBot
                            ? AppColors.primaryColor
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            if (cardMeta != null)
              _buildContextCard(cardMeta)
            else
              GestureDetector(
                onLongPress: () => _showMessageActions(msg),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDeleted
                        ? AppColors.dividerColor
                        : isMe
                        ? AppColors.primaryColor
                        : isBot
                        ? AppColors.surfaceColor
                        : AppColors.secondaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isMe
                          ? const Radius.circular(16)
                          : Radius.zero,
                      bottomRight: isMe
                          ? Radius.zero
                          : const Radius.circular(16),
                    ),
                    border: isBot && !isMe
                        ? Border.all(
                            color: AppColors.primaryColor.withAlpha(30),
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isForwarded)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.forward_rounded,
                                size: 12,
                                color: isMe
                                    ? Colors.white70
                                    : AppColors.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                l.messageForwarded,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isMe
                                      ? Colors.white60
                                      : AppColors.textTertiary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (replyTo != null) _buildReplyBubble(replyTo),
                      if (attachments.isNotEmpty)
                        ...attachments.map((att) {
                          final isMap = att is Map;
                          final url = isMap
                              ? (att['url'] as String? ??
                                    att['original_url'] as String? ??
                                    '')
                              : att.toString();
                          final isVideo =
                              isMap && isVideoMime(att['mime_type'] as String?);
                          if (url.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: MediaTile(
                                url: url,
                                isVideo: isVideo,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      if (isDeleted)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.block_rounded,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l.messageDeleted,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textTertiary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        )
                      else
                        StructuredChatText(
                          text: content,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isMe ? Colors.white : AppColors.textPrimary,
                          ),
                          accentColor: isMe
                              ? Colors.white
                              : AppColors.primaryColor,
                        ),
                    ],
                  ),
                ),
              ),
            if (reactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.dividerColor),
                  ),
                  child: Text(
                    reactions.map((r) => r['emoji'] as String? ?? '').join(' '),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Formatters.timeAgo(time),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      readBy.isNotEmpty
                          ? Icons.done_all_rounded
                          : Icons.done_rounded,
                      size: 14,
                      color: readBy.isNotEmpty
                          ? Colors.blue
                          : AppColors.textTertiary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (isDeleted) return messageBubble;

    return Dismissible(
      key: ValueKey(msg['id']),
      direction: isMe
          ? DismissDirection.endToStart
          : DismissDirection.startToEnd,
      confirmDismiss: (_) async {
        _setReplyTo(msg);
        return false;
      },
      background: Container(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withAlpha(30),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.reply_rounded,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
      ),
      child: messageBubble,
    );
  }

  Widget _buildReplyBubble(Map<String, dynamic> replyTo) {
    final name = replyTo['sender_name'] as String? ?? '';
    final message = ChatTextNormalizer.normalize(
      replyTo['message'] as String? ?? '',
    );
    final senderId = replyTo['sender_id'];
    final isMe = _guestId != null
        ? replyTo['is_me'] == true
        : senderId != null && senderId == _currentUserId();
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(isMe ? 30 : 100),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isMe ? Colors.white70 : AppColors.primaryColor.withAlpha(80),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isMe ? Colors.white70 : AppColors.primaryColor,
            ),
          ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: isMe ? Colors.white60 : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OtpAndPasswordSheet extends StatefulWidget {
  final String email;
  final VoidCallback onSuccess;
  final Function(String error) onFailed;

  const _OtpAndPasswordSheet({
    required this.email,
    required this.onSuccess,
    required this.onFailed,
  });

  @override
  State<_OtpAndPasswordSheet> createState() => _OtpAndPasswordSheetState();
}

class _OtpAndPasswordSheetState extends State<_OtpAndPasswordSheet> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _otpVerified = false;
  bool _isProcessing = false;
  String? _error;
  int _resendCountdown = 120;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_otpFocusNodes[0].canRequestFocus) _otpFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _resendCountdown = 120;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCountdown <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    setState(() {});
    if (_otpCode.length == 6 && !_otpVerified) {
      setState(() => _otpVerified = true);
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;
    try {
      final dio = DioClient.instance;
      await dio.post(
        ApiEndpoints.forgotPassword,
        data: {'email': widget.email},
      );
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.csOtpResentToEmail(widget.email))),
        );
        _startResendCountdown();
      }
    } catch (_) {}
  }

  Future<void> _resetPassword() async {
    final l = AppLocalizations.of(context)!;
    final otp = _otpCode;
    final newPass = _newPassController.text;
    final confirmPass = _confirmPassController.text;

    if (otp.length != 6) {
      setState(() => _error = l.csInvalidOtp);
      return;
    }
    if (newPass.length < 12) {
      setState(() => _error = l.csPasswordMinLength);
      return;
    }
    if (newPass != confirmPass) {
      setState(() => _error = l.csPasswordsDoNotMatch);
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });
    try {
      final dio = DioClient.instance;
      await dio.post(
        ApiEndpoints.resetPassword,
        data: {
          'email': widget.email,
          'otp': otp,
          'password': newPass,
          'password_confirmation': confirmPass,
        },
      );
      if (!mounted) return;
      Navigator.pop(context);
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _error = l.csPasswordChangeFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l.csResetPasswordTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  l.csEnterOtpToReset,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  widget.email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (i) => Container(
                    width: 42,
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    child: TextField(
                      controller: _otpControllers[i],
                      focusNode: _otpFocusNodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (v) => _onOtpChanged(i, v),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: _resendCountdown > 0
                    ? Text(
                        l.csResendOtpIn(_resendCountdown),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      )
                    : TextButton(
                        onPressed: _resendOtp,
                        child: Text(
                          l.resendOtp,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
              ),
              if (_otpVerified) ...[
                const SizedBox(height: 16),
                Divider(color: AppColors.dividerColor),
                const SizedBox(height: 16),
                Text(
                  l.newPassword,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _newPassController,
                  obscureText: _obscureNew,
                  decoration: InputDecoration(
                    hintText: l.csNewPasswordHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureNew
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureNew = !_obscureNew),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l.confirmNewPassword,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPassController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    hintText: l.csConfirmPasswordHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _error!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.errorColor,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : _otpVerified
                      ? _resetPassword
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    disabledBackgroundColor: AppColors.primaryColor.withAlpha(
                      120,
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _otpVerified ? l.save : l.verify,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onFailed(l.cancel);
                  },
                  child: Text(
                    l.cancel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
