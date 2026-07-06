class AdminReviewModel {
  final int id;
  final int userId;
  final String? userName;
  final String? userAvatar;
  final int? packageId;
  final int? productId;
  final int rating;
  final String? comment;
  final String? createdAt;

  const AdminReviewModel({
    required this.id,
    required this.userId,
    this.userName,
    this.userAvatar,
    this.packageId,
    this.productId,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  factory AdminReviewModel.fromJson(Map<String, dynamic> json) {
    return AdminReviewModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse('${json['user_id'] ?? '0'}') ?? 0,
      userName: json['user_name'] as String?,
      userAvatar: json['user_avatar'] as String?,
      packageId: json['package_id'] is int ? json['package_id'] as int : int.tryParse('${json['package_id'] ?? ''}'),
      productId: json['product_id'] is int ? json['product_id'] as int : int.tryParse('${json['product_id'] ?? ''}'),
      rating: json['rating'] is int ? json['rating'] as int : int.tryParse('${json['rating'] ?? '0'}') ?? 0,
      comment: json['comment'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': userId, 'user_name': userName,
    'user_avatar': userAvatar, 'package_id': packageId,
    'product_id': productId, 'rating': rating, 'comment': comment,
    'created_at': createdAt,
  };

  AdminReviewModel copyWith({
    int? id, int? userId, String? userName, String? userAvatar,
    int? packageId, int? productId, int? rating, String? comment, String? createdAt,
  }) => AdminReviewModel(
    id: id ?? this.id, userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userAvatar: userAvatar ?? this.userAvatar,
    packageId: packageId ?? this.packageId,
    productId: productId ?? this.productId,
    rating: rating ?? this.rating, comment: comment ?? this.comment,
    createdAt: createdAt ?? this.createdAt,
  );
}
