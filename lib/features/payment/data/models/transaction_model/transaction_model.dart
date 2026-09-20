import '../../../../../core/utils/number_utils/number_utils.dart';

class TransactionModel {
  final int id;
  final int userId;
  final int? orderId;
  final String? type;
  final String? referenceNumber;
  final double amount;
  final double serviceFee;
  final double totalAmount;
  final String? paymentMethod;
  final String? virtualAccountNo;
  final String? virtualAccountExpiry;
  final String status;
  final String? paidAt;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final String? createdAt;
  final String? updatedAt;

  const TransactionModel({
    required this.id,
    required this.userId,
    this.orderId,
    this.type,
    this.referenceNumber,
    required this.amount,
    this.serviceFee = 0,
    required this.totalAmount,
    this.paymentMethod,
    this.virtualAccountNo,
    this.virtualAccountExpiry,
    required this.status,
    this.paidAt,
    this.notes,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      userId: (json['user_id'] ?? 0) as int,
      orderId: json['order_id'] as int?,
      type: json['type'] as String?,
      referenceNumber: json['reference_number'] as String?,
      amount: parseDouble(json['amount']),
      serviceFee: parseDouble(json['admin_fee']),
      totalAmount: parseDouble(json['total_amount']),
      paymentMethod: json['payment_method'] as String?,
      virtualAccountNo:
          json['virtual_account_no'] as String? ??
          (json['metadata'] as Map<String, dynamic>?)?['virtual_account_no']
              as String?,
      virtualAccountExpiry: json['virtual_account_expiry'] as String?,
      status: (json['status'] ?? 'unpaid') as String,
      paidAt: json['paid_at'] as String?,
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  bool get isSuccess =>
      status == 'paid' || status == 'success' || status == 'completed';
  bool get isPending => status == 'pending' || status == 'unpaid';
  bool get isFailed =>
      status == 'failed' || status == 'cancelled' || status == 'expired';
}
