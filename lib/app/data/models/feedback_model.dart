// app/data/models/feedback_model.dart
import 'package:ebee/app/data/models/product_model.dart' show Product;
import 'package:ebee/app/data/models/user_model.dart' show UserModel;

class Feedback {
  final String id;
  final int rating;
  final String? comment;
  final String userId;
  final String productId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final UserModel? user;
  final Product? product;

  Feedback({
    required this.id,
    required this.rating,
    this.comment,
    required this.userId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.product,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id']?.toString() ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      userId: json['userId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }
}

// app/data/models/inventory_model.dart
enum ChangeType { add, remove, adjust }

class Inventory {
  final String id;
  final int quantity;
  final ChangeType changeType;
  final String reason;
  final String productId;
  final String? orderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inventory({
    required this.id,
    required this.quantity,
    required this.changeType,
    required this.reason,
    required this.productId,
    this.orderId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      changeType: _parseChangeType(json['changeType']),
      reason: json['reason'] ?? '',
      productId: json['productId']?.toString() ?? '',
      orderId: json['orderId']?.toString(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static ChangeType _parseChangeType(String type) {
    switch (type) {
      case 'remove':
        return ChangeType.remove;
      case 'adjust':
        return ChangeType.adjust;
      default:
        return ChangeType.add;
    }
  }
}
