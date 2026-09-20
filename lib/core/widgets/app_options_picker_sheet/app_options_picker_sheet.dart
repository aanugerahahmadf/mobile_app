import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_text_styles/app_text_styles.dart';

Future<void> showAppOptionsPicker(
  BuildContext context, {
  required String title,
  required List<String> options,
  required String currentValue,
  required void Function(String value) onSelected,
  int? columns,
}) async {
  final screen = MediaQuery.sizeOf(context);
  final viewPadding = MediaQuery.paddingOf(context);

  final box = context.findRenderObject() as RenderBox?;
  final fieldRect = box?.localToGlobal(Offset.zero) ?? Offset.zero;

  final fieldWidth = box?.size.width ?? 0.0;
  final panelWidth =
      fieldWidth.clamp(math.min(220.0, screen.width - 16), screen.width - 16)
          .toDouble();

  final left = fieldRect.dx.clamp(8.0, screen.width - panelWidth - 8.0).toDouble();

  final opensUpward = fieldRect.dy > screen.height / 2;

  double? top;
  double? bottom;
  if (opensUpward) {
    bottom = screen.height - fieldRect.dy + 6;
  } else {
    top = fieldRect.dy + (box?.size.height ?? 0) + 6;
  }

  final selected = await showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, _) => _AppOptionsOverlay(
      title: title,
      options: options,
      currentValue: currentValue,
      left: left,
      top: top,
      bottom: bottom,
      panelWidth: panelWidth,
      topInset: viewPadding.top,
      columns: columns,
      onSelected: (v) => Navigator.of(dialogContext).pop(v),
    ),
    transitionBuilder: (dialogContext, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return Opacity(
        opacity: curved.value,
        child: Transform.scale(
          scale: 0.94 + 0.06 * curved.value,
          alignment: opensUpward
              ? Alignment.bottomCenter
              : Alignment.topCenter,
          child: child,
        ),
      );
    },
  );
  if (selected != null) onSelected(selected);
}

class _AppOptionsOverlay extends StatefulWidget {
  final String title;
  final List<String> options;
  final String currentValue;
  final double left;
  final double? top;
  final double? bottom;
  final double panelWidth;
  final double topInset;
  final int? columns;
  final ValueChanged<String> onSelected;

  const _AppOptionsOverlay({
    required this.title,
    required this.options,
    required this.currentValue,
    required this.left,
    required this.top,
    required this.bottom,
    required this.panelWidth,
    required this.topInset,
    this.columns,
    required this.onSelected,
  });

  @override
  State<_AppOptionsOverlay> createState() => _AppOptionsOverlayState();
}

class _AppOptionsOverlayState extends State<_AppOptionsOverlay> {
  late final TextEditingController _searchController;
  late List<String> _filtered;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filtered = List.of(widget.options);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List.of(widget.options)
          : widget.options
              .where((o) => o.toLowerCase().contains(q))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        if (widget.top != null)
          Positioned(
            left: widget.left,
            top: widget.top,
            width: widget.panelWidth,
            child: _buildPanel(isDark),
          )
        else if (widget.bottom != null)
          Positioned(
            left: widget.left,
            bottom: widget.bottom! + widget.topInset,
            width: widget.panelWidth,
            child: _buildPanel(isDark),
          ),
      ],
    );
  }

  Widget _buildPanel(bool isDark) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.5;
    final isGrid = widget.columns != null && widget.columns! > 1;

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : AppColors.dividerColor.withValues(alpha: 0.7),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                    visualDensity: VisualDensity.compact,
                    tooltip: AppLocalizations.of(context)!.close,
                  ),
                ],
              ),
            ),
            if (!isGrid)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filter,
                  style: AppTextStyles.bodyMedium,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.calendarSearch,
                    hintStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: ListenableBuilder(
                      listenable: _searchController,
                      builder: (context, _) {
                        return _searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _filter('');
                                },
                                icon: Icon(
                                  Icons.cancel_rounded,
                                  size: 16,
                                  color: AppColors.textTertiary,
                                ),
                                visualDensity: VisualDensity.compact,
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : AppColors.secondaryColor,
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 11),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            Flexible(
              child: _filtered.isEmpty
                  ? _EmptyState(isDark: isDark)
                  : isGrid
                      ? _buildGrid(isDark)
                      : _buildList(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.columns!,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 2.2,
        ),
        itemCount: _filtered.length,
        itemBuilder: (context, index) {
          final option = _filtered[index];
          final selected = option == widget.currentValue;
          return _GridCell(
            option: option,
            selected: selected,
            isDark: isDark,
            onTap: () => widget.onSelected(option),
          );
        },
      ),
    );
  }

  Widget _buildList(bool isDark) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 6),
      itemCount: _filtered.length,
      itemBuilder: (context, index) {
        final option = _filtered[index];
        final selected = option == widget.currentValue;
        return _OptionTile(
          option: option,
          selected: selected,
          onTap: () => widget.onSelected(option),
        );
      },
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String option;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor.withValues(alpha: isDark ? 0.16 : 0.10)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            selected
                ? Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppColors.primaryColor,
                  )
                : const SizedBox(width: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                option,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected
                      ? AppColors.primaryColor
                      : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  height: 1.3,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.radio_button_checked,
                size: 18,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final String option;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _GridCell({
    required this.option,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppColors.primaryColor.withValues(alpha: isDark ? 0.16 : 0.10)
          : isDark
              ? Colors.white.withValues(alpha: 0.08)
              : AppColors.secondaryColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: Text(
            option,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: selected
                  ? AppColors.primaryColor
                  : AppColors.textPrimary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isDark;

  const _EmptyState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 32,
            color: isDark
                ? Colors.white.withValues(alpha: 0.25)
                : AppColors.textTertiary,
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.calendarNoResults,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}