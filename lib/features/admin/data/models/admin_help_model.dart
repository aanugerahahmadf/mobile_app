class AdminHelpModel {
  final int id;
  final String title;
  final String? subtitle;
  final List<dynamic>? faqs;
  final List<dynamic>? contactOptions;
  final String? createdAt;
  final String? updatedAt;

  const AdminHelpModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.faqs,
    this.contactOptions,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminHelpModel.fromJson(Map<String, dynamic> json) {
    return AdminHelpModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: '${json['title'] ?? ''}',
      subtitle: json['subtitle'] as String?,
      faqs: json['faqs'] as List<dynamic>?,
      contactOptions: json['contact_options'] as List<dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'subtitle': subtitle,
    'faqs': faqs, 'contact_options': contactOptions,
    'created_at': createdAt, 'updated_at': updatedAt,
  };

  AdminHelpModel copyWith({
    int? id, String? title, String? subtitle, List<dynamic>? faqs,
    List<dynamic>? contactOptions, String? createdAt, String? updatedAt,
  }) => AdminHelpModel(
    id: id ?? this.id, title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle, faqs: faqs ?? this.faqs,
    contactOptions: contactOptions ?? this.contactOptions,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
