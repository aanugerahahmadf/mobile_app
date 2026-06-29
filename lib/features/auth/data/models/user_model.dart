import '../../../../core/utils/formatters.dart';

class UserModel {
  final int id;
  final String fullName;
  final String? firstName;
  final String? midName;
  final String? lastName;
  final String username;
  final String email;
  final String? whatsapp;
  final String? phone;
  final String? avatar;
  final String? avatarUrl;
  final String? gender;
  final String? address;
  final String? weddingDate;
  final double balance;
  final bool darkMode;
  final String? socialId;
  final String? socialType;
  final String? emailVerifiedAt;
  final String? nik;
  final String? passportNumber;
  final String? simNumber;
  final String? npwpNumber;
  final String? birthPlace;
  final String? birthDate;
  final String? country;
  final String? provinceName;
  final String? cityName;
  final String? districtName;
  final String? villageName;
  final String? postalCode;
  final String? identityType;
  final String? identityVerifiedAt;
  final String? ktpPhoto;
  final String? ktpPhotoUrl;
  final String? selfiePhoto;
  final String? selfiePhotoUrl;
  final double? budget;
  final String? themePreference;
  final String? colorPreference;
  final String? eventConcept;
  final String? dreamVenue;
  final bool activeStatus;
  final bool isAdmin;
  final List<String> roles;
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    this.firstName,
    this.midName,
    this.lastName,
    required this.username,
    required this.email,
    this.whatsapp,
    this.phone,
    this.avatar,
    this.avatarUrl,
    this.gender,
    this.address,
    this.weddingDate,
    this.balance = 0,
    this.darkMode = false,
    this.socialId,
    this.socialType,
    this.emailVerifiedAt,
    this.nik,
    this.passportNumber,
    this.simNumber,
    this.npwpNumber,
    this.birthPlace,
    this.birthDate,
    this.country,
    this.provinceName,
    this.cityName,
    this.districtName,
    this.villageName,
    this.postalCode,
    this.identityType,
    this.identityVerifiedAt,
    this.ktpPhoto,
    this.ktpPhotoUrl,
    this.selfiePhoto,
    this.selfiePhotoUrl,
    this.budget,
    this.themePreference,
    this.colorPreference,
    this.eventConcept,
    this.dreamVenue,
    this.activeStatus = true,
    this.isAdmin = false,
    this.roles = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0;
      return 0;
    }

    bool toBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      return false;
    }

    return UserModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      fullName: '${json['full_name'] ?? json['name'] ?? ''}',
      firstName: json['first_name'] as String?,
      midName: json['mid_name'] as String?,
      lastName: json['last_name'] as String?,
      username: '${json['username'] ?? ''}',
      email: '${json['email'] ?? ''}',
      whatsapp: json['whatsapp'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      avatarUrl: json['avatar_url'] != null ? Formatters.imageUrl(json['avatar_url'] as String) : null,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      weddingDate: json['wedding_date'] as String?,
      balance: toDouble(json['balance']),
      darkMode: toBool(json['dark_mode']),
      socialId: json['social_id'] as String?,
      socialType: json['social_type'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      nik: json['nik'] as String?,
      passportNumber: json['passport_number'] as String?,
      simNumber: json['sim_number'] as String?,
      npwpNumber: json['npwp_number'] as String?,
      birthPlace: json['birth_place'] as String?,
      birthDate: json['birth_date'] as String?,
      country: json['country'] as String?,
      provinceName: json['province_name'] as String?,
      cityName: json['city_name'] as String?,
      districtName: json['district_name'] as String?,
      villageName: json['village_name'] as String?,
      postalCode: json['postal_code'] as String?,
      identityType: json['identity_type'] as String?,
      identityVerifiedAt: json['identity_verified_at'] as String?,
      ktpPhoto: json['ktp_photo'] as String?,
      ktpPhotoUrl: json['ktp_photo_url'] != null ? Formatters.imageUrl(json['ktp_photo_url'] as String) : null,
      selfiePhoto: json['selfie_photo'] as String?,
      selfiePhotoUrl: json['selfie_photo_url'] != null ? Formatters.imageUrl(json['selfie_photo_url'] as String) : null,
      budget: toDouble(json['budget']),
      themePreference: json['theme_preference'] as String?,
      colorPreference: json['color_preference'] as String?,
      eventConcept: json['event_concept'] as String?,
      dreamVenue: json['dream_venue'] as String?,
      activeStatus: toBool(json['active_status']),
      isAdmin: toBool(json['is_admin']),
      roles: (json['roles'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  bool get isEmailVerified => emailVerifiedAt != null && emailVerifiedAt!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'first_name': firstName,
      'mid_name': midName,
      'last_name': lastName,
      'username': username,
      'email': email,
      'whatsapp': whatsapp,
      'phone': phone,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'gender': gender,
      'address': address,
      'wedding_date': weddingDate,
      'balance': balance,
      'dark_mode': darkMode,
      'social_id': socialId,
      'social_type': socialType,
      'email_verified_at': emailVerifiedAt,
      'nik': nik,
      'passport_number': passportNumber,
      'sim_number': simNumber,
      'npwp_number': npwpNumber,
      'birth_place': birthPlace,
      'birth_date': birthDate,
      'country': country,
      'province_name': provinceName,
      'city_name': cityName,
      'district_name': districtName,
      'village_name': villageName,
      'postal_code': postalCode,
      'identity_type': identityType,
      'identity_verified_at': identityVerifiedAt,
      'ktp_photo': ktpPhoto,
      'ktp_photo_url': ktpPhotoUrl,
      'selfie_photo': selfiePhoto,
      'selfie_photo_url': selfiePhotoUrl,
      'budget': budget,
      'theme_preference': themePreference,
      'color_preference': colorPreference,
      'event_concept': eventConcept,
      'dream_venue': dreamVenue,
      'active_status': activeStatus,
      'is_admin': isAdmin,
      'roles': roles,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? firstName,
    String? midName,
    String? lastName,
    String? username,
    String? email,
    String? whatsapp,
    String? phone,
    String? avatar,
    String? avatarUrl,
    String? gender,
    String? address,
    String? weddingDate,
    double? balance,
    bool? darkMode,
    String? socialId,
    String? socialType,
    String? emailVerifiedAt,
    String? nik,
    String? passportNumber,
    String? simNumber,
    String? npwpNumber,
    String? birthPlace,
    String? birthDate,
    String? country,
    String? provinceName,
    String? cityName,
    String? districtName,
    String? villageName,
    String? postalCode,
    String? identityType,
    String? identityVerifiedAt,
    String? ktpPhoto,
    String? ktpPhotoUrl,
    String? selfiePhoto,
    String? selfiePhotoUrl,
    double? budget,
    String? themePreference,
    String? colorPreference,
    String? eventConcept,
    String? dreamVenue,
    bool? activeStatus,
    bool? isAdmin,
    List<String>? roles,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      firstName: firstName ?? this.firstName,
      midName: midName ?? this.midName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      weddingDate: weddingDate ?? this.weddingDate,
      balance: balance ?? this.balance,
      darkMode: darkMode ?? this.darkMode,
      socialId: socialId ?? this.socialId,
      socialType: socialType ?? this.socialType,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      nik: nik ?? this.nik,
      passportNumber: passportNumber ?? this.passportNumber,
      simNumber: simNumber ?? this.simNumber,
      npwpNumber: npwpNumber ?? this.npwpNumber,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      provinceName: provinceName ?? this.provinceName,
      cityName: cityName ?? this.cityName,
      districtName: districtName ?? this.districtName,
      villageName: villageName ?? this.villageName,
      postalCode: postalCode ?? this.postalCode,
      identityType: identityType ?? this.identityType,
      identityVerifiedAt: identityVerifiedAt ?? this.identityVerifiedAt,
      ktpPhoto: ktpPhoto ?? this.ktpPhoto,
      ktpPhotoUrl: ktpPhotoUrl ?? this.ktpPhotoUrl,
      selfiePhoto: selfiePhoto ?? this.selfiePhoto,
      selfiePhotoUrl: selfiePhotoUrl ?? this.selfiePhotoUrl,
      budget: budget ?? this.budget,
      themePreference: themePreference ?? this.themePreference,
      colorPreference: colorPreference ?? this.colorPreference,
      eventConcept: eventConcept ?? this.eventConcept,
      dreamVenue: dreamVenue ?? this.dreamVenue,
      activeStatus: activeStatus ?? this.activeStatus,
      isAdmin: isAdmin ?? this.isAdmin,
      roles: roles ?? this.roles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
