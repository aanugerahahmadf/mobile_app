class AdminLegalPageModel {
  final int id;
  final String? slug;
  final String title;
  final dynamic content;
  final String? createdAt;
  final String? updatedAt;

  const AdminLegalPageModel({
    required this.id,
    this.slug,
    required this.title,
    this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminLegalPageModel.fromJson(Map<String, dynamic> json) {
    return AdminLegalPageModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      slug: json['slug'] as String?,
      title: '${json['title'] ?? ''}',
      content: json['content'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'slug': slug, 'title': title, 'content': content,
    'created_at': createdAt, 'updated_at': updatedAt,
  };

  AdminLegalPageModel copyWith({
    int? id, String? slug, String? title, dynamic content,
    String? createdAt, String? updatedAt,
  }) => AdminLegalPageModel(
    id: id ?? this.id, slug: slug ?? this.slug, title: title ?? this.title,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
