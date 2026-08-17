import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/chat_provider.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key});

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  bool _loading = false;
  List<Map<String, dynamic>> _customers = [];
  bool _loadingCustomers = false;

  Future<void> _startOrOpenChat() async {
    setState(() => _loading = true);
    try {
      final notifier = ref.read(chatProvider.notifier);
      await notifier.loadConversations();

      final chatState = ref.read(chatProvider);
      if (chatState is ChatConversationsLoaded && chatState.conversations.isNotEmpty) {
        if (mounted) context.go('/chat/${chatState.conversations.first['id']}');
      } else {
        final inboxId = await notifier.startConversation();
        if (mounted) context.go('/chat/$inboxId');
      }
    } catch (_) {
      if (mounted) {
        final notifier = ref.read(chatProvider.notifier);
        final inboxId = await notifier.startConversation();
        if (mounted) context.go('/chat/$inboxId');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _chatWithCustomer(Map<String, dynamic> customer) async {
    setState(() => _loading = true);
    try {
      final notifier = ref.read(chatProvider.notifier);
      final customerId = customer['id'] as int;
      final inboxId = await notifier.startConversation(itemContext: {'with_user_id': customerId});
      if (mounted) context.go('/chat/$inboxId');
    } catch (_) {
      if (mounted) {
        final inboxId = await ref.read(chatProvider.notifier).startConversation();
        if (mounted) context.go('/chat/$inboxId');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadCustomers() async {
    setState(() => _loadingCustomers = true);
    try {
      final customers = await ref.read(chatProvider.notifier).getCustomersForChat();
      if (mounted) setState(() => _customers = customers);
    } catch (_) {}
    if (mounted) setState(() => _loadingCustomers = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(chatProvider.notifier).loadConversations();
      final state = ref.read(chatProvider);
      if (state is ChatConversationsLoaded && state.isSuperAdmin) {
        _loadCustomers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final chatState = ref.watch(chatProvider);

    final isSuperAdmin = chatState is ChatConversationsLoaded && chatState.isSuperAdmin;

    if (chatState is ChatLoading && _customers.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l.navChat), backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.navChat), backgroundColor: Colors.transparent, elevation: 0),
      body: isSuperAdmin ? _buildAdminView(l) : _buildUserView(l),
    );
  }

  Widget _buildAdminView(AppLocalizations l) {
    if (_loadingCustomers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_customers.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people_outline, size: 80, color: AppColors.primaryColor.withAlpha(150)),
              const SizedBox(height: AppSizes.md),
              Text(l.loadCustomers, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSizes.lg),
              AppButton(label: l.loadCustomersAction, onPressed: _loadCustomers, type: ButtonType.primary),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCustomers,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSizes.sm),
        itemCount: _customers.length,
        itemBuilder: (_, i) {
          final c = _customers[i];
          final name = c['full_name'] as String? ?? c['username'] as String? ?? 'User';
          final email = c['email'] as String? ?? '';
          final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

          return Dismissible(
            key: ValueKey('customer_${c['id']}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSizes.md),
              margin: const EdgeInsets.only(bottom: AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.errorColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
            ),
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Text(l.delete),
                  content: Text(l.deleteChatConfirm),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(l.delete, style: const TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) => setState(() => _customers.removeAt(i)),
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSizes.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.dividerColor.withAlpha(80)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryColor.withAlpha(25),
                  child: Text(initial,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                ),
                title: Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(email, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.chat_outlined, color: AppColors.primaryColor, size: 20),
                ),
                onTap: () => _chatWithCustomer(c),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserView(AppLocalizations l) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_outlined, size: 80, color: AppColors.primaryColor.withAlpha(150)),
            const SizedBox(height: AppSizes.lg),
            Text(l.chatWithAdmin, style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.sm),
            Text(l.chatWithAdminDesc, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: AppSizes.xl),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: l.chatWithAdmin,
                loading: _loading,
                onPressed: _startOrOpenChat,
                type: ButtonType.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
