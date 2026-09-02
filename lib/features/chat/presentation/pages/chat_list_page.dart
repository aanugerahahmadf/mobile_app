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

  Future<void> _startChatWithCategory(String category) async {
    setState(() => _loading = true);
    try {
      final notifier = ref.read(chatProvider.notifier);
      await notifier.loadConversations();
      final chatState = ref.read(chatProvider);
      String inboxId;
      if (chatState is ChatConversationsLoaded && chatState.conversations.isNotEmpty) {
        inboxId = chatState.conversations.first['id'].toString();
      } else {
        inboxId = (await notifier.startConversation()).toString();
      }
      if (mounted) {
        context.go('/chat/$inboxId', extra: {'cs_category': category});
      }
    } catch (_) {
      if (mounted) {
        final notifier = ref.read(chatProvider.notifier);
        final inboxId = await notifier.startConversation();
        if (mounted) context.go('/chat/$inboxId', extra: {'cs_category': category});
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
        appBar: AppBar(title: Text(l.csTitle), backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.csTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
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
              Icon(Icons.support_agent_rounded, size: 80, color: AppColors.primaryColor.withAlpha(150)),
              const SizedBox(height: AppSizes.md),
              Text(l.csNoConversationsDesc, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
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

          return Container(
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
          );
        },
      ),
    );
  }

  Widget _buildUserView(AppLocalizations l) {
    final csActions = [
      _CsAction(
        icon: Icons.bug_report_outlined,
        color: Colors.orange,
        title: l.csQuickBugReport,
        subtitle: l.csQuickBugReportDesc,
        category: 'bug_report',
      ),
      _CsAction(
        icon: Icons.person_outline_rounded,
        color: Colors.blue,
        title: l.csQuickAccountIssue,
        subtitle: l.csQuickAccountIssueDesc,
        category: 'account_issue',
      ),
      _CsAction(
        icon: Icons.receipt_long_outlined,
        color: Colors.green,
        title: l.csQuickOrderHelp,
        subtitle: l.csQuickOrderHelpDesc,
        category: 'order_help',
      ),
      _CsAction(
        icon: Icons.payment_outlined,
        color: Colors.red,
        title: l.csQuickPaymentIssue,
        subtitle: l.csQuickPaymentIssueDesc,
        category: 'payment_issue',
      ),
      _CsAction(
        icon: Icons.local_florist_outlined,
        color: Colors.pink,
        title: l.csQuickDecorConsult,
        subtitle: l.csQuickDecorConsultDesc,
        category: 'decor_consultation',
      ),
      _CsAction(
        icon: Icons.help_outline_rounded,
        color: Colors.teal,
        title: l.csQuickGeneralQuestion,
        subtitle: l.csQuickGeneralQuestionDesc,
        category: 'general_question',
      ),
    ];

    return RefreshIndicator(
      onRefresh: () async => ref.read(chatProvider.notifier).loadConversations(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        children: [
          const SizedBox(height: AppSizes.md),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withAlpha(200),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withAlpha(60),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.csWelcomeTitle,
                        style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(l.csSubtitle,
                        style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withAlpha(220))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          Text(l.csWelcomeDesc,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSizes.md),
          ...csActions.map((action) => _buildCsActionCard(action, l)),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _loading ? '' : l.csStartChat,
              loading: _loading,
              onPressed: _startOrOpenChat,
              type: ButtonType.primary,
            ),
          ),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }

  Widget _buildCsActionCard(_CsAction action, AppLocalizations l) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor.withAlpha(60)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: action.color.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(action.icon, color: action.color, size: 22),
        ),
        title: Text(action.title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(action.subtitle,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
        trailing: Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 20),
        onTap: () => _startChatWithCategory(action.category),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _CsAction {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String category;

  const _CsAction({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.category,
  });
}
