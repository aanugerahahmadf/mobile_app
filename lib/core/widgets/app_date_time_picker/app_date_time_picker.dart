import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_text_styles/app_text_styles.dart';
import '../app_options_picker_sheet/app_options_picker_sheet.dart';
const _fallbackMonthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _fallbackWeekdayLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

List<String> _localizedMonthNames(BuildContext context) {
  final locale =
      Intl.canonicalizedLocale(Localizations.localeOf(context).toLanguageTag());
  try {
    final format = DateFormat('MMMM', locale);
    return [for (var m = 1; m <= 12; m++) format.format(DateTime(2000, m))];
  } catch (_) {
    return _fallbackMonthNames;
  }
}

List<String> _localizedWeekdayLabels(BuildContext context) {
  final locale =
      Intl.canonicalizedLocale(Localizations.localeOf(context).toLanguageTag());
  try {
    final format = DateFormat('EEE', locale);
    return [for (var d = 0; d < 7; d++) format.format(DateTime(2024, 1, 1 + d))];
  } catch (_) {
    return _fallbackWeekdayLabels;
  }
}

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  bool emphasizeAvailable = false,
  bool isCheckout = false,
  bool isBirthday = false,
}) {
  final screen = MediaQuery.sizeOf(context);
  final viewPadding = MediaQuery.paddingOf(context);

  final box = context.findRenderObject() as RenderBox?;
  final fieldRect = box?.localToGlobal(Offset.zero) ?? Offset.zero;

  final fieldWidth = box?.size.width ?? 0.0;
  final panelWidth =
      fieldWidth.clamp(math.min(310.0, screen.width - 16), screen.width - 16)
          .toDouble();

  final left =
      fieldRect.dx.clamp(8.0, screen.width - panelWidth - 8.0).toDouble();

  final opensUpward = fieldRect.dy > screen.height / 2;

  double? top;
  double? bottom;
  if (opensUpward) {
    bottom = screen.height - fieldRect.dy + 6;
  } else {
    top = fieldRect.dy + (box?.size.height ?? 0) + 6;
  }

  return showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, _) => _AnchoredDateOverlay(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      emphasizeAvailable: emphasizeAvailable,
      isCheckout: isCheckout,
      isBirthday: isBirthday,
      left: left,
      top: top,
      bottom: bottom,
      panelWidth: panelWidth,
      topInset: viewPadding.top,
      onPicked: (v) => Navigator.of(dialogContext).pop(v),
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
}

Future<TimeOfDay?> showAppTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  final screen = MediaQuery.sizeOf(context);
  final viewPadding = MediaQuery.paddingOf(context);

  final box = context.findRenderObject() as RenderBox?;
  final fieldRect = box?.localToGlobal(Offset.zero) ?? Offset.zero;

  final fieldWidth = box?.size.width ?? 0.0;
  final panelWidth =
      fieldWidth.clamp(math.min(280.0, screen.width - 16), screen.width - 16)
          .toDouble();

  final left =
      fieldRect.dx.clamp(8.0, screen.width - panelWidth - 8.0).toDouble();

  final opensUpward = fieldRect.dy > screen.height / 2;

  double? top;
  double? bottom;
  if (opensUpward) {
    bottom = screen.height - fieldRect.dy + 6;
  } else {
    top = fieldRect.dy + (box?.size.height ?? 0) + 6;
  }

  return showGeneralDialog<TimeOfDay>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (dialogContext, animation, _) => _AnchoredTimeOverlay(
      initialTime: initialTime,
      left: left,
      top: top,
      bottom: bottom,
      panelWidth: panelWidth,
      topInset: viewPadding.top,
      onPicked: (v) => Navigator.of(dialogContext).pop(v),
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
}

Future<void> showAppDatePickerField(
  BuildContext context,
  TextEditingController controller, {
  bool isCheckout = false,
  bool isBirthday = true,
}) async {
  final now = DateTime.now();
  final initial = controller.text.isNotEmpty
      ? DateTime.tryParse(controller.text) ?? now
      : now;
  final picked = await showAppDatePicker(
    context: context,
    initialDate: initial,
    firstDate: isCheckout ? now : DateTime(1900),
    lastDate: isCheckout ? now.add(const Duration(days: 365 * 5)) : now,
    isCheckout: isCheckout,
    isBirthday: isBirthday,
  );
  if (picked != null) {
    controller.text = '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }
}

Widget _buildPanelHeader(
  BuildContext context, {
  required String title,
  required bool isDark,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
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
  );
}

enum _CalendarViewMode { days, months, years }

class _AnchoredDateOverlay extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool emphasizeAvailable;
  final bool isCheckout;
  final bool isBirthday;
  final double left;
  final double? top;
  final double? bottom;
  final double panelWidth;
  final double topInset;
  final ValueChanged<DateTime> onPicked;

  const _AnchoredDateOverlay({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.emphasizeAvailable = false,
    this.isCheckout = false,
    this.isBirthday = false,
    required this.left,
    required this.top,
    required this.bottom,
    required this.panelWidth,
    required this.topInset,
    required this.onPicked,
  });

  @override
  State<_AnchoredDateOverlay> createState() => _AnchoredDateOverlayState();
}

