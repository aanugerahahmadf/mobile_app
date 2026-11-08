import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../Core/Errors/LocalizedError/LocalizedError.dart';
import '../../../../../Core/Utils/Formatters/Formatters.dart';
import '../../../../../Core/Widgets/AppButton/AppButton.dart';
import '../../../../../Core/Widgets/AppDateTimePicker/AppDateTimePicker.dart';
import '../../../../../Core/Widgets/AppSnackbar/AppSnackbar.dart';
import '../../../../../Core/Widgets/AppTextField/AppTextField.dart';
import '../../../../Auth/Presentation/Providers/AuthProvider/AuthProvider.dart';
import '../../Providers/OrderProvider/OrderProvider.dart';

/// Mengubah detail booking dan metode checkout (Virtual Account / QRIS) pada
/// order yang belum dibayar. Nominal dan stok dihitung ulang oleh server.
class OrderEditSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> order;

  const OrderEditSheet({super.key, required this.order});

  @override
  ConsumerState<OrderEditSheet> createState() => _OrderEditSheetState();
}

class _OrderEditSheetState extends ConsumerState<OrderEditSheet> {
  late DateTime? _date;
  late TimeOfDay? _time;
  late int _quantity;
  late String? _paymentType;
  late final TextEditingController _notesController;
  late final TextEditingController _whatsappController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final order = widget.order;
    _date = DateTime.tryParse('${order['event_date'] ?? ''}');
    _time = _parseTime(order['event_time'] ?? order['booking_time']);
    _quantity = (order['quantity'] is num)
        ? (order['quantity'] as num).toInt()
        : 1;
    _paymentType = order['payment_type'] as String?;
    _notesController = TextEditingController(
      text: _stripTimeNote('${order['notes'] ?? ''}'),
    );
    final auth = ref.read(authProvider);
    _whatsappController = TextEditingController(
      text: auth is AuthAuthenticated ? (auth.user.whatsapp ?? '') : '',
    );
  }

  /// Order lama menyimpan jam event sebagai prefix "Waktu: … |" di notes.
  String _stripTimeNote(String notes) {
    if (!notes.startsWith('Waktu:')) return notes;
    final separator = notes.indexOf('|');
    return separator == -1 ? '' : notes.substring(separator + 1).trim();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(dynamic value) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})').firstMatch('$value');
    if (match == null) return null;
    return TimeOfDay(
      hour: int.parse(match.group(1)!),
      minute: int.parse(match.group(2)!),
    );
  }

  String get _timeText {
    if (_time == null) return '';
    return '${_time!.hour.toString().padLeft(2, '0')}:'
        '${_time!.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showAppDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
      emphasizeAvailable: true,
      isCheckout: true,
      isBirthday: false,
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showAppTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    if (_date == null) {
      AppSnackBar.show(context, l.selectEventDate, type: SnackBarType.warning);
      return;
    }
    setState(() => _saving = true);
    final wa = _whatsappController.text.trim();
    final ok = await ref
        .read(orderProvider.notifier)
        .updateOrder('${widget.order['id']}', {
          'event_date': _date!.toIso8601String().split('T')[0],
          if (_time != null) 'event_time': _timeText,
          'quantity': _quantity,
          'notes': _notesController.text.trim(),
          if (_paymentType != null) 'payment_type': _paymentType,
          if (wa.isNotEmpty) 'whatsapp': wa,
        });
    if (!mounted) return;
    setState(() => _saving = false);
    if (!ok) {
      final error = ref.read(orderProvider).error;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            error == null ? l.failedUpdateOrder : LocalizedError.of(l, error),
          ),
        ),
      );
      return;
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final amount = Formatters.currency(
      Formatters.parsePrice(
        (widget.order['payment'] as Map<String, dynamic>?)?['amount'] ??
            widget.order['total_price'],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l.order,
          style: AppTextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
        Text(
          '${widget.order['order_number'] ?? widget.order['id']}  ·  $amount',
          style: AppTextStyles.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSizes.md),
        Text(l.eventDate, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  _date != null
                      ? Formatters.date(_date!.toIso8601String())
                      : l.selectEventDate,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text(l.eventTime, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickTime,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.dividerColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  _time != null ? _timeText : l.selectEventTime,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSizes.md),
        Text(l.quantity, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: _quantity > 1
                  ? () => setState(() => _quantity--)
                  : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$_quantity', style: AppTextStyles.titleLarge),
            IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        AppTextField(
          label: '${l.notes} (${l.optional})',
          controller: _notesController,
          maxLines: 3,
        ),
        const SizedBox(height: AppSizes.md),
        AppTextField(
          label: l.whatsapp,
          controller: _whatsappController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSizes.md),
        Text(l.paymentMethod, style: AppTextStyles.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: AppSizes.sm,
          children: [
            ChoiceChip(
              label: Text(l.virtualAccount),
              selected: _paymentType == 'virtual_account',
              onSelected: (_) =>
                  setState(() => _paymentType = 'virtual_account'),
            ),
            ChoiceChip(
              label: Text(l.qris),
              selected: _paymentType == 'qris',
              onSelected: (_) => setState(() => _paymentType = 'qris'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          l.editPaymentWarning,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSizes.lg),
        AppButton(
          label: l.saveChanges,
          onPressed: _saving ? null : _save,
          loading: _saving,
        ),
        const SizedBox(height: AppSizes.md),
      ],
    );
  }
}
