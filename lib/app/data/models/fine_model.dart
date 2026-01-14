// app/data/models/fine_model.dart
import 'user_model.dart';
import 'rental_model.dart';

class Fine {
  final String id;
  final String reason;
  final double amount;
  final String userId;
  final String rentalId;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final UserModel? user;
  final Rental? rental;

  Fine({
    required this.id,
    required this.reason,
    required this.amount,
    required this.userId,
    required this.rentalId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.rental,
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
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      rental: json['rental'] != null ? Rental.fromJson(json['rental']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reason': reason,
      'amount': amount,
      'userId': userId,
      'rentalId': rentalId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper methods
  String get formattedAmount => 'KES ${amount.toStringAsFixed(2)}';

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get formattedTime {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  String get fullDateTime {
    return '$formattedDate at $formattedTime';
  }

  // Get user name (convenience method)
  String get userName => user?.name ?? 'Unknown User';

  // Get rental info (convenience method)
  String get rentalInfo {
    if (rental == null) return 'Unknown Rental';
    return 'Rental #${rental!.id}';
  }

  // Get product name from rental (convenience method)
  String get productName {
    return rental?.product?.name ?? 'Unknown Product';
  }

  // Check if fine is recent (created within last 7 days)
  bool get isRecent {
    final now = DateTime.now();
    return now.difference(createdAt).inDays <= 7;
  }

  // Check if fine is high amount (above 1000 KES)
  bool get isHighAmount => amount > 1000;

  // Check if fine is medium amount (between 500 and 1000 KES)
  bool get isMediumAmount => amount >= 500 && amount <= 1000;

  // Check if fine is low amount (below 500 KES)
  bool get isLowAmount => amount < 500;

  // Get amount category for UI styling
  String get amountCategory {
    if (isHighAmount) return 'high';
    if (isMediumAmount) return 'medium';
    return 'low';
  }

  // Get color based on amount (for UI)
  String get amountColor {
    switch (amountCategory) {
      case 'high':
        return '#FF4444'; // Red
      case 'medium':
        return '#FFAA00'; // Orange
      case 'low':
        return '#00C853'; // Green
      default:
        return '#757575'; // Grey
    }
  }

  // Get fine status (paid/unpaid) - you might want to add a paid field to your model
  bool get isPaid {
    // This would depend on your business logic
    // You might want to add a 'paid' boolean field to your Fine model
    return false; // Default to unpaid
  }

  // Get display status
  String get statusDisplay {
    return isPaid ? 'Paid' : 'Unpaid';
  }

  String get statusIcon {
    return isPaid ? '✅' : '⏳';
  }

  // Check if fine can be waived (business logic)
  bool get canBeWaived {
    // Example business logic: fines under 200 can be waived
    return amount <= 200 && !isPaid;
  }

  // Check if fine is overdue (if you add due dates)
  bool get isOverdue {
    // You might want to add a dueDate field to your Fine model
    final dueDate = createdAt.add(
      const Duration(days: 30),
    ); // Example: 30 days to pay
    return DateTime.now().isAfter(dueDate) && !isPaid;
  }

  // Get days until due (if you add due dates)
  int get daysUntilDue {
    final dueDate = createdAt.add(const Duration(days: 30));
    return dueDate.difference(DateTime.now()).inDays;
  }
}
