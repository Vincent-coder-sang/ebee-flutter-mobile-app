// app/data/models/rental_model.dart
import 'package:ebee/app/data/models/product_model.dart' show Product;

enum RentalStatus { pending, paid, cancelled }

class Rental {
  final String id;
  final String userId;
  final String productId;
  final double price;
  final DateTime rentStart;
  final DateTime rentEnd;
  final String? fineId;
  final String? staffId;
  final RentalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final Product? product;
  final Fine? fine;

  Rental({
    required this.id,
    required this.userId,
    required this.productId,
    required this.price,
    required this.rentStart,
    required this.rentEnd,
    this.fineId,
    this.staffId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.product,
    this.fine,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      price: (json['price'] as num).toDouble(),
      rentStart: DateTime.parse(json['rentStart']),
      rentEnd: DateTime.parse(json['rentEnd']),
      fineId: json['fineId']?.toString(),
      staffId: json['staffId']?.toString(),
      status: _parseStatus(json['status']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
      fine: json['fine'] != null ? Fine.fromJson(json['fine']) : null,
    );
  }

  static RentalStatus _parseStatus(String status) {
    switch (status) {
      case 'paid':
        return RentalStatus.paid;
      case 'cancelled':
        return RentalStatus.cancelled;
      default:
        return RentalStatus.pending;
    }
  }

  int get rentalDays => rentEnd.difference(rentStart).inDays;
  double get totalCost => rentalDays * price;
}

class Fine {
  final String id;
  final String reason;
  final double amount;
  final String userId;
  final String rentalId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Fine({
    required this.id,
    required this.reason,
    required this.amount,
    required this.userId,
    required this.rentalId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Fine.fromJson(Map<String, dynamic> json) {
    return Fine(
      id: json['id']?.toString() ?? '',
      reason: json['reason'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      userId: json['userId']?.toString() ?? '',
      rentalId: json['rentalId']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
