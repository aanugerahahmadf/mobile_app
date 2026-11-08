class NotificationModel {
  final String id;
  final String? type;
  final String? title;
  final String? body;
  final Map<String, dynamic>? data;
  final bool read;
  final String? readAt;
  final String? createdAt;

  const NotificationModel({
    required this.id,
    this.type,
    this.title,
    this.body,
    this.data,
    this.read = false,
    this.readAt,
    this.createdAt,
  });

  bool get isUnread => readAt == null;

  NotificationModel copyWith({String? readAt}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      data: data,
      read: readAt != null ? true : read,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'] as Map<String, dynamic>?;
    final rawType = json['type'] as String?;
    String? effectiveType = rawType;
    if (rawType != null && rawType.contains('\\')) {
      effectiveType = dataRaw?['type'] as String?;
    }
    return NotificationModel(
      id: json['id'] is String ? json['id'] as String : json['id'].toString(),
      type: effectiveType,
      title: json['title'] as String? ?? dataRaw?['title'] as String?,
      body:
          json['body'] as String? ??
          dataRaw?['body'] as String? ??
          json['message'] as String?,
      data: dataRaw,
      read: json['read'] as bool? ?? json['read_at'] != null,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
