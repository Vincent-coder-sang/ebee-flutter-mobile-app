// app/data/models/report_model.dart

import 'package:ebee/app/data/models/user_model.dart' show UserModel;

enum ReportType { orders, rentals, payments, inventory, feedback, custom }

extension ReportTypeExtension on ReportType {
  String get value {
    switch (this) {
      case ReportType.orders:
        return 'orders';
      case ReportType.rentals:
        return 'rentals';
      case ReportType.payments:
        return 'payments';
      case ReportType.inventory:
        return 'inventory';
      case ReportType.feedback:
        return 'feedback';
      case ReportType.custom:
        return 'custom';
    }
  }

  static ReportType fromString(String value) {
    switch (value) {
      case 'orders':
        return ReportType.orders;
      case 'rentals':
        return ReportType.rentals;
      case 'payments':
        return ReportType.payments;
      case 'inventory':
        return ReportType.inventory;
      case 'feedback':
        return ReportType.feedback;
      case 'custom':
        return ReportType.custom;
      default:
        return ReportType.custom;
    }
  }
}

class Report {
  final String id;
  final String userId;
  final String title;
  final ReportType type;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final UserModel? user;

  Report({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title'] ?? '',
      type: ReportTypeExtension.fromString(json['type'] ?? 'custom'),
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'type': type.value,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper methods
  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get formattedTime {
    return '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
  }

  bool get isOrdersReport => type == ReportType.orders;
  bool get isRentalsReport => type == ReportType.rentals;
  bool get isPaymentsReport => type == ReportType.payments;
  bool get isInventoryReport => type == ReportType.inventory;
  bool get isFeedbackReport => type == ReportType.feedback;
  bool get isCustomReport => type == ReportType.custom;

  // Get report type display name
  String get typeDisplayName {
    switch (type) {
      case ReportType.orders:
        return 'Orders Report';
      case ReportType.rentals:
        return 'Rentals Report';
      case ReportType.payments:
        return 'Payments Report';
      case ReportType.inventory:
        return 'Inventory Report';
      case ReportType.feedback:
        return 'Feedback Report';
      case ReportType.custom:
        return 'Custom Report';
    }
  }

  // Get icon based on report type (for UI)
  String get typeIcon {
    switch (type) {
      case ReportType.orders:
        return '📦';
      case ReportType.rentals:
        return '🚲';
      case ReportType.payments:
        return '💳';
      case ReportType.inventory:
        return '📊';
      case ReportType.feedback:
        return '💬';
      case ReportType.custom:
        return '📝';
    }
  }
}