class _AnchoredDateOverlayState extends State<_AnchoredDateOverlay> {
  late int _displayedYear;
  late int _displayedMonth;
  late DateTime _minMonth;
  late DateTime _maxMonth;
  late DateTime _minDay;
  late DateTime _maxDay;
  late int _yearPageStart;
  _CalendarViewMode _viewMode = _CalendarViewMode.days;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _minDay = DateTime(
      widget.firstDate.year,
      widget.firstDate.month,
      widget.firstDate.day,
    );
    _maxDay = DateTime(
      widget.lastDate.year,
      widget.lastDate.month,
      widget.lastDate.day,
    );
    _minMonth = DateTime(widget.firstDate.year, widget.firstDate.month);
    _maxMonth = DateTime(widget.lastDate.year, widget.lastDate.month);

    var year = widget.initialDate.year;
    var month = widget.initialDate.month;

    if (widget.isCheckout) {
      final currentMonthDate = DateTime(now.year, now.month);
      if (DateTime(year, month).isBefore(currentMonthDate)) {
        year = now.year;
        month = now.month;
      }
    }

    if (DateTime(year, month).isBefore(_minMonth)) {
      year = _minMonth.year;
      month = _minMonth.month;
    } else if (DateTime(year, month).isAfter(_maxMonth)) {
      year = _maxMonth.year;
      month = _maxMonth.month;
    }
    _displayedYear = year;
    _displayedMonth = month;
    _yearPageStart = (_displayedYear ~/ 12) * 12;
  }

  void _goToMonth(int year, int month) {
    var target = DateTime(year, month);
    if (widget.isCheckout) {
      final currentMonthDate = DateTime(DateTime.now().year, DateTime.now().month);
      if (target.isBefore(currentMonthDate)) target = currentMonthDate;
    }
    if (target.isBefore(_minMonth)) target = _minMonth;
    if (target.isAfter(_maxMonth)) target = _maxMonth;
    setState(() {
      _displayedYear = target.year;
      _displayedMonth = target.month;
      _yearPageStart = (_displayedYear ~/ 12) * 12;
    });
  }

  void _prevMonth() {
    final target = DateTime(_displayedYear, _displayedMonth - 1);
    if (widget.isCheckout) {
      final currentMonthDate = DateTime(DateTime.now().year, DateTime.now().month);
      if (target.isBefore(currentMonthDate)) return;
    }
    if (target.isBefore(_minMonth)) return;
    _goToMonth(target.year, target.month);
  }

  void _nextMonth() {
    final target = DateTime(_displayedYear, _displayedMonth + 1);
    if (target.isAfter(_maxMonth)) return;
    _goToMonth(target.year, target.month);
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
            child: _buildDatePanel(isDark),
          )
        else if (widget.bottom != null)
          Positioned(
            left: widget.left,
            bottom: widget.bottom! + widget.topInset,
            width: widget.panelWidth,
            child: _buildDatePanel(isDark),
          ),
      ],
    );
  }

  Widget _buildDatePanel(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: Container(
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
            _buildPanelHeader(
              context,
              title: _viewMode == _CalendarViewMode.months
                  ? AppLocalizations.of(context)!.calendarSelectMonth
                  : _viewMode == _CalendarViewMode.years
                      ? AppLocalizations.of(context)!.calendarSelectYear
                      : AppLocalizations.of(context)!.calendarSelectDate,
              isDark: isDark,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: _buildBody(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(isDark),
        const SizedBox(height: 8),
        Stack(
          children: [
            _buildDaysView(isDark),
            if (_viewMode == _CalendarViewMode.months ||
                _viewMode == _CalendarViewMode.years)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : AppColors.dividerColor,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: _viewMode == _CalendarViewMode.months
                      ? _buildMonthOverlay(isDark)
                      : _buildYearOverlay(isDark),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    final today = DateTime.now();
    final prevEnabled = widget.isCheckout
        ? !DateTime(_displayedYear, _displayedMonth - 1).isBefore(DateTime(today.year, today.month))
        : !DateTime(_displayedYear, _displayedMonth - 1).isBefore(_minMonth);
    final nextEnabled = !DateTime(_displayedYear, _displayedMonth + 1).isAfter(_maxMonth);

    return Row(
      children: [
        IconButton(
          onPressed: (_viewMode == _CalendarViewMode.days && prevEnabled)
              ? _prevMonth
              : null,
          icon: const Icon(Icons.chevron_left_rounded),
          color: AppColors.textPrimary,
          iconSize: 22,
          visualDensity: VisualDensity.compact,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _CalendarHeaderChip(
                text: _localizedMonthNames(context)[_displayedMonth - 1],
                isOpen: _viewMode == _CalendarViewMode.months,
                onTap: () {
                  setState(() {
                    _viewMode = _viewMode == _CalendarViewMode.months
                        ? _CalendarViewMode.days
                        : _CalendarViewMode.months;
                  });
                },
              ),
              const SizedBox(width: 8),
              _CalendarHeaderChip(
                text: '$_displayedYear',
                isOpen: _viewMode == _CalendarViewMode.years,
                onTap: () {
                  setState(() {
                    if (_viewMode == _CalendarViewMode.years) {
                      _viewMode = _CalendarViewMode.days;
                    } else {
                      _yearPageStart = (_displayedYear ~/ 12) * 12;
                      _viewMode = _CalendarViewMode.years;
                    }
                  });
                },
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: (_viewMode == _CalendarViewMode.days && nextEnabled)
              ? _nextMonth
              : null,
          icon: const Icon(Icons.chevron_right_rounded),
          color: AppColors.textPrimary,
          iconSize: 22,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildMonthOverlay(bool isDark) {
    final months = _localizedMonthNames(context);
    final today = DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 4; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                for (var col = 0; col < 3; col++) ...[
                  if (col > 0) const SizedBox(width: 6),
                  Expanded(
                    child: _buildMonthCell(
                      row * 3 + col + 1,
                      months[row * 3 + col],
                      today,
                      isDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMonthCell(
    int monthNum,
    String monthName,
    DateTime today,
    bool isDark,
  ) {
    final isSelected = monthNum == _displayedMonth;
    bool isMonthDisabled = false;
    FontWeight monthWeight = FontWeight.w600;

    if (widget.isCheckout) {
      if (_displayedYear < today.year) {
        isMonthDisabled = true;
        monthWeight = FontWeight.w400;
      } else if (_displayedYear == today.year && monthNum < today.month) {
        // Bulan kemarin: font JANGAN di semi bold, TIDAK BISA di klick atau dibekukan!
        isMonthDisabled = true;
        monthWeight = FontWeight.w400;
      } else {
        // Bulan sekarang dan seterusnya: font HARUS semi bold, BISA di klick!
        isMonthDisabled = false;
        monthWeight = FontWeight.w600;
      }
    } else if (widget.isBirthday) {
      // Bulan lahir: SEMUA HARUS SEMIBOLD DAN BISA DI KLIK
      isMonthDisabled = false;
      monthWeight = FontWeight.w600;
    } else {
      final target = DateTime(_displayedYear, monthNum);
      isMonthDisabled = target.isBefore(_minMonth) || target.isAfter(_maxMonth);
      monthWeight = isMonthDisabled ? FontWeight.w400 : FontWeight.w600;
    }

    return InkWell(
      onTap: isMonthDisabled
          ? null
          : () {
              _goToMonth(_displayedYear, monthNum);
              setState(() => _viewMode = _CalendarViewMode.days);
            },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primaryColor.withValues(alpha: 0.3)
                  : AppColors.primaryLight)
              : Colors.transparent, // Button warna putih dihilangkan!
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 1.5)
              : null,
        ),
        child: Text(
          monthName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isMonthDisabled
                ? AppColors.textTertiary.withValues(alpha: 0.35)
                : isSelected
                    ? AppColors.primaryColor
                    : AppColors.textPrimary,
            fontWeight: monthWeight,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildYearOverlay(bool isDark) {
    final today = DateTime.now();
    final canPrev = widget.isCheckout
        ? (_yearPageStart - 12 >= today.year || _yearPageStart > today.year)
        : (_yearPageStart - 12 >= _minMonth.year || _yearPageStart > _minMonth.year);
    final canNext = _yearPageStart + 12 <= _maxMonth.year + 11;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: canPrev
                  ? () => setState(() => _yearPageStart -= 12)
                  : null,
              icon: const Icon(Icons.chevron_left_rounded),
              color: AppColors.textPrimary,
              iconSize: 20,
              visualDensity: VisualDensity.compact,
            ),
            Text(
              '$_yearPageStart – ${_yearPageStart + 11}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: canNext
                  ? () => setState(() => _yearPageStart += 12)
                  : null,
              icon: const Icon(Icons.chevron_right_rounded),
              color: AppColors.textPrimary,
              iconSize: 20,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (var row = 0; row < 4; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                for (var col = 0; col < 3; col++) ...[
                  if (col > 0) const SizedBox(width: 6),
                  Expanded(
                    child: _buildYearCell(
                      _yearPageStart + (row * 3 + col),
                      today,
                      isDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildYearCell(int year, DateTime today, bool isDark) {
    final isSelected = year == _displayedYear;
    bool isYearDisabled = false;
    FontWeight yearWeight = FontWeight.w600;

    if (widget.isCheckout) {
      if (year < today.year) {
        // Tahun kemarin: font JANGAN di semi bold, TIDAK BISA di klick atau dibekukan!
        isYearDisabled = true;
        yearWeight = FontWeight.w400;
      } else {
        // Tahun sekarang dan seterusnya: font HARUS semi bold, BISA di klick!
        isYearDisabled = false;
        yearWeight = FontWeight.w600;
      }
    } else if (widget.isBirthday) {
      // Tahun lahir: SEMUA HARUS SEMIBOLD DAN BISA DI KLIK
      isYearDisabled = false;
      yearWeight = FontWeight.w600;
    } else {
      isYearDisabled = year < _minMonth.year || year > _maxMonth.year;
      yearWeight = isYearDisabled ? FontWeight.w400 : FontWeight.w600;
    }

    return InkWell(
      onTap: isYearDisabled
          ? null
          : () {
              _goToMonth(year, _displayedMonth);
              setState(() => _viewMode = _CalendarViewMode.days);
            },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? AppColors.primaryColor.withValues(alpha: 0.3)
                  : AppColors.primaryLight)
              : Colors.transparent, // Button warna putih dihilangkan!
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppColors.primaryColor, width: 1.5)
              : null,
        ),
        child: Text(
          '$year',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isYearDisabled
                ? AppColors.textTertiary.withValues(alpha: 0.35)
                : isSelected
                    ? AppColors.primaryColor
                    : AppColors.textPrimary,
            fontWeight: yearWeight,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDaysView(bool isDark) {
    final daysInMonth = DateTime(_displayedYear, _displayedMonth + 1, 0).day;
    final leadingBlanks =
        DateTime(_displayedYear, _displayedMonth, 1).weekday - 1;
    final totalCells = ((leadingBlanks + daysInMonth) / 7).ceil() * 7;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // | Hari | row (7 columns)
        Row(
          children: [
            for (final label in _localizedWeekdayLabels(context))
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        // Day rows (ROW 5 or 6 x COLUMN 7)
        for (var row = 0; row < totalCells ~/ 7; row++)
          _buildDayRow(
            row,
            leadingBlanks,
            daysInMonth,
            todayDate,
            isDark,
          ),
      ],
    );
  }

  Widget _buildDayRow(
    int row,
    int leadingBlanks,
    int daysInMonth,
    DateTime todayDate,
    bool isDark,
  ) {
    return Row(
      children: [
        for (var col = 0; col < 7; col++)
          Expanded(
            child: _buildDayCell(
              row * 7 + col,
              leadingBlanks,
              daysInMonth,
              todayDate,
              isDark,
            ),
          ),
      ],
    );
  }

  Widget _buildDayCell(
    int index,
    int leadingBlanks,
    int daysInMonth,
    DateTime todayDate,
    bool isDark,
  ) {
    final day = index - leadingBlanks + 1;
    if (day < 1 || day > daysInMonth) {
      return const SizedBox(height: 38);
    }
    final date = DateTime(_displayedYear, _displayedMonth, day);
    final isToday = date == todayDate;

    bool isDisabled = false;
    FontWeight fontWeight = FontWeight.w600;

    if (widget.isCheckout) {
      if (date.isBefore(todayDate)) {
        // Tanggal kemarin: font JANGAN di semi bold, TIDAK BISA di klick atau dibekukan!
        isDisabled = true;
        fontWeight = FontWeight.w400;
      } else {
        // Tanggal sekarang dan besok/seterusnya: font HARUS semi bold, BISA di klick!
        isDisabled = false;
        fontWeight = FontWeight.w600;
      }
    } else if (widget.isBirthday) {
      // Tanggal lahir: SEMUA HARUS SEMIBOLD DAN BISA DI KLIK
      isDisabled = false;
      fontWeight = FontWeight.w600;
    } else if (widget.emphasizeAvailable) {
      final outOfRange = date.isBefore(_minDay) || date.isAfter(_maxDay);
      isDisabled = outOfRange;
      fontWeight = isDisabled ? FontWeight.w400 : FontWeight.w600;
    } else {
      final outOfRange = date.isBefore(_minDay) || date.isAfter(_maxDay);
      isDisabled = outOfRange;
      fontWeight = FontWeight.w600;
    }

    return InkWell(
      onTap: isDisabled ? null : () => widget.onPicked(date),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 38,
        alignment: Alignment.center,
        // BUTTON WARNA PUTIH DI ANGKA TANGGAL DIHILANGKAN!
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: AppTextStyles.bodySmall.copyWith(
                color: isDisabled
                    ? AppColors.textTertiary.withValues(alpha: 0.35)
                    : isToday
                        ? AppColors.primaryColor
                        : AppColors.textPrimary,
                fontWeight: fontWeight,
                fontSize: 13,
              ),
            ),
            if (isToday && !isDisabled)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeaderChip extends StatelessWidget {
  final String text;
  final bool isOpen;
  final VoidCallback onTap;

  const _CalendarHeaderChip({
    required this.text,
    this.isOpen = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isOpen
          ? (isDark
              ? AppColors.primaryColor.withValues(alpha: 0.3)
              : AppColors.primaryColor.withValues(alpha: 0.12))
          : (isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.secondaryColor),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isOpen ? AppColors.primaryColor : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnchoredTimeOverlay extends StatefulWidget {
  final TimeOfDay initialTime;
  final double left;
  final double? top;
  final double? bottom;
  final double panelWidth;
  final double topInset;
  final ValueChanged<TimeOfDay> onPicked;

  const _AnchoredTimeOverlay({
    required this.initialTime,
    required this.left,
    required this.top,
    required this.bottom,
    required this.panelWidth,
    required this.topInset,
    required this.onPicked,
  });

  @override
  State<_AnchoredTimeOverlay> createState() => _AnchoredTimeOverlayState();
}

class _AnchoredTimeOverlayState extends State<_AnchoredTimeOverlay> {
  late TimeOfDay _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialTime;
  }

  Future<void> _pickHour(BuildContext anchor) async {
    final hours = <String>[
      for (var h = 0; h < 24; h++) h.toString().padLeft(2, '0'),
    ];
    await showAppOptionsPicker(
      anchor,
      title: AppLocalizations.of(anchor)!.calendarHour,
      options: hours,
      currentValue: _value.hour.toString().padLeft(2, '0'),
      onSelected: (value) {
        setState(() => _value = TimeOfDay(hour: int.parse(value), minute: _value.minute));
      },
    );
  }

  Future<void> _pickMinute(BuildContext anchor) async {
    final minutes = <String>[
      for (var m = 0; m < 60; m++) m.toString().padLeft(2, '0'),
    ];
    await showAppOptionsPicker(
      anchor,
      title: AppLocalizations.of(anchor)!.calendarMinute,
      options: minutes,
      currentValue: _value.minute.toString().padLeft(2, '0'),
      onSelected: (value) {
        setState(() => _value = TimeOfDay(hour: _value.hour, minute: int.parse(value)));
      },
    );
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
            child: _buildTimePanel(isDark),
          )
        else if (widget.bottom != null)
          Positioned(
            left: widget.left,
            bottom: widget.bottom! + widget.topInset,
            width: widget.panelWidth,
            child: _buildTimePanel(isDark),
          ),
      ],
    );
  }

  Widget _buildTimePanel(bool isDark) {
    return Material(
      color: Colors.transparent,
      child: Container(
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
            _buildPanelHeader(
              context,
              title: AppLocalizations.of(context)!.calendarSelectTime,
              isDark: isDark,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: Text(
                AppLocalizations.of(context)!.calendarHourMinute,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Builder(
                    builder: (anchor) => _TimePartChip(
                      text: _value.hour.toString().padLeft(2, '0'),
                      onTap: () => _pickHour(anchor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    ':',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Builder(
                    builder: (anchor) => _TimePartChip(
                      text: _value.minute.toString().padLeft(2, '0'),
                      onTap: () => _pickMinute(anchor),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: SizedBox(
                height: 40,
                child: FilledButton(
                  onPressed: () => widget.onPicked(_value),
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePartChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _TimePartChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 84,
      child: Material(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.secondaryColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
