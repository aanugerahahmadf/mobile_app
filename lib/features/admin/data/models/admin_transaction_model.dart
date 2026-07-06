class AdminTransactionModel {
  final int id;
  final int userId;
  final String? userName;
  final int? orderId;
  final String type;
  final String referenceNumber;
  final double amount;
  final double adminFee;
  final double totalAmount;
  final String? paymentGateway;
  final String? paymentMethod;
  final String status;
  final String? paidAt;
  final String? notes;
  final String? createdAt;

  const AdminTransactionModel({
    required this.id,
    required this.userId,
    this.userName,
    this.orderId,
    required this.type,
    required this.referenceNumber,
    required this.amount,
    this.adminFee = 0,
    required this.totalAmount,
    this.paymentGateway,
    this.paymentMethod,
    required this.status,
    this.paidAt,
    this.notes,
    this.createdAt,
  });

  factory AdminTransactionModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }
    return AdminTransactionModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse('${json['user_id'] ?? '0'}') ?? 0,
      userName: json['user_name'] as String?,
      orderId: json['order_id'] is int ? json['order_id'] as int : int.tryParse('${json['order_id'] ?? ''}'),
      type: '${json['type'] ?? ''}',
      referenceNumber: '${json['reference_number'] ?? ''}',
      amount: toDouble(json['amount']),
      adminFee: toDouble(json['admin_fee']),
      totalAmount: toDouble(json['total_amount']),
      paymentGateway: json['payment_gateway'] as String?,
      paymentMethod: json['payment_method'] as String?,
      status: '${json['status'] ?? ''}',
      paidAt: json['paid_at'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': userId, 'user_name': userName,
    'order_id': orderId, 'type': type,
    'reference_number': referenceNumber, 'amount': amount,
    'admin_fee': adminFee, 'total_amount': totalAmount,
    'payment_gateway': paymentGateway, 'payment_method': paymentMethod,
    'status': status, 'paid_at': paidAt, 'notes': notes, 'created_at': createdAt,
  };

  AdminTransactionModel copyWith({
    int? id, int? userId, String? userName, int? orderId, String? type,
    String? referenceNumber, double? amount, double? adminFee,
    double? totalAmount, String? paymentGateway, String? paymentMethod,
    String? status, String? paidAt, String? notes, String? createdAt,
  }) => AdminTransactionModel(
    id: id ?? this.id, userId: userId ?? this.userId,
    userName: userName ?? this.userName, orderId: orderId ?? this.orderId,
    type: type ?? this.type,
    referenceNumber: referenceNumber ?? this.referenceNumber,
    amount: amount ?? this.amount, adminFee: adminFee ?? this.adminFee,
    totalAmount: totalAmount ?? this.totalAmount,
    paymentGateway: paymentGateway ?? this.paymentGateway,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    status: status ?? this.status, paidAt: paidAt ?? this.paidAt,
    notes: notes ?? this.notes, createdAt: createdAt ?? this.createdAt,
  );
}
