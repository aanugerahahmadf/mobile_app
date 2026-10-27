import 'package:flutter/material.dart';

/// Compact, horizontally scrollable route hierarchy for mobile screens.
/// The current page is shown as plain text; previous levels are tappable.
class AppBreadcrumbs extends StatelessWidget {
  const AppBreadcrumbs({super.key, required this.items});

  final List<AppBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 17,
                    color: scheme.onSurface.withValues(alpha: .42),
                  ),
                ),
              if (i == items.length - 1)
                Text(
                  items[i].label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                InkWell(
                  onTap: items[i].onTap,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 2),
                    child: Text(
                      items[i].label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
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
