import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/utils/formatters/formatters.dart';
import '../../../../../core/utils/guest_mode/guest_mode.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../providers/chat_provider.dart';
import '../../utils/chat_text_normalizer/chat_text_normalizer.dart';
import '../../utils/cs_guest_chat/cs_guest_chat.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({super.key, this.isGuestMode = false});

  final bool isGuestMode;

  @override
  ConsumerState<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  bool _loading = false;

  final _searchController = TextEditingController();
  String _searchQuery = '';

  bool get _isGuest =>
      widget.isGuestMode ||
      ref.read(guestModeProvider).isGuest ||
      ref.read(authProvider) is! AuthAuthenticated;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _startOrOpenChat() async {
    setState(() => _loading = true);
    try {
      final auth = ref.read(authProvider);
      final notifier = ref.read(chatProvider.notifier);
      if (auth is! AuthAuthenticated || _isGuest) {
        final guestId = await getOrCreateGuestId();
        if (!mounted) return;
        final inboxId = await notifier.startGuestConversation(guestId: guestId);
        if (!mounted) return;
        context.push('/chat/$inboxId', extra: {'guestId': guestId});
        return;
      }
      await notifier.loadConversations();
      final chatState = ref.read(chatProvider);
      if (!mounted) return;
      if (chatState is ChatConversationsLoaded &&
          chatState.conversations.isNotEmpty) {
        context.push('/chat/${chatState.conversations.first['id']}');
      } else {
        final inboxId = await notifier.startConversation();
        if (!mounted) return;
        context.push('/chat/$inboxId');
      }
    } catch (e) {
      if (!mounted) return;
      try {
        final auth = ref.read(authProvider);
        final notifier = ref.read(chatProvider.notifier);
        if (auth is! AuthAuthenticated || _isGuest) {
          final guestId = await getOrCreateGuestId();
          if (!mounted) return;
          final inboxId = await notifier.startGuestConversation(
            guestId: guestId,
          );
          if (!mounted) return;
          context.push('/chat/$inboxId', extra: {'guestId': guestId});
        } else {
          final inboxId = await notifier.startConversation();
          if (!mounted) return;
          context.push('/chat/$inboxId');
        }
      } catch (_) {
        _showError(AppLocalizations.of(context)!.failedStartConversation);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _startChatWithCategory(String category) async {
    setState(() => _loading = true);
    try {
      final auth = ref.read(authProvider);
      final notifier = ref.read(chatProvider.notifier);
      if (auth is! AuthAuthenticated || _isGuest) {
        final guestId = await getOrCreateGuestId();
        if (!mounted) return;
        final inboxId = await notifier.startGuestConversation(
          guestId: guestId,
          csCategory: category,
        );
        if (!mounted) return;
        context.push(
          '/chat/$inboxId',
          extra: {'guestId': guestId, 'cs_category': category},
        );
        return;
      }
      await notifier.loadConversations();
      final chatState = ref.read(chatProvider);
      String inboxId;
      if (chatState is ChatConversationsLoaded &&
          chatState.conversations.isNotEmpty) {
        inboxId = chatState.conversations.first['id'].toString();
      } else {
        inboxId = (await notifier.startConversation()).toString();
      }
      if (!mounted) return;
      context.push('/chat/$inboxId', extra: {'cs_category': category});
    } catch (e) {
      if (!mounted) return;
      try {
        final auth = ref.read(authProvider);
        final notifier = ref.read(chatProvider.notifier);
        if (auth is! AuthAuthenticated || _isGuest) {
          final guestId = await getOrCreateGuestId();
          if (!mounted) return;
          final inboxId = await notifier.startGuestConversation(
            guestId: guestId,
            csCategory: category,
          );
          if (!mounted) return;
          context.push(
            '/chat/$inboxId',
            extra: {'guestId': guestId, 'cs_category': category},
          );
        } else {
          final inboxId = await notifier.startConversation();
          if (!mounted) return;
          context.push('/chat/$inboxId', extra: {'cs_category': category});
        }
      } catch (_) {
        _showError(AppLocalizations.of(context)!.failedStartConversation);
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await ref.read(guestModeProvider.notifier).load();
      if (!mounted) return;
      final isGuest = _isGuest;
      Map<String, dynamic>? extra;
      try {
        extra = GoRouter.of(context).state.extra as Map<String, dynamic>?;
      } catch (_) {
        // Standalone/widget-test contexts do not provide GoRouter.
      }
      final inboxId = extra?['inboxId'] as String?;
      if (inboxId != null) {
        if (isGuest) {
          final guestId = await getOrCreateGuestId();
          if (!mounted) return;
          context.push(
            '/chat/$inboxId',
            extra: {'guestId': guestId, 'cs_category': extra?['cs_category']},
          );
          return;
        }
        context.push(
          '/chat/$inboxId',
          extra: {'cs_category': extra?['cs_category']},
        );
        return;
      }
      // Tidak auto-buka chat: tampilkan halaman list untuk guest maupun user.
      if (isGuest) {
        // Guest / belum login: jangan panggil loadConversations (butuh auth).
        return;
      }
      await ref.read(chatProvider.notifier).loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final chatState = ref.watch(chatProvider);
    final isGuest = _isGuest;

    // Guest / belum login: langsung tampilkan UI guest, tanpa spinner auth.
    if (isGuest) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.canPop() ? context.pop() : null,
          ),
          title: Text(l.csTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: _buildUserView(l, chatState),
      );
    }

    if (chatState is ChatLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.csTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.canPop() ? context.pop() : null,
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (chatState is ChatError) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.canPop() ? context.pop() : null,
          ),
          title: Text(l.csTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_off_rounded,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  chatState.message,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSizes.lg),
                AppButton(
                  label: l.tryAgain,
                  onPressed: () =>
                      ref.read(chatProvider.notifier).loadConversations(),
                  type: ButtonType.primary,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop() ? context.pop() : null,
        ),
        title: Text(l.csTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildUserView(l, chatState),
    );
  }

  Widget _buildUserView(AppLocalizations l, ChatState chatState) {
    final isGuest = _isGuest || ref.read(authProvider) is! AuthAuthenticated;

    // Di mode guest, kartu aksi yang berbau katalog/paket/produk/transaksi disembunyikan.
    const guestHiddenCategories = {
      'order_help',
      'payment_issue',
      'decor_consultation',
    };

    final csActions =
        [
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
            ]
            .where(
              (a) => !(isGuest && guestHiddenCategories.contains(a.category)),
            )
            .toList();

    final conversations = chatState is ChatConversationsLoaded
        ? chatState.conversations
        : const <Map<String, dynamic>>[];
    final query = _searchQuery.trim().toLowerCase();
    final filtered = query.isEmpty
        ? conversations
        : conversations.where((c) {
            final title = (c['title'] as String? ?? '').toLowerCase();
            final userName =
                (c['other_user'] as Map<String, dynamic>?)?['name']
                    as String? ??
                '';
            final lastMsg =
                (c['last_message'] as Map<String, dynamic>?)?['message']
                    as String? ??
                '';
            return title.contains(query) ||
                userName.toLowerCase().contains(query) ||
                lastMsg.toLowerCase().contains(query);
          }).toList();

    return RefreshIndicator(
      onRefresh: isGuest
          ? () async {}
          : () async => ref.read(chatProvider.notifier).loadConversations(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        children: [
          const SizedBox(height: AppSizes.md),
          _buildStatusCard(l),
          const SizedBox(height: AppSizes.md),
          TextFormField(
            controller: _searchController,
            onChanged: (v) => setState(() => _searchQuery = v),
            textInputAction: TextInputAction.search,
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: l.csSearchHint,
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.textTertiary,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppColors.textTertiary,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.surfaceColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          if (!isGuest && conversations.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l.csYourConversations,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${conversations.length}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.dividerColor.withAlpha(60),
                  ),
                ),
                child: Text(
                  l.csEmptyConversations,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...filtered.map((conv) => _buildConversationCard(l, conv)),
            const SizedBox(height: AppSizes.md),
          ],
          Text(
            conversations.isEmpty ? l.csWelcomeDesc : l.selectConversation,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          ...csActions.map((action) => _buildCsActionCard(action, l)),
          const SizedBox(height: AppSizes.md),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: _loading ? '' : l.csNewChat,
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

  Widget _buildStatusCard(AppLocalizations l) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            child: const Icon(
              Icons.support_agent_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.csWelcomeTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7CFC9A),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(40),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        l.csOnlineNow,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withAlpha(230),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(AppLocalizations l, Map<String, dynamic> conv) {
    final id = conv['id'];
    if (id == null) return const SizedBox.shrink();
    final otherUser = conv['other_user'] as Map<String, dynamic>?;
    final title = ChatTextNormalizer.normalize(
      conv['title'] as String? ?? l.conversationWithAdmin,
    );
    final lastMsg = conv['last_message'] as Map<String, dynamic>?;
    final unread = (conv['unread_count'] as int?) ?? 0;
    final lastMessage = ChatTextNormalizer.normalize(
      lastMsg?['message'] as String? ?? '',
    );
    final preview = lastMessage.isEmpty ? l.noMessages : lastMessage;
    final time = lastMsg?['created_at'] != null
        ? Formatters.timeAgo(lastMsg!['created_at'] as String)
        : '';
    final initial = title.isNotEmpty ? title[0].toUpperCase() : '?';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.dividerColor.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryColor.withAlpha(25),
              child: _buildAvatarContent(otherUser, initial),
            ),
            if (unread > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(40),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(minWidth: 18),
                  child: Text(
                    unread > 99 ? '99+' : '$unread',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        subtitle: Text(
          preview,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: unread > 0 ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
        trailing: Text(
          time,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textTertiary,
            fontSize: 11,
          ),
        ),
        onTap: () => context.push('/chat/$id'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildAvatarContent(Map<String, dynamic>? otherUser, String initial) {
    final photoUrl = otherUser?['profile_photo'] as String?;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          Formatters.imageUrl(photoUrl),
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) =>
              Icon(Icons.support_agent_rounded, color: AppColors.primaryColor),
        ),
      );
    }
    return Text(
      initial,
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.primaryColor,
        fontWeight: FontWeight.bold,
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
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 6,
          ),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: action.color.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(action.icon, color: action.color, size: 22),
          ),
          title: Text(
            action.title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            action.subtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textTertiary,
            size: 20,
          ),
          onTap: () => _startChatWithCategory(action.category),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
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
