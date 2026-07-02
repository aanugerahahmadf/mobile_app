class NotificationModel {
  final int id;
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
    return NotificationModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      type: json['type'] as String?,
      title: json['title'] as String? ?? dataRaw?['title'] as String?,
      body: json['body'] as String? ?? dataRaw?['body'] as String? ?? json['message'] as String?,
      data: dataRaw,
      read: json['read'] as bool? ?? json['read_at'] != null,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}
