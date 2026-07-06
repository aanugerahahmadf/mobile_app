class AdminNotificationModel {
  final String id;
  final String type;
  final int notifiableId;
  final dynamic data;
  final String? readAt;
  final String? createdAt;

  const AdminNotificationModel({
    required this.id,
    required this.type,
    required this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
  });

  factory AdminNotificationModel.fromJson(Map<String, dynamic> json) {
    return AdminNotificationModel(
      id: '${json['id'] ?? ''}',
      type: '${json['type'] ?? ''}',
      notifiableId: json['notifiable_id'] is int
          ? json['notifiable_id'] as int
          : int.tryParse('${json['notifiable_id'] ?? '0'}') ?? 0,
      data: json['data'],
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'type': type, 'notifiable_id': notifiableId,
    'data': data, 'read_at': readAt, 'created_at': createdAt,
  };

  AdminNotificationModel copyWith({
    String? id, String? type, int? notifiableId, dynamic data,
    String? readAt, String? createdAt,
  }) => AdminNotificationModel(
    id: id ?? this.id, type: type ?? this.type,
    notifiableId: notifiableId ?? this.notifiableId,
    data: data ?? this.data, readAt: readAt ?? this.readAt,
    createdAt: createdAt ?? this.createdAt,
  );
}
