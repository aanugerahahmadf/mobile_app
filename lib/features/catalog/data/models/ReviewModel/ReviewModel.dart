class ReviewModel {
  final int id;
  final int userId;
  final int? packageId;
  final int? catalogId;
  final int rating;
  final String? title;
  final String? comment;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? package;
  final Map<String, dynamic>? catalog;
  final String? createdAt;
  final String? updatedAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    this.packageId,
    this.catalogId,
    required this.rating,
    this.title,
    this.comment,
    this.user,
    this.package,
    this.catalog,
    this.createdAt,
    this.updatedAt,
  });

  String? get userName =>
      user?['full_name'] as String? ?? user?['name'] as String?;
  String? get userAvatar {
    final url = user?['avatar_url'] as String?;
    if (url != null && url.isNotEmpty) return url;
    final avatar = user?['avatar'] as String?;
    if (avatar != null && avatar.isNotEmpty) return avatar;
    return null;
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int,
      userId: (json['user_id'] ?? 0) as int,
      packageId: json['package_id'] as int?,
      catalogId: json['catalog_id'] as int?,
      rating: (json['rating'] ?? 5) as int,
      title: json['title'] as String?,
      comment: json['comment'] as String?,
      user: json['user'] as Map<String, dynamic>?,
      package: json['package'] as Map<String, dynamic>?,
      catalog: json['catalog'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}
