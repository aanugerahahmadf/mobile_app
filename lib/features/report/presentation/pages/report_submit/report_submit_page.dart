import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../../core/api/dio_client/dio_client.dart';
import '../../../../../core/constants/app_colors/app_colors.dart';
import '../../../../../core/constants/app_sizes/app_sizes.dart';
import '../../../../../core/constants/app_text_styles/app_text_styles.dart';
import '../../../../../core/errors/localized_error/localized_error.dart';
import '../../../../../core/widgets/app_button/app_button.dart';
import '../../../../../core/widgets/app_snackbar/app_snackbar.dart';
import '../../../../../core/widgets/app_options_picker_sheet/app_options_picker_sheet.dart';

class ReportSubmitPage extends StatefulWidget {
  /// Backend FQCN e.g. `App\Models\Product`, used for polymorphic morphTo.
  final String? reportableType;
  final String? reportableId;
  final String category;
  final String itemName;

  const ReportSubmitPage({
    super.key,
    this.reportableType,
    this.reportableId,
    this.category = 'general',
    this.itemName = '',
  });

  @override
  State<ReportSubmitPage> createState() => _ReportSubmitPageState();
}

class _ReportSubmitPageState extends State<ReportSubmitPage> {
  final _descriptionController = TextEditingController();
  String? _reason;
  bool _submitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  List<String> _reasonKeys() => const [
    'reportReasonSpam',
    'reportReasonFraud',
    'reportReasonInappropriate',
    'reportReasonMisleading',
    'reportReasonCopyright',
    'reportReasonOther',
  ];

  String _reasonValue(AppLocalizations l, String key) {
    switch (key) {
      case 'reportReasonSpam':
        return l.reportReasonSpam;
      case 'reportReasonFraud':
        return l.reportReasonFraud;
      case 'reportReasonInappropriate':
        return l.reportReasonInappropriate;
      case 'reportReasonMisleading':
        return l.reportReasonMisleading;
      case 'reportReasonCopyright':
        return l.reportReasonCopyright;
      default:
        return l.reportReasonOther;
    }
  }

  String _categoryLabel(AppLocalizations l) {
    switch (widget.category) {
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

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    if (_reason == null) {
      AppSnackBar.show(
        context,
        l.reportRequiresReason,
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      await DioClient.instance.post(
        ApiEndpoints.reports,
        data: {
          'category': widget.category,
          'reportable_type': widget.reportableType,
          'reportable_id': widget.reportableId,
          'reason': _reason,
          'description': _descriptionController.text.trim(),
        },
      );
      if (mounted) {
        AppSnackBar.show(context, l.reportSuccess, type: SnackBarType.success);
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        AppSnackBar.show(
          context,
          '${l.reportFailed}: ${LocalizedError.of(l, e.toString())}',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final displayName = widget.itemName.isNotEmpty
        ? widget.itemName
        : _categoryLabel(l).toLowerCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(l.report),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.itemName.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSizes.md),
                decoration: BoxDecoration(
                  color: AppColors.secondaryColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.reportContentTitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l.reportTitle(displayName),
                      style: AppTextStyles.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
            ],
            Text(l.reportCategory, style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSizes.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: AppColors.textTertiary,
                    size: 18,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(_categoryLabel(l), style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(l.reportReason, style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSizes.xs),
            Builder(
              builder: (reasonCtx) => GestureDetector(
                onTap: () {
                  showAppOptionsPicker(
                    reasonCtx,
                    title: l.reportReasonHint,
                    options:
                        _reasonKeys().map((k) => _reasonValue(l, k)).toList(),
                    currentValue: _reason == null ? '' : _reasonValue(l, _reason!),
                    onSelected: (v) {
                      setState(() {
                        _reason = _reasonKeys()
                            .firstWhere(
                              (k) => _reasonValue(l, k) == v,
                              orElse: () => _reasonKeys().last,
                            );
                      });
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.dividerColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        color: AppColors.textTertiary,
                        size: 18,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Text(
                          _reason == null
                              ? l.reportReasonHint
                              : _reasonValue(l, _reason!),
                          style: _reason == null
                              ? AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textTertiary,
                                )
                              : AppTextStyles.bodyMedium,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textTertiary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Text(l.reportDescription, style: AppTextStyles.bodyMedium),
            const SizedBox(height: AppSizes.xs),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: l.reportDescriptionHint,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 2000,
              maxLines: 5,
            ),
            const SizedBox(height: AppSizes.lg),
            AppButton(
              label: l.reportSubmit,
              loading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}
