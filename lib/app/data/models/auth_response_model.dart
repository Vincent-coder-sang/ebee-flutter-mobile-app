
import 'user_model.dart';
class AuthResponseModel {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? data;

  AuthResponseModel({
    required this.success,
    required this.message,
    this.token,
    this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? json['access_token'],
      data: json['data'],
    );
  }

  /// Derived user model (single source of truth)
  UserModel? get user {
    if (data == null || data!.isEmpty) return null;
    return UserModel.fromJson(data!);
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'token': token,
      'data': data,
    };
  }
}
