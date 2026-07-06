class AdminInboxModel {
  final int id;
  final String title;
  final List<dynamic> participants;
  final int messagesCount;
  final Map<String, dynamic>? lastMessage;
  final String? createdAt;
  final String? updatedAt;

  const AdminInboxModel({
    required this.id,
    required this.title,
    this.participants = const [],
    this.messagesCount = 0,
    this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminInboxModel.fromJson(Map<String, dynamic> json) {
    return AdminInboxModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      title: '${json['title'] ?? ''}',
      participants: json['participants'] as List<dynamic>? ?? [],
      messagesCount: json['messages_count'] is int
          ? json['messages_count'] as int
          : int.tryParse('${json['messages_count'] ?? '0'}') ?? 0,
      lastMessage: json['last_message'] as Map<String, dynamic>?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'participants': participants,
    'messages_count': messagesCount, 'last_message': lastMessage,
    'created_at': createdAt, 'updated_at': updatedAt,
  };

  AdminInboxModel copyWith({
    int? id, String? title, List<dynamic>? participants,
    int? messagesCount, Map<String, dynamic>? lastMessage,
    String? createdAt, String? updatedAt,
  }) => AdminInboxModel(
    id: id ?? this.id, title: title ?? this.title,
    participants: participants ?? this.participants,
    messagesCount: messagesCount ?? this.messagesCount,
    lastMessage: lastMessage ?? this.lastMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
