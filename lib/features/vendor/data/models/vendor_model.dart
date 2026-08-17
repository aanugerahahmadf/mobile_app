class VendorModel {
  final int id;
  final String storeName;
  final String? contactPerson;
  final String? noTelp;
  final String? storeDescription;
  final String? logo;
  final int packageCount;
  final int productCount;

  const VendorModel({
    required this.id,
    required this.storeName,
    this.contactPerson,
    this.noTelp,
    this.storeDescription,
    this.logo,
    this.packageCount = 0,
    this.productCount = 0,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: (json['id'] as num).toInt(),
      storeName: (json['store_name'] as String? ?? ''),
      contactPerson: json['contact_person'] as String?,
      noTelp: json['no_telp'] as String?,
      storeDescription: json['store_description'] as String?,
      logo: json['logo'] as String?,
      packageCount: (json['package_count'] as num? ?? 0).toInt(),
      productCount: (json['product_count'] as num? ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_name': storeName,
    'contact_person': contactPerson,
    'no_telp': noTelp,
    'store_description': storeDescription,
    'logo': logo,
    'package_count': packageCount,
    'product_count': productCount,
  };
}
