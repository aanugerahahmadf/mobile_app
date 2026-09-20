import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../cs_guest_chat/cs_guest_chat.dart';

import '../../../../auth/presentation/providers/auth_provider/auth_provider.dart';
import '../../providers/chat_provider.dart';

String reportCsCategory(String category) {
  switch (category) {
    case 'order':
    case 'payment':
      return 'order_help';
    case 'product':
    case 'package':
    case 'vendor':
    case 'review':
    default:
      return 'bug_report';
  }
}

String reportCategoryLabel(AppLocalizations l, String category) {
  switch (category) {
    case 'product':
      return l.reportProduct;
    case 'package':
      return l.reportPackage;
    case 'vendor':
      return l.reportVendor;
    case 'order':
      return l.reportOrder;
    case 'review':
      return l.reportReview;
    default:
      return l.reportGeneral;
  }
}

/// Membuka halaman chat customer service dan otomatis mengirim pesan bawaan
/// berisi laporan yang lengkap terhadap [itemName] (kategori [category]).
///
/// [itemContext] diteruskan agar tampil kartu konteks item yang dilaporkan,
/// dan [details] ditambahkan sebagai keterangan tambahan pada pesan.
Future<void> openReportChat(
  BuildContext context,
  WidgetRef ref, {
  required String category,
  required String itemName,
  Map<String, dynamic>? itemContext,
  String? details,
}) async {
  final l = AppLocalizations.of(context)!;
  final auth = ref.read(authProvider);
  final isGuest = auth is! AuthAuthenticated;
  final senderName = auth is AuthAuthenticated
      ? (auth.user.fullName.isNotEmpty
            ? auth.user.fullName
            : auth.user.username)
      : l.guestName;

  final csCategory = reportCsCategory(category);
  final subject = itemName.trim().isNotEmpty
      ? itemName.trim()
      : reportCategoryLabel(l, category);
  final catLabel = reportCategoryLabel(l, category);

  var message = l.reportChatIntro(catLabel, subject);
  if (details != null && details.trim().isNotEmpty) {
    message = '$message\n\n$details';
  }
  message = '$message${l.reportChatPrompt}';

  final notifier = ref.read(chatProvider.notifier);
  String inboxId;
  String? guestId;
  try {
    if (!isGuest) {
      await notifier.loadConversations();
      final chatState = ref.read(chatProvider);
      if (chatState is ChatConversationsLoaded &&
          chatState.conversations.isNotEmpty) {
        inboxId = chatState.conversations.first['id'].toString();
      } else {
        inboxId = (await notifier.startConversation()).toString();
      }
    } else {
      guestId = await getOrCreateGuestId();
      inboxId = (await notifier.startGuestConversation(
        guestId: guestId,
        csCategory: csCategory,
      )).toString();
    }
  } catch (_) {
    if (!context.mounted) return;
    try {
      if (!isGuest) {
        inboxId = (await notifier.startConversation()).toString();
      } else {
        guestId = await getOrCreateGuestId();
        inboxId = (await notifier.startGuestConversation(
          guestId: guestId,
          csCategory: csCategory,
        )).toString();
      }
    } catch (_) {
      return;
    }
  }

  try {
    if (!isGuest) {
      await notifier.sendMessage(
        inboxId: int.parse(inboxId),
        message: message,
        senderName: senderName,
        csCategory: csCategory,
        itemContext: itemContext,
      );
    } else {
      await notifier.sendGuestMessage(
        inboxId: int.parse(inboxId),
        message: message,
        guestId: guestId!,
        senderName: senderName,
        csCategory: csCategory,
      );
    }
  } catch (_) {}

  if (context.mounted) {
    final extra = isGuest
        ? {'cs_category': csCategory, 'guestId': guestId}
        : {'cs_category': csCategory};
    context.push('/chat/$inboxId', extra: extra);
  }
}
