import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/l10n/app_localizations.dart';

/// The navigation history used by breadcrumbs throughout the app.
///
/// The first entry is set by a visible bottom-navigation tab. Every route
/// pushed after that is appended here, so breadcrumbs describe the actual
/// navigation path instead of a hard-coded page hierarchy.
class AppNavigationTrail extends ChangeNotifier {
  AppNavigationTrail._();

  static final instance = AppNavigationTrail._();
  final List<TrailEntry> _entries = [];

  List<TrailEntry> get entries => List.unmodifiable(_entries);

  void startAt(String path, String label) {
    final normalized = _normalize(path);
    _entries
      ..clear()
      ..add(TrailEntry(normalized, label));
    notifyListeners();
  }

  void ensureOrigin(String path, String label) {
    if (_entries.isEmpty) startAt(path, label);
  }

  void record(String path) {
    final normalized = _normalize(path);
    if (normalized.isEmpty || _isIgnored(normalized)) return;
    if (_entries.isEmpty) {
      // A detail route can be opened directly (for example from a
      // notification). It still needs a bottom-navigation root.
      _entries.add(const TrailEntry('/home', 'Home'));
      if (normalized != '/home') {
        _entries.add(TrailEntry(normalized, normalized));
      }
    } else if (_entries.last.path != normalized) {
      final existing = _entries.indexWhere((entry) => entry.path == normalized);
      if (existing >= 0) {
        _entries.removeRange(existing + 1, _entries.length);
      } else {
        _entries.add(TrailEntry(normalized, normalized));
      }
    }
    notifyListeners();
  }

  void pop(String? path) {
    if (_entries.length <= 1) return;
    if (path != null) {
      final index = _entries.lastIndexWhere((entry) => entry.path == _normalize(path));
      if (index >= 0) {
        _entries.removeRange(index, _entries.length);
      }
    } else {
      _entries.removeLast();
    }
    notifyListeners();
  }

  void setCurrentLabel(String path, String label) {
    if (_entries.isEmpty || label.trim().isEmpty) return;
    final normalized = _normalize(path);
    if (_entries.last.path == normalized && _entries.last.fallbackLabel != label) {
      _entries[_entries.length - 1] = TrailEntry(normalized, label.trim());
      notifyListeners();
    }
  }

  void insertBeforeCurrent(String path, String label) {
    if (_entries.isEmpty || label.trim().isEmpty) return;
    final normalized = _normalize(path);
    if (_entries.any((entry) => entry.path == normalized)) return;
    _entries.insert(_entries.length - 1, TrailEntry(normalized, label.trim()));
    notifyListeners();
  }

  String labelFor(String path, AppLocalizations l, {String? fallback}) {
    final normalized = _normalize(path);
    if (normalized == '/home') return l.navHome;
    if (normalized == '/orders') return l.navOrders;
    if (normalized == '/cart') return l.navCart;
    if (normalized == '/profile') return l.navProfile;
    if (normalized == '/catalog') return l.flowerDecorationsCatalog;
    if (normalized.startsWith('/catalog/')) {
      return fallback != null && fallback != normalized
          ? fallback
          : l.catalogDetail;
    }
    if (normalized == '/search') return l.search;
    if (normalized == '/cbir-result') return l.searchResults;
    if (normalized == '/settings') return l.settings;
    if (normalized == '/storage-and-data') return l.storageAndData;
    if (normalized == '/password-and-security') return l.passwordAndSecurity;
    if (normalized == '/change-password') return l.changePassword;
    if (normalized == '/two-factor-settings') return l.twoFactorAuth;
    if (normalized == '/checkout') return l.checkout;
    if (normalized == '/chat-list') return l.navChat;
    if (normalized.startsWith('/chat/')) {
      return fallback != null && fallback != normalized ? fallback : l.navChat;
    }
    if (normalized.startsWith('/order/')) {
      return fallback != null && fallback != normalized ? fallback : l.orderDetail;
    }
    if (normalized == '/orders') return l.orderHistory;
    if (normalized == '/notifications') return l.notifications;
    if (normalized.startsWith('/notification/')) return l.notifications;
    if (normalized == '/notification-settings') return l.notificationSettings;
    if (normalized == '/language') return l.language;
    if (normalized == '/vouchers') return l.vouchers;
    if (normalized.startsWith('/vouchers/')) return l.voucherDetail;
    if (normalized == '/history') return l.history;
    if (normalized == '/privacy-policy') return l.privacyPolicy;
    if (normalized == '/terms-of-service') return l.termsOfService;
    if (normalized == '/wedding-policy') return l.weddingPolicy;
    if (normalized == '/help-center') return l.helpCenter;
    if (normalized == '/payment-method') return l.paymentMethod;
    if (normalized == '/payment-instruction') return l.paymentInstructions;
    if (normalized.startsWith('/payment-method/')) return l.paymentMethod;
    if (normalized.startsWith('/payment-webview')) return l.payment;
    if (normalized.startsWith('/payment/')) return l.payment;
    if (normalized == '/menu') return l.menu;
    return fallback != null && fallback != normalized
        ? fallback
        : normalized.substring(1).replaceAll('-', ' ');
  }

