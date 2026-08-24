import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Auth Repository - Handles all authentication operations
class AuthRepository {
  final ApiService _apiService;
  final StorageService _storage;

  AuthRepository({
    required ApiService apiService,
    required StorageService storage,
  })  : _apiService = apiService,
        _storage = storage;

  Future<UserModel> login({
    required String username,
    required String password,
    required String role,
  }) async {
    Response response;
    try {
      response = await _apiService.post(
        ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
          'user_type': role,
        },
      );
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          throw Exception(data['message']); // E.g. "Role mismatch" or "Invalid credentials"
        }
      }
      throw Exception(e.message ?? 'Network error occurred');
    }

    if (response.statusCode == 200) {
      final responseData = response.data;
      
      if (responseData['status'] == 'success') {
        final data = responseData['data'];
        
        // DEBUG: Log the response data structure
        print('🔑 Login Response Data: $data');
        print('🔑 Token from API: ${data['token'] != null ? "EXISTS (len:${data['token'].toString().length})" : "NULL/EMPTY"}');
        print('🔑 Refresh Token: ${data['refreshToken'] != null ? "EXISTS" : "NULL"}');
        print('📍 AuthRepo Storage instance: ${_storage.hashCode}');
        
        final userJson = data['user'] as Map<String, dynamic>;
        
        // Extract division from assignedDivisions if available
        if (userJson['assignedDivisions'] != null) {
          final assignedDivisions = userJson['assignedDivisions'] as List;
          if (assignedDivisions.isNotEmpty) {
            userJson['division_name'] = assignedDivisions[0]['name'];
          }
        }

        // Defensive casting for Freezed parsing
        if (userJson['id'] is String) {
          userJson['id'] = int.tryParse(userJson['id']) ?? 0;
        }
        userJson['address'] = userJson['address'] ?? '';
        
        final String? rawPhotoLink = userJson['profile_photo_link'];
        if (rawPhotoLink != null && rawPhotoLink.isNotEmpty && !rawPhotoLink.startsWith('http')) {
          userJson['profile_photo_link'] = '${ApiEndpoints.baseUrlImage}$rawPhotoLink';
        } else {
          userJson['profile_photo_link'] = rawPhotoLink ?? '';
        }
        
        userJson['first_time_login'] = userJson['first_time_login'] ?? false;

        print('📝 Parsing User JSON: $userJson');
        
        final user = UserModel.fromJson(userJson);

        // Save tokens
        print('💾 About to call saveTokens...');
        await _storage.saveTokens(
          token: data['token'] ?? '',
          refreshToken: data['refreshToken'] ?? data['refresh_token'] ?? '',
        );
        print('✅ saveTokens completed');

        // Save user model
        await _storage.saveUserModel(user);

        // Save user session
        await _storage.saveUserSession(
          userName: username,
          id: user.id.toString(),
          mobile: user.mobile,
          userType: user.userType,
          name: user.name,
          designation: user.designation,
          profileImage: user.profilePhotoLink,
          address: user.address,
          division: user.divisionName,
        );

        // Register FCM Token with backend
        await _registerFcmToken(user.id);

        return user;
      } else {
        throw Exception(responseData['message'] ?? 'Login failed');
      }
    }

    throw Exception('Login failed: ${response.statusMessage}');
  }

  Future<void> _registerFcmToken(int userId) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) return;

      final deviceInfo = DeviceInfoPlugin();
      String deviceId = 'unknown';

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Or androidInfo.androidId if using the specific android_id plugin, but this works generally for device matching.
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown';
      }

      await _apiService.post(
        ApiEndpoints.sendFcmToken,
        data: {
          'user_id': userId,
          'fcm_token': fcmToken,
          'device_info': deviceId,
        },
      );
      print('✅ FCM token updated successfully');
    } catch (e) {
      print('❌ Failed to send FCM token: $e');
    }
  }

  /// Forgot Password - POST /api/v1/login/forgot-password
  Future<void> forgotPassword({
    required String username,
    required String role,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.forgotPassword,
      data: {
        'username': username,
        'user_type': role,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Forgot password failed: ${response.statusMessage}');
    }
  }

  /// Verify OTP - POST /api/v1/auth/verify-otp
  Future<void> verifyOtp({
    required String username,
    required String otp,
    required String role,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.otpVerification,
      data: {
        'username': username,
        'otp': otp,
        'user_type': role,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('OTP verification failed: ${response.statusMessage}');
    }
  }

  /// Resend OTP - POST /api/v1/auth/resend-otp
  Future<void> resendOtp({
    required String username,
    required String role,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.resendOtp,
      data: {
        'username': username,
        'user_type': role,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Resend OTP failed: ${response.statusMessage}');
    }
  }

  /// Reset Password - POST /api/v1/login/reset-password
  Future<void> resetPassword({
    required String username,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.resetPassword,
      data: {
        'username': username,
        'password': password,
        'password_confirmation': confirmPassword,
        'user_type': role,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Reset password failed: ${response.statusMessage}');
    }
  }

  /// Update / Create Profile (multipart form matching api/v1/profile/create)
  Future<UserModel> updateProfile({
    String? name,
    String? address,
    String? imagePath,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (address != null) data['com_address'] = address;
    
    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        // Download existing image to re-upload (API requirement)
        try {
          final tempDir = await getTemporaryDirectory();
          final tempFile = File('${tempDir.path}/temp_profile.jpg');
          final response = await Dio().get(
            imagePath,
            options: Options(responseType: ResponseType.bytes),
          );
          await tempFile.writeAsBytes(response.data);
          data['profile_photo'] = await MultipartFile.fromFile(tempFile.path);
        } catch (e) {
          throw Exception('Failed to download existing profile photo: $e');
        }
      } else {
        data['profile_photo'] = await MultipartFile.fromFile(imagePath);
      }
    }

    final formData = FormData.fromMap(data);

    final response = await _apiService.postMultipart(
      ApiEndpoints.updateProfile,
      formData: formData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = response.data;
      if (responseData['status'] == 'success') {
        final profileObject = responseData['data']['profile'];
        
        // Keep the old user data and update with new profile info
        UserModel? existingUser = _storage.getUserModel();
        
        if (existingUser != null) {
          final String rawPhotoLink = profileObject['profile_photo_link'] ?? '';
          String finalPhotoLink = rawPhotoLink;
          if (rawPhotoLink.isNotEmpty && !rawPhotoLink.startsWith('http')) {
            finalPhotoLink = '${ApiEndpoints.baseUrlImage}$rawPhotoLink';
          }

          final updatedUser = existingUser.copyWith(
            name: profileObject['name'] ?? existingUser.name,
            address: profileObject['address'] ?? existingUser.address,
            profilePhotoLink: finalPhotoLink,
          );

          await _storage.saveUserModel(updatedUser);
          await _storage.saveUserSession(
            userName: updatedUser.name,
            id: updatedUser.id.toString(),
            mobile: updatedUser.mobile,
            userType: updatedUser.userType,
            name: updatedUser.name,
            designation: updatedUser.designation,
            profileImage: updatedUser.profilePhotoLink,
            address: updatedUser.address,
            division: updatedUser.divisionName,
          );
          return updatedUser;
        }
      }
      throw Exception(responseData['message'] ?? 'Profile update failed');
    }

    throw Exception('Profile update failed: ${response.statusMessage}');
  }

  /// Logout
  Future<void> logout() async {
    await _storage.clearAll();
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isUserLogin;
  }

  /// Get current user
  UserModel? getCurrentUser() {
    return _storage.getUserModel();
  }
}
