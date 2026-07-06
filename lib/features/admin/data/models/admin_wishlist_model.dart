class AdminWishlistModel {
  final int id;
  final int userId;
  final String? userName;
  final int? packageId;
  final String? packageName;
  final int? productId;
  final String? productName;
  final String? createdAt;

  const AdminWishlistModel({
    required this.id,
    required this.userId,
    this.userName,
    this.packageId,
    this.packageName,
    this.productId,
    this.productName,
    this.createdAt,
  });

  factory AdminWishlistModel.fromJson(Map<String, dynamic> json) {
    return AdminWishlistModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse('${json['user_id'] ?? '0'}') ?? 0,
      userName: json['user_name'] as String?,
      packageId: json['package_id'] is int ? json['package_id'] as int : int.tryParse('${json['package_id'] ?? ''}'),
      packageName: json['package_name'] as String?,
      productId: json['product_id'] is int ? json['product_id'] as int : int.tryParse('${json['product_id'] ?? ''}'),
      productName: json['product_name'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': userId, 'user_name': userName,
    'package_id': packageId, 'package_name': packageName,
    'product_id': productId, 'product_name': productName,
    'created_at': createdAt,
  };

  AdminWishlistModel copyWith({
    int? id, int? userId, String? userName, int? packageId,
    String? packageName, int? productId, String? productName, String? createdAt,
  }) => AdminWishlistModel(
    id: id ?? this.id, userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    packageId: packageId ?? this.packageId,
    packageName: packageName ?? this.packageName,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    createdAt: createdAt ?? this.createdAt,
  );
}