  static String _normalize(String path) {
    final value = path.split('?').first;
    if (value.length > 1 && value.endsWith('/')) return value.substring(0, value.length - 1);
    return value;
  }

  static bool _isIgnored(String path) => path == '/' || path == '/startup' || path == '/landing' ||
      path == '/login' || path == '/register' || path.startsWith('/auth');
}

class TrailEntry {
  const TrailEntry(this.path, this.fallbackLabel);
  final String path;
  final String fallbackLabel;
}

class AppBreadcrumbs extends StatelessWidget {
  const AppBreadcrumbs({super.key, required this.items});
  const AppBreadcrumbs.global({super.key}) : items = null;

  final List<AppBreadcrumbItem>? items;

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      return AnimatedBuilder(
        animation: AppNavigationTrail.instance,
        builder: (context, _) {
          final l = AppLocalizations.of(context)!;
          final trail = AppNavigationTrail.instance.entries;
          if (trail.length <= 1) return const SizedBox.shrink();
          return _build(context, [
            for (final entry in trail)
              AppBreadcrumbItem(
                AppNavigationTrail.instance.labelFor(
                  entry.path,
                  l,
                  fallback: entry.fallbackLabel,
                ),
                onTap: entry.path == trail.last.path
                    ? null
                    : () => context.go(entry.path),
              ),
          ]);
        },
      );
    }
    return _build(context, items!);
  }

  Widget _build(BuildContext context, List<AppBreadcrumbItem> items) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 38,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                Icon(Icons.chevron_right_rounded, size: 18, color: colors.onSurface.withValues(alpha: .45)),
              InkWell(
                onTap: items[i].onTap,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Text(
                    items[i].label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: i == items.length - 1 ? FontWeight.w600 : FontWeight.w500,
                      color: i == items.length - 1 ? colors.onSurface : colors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppBreadcrumbItem {
  const AppBreadcrumbItem(this.label, {this.onTap});

  final String label;
  final VoidCallback? onTap;
}

/// Adds breadcrumbs to routes that do not provide an AppBar of their own.
/// Pages with a custom/inline breadcrumb opt out to avoid rendering it twice.
class AppBreadcrumbRouteView extends StatelessWidget {
  const AppBreadcrumbRouteView({super.key, required this.child, required this.path});

  final Widget child;
  final String path;

  @override
  Widget build(BuildContext context) {
    if (_isExcluded(path)) return child;
    return Column(
      children: [
        const AppBreadcrumbs.global(),
        Expanded(child: child),
      ],
    );
  }

  static bool _isExcluded(String path) {
    final normalized = path.split('?').first;
    if (normalized == '/startup' || normalized == '/landing' ||
        normalized == '/app-lock' || normalized == '/onboarding' ||
        normalized == '/login' || normalized == '/register' ||
        normalized.startsWith('/auth') || normalized == '/security-question' ||
        normalized == '/two-factor-setup') {
      return true;
    }
    return normalized == '/settings' || normalized == '/orders' ||
        normalized == '/storage-and-data' || normalized == '/checkout' ||
        normalized == '/search' || normalized == '/cbir-result' ||
        normalized == '/chat-list' || normalized.startsWith('/chat/') ||
        normalized.startsWith('/catalog/') || normalized.startsWith('/order/') ||
        normalized.startsWith('/payment/');
  }
}
