import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';

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
    final auth = ref.read(authProvider);
    if (auth is AuthAuthenticated) {
      return auth.user.fullName.isNotEmpty ? auth.user.fullName : auth.user.username;
    }
    return 'saya'.tr();
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

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    try {
      await ref.read(chatProvider.notifier).sendMessage(
        inboxId: int.parse(widget.id),
        message: text,
        senderName: _senderName(),
      );
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('gagal_mengirim_pesan'.tr())),
        );
      }
    }
  }

  Widget _buildContextCard(Map<String, dynamic> meta) {
    final isOrder = meta['is_order'] == true;

    if (isOrder) {
      return _buildOrderContextCard(meta);
    }

    final name = meta['name'] as String? ?? '';
    final price = meta['price'];
    final image = meta['image'] as String? ?? '';
    final type = meta['type'] as String? ?? 'product';

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
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
                        errorWidget: (_, _, _) => Container(color: Colors.grey[200],
                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                        ),
                      )
                    : Container(color: Colors.grey[200],
                        child: const Icon(Icons.image_outlined, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type == 'package' ? 'paket'.tr() : 'produk'.tr(),
                    style: TextStyle(fontSize: 10, color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(name,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                    maxLines: 2, overflow: TextOverflow.ellipsis,
                  ),
                  if (price != null) ...[
                    const SizedBox(height: 2),
                    Text(_formatCurrency((price as num).toInt()),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFE53935)),
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
    final orderNumber = meta['order_number'] as String? ?? '';
    final orderStatus = meta['order_status'] as String? ?? '';
    final paymentStatus = meta['payment_status'] as String? ?? '';
    final name = meta['name'] as String? ?? '';
    final image = meta['image'] as String? ?? '';

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3F2FD)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_rounded, size: 16, color: Color(0xFF1565C0)),
              const SizedBox(width: 6),
              Text('pesanan'.tr(),
                style: const TextStyle(fontSize: 10, color: Color(0xFF1565C0), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('#$orderNumber',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E)),
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
                        errorWidget: (_, _, _) => Container(color: Colors.grey[200]),
                      ),
                    ),
                  ),
                if (image.isNotEmpty) const SizedBox(width: 8),
                Expanded(
                  child: Text(name,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF666680)),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              _orderBadge(orderStatus.isNotEmpty ? orderStatus : '-', const Color(0xFF1565C0), const Color(0xFFE3F2FD)),
              const SizedBox(width: 8),
              _orderBadge(paymentStatus.isNotEmpty ? paymentStatus : '-', const Color(0xFFE65100), const Color(0xFFFFF3E0)),
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

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(title: Text('chat_dengan_admin'.tr())),
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
                                        color: isMe ? AppColors.primaryColor : Colors.grey[100],
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
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'ketik_pesan'.tr(),
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
                      onPressed: _sendMessage,
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
