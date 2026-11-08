class FaqItem {
  final String? question;
  final String? answer;

  const FaqItem({this.question, this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json, {String locale = 'id'}) {
    return FaqItem(
      question: json['question'] as String? ?? json['q'] as String?,
      answer: json['answer'] as String? ?? json['a'] as String?,
    );
  }
}

class HelpModel {
  final String title;
  final String? subtitle;
  final List<FaqItem> faqs;
  final dynamic contactOptions;

  const HelpModel({
    this.title = 'Help Center',
    this.subtitle,
    this.faqs = const [],
    this.contactOptions,
  });

  factory HelpModel.fromJson(
    Map<String, dynamic> json, {
    String locale = 'id',
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final faqsList = data['faqs'] as List? ?? [];
    return HelpModel(
      title: (data['title'] ?? 'Help Center') as String,
      subtitle: data['subtitle'] as String?,
      faqs: faqsList
          .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      contactOptions: data['contact_options'],
    );
  }

  /// Factory from GraphQL response (no nested 'data' wrapper)
  factory HelpModel.fromGraphQl(
    Map<String, dynamic> json, {
    String locale = 'id',
  }) {
    final faqsList = json['faqs'] as List? ?? [];
    return HelpModel(
      title: (json['title'] ?? 'Help Center') as String,
      subtitle: json['subtitle'] as String?,
      faqs: faqsList
          .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      contactOptions: json['contactOptions'],
    );
  }

  /// Factory from gRPC response (protobuf message fields)
  factory HelpModel.fromGrpc({
    String title = 'Help Center',
    String? subtitle,
    List<Map<String, String>> faqs = const [],
    String? contactOptions,
  }) {
    return HelpModel(
      title: title,
      subtitle: subtitle,
      faqs: faqs
          .map((e) => FaqItem(
                question: e['question'],
                answer: e['answer'],
              ))
          .toList(),
      contactOptions: contactOptions,
    );
  }
}

class LegalContent {
  final int? id;
  final String title;
  final dynamic content;
  final String? updatedAt;

  const LegalContent({
    this.id,
    required this.title,
    this.content,
    this.updatedAt,
  });

  factory LegalContent.fromJson(
    Map<String, dynamic> json, {
    String locale = 'id',
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return LegalContent(
      id: data['id'] as int?,
      title: (data['title'] ?? '') as String,
      content: data['content'],
      updatedAt: data['updated_at'] as String?,
    );
  }

  /// Factory from GraphQL response (no nested 'data' wrapper)
  factory LegalContent.fromGraphQl(
    Map<String, dynamic> json, {
    String locale = 'id',
  }) {
    return LegalContent(
      id: json['id'] as int?,
      title: (json['title'] ?? '') as String,
      content: json['content'],
      updatedAt: json['updatedAt'] as String?,
    );
  }

  /// Factory from gRPC response (protobuf message fields)
  factory LegalContent.fromGrpc({
    int? id,
    String title = '',
    String? content,
    String? updatedAt,
  }) {
    return LegalContent(
      id: id,
      title: title,
      content: content,
      updatedAt: updatedAt,
    );
  }
}

class AboutModel {
  final String title;
  final String? content;
  final String? mission;
  final String? owner;

  const AboutModel({
    this.title = 'About WeddingApp',
    this.content,
    this.mission,
    this.owner,
  });

  factory AboutModel.fromJson(
    Map<String, dynamic> json, {
    String locale = 'id',
  }) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    return AboutModel(
      title: (data['title'] ?? 'About WeddingApp') as String,
      content: data['content'] as String?,
      mission: data['mission'] as String?,
      owner: data['owner'] as String?,
    );
  }

  /// Factory from GraphQL response (no nested 'data' wrapper)
  factory AboutModel.fromGraphQl(
    Map<String, dynamic> json, {
    String locale = 'id',
  }) {
    return AboutModel(
      title: (json['title'] ?? 'About WeddingApp') as String,
      content: json['content'] as String?,
      mission: json['mission'] as String?,
      owner: json['owner'] as String?,
    );
  }

  /// Factory from gRPC response (protobuf message fields)
  factory AboutModel.fromGrpc({
    String title = 'About WeddingApp',
    String? content,
    String? mission,
    String? owner,
  }) {
    return AboutModel(
      title: title,
      content: content,
      mission: mission,
      owner: owner,
    );
  }
}
