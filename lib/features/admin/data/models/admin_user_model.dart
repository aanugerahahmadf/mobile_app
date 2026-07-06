class AdminUserModel {
  final int id;
  final String fullName;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? whatsapp;
  final bool activeStatus;
  final String? emailVerifiedAt;
  final List<String> roles;
  final String? createdAt;

  const AdminUserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.whatsapp,
    this.activeStatus = true,
    this.emailVerifiedAt,
    this.roles = const [],
    this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      return false;
    }
    return AdminUserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      fullName: '${json['full_name'] ?? ''}',
      username: '${json['username'] ?? ''}',
      email: '${json['email'] ?? ''}',
      avatarUrl: json['avatar_url'] as String?,
      whatsapp: json['whatsapp'] as String?,
      activeStatus: toBool(json['active_status']),
      emailVerifiedAt: json['email_verified_at'] as String?,
      roles: (json['role_names'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'username': username,
    'email': email,
    'avatar_url': avatarUrl,
    'whatsapp': whatsapp,
    'active_status': activeStatus,
    'email_verified_at': emailVerifiedAt,
    'role_names': roles,
    'created_at': createdAt,
  };

  AdminUserModel copyWith({
    int? id,
    String? fullName,
    String? username,
    String? email,
    String? avatarUrl,
    String? whatsapp,
    bool? activeStatus,
    String? emailVerifiedAt,
    List<String>? roles,
    String? createdAt,
  }) => AdminUserModel(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    username: username ?? this.username,
    email: email ?? this.email,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    whatsapp: whatsapp ?? this.whatsapp,
    activeStatus: activeStatus ?? this.activeStatus,
    emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    roles: roles ?? this.roles,
    createdAt: createdAt ?? this.createdAt,
  );
}
