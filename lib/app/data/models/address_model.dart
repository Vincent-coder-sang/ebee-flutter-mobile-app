// models/address_model.dart
class UserAddress {
  final String id;
  final String userId;
  final String county;
  final String phoneNumber;
  final String postalCode;
  final String street;
  final String subCounty;
  final String ward;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserAddress({
    required this.id,
    required this.userId,
    required this.county,
    required this.phoneNumber,
    required this.postalCode,
    required this.street,
    required this.subCounty,
    required this.isDefault,
    required this.ward,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      county: json['county'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      postalCode: json['postalCode'] ?? '',
      street: json['street'] ?? '',
      subCounty: json['subCounty'] ?? '',
      isDefault: json['isDefault'] ?? false,
      ward: json['ward'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'county': county,
      'phoneNumber': phoneNumber,
      'postalCode': postalCode,
      'street': street,
      'isDefault': isDefault,
      'subCounty': subCounty,
      'ward': ward,
    };
  }

  String get fullAddress => '$street, $ward, $subCounty, $county';

  String get shortAddress => '$street, $county';
}
