class AdminPaymentMethodModel {
  final int id;
  final String name;
  final String code;
  final String? description;
  final bool isActive;
  final String? createdAt;

  const AdminPaymentMethodModel({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.isActive = true,
    this.createdAt,
  });

  factory AdminPaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return AdminPaymentMethodModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      code: '${json['code'] ?? ''}',
      description: json['description'] as String?,
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == '1',
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'code': code,
    'description': description, 'is_active': isActive,
    'created_at': createdAt,
  };

  AdminPaymentMethodModel copyWith({
    int? id, String? name, String? code,
    String? description, bool? isActive, String? createdAt,
  }) => AdminPaymentMethodModel(
    id: id ?? this.id, name: name ?? this.name,
    code: code ?? this.code,
    description: description ?? this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
}
