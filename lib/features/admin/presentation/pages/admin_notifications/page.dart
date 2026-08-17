import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import 'package:mobile_app/core/api/api_endpoints.dart';
import 'package:mobile_app/core/api/dio_client.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../base/base_page.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AdminCrudPage(
      title: l.adminNotifications,
      listEndpoint: ApiEndpoints.adminNotifications,
      storeEndpoint: ApiEndpoints.adminSendNotification,
      detailEndpoint: ApiEndpoints.adminNotification,
      updateEndpoint: ApiEndpoints.adminNotification,
      deleteEndpoint: ApiEndpoints.adminNotification,
      fields: [FieldConfig('id', isTitle: true), FieldConfig('type'), FieldConfig('created_at')],
      cardBuilder: (item, onEdit, onDelete) => _NotificationCard(item: item, onEdit: onEdit, onDelete: onDelete),
      formFields: const [],
      customFormBuilder: _buildSendForm,
    );
  }

  static Future<Map<String, dynamic>?> _buildSendForm(
    BuildContext context,
    Map<String, dynamic>? item,
    Map<String, List<Map<String, dynamic>>> preloaded,
  ) async {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SendNotificationForm(item: item),
    );
  }
}

class _SendNotificationForm extends StatefulWidget {
  final Map<String, dynamic>? item;
  const _SendNotificationForm({this.item});

  @override
  State<_SendNotificationForm> createState() => _SendNotificationFormState();
}

class _SendNotificationFormState extends State<_SendNotificationForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _sendToAll = false;
  String? _selectedUserId;
  List<Map<String, dynamic>> _users = [];
  bool _loadingUsers = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _isEdit = widget.item != null;
    if (_isEdit) {
      final data = widget.item!['data'];
      if (data is Map<String, dynamic>) {
        _titleCtrl.text = data['title']?.toString() ?? '';
        _messageCtrl.text = data['message']?.toString() ?? '';
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    if (_sendToAll) return;
    setState(() => _loadingUsers = true);
    try {
      final res = await DioClient.instance.get(ApiEndpoints.adminUsers);
      final data = res.data['data'];
      List<Map<String, dynamic>> items;
      if (data is List) {
        items = data.cast<Map<String, dynamic>>();
      } else if (data is Map && data.containsKey('data')) {
        items = (data['data'] as List).cast<Map<String, dynamic>>();
      } else {
        items = [];
      }
      setState(() { _users = items; _loadingUsers = false; });
    } catch (_) {
      setState(() { _users = []; _loadingUsers = false; });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final data = <String, dynamic>{
      'title': _titleCtrl.text.trim(),
      'message': _messageCtrl.text.trim(),
    };
    if (!_sendToAll) {
      if (_selectedUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.selectUser)),
        );
        return;
      }
      data['user_id'] = int.parse(_selectedUserId!);
    }
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.textTertiary.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              Text(l.sendNotification, style: AppTextStyles.titleMedium),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleCtrl,
                        decoration: InputDecoration(
                          labelText: l.title,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? l.fieldRequired : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _messageCtrl,
                        decoration: InputDecoration(
                          labelText: l.message,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        maxLines: 4,
                        validator: (v) => v == null || v.trim().isEmpty ? l.fieldRequired : null,
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text(l.allUsers),
                        value: _sendToAll,
                        onChanged: (v) {
                          setState(() => _sendToAll = v);
                          if (!v) _fetchUsers();
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (!_sendToAll) ...[
                        const SizedBox(height: 8),
                        _loadingUsers
                          ? const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))
                          : DropdownButtonFormField<String>(
                              initialValue: _selectedUserId,
                              decoration: InputDecoration(
                                labelText: l.selectUser,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: _users.map((u) => DropdownMenuItem(
                                value: '${u['id']}',
                                child: Text('${u['name'] ?? u['email'] ?? '-'}'),
                              )).toList(),
                              onChanged: (v) => setState(() => _selectedUserId = v),
                            ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)),
                  const SizedBox(width: 8),
                  FilledButton(onPressed: _submit, child: Text(l.send)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _NotificationCard({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final type = item['type'] as String? ?? '-';
    final data = item['data'] as Map<String, dynamic>?;
    final title = data?['title'] as String? ?? '-';
    final readAt = item['read_at'] as String?;
    final createdAt = item['created_at'] as String?;

    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: readAt == null ? AppColors.infoColor.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(readAt == null ? 'New' : 'Read', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: readAt == null ? AppColors.infoColor : Colors.grey)),
                ),
                const Spacer(),
                GestureDetector(onTap: onDelete, child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.errorColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.delete_outline, size: 18, color: AppColors.errorColor),
                )),
              ],
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(type, style: TextStyle(fontSize: 10, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis),
            if (createdAt != null) ...[
              const SizedBox(height: 2),
              Text(createdAt, style: const TextStyle(fontSize: 9, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }
}
