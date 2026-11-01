import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';

class QrisPaymentScreen extends ConsumerStatefulWidget {
  final String orderId;

  const QrisPaymentScreen({super.key, required this.orderId});

  @override
  ConsumerState<QrisPaymentScreen> createState() =>
      _QrisPaymentPageState();
}

class _QrisPaymentPageState extends ConsumerState<QrisPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('Payment QRIS')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment QRIS', style: AppTextStyles.headTitle),
            const SizedBox(height: AppSizes.md),
            Text('${l.order} #${widget.orderId}'),
          ],
        ),
      ),
    );
  }
}


