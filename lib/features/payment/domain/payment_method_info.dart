class PaymentMethodInfo {
  final int id;
  final String name;
  final String type;
  final String? code;
  final String? deeplink;
  final String? accountNumber;
  final String? accountHolder;
  final String? bankName;
  final String? imageUrl;
  final String? instructions;
  final double fee;
  final int sortOrder;
  final bool isActive;
  final bool gatewayEnabled;

  const PaymentMethodInfo({
    required this.id,
    required this.name,
    required this.type,
    this.code,
    this.deeplink,
    this.accountNumber,
    this.accountHolder,
    this.bankName,
    this.imageUrl,
    this.instructions,
    this.fee = 0,
    this.sortOrder = 0,
    this.isActive = true,
    this.gatewayEnabled = false,
  });

  factory PaymentMethodInfo.fromJson(Map<String, dynamic> json) {
    return PaymentMethodInfo(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      code: json['code'] as String?,
      deeplink: json['deeplink'] as String?,
      accountNumber: json['account_number'] as String?,
      accountHolder: json['account_holder'] as String?,
      bankName: json['bank_name'] as String?,
      imageUrl: json['image_url'] as String?,
      instructions: json['instructions'] as String?,
      fee: json['fee'] is num ? (json['fee'] as num).toDouble() : (double.tryParse(json['fee']?.toString() ?? '') ?? 0),
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      gatewayEnabled: json['gateway_enabled'] as bool? ?? false,
    );
  }
}
