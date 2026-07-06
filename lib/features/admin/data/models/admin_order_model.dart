class AdminOrderModel {
  final int id;
  final String orderNumber;
  final int userId;
  final String? userName;
  final String? userEmail;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final String? bookingDate;
  final String? notes;
  final String? createdAt;

  const AdminOrderModel({
    required this.id,
    required this.orderNumber,
    required this.userId,
    this.userName,
    this.userEmail,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    this.bookingDate,
    this.notes,
    this.createdAt,
  });

  factory AdminOrderModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }
    return AdminOrderModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      orderNumber: '${json['order_number'] ?? ''}',
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse('${json['user_id'] ?? '0'}') ?? 0,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      totalPrice: toDouble(json['total_price']),
      status: '${json['status'] ?? ''}',
      paymentStatus: '${json['payment_status'] ?? ''}',
      bookingDate: json['booking_date'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'order_number': orderNumber, 'user_id': userId,
    'user_name': userName, 'user_email': userEmail,
    'total_price': totalPrice, 'status': status,
    'payment_status': paymentStatus, 'booking_date': bookingDate,
    'notes': notes, 'created_at': createdAt,
  };

  AdminOrderModel copyWith({
    int? id, String? orderNumber, int? userId, String? userName,
    String? userEmail, double? totalPrice, String? status,
    String? paymentStatus, String? bookingDate, String? notes, String? createdAt,
  }) => AdminOrderModel(
    id: id ?? this.id, orderNumber: orderNumber ?? this.orderNumber,
    userId: userId ?? this.userId, userName: userName ?? this.userName,
    userEmail: userEmail ?? this.userEmail,
    totalPrice: totalPrice ?? this.totalPrice, status: status ?? this.status,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    bookingDate: bookingDate ?? this.bookingDate, notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
}
