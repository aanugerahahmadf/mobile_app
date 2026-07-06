import 'package:flutter/material.dart';
import 'package:mobile_app/l10n/app_localizations.dart';
import '../../../../../core/api/api_endpoints.dart';
import '../base/base_page.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!
;
    return AdminCrudPage(
      title: l.adminOrders,
      listEndpoint: ApiEndpoints.adminOrders,
      storeEndpoint: ApiEndpoints.adminOrders,
      detailEndpoint: ApiEndpoints.adminOrder,
      updateEndpoint: ApiEndpoints.adminOrder,
      deleteEndpoint: ApiEndpoints.adminOrder,
      fields: [FieldConfig('order_number', isTitle: true), FieldConfig('status'), FieldConfig('payment_status'), FieldConfig('total_price')],
      formFields: [
        FormFieldConfig(key: 'order_number', label: l.orderNumber),
        FormFieldConfig(key: 'user_id', label: l.userId, type: FormFieldType.number),
        FormFieldConfig(key: 'package_id', label: l.adminPackages, type: FormFieldType.number),
        FormFieldConfig(key: 'product_id', label: l.adminProducts, type: FormFieldType.number),
        FormFieldConfig(key: 'total_price', label: l.totalPrice, type: FormFieldType.number),
        FormFieldConfig(key: 'quantity', label: l.quantity, type: FormFieldType.number),
        FormFieldConfig(key: 'booking_date', label: l.bookingDate),
        FormFieldConfig(key: 'booking_time', label: l.bookingTime),
        FormFieldConfig(key: 'status', label: l.status),
        FormFieldConfig(key: 'payment_status', label: l.paymentStatus),
        FormFieldConfig(key: 'notes', label: l.notes, type: FormFieldType.multiline),
      ],
    );
  }
}
