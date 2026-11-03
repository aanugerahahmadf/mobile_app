import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../Core/Constants/AppSizes/AppSizes.dart';
import '../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';

class VirtualAccountPaymentScreen extends ConsumerStatefulWidget {
  final String orderId;

  const VirtualAccountPaymentScreen({super.key, required this.orderId});

  @override
  ConsumerState<VirtualAccountPaymentScreen> createState() =>
      _VirtualAccountPaymentPageState();
}

class _VirtualAccountPaymentPageState
    extends ConsumerState<VirtualAccountPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('Payment Virtual Account')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment Virtual Account', style: AppTextStyles.headTitle),
            const SizedBox(height: AppSizes.md),
            Text('${l.order} #${widget.orderId}'),
          ],
        ),
      ),
    );
  }
}


