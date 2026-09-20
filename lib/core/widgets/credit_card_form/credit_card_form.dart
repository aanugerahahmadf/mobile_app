import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../constants/app_colors/app_colors.dart';
import '../../constants/app_sizes/app_sizes.dart';
import '../app_text_field/app_text_field.dart';

class CreditCardForm extends StatefulWidget {
  final GlobalKey<CreditCardFormState> formKey;

  const CreditCardForm({super.key, required this.formKey});

  @override
  State<CreditCardForm> createState() => CreditCardFormState();
}

class CreditCardFormState extends State<CreditCardForm> {
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  bool validate() {
    final form = widget.formKey.currentState;
    return form != null && form.validate();
  }

  Map<String, dynamic> get cardDetails => {
    'card_number': _cardNumberController.text.replaceAll(RegExp(r'\D'), ''),
    'card_holder': _cardHolderController.text.trim(),
    'card_expiry': _cardExpiryController.text.trim(),
    'card_cvv': _cardCvvController.text.trim(),
  };

  String? _validateCardNumber(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length != 16) {
      return AppLocalizations.of(context)!.required;
    }
    return null;
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.required;
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    final text = (value ?? '').trim();
    if (text.length != 5) {
      return AppLocalizations.of(context)!.required;
    }
    return null;
  }

  String? _validateCvv(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.length < 3 || digits.length > 4) {
      return AppLocalizations.of(context)!.required;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: l.cardNumber,
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: _validateCardNumber,
            onChanged: (value) {
              final digits = value.replaceAll(RegExp(r'\D'), '');
              final buffer = StringBuffer();
              for (var i = 0; i < digits.length; i++) {
                if (i > 0 && i % 4 == 0) buffer.write(' ');
                buffer.write(digits[i]);
              }
              final formatted = buffer.toString();
              if (formatted != value) {
                _cardNumberController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: formatted.length),
                );
              }
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            prefix: Icon(Icons.credit_card, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.md),
          AppTextField(
            label: l.cardHolderName,
            controller: _cardHolderController,
            textInputAction: TextInputAction.next,
            validator: _validateRequired,
            textCapitalization: TextCapitalization.characters,
            prefix: Icon(Icons.person_outline, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSizes.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: l.cardExpiry,
                  hintText: 'MM/YY',
                  controller: _cardExpiryController,
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  validator: _validateExpiry,
                  onChanged: (value) {
                    var digits = value.replaceAll(RegExp(r'\D'), '');
                    if (digits.length > 4) digits = digits.substring(0, 4);
                    if (digits.length >= 3) {
                      final mm = digits.substring(0, 2);
                      final yy = digits.substring(2);
                      final formatted = '$mm/$yy';
                      if (formatted != value) {
                        _cardExpiryController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(offset: formatted.length),
                        );
                      }
                    }
                  },
                  prefix: Icon(Icons.event, size: 20, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: AppTextField(
                  label: l.cvv,
                  controller: _cardCvvController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: _validateCvv,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  prefix: Icon(Icons.lock_outline, size: 20, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

