class AdminVoucherModel {
  final int id;
  final String code;
  final String? description;
  final double discountAmount;
  final String discountType;
  final double? minPurchase;
  final double? maxDiscount;
  final String? validFrom;
  final String? validUntil;
  final int usageLimit;
  final int usedCount;
  final bool isActive;
  final String? createdAt;

  const AdminVoucherModel({
    required this.id,
    required this.code,
    this.description,
    required this.discountAmount,
    this.discountType = 'fixed',
    this.minPurchase,
    this.maxDiscount,
    this.validFrom,
    this.validUntil,
    this.usageLimit = 0,
    this.usedCount = 0,
    this.isActive = true,
    this.createdAt,
  });

  factory AdminVoucherModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }
    bool toBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      return false;
    }
    return AdminVoucherModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      code: '${json['code'] ?? ''}',
      description: json['description'] as String?,
      discountAmount: toDouble(json['discount_amount']),
      discountType: '${json['discount_type'] ?? 'fixed'}',
      minPurchase: json['min_purchase'] != null ? toDouble(json['min_purchase']) : null,
      maxDiscount: json['max_discount'] != null ? toDouble(json['max_discount']) : null,
      validFrom: json['valid_from'] as String?,
      validUntil: json['valid_until'] as String?,
      usageLimit: json['usage_limit'] is int ? json['usage_limit'] as int : int.tryParse('${json['usage_limit'] ?? '0'}') ?? 0,
      usedCount: json['used_count'] is int ? json['used_count'] as int : int.tryParse('${json['used_count'] ?? '0'}') ?? 0,
      isActive: toBool(json['is_active']),
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'code': code, 'description': description,
    'discount_amount': discountAmount, 'discount_type': discountType,
    'min_purchase': minPurchase, 'max_discount': maxDiscount,
    'valid_from': validFrom, 'valid_until': validUntil,
    'usage_limit': usageLimit, 'used_count': usedCount,
    'is_active': isActive, 'created_at': createdAt,
  };

  AdminVoucherModel copyWith({
    int? id, String? code, String? description, double? discountAmount,
    String? discountType, double? minPurchase, double? maxDiscount,
    String? validFrom, String? validUntil, int? usageLimit, int? usedCount,
    bool? isActive, String? createdAt,
  }) => AdminVoucherModel(
    id: id ?? this.id, code: code ?? this.code,
    description: description ?? this.description,
    discountAmount: discountAmount ?? this.discountAmount,
    discountType: discountType ?? this.discountType,
    minPurchase: minPurchase ?? this.minPurchase,
    maxDiscount: maxDiscount ?? this.maxDiscount,
    validFrom: validFrom ?? this.validFrom,
    validUntil: validUntil ?? this.validUntil,
    usageLimit: usageLimit ?? this.usageLimit,
    usedCount: usedCount ?? this.usedCount,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
}
