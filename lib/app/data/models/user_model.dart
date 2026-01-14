import 'address_model.dart';
import 'order_model.dart';
import 'payment_model.dart';
import 'feedback_model.dart';

enum UserType {
  customer,
  admin,
  financeManager,
  inventoryManager,
  dispatchManager,
  serviceManager,
  supplier,
  technicianManager,
  driver,
}

class UserModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final bool isApproved;
  final UserType userType;

  final String? resetToken;
  final DateTime? resetTokenExpires;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final List<UserAddress>? addresses;
  final List<Order>? orders;
  final List<Payment>? payments;
  final List<Feedback>? feedbacks;

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.isApproved,
    required this.userType,
    this.resetToken,
    this.resetTokenExpires,
    required this.createdAt,
    required this.updatedAt,
    this.addresses,
    this.orders,
    this.payments,
    this.feedbacks,
  });

  /// Handles:
  /// - Auth response
  /// - JWT payload
  /// - Normal API user object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['userId']?.toString() ?? '',
      name: json['name'] ?? 'User',
      phoneNumber: json['phoneNumber'] ?? json['phone'] ?? '',
      email: json['email'] ?? '',
      isApproved: json['isApproved'] ?? json['is_approved'] ?? false,
      userType: _parseUserType(json['userType'] ?? json['role'] ?? 'customer'),
      resetToken: json['resetToken'],
      resetTokenExpires: json['resetTokenExpires'] != null
          ? DateTime.tryParse(json['resetTokenExpires'])
          : null,
      createdAt:
          DateTime.tryParse(json['createdAt'] ?? json['created_at'] ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] ?? json['updated_at'] ?? '') ??
          DateTime.now(),
      addresses: json['addresses'] != null
          ? (json['addresses'] as List)
                .map((a) => UserAddress.fromJson(a))
                .toList()
          : null,
      orders: json['orders'] != null
          ? (json['orders'] as List).map((o) => Order.fromJson(o)).toList()
          : null,
      payments: json['payments'] != null
          ? (json['payments'] as List).map((p) => Payment.fromJson(p)).toList()
          : null,
      feedbacks: json['feedbacks'] != null
          ? (json['feedbacks'] as List)
                .map((f) => Feedback.fromJson(f))
                .toList()
          : null,
    );
  }

  /// Backend-safe string value
  String get userTypeValue {
    switch (userType) {
      case UserType.admin:
        return 'admin';
      case UserType.financeManager:
        return 'finance_manager';
      case UserType.inventoryManager:
        return 'inventory_manager';
      case UserType.dispatchManager:
        return 'dispatch_manager';
      case UserType.serviceManager:
        return 'service_manager';
      case UserType.supplier:
        return 'supplier';
      case UserType.technicianManager:
        return 'technician_manager';
      case UserType.driver:
        return 'driver';
      default:
        return 'customer';
    }
  }

  static UserType _parseUserType(String type) {
    switch (type) {
      case 'admin':
        return UserType.admin;
      case 'finance_manager':
        return UserType.financeManager;
      case 'inventory_manager':
        return UserType.inventoryManager;
      case 'dispatch_manager':
        return UserType.dispatchManager;
      case 'service_manager':
        return UserType.serviceManager;
      case 'supplier':
        return UserType.supplier;
      case 'technician_manager':
        return UserType.technicianManager;
      case 'driver':
        return UserType.driver;
      default:
        return UserType.customer;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'isApproved': isApproved,
    'userType': userTypeValue,
    'resetToken': resetToken,
    'resetTokenExpires': resetTokenExpires?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  // Role helpers (important for routing & guards)
  bool get isAdmin => userType == UserType.admin;
  bool get isCustomer => userType == UserType.customer;
  bool get isSupplier => userType == UserType.supplier;
  bool get isDispatchManager => userType == UserType.dispatchManager;
  bool get isDriver => userType == UserType.driver;
}
