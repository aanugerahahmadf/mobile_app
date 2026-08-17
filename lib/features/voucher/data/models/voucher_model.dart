import '../../../../core/utils/number_utils.dart';

class VoucherModel {
  final int id;
  final String? name;
  final String? code;
  final String? description;
  final double discountAmount;
  final String discountType;
  final double minPurchase;
  final String? expiresAt;
  final bool isActive;
  final bool isClaimed;
  final bool? isGlobal;
  final int? maxUses;
  final int? usesCount;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? discount;

  const VoucherModel({
    required this.id,
    this.name,
    this.code,
    this.description,
    required this.discountAmount,
    required this.discountType,
    this.minPurchase = 0,
    this.expiresAt,
    this.isActive = true,
    this.isClaimed = false,
    this.isGlobal,
    this.maxUses,
    this.usesCount,
    this.createdAt,
    this.updatedAt,
    this.discount,
  });

  bool get isPercentage => discountType == 'percentage';
  bool get isFixed => discountType == 'fixed';
  bool get isExpired => expiresAt != null ? DateTime.tryParse(expiresAt!)?.isBefore(DateTime.now()) ?? false : false;

  double calculateDiscount(double total) {
    if (total < minPurchase) return 0;
    if (isPercentage) return total * (discountAmount / 100);
    return discountAmount.clamp(0, total).toDouble();
  }

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    // Parse nested discount if available
    final disc = json['discount'] as Map<String, dynamic>?;

    // Top-level computed accessors (backward compat)
    double amount = parseDouble(json['discount_amount']);
    String type = (json['discount_type'] ?? 'fixed') as String;
    double min = parseDouble(json['min_purchase']);

    // Prefer nested discount data when top-level is empty
    if (amount == 0 && type == 'fixed' && disc != null) {
      amount = parseDouble(disc['value']);
      type = (disc['type'] ?? 'fixed') as String;
      min = parseDouble(disc['min_purchase']);
    }

    return VoucherModel(
      id: json['id'] as int,
      name: json['name'] as String?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      discountAmount: amount,
      discountType: type,
      minPurchase: min,
      expiresAt: json['expires_at'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isClaimed: json['is_claimed'] as bool? ?? false,
      isGlobal: json['is_global'] as bool?,
      maxUses: json['max_uses'] as int?,
      usesCount: json['uses_count'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      discount: disc,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'code': code, 'description': description,
    'discount_amount': discountAmount, 'discount_type': discountType,
    'min_purchase': minPurchase, 'expires_at': expiresAt,
    'is_active': isActive, 'is_claimed': isClaimed, 'is_global': isGlobal,
    'max_uses': maxUses, 'uses_count': usesCount,
  };
}
