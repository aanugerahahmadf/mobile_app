class AdminBankModel {
  final int id;
  final String name;
  final String accountNumber;
  final String accountHolder;
  final bool isActive;
  final String? createdAt;

  const AdminBankModel({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.accountHolder,
    this.isActive = true,
    this.createdAt,
  });

  factory AdminBankModel.fromJson(Map<String, dynamic> json) {
    return AdminBankModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: '${json['name'] ?? ''}',
      accountNumber: '${json['account_number'] ?? ''}',
      accountHolder: '${json['account_holder'] ?? ''}',
      isActive: json['is_active'] == true || json['is_active'] == 1 || json['is_active'] == '1',
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'account_number': accountNumber,
    'account_holder': accountHolder, 'is_active': isActive,
    'created_at': createdAt,
  };

  AdminBankModel copyWith({
    int? id, String? name, String? accountNumber,
    String? accountHolder, bool? isActive, String? createdAt,
  }) => AdminBankModel(
    id: id ?? this.id, name: name ?? this.name,
    accountNumber: accountNumber ?? this.accountNumber,
    accountHolder: accountHolder ?? this.accountHolder,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
}
