// app/data/models/booking_model.dart
import 'package:flutter/material.dart';

import 'user_model.dart';
import 'service_model.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

extension BookingStatusExtension on BookingStatus {
  String get value {
    switch (this) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
    }
  }

  static BookingStatus fromString(String value) {
    switch (value) {
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      default:
        return BookingStatus.pending;
    }
  }
}

class Booking {
  final String id;
  final String serviceId;
  final String userId;
  final String? assignedTo;
  final BookingStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Associations
  final Service? service;
  final UserModel? user;
  final UserModel? technician;

  Booking({
    required this.id,
    required this.serviceId,
    required this.userId,
    this.assignedTo,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.service,
    this.user,
    this.technician,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id']?.toString() ?? '',
      serviceId: json['serviceId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      assignedTo: json['assignedTo']?.toString(),
      status: BookingStatusExtension.fromString(json['status'] ?? 'pending'),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      service: json['service'] != null
          ? Service.fromJson(json['service'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      technician: json['technician'] != null
          ? UserModel.fromJson(json['technician'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'userId': userId,
      'assignedTo': assignedTo,
      'status': status.value,
      'notes': notes,
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

  String get statusDisplayName {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get statusIcon {
    switch (status) {
      case BookingStatus.pending:
        return '⏳';
      case BookingStatus.confirmed:
        return '✅';
      case BookingStatus.completed:
        return '🎉';
      case BookingStatus.cancelled:
        return '❌';
    }
  }

  Color get statusColor {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.completed:
        return Colors.blue;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  // Status checks
  bool get isPending => status == BookingStatus.pending;
  bool get isConfirmed => status == BookingStatus.confirmed;
  bool get isCompleted => status == BookingStatus.completed;
  bool get isCancelled => status == BookingStatus.cancelled;

  // Business logic methods
  bool get canBeConfirmed => isPending;
  bool get canBeCompleted => isConfirmed;
  bool get canBeCancelled => isPending || isConfirmed;

  // Get service name (convenience method)
  String get serviceName => service?.name ?? 'Unknown Service';

  // Get customer name (convenience method)
  String get customerName => user?.name ?? 'Unknown Customer';

  // Get technician name (convenience method)
  String get technicianName => technician?.name ?? 'Not Assigned';

  // Check if technician is assigned
  bool get isTechnicianAssigned => assignedTo != null && assignedTo!.isNotEmpty;

  // Get booking duration (if you add start/end times later)
  Duration get duration => updatedAt.difference(createdAt);

  // Check if booking is recent (created within last 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    return now.difference(createdAt).inHours <= 24;
  }

  // Check if booking requires attention (pending for more than 2 days)
  bool get requiresAttention {
    if (!isPending) return false;
    final now = DateTime.now();
    return now.difference(createdAt).inDays >= 2;
  }
}
