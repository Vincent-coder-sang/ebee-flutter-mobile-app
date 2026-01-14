// app/data/repositories/auth_repository.dart
import 'package:ebee/app/data/models/user_model.dart';
import 'package:ebee/app/data/providers/api_provider.dart';
import 'package:ebee/app/data/providers/local_storage.dart';
import 'package:ebee/app/utils/constants.dart';
import 'package:get/get.dart';

class AuthRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    print("🔐 AuthRepository.login() called for: $email");
    try {
      final response = await _apiProvider.post(ApiEndpoints.login, {
        'email': email,
        'password': password,
      });

      print("✅ Login response received");

      // Save token to local storage
      if (response['token'] != null) {
        await LocalStorage.saveToken(response['token']);
        print("🔑 Token saved successfully");
      }

      return response;
    } catch (e) {
      final errorMessage = _handleAuthError(e);
      print("❌ Login error: $errorMessage");
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
    String confirmPassword,
  ) async {
    print("👤 AuthRepository.register() called for: $email");
    try {
      // Validate all fields
      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        throw 'Please fill in all fields';
      }

      // Validate passwords match
      if (password != confirmPassword) {
        throw 'Passwords do not match';
      }

      // Validate password strength
      if (password.length < AppConstants.minPasswordLength) {
        throw 'Password must be at least ${AppConstants.minPasswordLength} characters long';
      }

      final response = await _apiProvider.post(ApiEndpoints.register, {
        'name': name.trim(),
        'email': email.trim(),
        'phoneNumber': phone.trim(),
        'password': password,
        'confirmPassword': confirmPassword,
      });

      print('✅ Registration response received');

      // Auto-login after successful registration if token is provided
      if (response['token'] != null) {
        await LocalStorage.saveToken(response['token']);
        print("🔑 Auto-login token saved");
      }

      return response;
    } catch (e) {
      final errorMessage = _handleAuthError(e);
      print("❌ Registration error: $errorMessage");
      throw errorMessage;
    }
  }

  Future<void> logout() async {
    print("🚪 AuthRepository.logout() called");

    try {
      // Since there's no logout endpoint, just clear local storage
      await LocalStorage.clearAuthData();
      print("🧹 Local auth data cleared");
    } catch (e) {
      print("❌ Error during logout: $e");
      // Even if logout fails, we should try to clear data
      await LocalStorage.eraseEverything();
      rethrow;
    }
  }

  Future<void> forgotPassword(String email) async {
    print("📧 AuthRepository.forgotPassword() for: $email");
    try {
      final response = await _apiProvider.post(ApiEndpoints.forgotPassword, {
        'email': email,
      });

      print("✅ Forgot password response: $response");
    } catch (e) {
      final errorMessage = _handleAuthError(e);
      print("❌ Forgot password error: $errorMessage");
      throw errorMessage;
    }
  }

  Future<UserModel> updateProfile(Map<String, dynamic> updates) async {
    print("📝 AuthRepository.updateProfile() with updates: $updates");
    try {
      // Get current user ID from storage
      final userId = LocalStorage.getUserId();
      if (userId == null) {
        throw 'User not authenticated. Please login again.';
      }

      print("🆔 Updating profile for user: $userId");

      final response = await _apiProvider.put(
        ApiEndpoints.updateUser(userId),
        updates,
      );

      final user = UserModel.fromJson(response['user'] ?? response);

      // Update local storage with new user data if needed
      if (response['token'] != null) {
        await LocalStorage.saveToken(response['token']);
      }

      return user;
    } catch (e) {
      final errorMessage = _handleAuthError(e);
      print("❌ Update profile error: $errorMessage");
      throw errorMessage;
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    print("🔒 AuthRepository.changePassword() called");
    try {
      // Validate new passwords match
      if (newPassword != confirmPassword) {
        throw 'New passwords do not match';
      }

      // Validate password strength
      if (newPassword.length < 6) {
        throw 'Password must be at least 6 characters long';
      }

      // Get current user ID from storage
      final userId = LocalStorage.getUserId();
      if (userId == null) {
        throw 'User not authenticated. Please login again.';
      }

      final response = await _apiProvider
          .put(ApiEndpoints.changePassword(userId), {
            'currentPassword': currentPassword,
            'newPassword': newPassword,
            'confirmPassword': confirmPassword,
          });

      print("✅ Password change response: $response");
    } catch (e) {
      final errorMessage = _handleAuthError(e);
      print("❌ Change password error: $errorMessage");
      throw errorMessage;
    }
  }

  Future<UserModel> getProfile() async {
    print("👤 AuthRepository.getProfile() called");
    try {
      final userId = LocalStorage.getUserId();
      if (userId == null) {
        throw 'User not authenticated. Please login again.';
      }

      print("🆔 Fetching profile for user: $userId");

      final response = await _apiProvider.get(ApiEndpoints.getUserById(userId));
      final user = UserModel.fromJson(response['user'] ?? response);

      print("✅ Profile fetched successfully: ${user.name}");

      return user;
    } catch (e) {
      final errorMessage = _handleAuthError(e);
      print("❌ Get profile error: $errorMessage");
      throw errorMessage;
    }
  }

  // Enhanced error handler with more specific cases
  String _handleAuthError(dynamic error) {
    print("🛑 Raw auth error: $error");

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('socket')) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (errorString.contains('timeout')) {
      return 'Request timeout. Please check your connection and try again.';
    } else if (errorString.contains('401') ||
        errorString.contains('unauthorized')) {
      return 'Invalid email or password. Please check your credentials.';
    } else if (errorString.contains('422') ||
        errorString.contains('validation')) {
      return 'Please check your input fields for errors.';
    } else if (errorString.contains('409') ||
        errorString.contains('conflict')) {
      return 'An account with this email already exists. Please try logging in.';
    } else if (errorString.contains('500') || errorString.contains('server')) {
      return 'Server error. Please try again in a few moments.';
    } else if (errorString.contains('email') && errorString.contains('taken')) {
      return 'This email address is already registered. Please use a different email or try logging in.';
    } else if (errorString.contains('phone') && errorString.contains('taken')) {
      return 'This phone number is already registered. Please use a different number.';
    } else if (errorString.contains('password') &&
        errorString.contains('weak')) {
      return 'Password is too weak. Please use a stronger password.';
    } else if (errorString.contains('password') &&
        errorString.contains('incorrect')) {
      return 'Current password is incorrect. Please try again.';
    } else if (errorString.contains('user not found')) {
      return 'No account found with this email. Please check your email or register.';
    } else {
      // Clean up the error message
      String cleanError = error.toString();
      cleanError = cleanError.replaceAll('Exception: ', '');
      cleanError = cleanError.replaceAll('error: ', '');
      cleanError = cleanError.replaceAll('Error: ', '');

      return cleanError.isNotEmpty
          ? cleanError
          : 'An unexpected error occurred. Please try again.';
    }
  }

  bool get isAuthenticated => LocalStorage.isLoggedIn;

  // Get current user data
  Map<String, dynamic>? get currentUser => LocalStorage.getUserData();

  // Clear auth data without showing snackbar (for silent logout)
  Future<void> silentLogout() async {
    print("🔒 Silent logout called");
    await LocalStorage.clearAuthData();
  }

  // Debug method to check authentication state
  void debugAuthState() {
    print('\n🔍 AUTH REPOSITORY DEBUG:');
    print('   - Token exists: ${LocalStorage.getToken() != null}');
    print('   - User ID: ${LocalStorage.getUserId()}');
    print('   - Is logged in: ${LocalStorage.isLoggedIn}');

    final userData = LocalStorage.getUserData();
    print('   - User data: $userData');
    print('---\n');
  }
}
