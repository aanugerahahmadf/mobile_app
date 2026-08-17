import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';

class AdminInboxesPage extends ConsumerStatefulWidget {
  const AdminInboxesPage({super.key});

  @override
  ConsumerState<AdminInboxesPage> createState() => _AdminInboxesPageState();
}

class _AdminInboxesPageState extends ConsumerState<AdminInboxesPage> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => _loading = true);
    try {
      final res = await DioClient.instance.get(ApiEndpoints.adminInboxes);
      final data = res.data['data'];
      List<Map<String, dynamic>> items;
      if (data is List) {
        items = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('data')) {
        items = (data['data'] as List).cast<Map<String, dynamic>>();
      } else {
        items = [];
      }
      if (mounted) setState(() { _items = items; _loading = false; });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _viewMessages(Map<String, dynamic> item) async {
    final id = item['id'] as int? ?? 0;
    try {
      final res = await DioClient.instance.get(ApiEndpoints.adminInbox(id));
      final data = res.data['data'] as Map<String, dynamic>? ?? item;
      if (!mounted) return;
      _showMessageDialog(data);
    } catch (_) {
      if (mounted) _showMessageDialog(item);
    }
  }

  void _showMessageDialog(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InboxDetailSheet(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.adminInboxes), backgroundColor: Colors.transparent, elevation: 0),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(child: Text(l.noData, style: AppTextStyles.bodyMedium))
              : RefreshIndicator(
                  onRefresh: _fetch,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (_, i) {
                      final item = _items[i];
                      final title = item['title'] as String? ?? '-';
                      final participants = item['participants'] as List? ?? [];
                      final messagesCount = item['messages_count'] as int? ?? 0;
                      final lastMsg = item['last_message'] as Map<String, dynamic>?;
                      final lastMsgText = lastMsg?['message'] as String?;
                      final updatedAt = item['updated_at'] as String?;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Material(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          elevation: 1,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _viewMessages(item),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44, height: 44,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.inbox, color: AppColors.primaryColor, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 2),
                                        if (lastMsgText != null)
                                          Text(lastMsgText, style: TextStyle(fontSize: 12, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Text('${participants.length} participants', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                            const SizedBox(width: 8),
                                            Text('$messagesCount messages', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                            if (updatedAt != null) ...[
                                              const Spacer(),
                                              Text(updatedAt, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class _InboxDetailSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  const _InboxDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final title = item['title'] as String? ?? '-';
    final messages = item['messages'] as List<dynamic>? ?? [];
    final participants = item['participants'] as List? ?? [];

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.textTertiary.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.titleMedium),
            if (participants.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('${l.userName}: ${participants.map((p) => p['name'] ?? p['email'] ?? '-').join(', ')}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: 16),
            Flexible(
              child: messages.isEmpty
                ? Center(child: Text(l.noData, style: AppTextStyles.bodyMedium))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: messages.length,
                    itemBuilder: (_, i) {
                      final msg = messages[i] as Map<String, dynamic>;
                      final sender = msg['sender'] as Map<String, dynamic>?;
                      final senderName = sender?['name']?.toString() ?? 'User #${msg['sender_id']}';
                      final text = msg['message'] as String? ?? '-';
                      final createdAt = msg['created_at'] as String?;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.dividerColor.withValues(alpha: 0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(senderName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                  const Spacer(),
                                  if (createdAt != null)
                                    Text(createdAt, style: const TextStyle(fontSize: 9, color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(text, style: const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        ),
      ),
    );
  }
}
