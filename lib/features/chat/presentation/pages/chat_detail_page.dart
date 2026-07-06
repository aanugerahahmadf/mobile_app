import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ChatDetailPage extends ConsumerStatefulWidget {
  final String id;

  const ChatDetailPage({super.key, required this.id});

  @override
  ConsumerState<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends ConsumerState<ChatDetailPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).loadMessages(widget.id);
      _startPolling();
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      ref.read(chatProvider.notifier).refreshMessages(widget.id);
    });
  }

  String _senderName() {
    final l = AppLocalizations.of(context)!;
    final auth = ref.read(authProvider);
    if (auth is AuthAuthenticated) {
      return auth.user.fullName.isNotEmpty ? auth.user.fullName : auth.user.username;
    }
    return l.me;
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

  Future<void> _sendMessage({String? filePath}) async {
    final l = AppLocalizations.of(context)!;
    final text = _messageController.text.trim();
    if (text.isEmpty && filePath == null) return;

    _messageController.clear();
    try {
      await ref.read(chatProvider.notifier).sendMessage(
        inboxId: int.parse(widget.id),
        message: text,
        senderName: _senderName(),
        filePath: filePath,
      );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failedSendMessage)),
        );
      }
    }
  }

  void _showAttachmentOptions() {
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
                Text(l.attachment,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                _attachmentOption(
                  icon: Icons.camera_alt_rounded,
                  title: l.camera,
                  subtitle: l.takePhotoDirect,
                  onTap: () { context.pop(); _pickImage(ImageSource.camera); },
                ),
                _attachmentOption(
                  icon: Icons.photo_library,
                  title: l.gallery,
                  subtitle: l.chooseFromGallery,
                  onTap: () { context.pop(); _pickImage(ImageSource.gallery); },
                ),
                _attachmentOption(
                  icon: Icons.folder_open_rounded,
                  title: l.file,
                  subtitle: l.chooseFromStorage,
                  onTap: () { context.pop(); _pickFile(); },
                ),
                _attachmentOption(
                  icon: Icons.cloud,
                  title: l.googleDrive,
                  subtitle: l.chooseFromDrive,
                  onTap: () { context.pop(); _pickFromDrive(); },
                ),
                _attachmentOption(
                  icon: Icons.category_rounded,
                  title: l.catalog,
                  subtitle: l.shareProduct,
                  onTap: () { context.pop(); _pickFromCatalog(); },
                ),
                _attachmentOption(
                  icon: Icons.receipt_long_rounded,
                  title: l.order,
                  subtitle: l.shareOrderDetail,
                  onTap: () { context.pop(); _pickFromOrders(); },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 1024);
    if (picked != null && mounted) {
      await _sendMessage(filePath: picked.path);
      _scrollToBottom();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty && mounted) {
      final path = result.files.first.path;
      if (path != null) {
        await _sendMessage(filePath: path);
        _scrollToBottom();
      }
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
                                decoration: BoxDecoration(color: AppColors.successColor.withAlpha(25), borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.cloud, color: AppColors.successColor, size: 24),
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

      await _sendMessage(filePath: file.path);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failedFetchFromDrive.replaceFirst('%s', e.toString()))),
        );
      }
    }
  }

  Future<void> _pickFromCatalog() async {
    try {
      final dio = DioClient.instance;
      final results = await Future.wait([
        dio.get(ApiEndpoints.packages, queryParameters: {'per_page': 20}),
        dio.get(ApiEndpoints.products, queryParameters: {'per_page': 20}),
      ]);
      final packages = ((results[0].data['data'] as List?) ?? []).map((e) => e as Map<String, dynamic>..['_type'] = 'package').toList();
      final products = ((results[1].data['data'] as List?) ?? []).map((e) => e as Map<String, dynamic>..['_type'] = 'product').toList();
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
                width: 36, height: 4, margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(l.chooseProduct,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.45,
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 70),
                  itemBuilder: (_, i) {
                    final item = items[i];
                    final imageUrl = _fixImageUrl(item['image_url'] as String? ?? (() {
                      final images = item['media'] as List? ?? item['images'] as List? ?? [];
                      if (images.isEmpty) return '';
                      final first = images.first;
                      return first is String ? first : (first['url'] as String? ?? first['original_url'] as String? ?? '');
                    })());
                    final name = item['name'] as String? ?? '';
                    final price = item['price'];
                    final type = item['_type'] as String? ?? '';
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: imageUrl.isNotEmpty
                            ? CachedNetworkImage(imageUrl: imageUrl, width: 48, height: 48, fit: BoxFit.cover)
                            : Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(color: AppColors.secondaryColor, borderRadius: BorderRadius.circular(8)),
                                child: Icon(Icons.image_outlined, color: AppColors.textTertiary),
                              ),
                      ),
                      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('$type · Rp ${price != null ? (price is int ? price.toString() : price.toString()) : '0'}'),
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

      await ref.read(chatProvider.notifier).sendMessage(
        inboxId: int.parse(widget.id),
        message: '',
        senderName: _senderName(),
        itemContext: {
          'type': selected['_type'] as String? ?? 'product',
          'item_id': selected['id'],
          'item_name': selected['name'] as String? ?? '',
          'item_price': selected['price'],
          'item_image': _fixImageUrl(selected['image_url'] as String? ?? (() {
            final images = selected['media'] as List? ?? selected['images'] as List? ?? [];
            if (images.isEmpty) return '';
            final first = images.first;
            return first is String ? first : (first['url'] as String? ?? first['original_url'] as String? ?? '');
          })()),
        },
      );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failedLoadCatalog)),
        );
      }
    }
  }

  Future<void> _pickFromOrders() async {
    try {
      final dio = DioClient.instance;
      final response = await dio.get(ApiEndpoints.bookings, queryParameters: {'per_page': 20});
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
                width: 36, height: 4, margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(color: AppColors.dividerColor, borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Text(l.chooseOrder,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.45,
                child: ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, indent: 16),
                  itemBuilder: (_, i) {
                    final order = orders[i];
                    final orderNumber = order['order_number'] as String? ?? '';
                    final status = order['status'] as String? ?? '';
                    final title = order['title'] as String? ?? '';
                    return ListTile(
                      title: Text('#$orderNumber', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(status.isNotEmpty ? '$status · $title' : title, maxLines: 1, overflow: TextOverflow.ellipsis),
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

      await ref.read(chatProvider.notifier).sendMessage(
        inboxId: int.parse(widget.id),
        message: '',
        senderName: _senderName(),
        itemContext: {
          'order_id': selected['id'],
        },
      );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        final l = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.failedLoadOrders)),
        );
      }
    }
  }

  Widget _attachmentOption({
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

  String _fixImageUrl(String url) => url.replaceAll('/storage/', '/media/');

  Widget _buildContextCard(Map<String, dynamic> meta) {
    final isOrder = meta['is_order'] == true;

    if (isOrder) {
      return _buildOrderContextCard(meta);
    }

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
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 60, height: 60,
                child: image.isNotEmpty
                    ? CachedNetworkImage(imageUrl: image, fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Container(color: AppColors.dividerColor,
                        child: Icon(Icons.image_outlined, color: AppColors.textTertiary),
                      ),
                    )
                    : Container(color: AppColors.dividerColor,
                        child: Icon(Icons.image_outlined, color: AppColors.textTertiary),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type == 'package' ? 'Paket' : 'Produk',
                    style: TextStyle(fontSize: 10, color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(name,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  if (price != null) ...[
                    const SizedBox(height: 2),
                    Text(_formatCurrency((num.tryParse(price.toString()) ?? 0).toInt()),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.errorColor),
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
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, size: 16, color: AppColors.infoColor),
              const SizedBox(width: 6),
              Text(l.order,
                style: const TextStyle(fontSize: 10, color: AppColors.infoColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('#$orderNumber',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          if (name.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: SizedBox(
                      width: 36, height: 36,
                      child: CachedNetworkImage(imageUrl: image, fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Container(color: AppColors.secondaryColor),
                      ),
                    ),
                  ),
                if (image.isNotEmpty) const SizedBox(width: 8),
                Expanded(
                  child: Text(name,
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              _orderBadge(orderStatus.isNotEmpty ? orderStatus : '-', AppColors.infoColor, AppColors.infoColor.withAlpha(25)),
              const SizedBox(width: 8),
              _orderBadge(paymentStatus.isNotEmpty ? paymentStatus : '-', AppColors.warningColor, AppColors.warningColor.withAlpha(25)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  void _showImagePreview(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(url, fit: BoxFit.contain, width: double.infinity, height: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final chatState = ref.watch(chatProvider);

    final otherUser = chatState is ChatMessagesLoaded ? chatState.otherUser : null;
    final otherName = otherUser?['name'] as String? ?? l.navChat;
    final otherPhoto = otherUser?['profile_photo'] as String?;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/chat-list'),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: otherPhoto != null
                  ? () => _showImagePreview(otherPhoto)
                  : null,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.secondaryColor,
                backgroundImage: otherPhoto != null ? NetworkImage(otherPhoto) : null,
                child: otherPhoto == null
                    ? Icon(Icons.person, size: 18, color: AppColors.primaryColor)
                    : null,
              ),
            ),
            const SizedBox(width: AppSizes.sm),
            Flexible(child: Text(otherName, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState is ChatLoading
                ? const Center(child: CircularProgressIndicator())
                : chatState is ChatMessagesLoaded
                    ? ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppSizes.md),
                        itemCount: chatState.messages.length,
                        itemBuilder: (context, index) {
                          final msg = chatState.messages[index];
                          final isMe = msg['is_me'] == true;
                          final content = msg['message'] as String? ?? '';
                          final time = msg['created_at'] as String? ?? '';
                          final senderName = msg['sender_name'] as String? ?? '';
                          final attachments = msg['attachments'] as List<dynamic>? ?? [];
                          final meta = msg['meta'] as Map<String, dynamic>?;

                          final cardMeta = (meta != null && meta['type'] != null && meta['id'] != null && meta['name'] != null && meta['is_order'] != true)
                              ? meta
                              : (meta != null && meta['is_order'] == true && meta['order_id'] != null)
                                  ? meta
                                  : null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Align(
                              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  if (!isMe && senderName.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4, left: 4),
                                      child: Text(senderName,
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.primaryColor, fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  if (cardMeta != null)
                                    _buildContextCard(cardMeta)
                                  else
                                    Container(
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isMe ? AppColors.primaryColor : AppColors.secondaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(16),
                                          topRight: const Radius.circular(16),
                                          bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
                                          bottomRight: isMe ? Radius.zero : const Radius.circular(16),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (attachments.isNotEmpty)
                                            ...attachments.map((att) {
                                              final url = att is Map
                                                  ? (att['url'] as String? ?? att['original_url'] as String? ?? '')
                                                  : att.toString();
                                              if (url.isNotEmpty) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(bottom: 4),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.network(url, fit: BoxFit.cover, height: 160, width: double.infinity),
                                                  ),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            }),
                                          Text(content,
                                            style: AppTextStyles.bodyMedium.copyWith(
                                              color: isMe ? Colors.white : AppColors.textPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, left: 4),
                                    child: Text(Formatters.timeAgo(time),
                                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : chatState is ChatError
                        ? Center(child: Text(chatState.message))
                        : const SizedBox.shrink(),
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor.withAlpha(60),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add_rounded, color: AppColors.primaryColor, size: 24),
                      onPressed: _showAttachmentOptions,
                      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      splashRadius: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: l.typeMessage,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
