import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

/// Storage Service - Replaces Android UserManagement.java SharedPreferences
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  final _secureStorage = const FlutterSecureStorage();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== USER SESSION ====================

  Future<void> saveUserSession({
    required String userName,
    required String id,
    required String mobile,
    required String userType,
    required String name,
    required String designation,
    String? profileImage,
    String? address,
    String? division,
  }) async {
    await _prefs?.setBool(AppConstants.keyLogin, true);
    await _prefs?.setString(AppConstants.keyUserName, userName);
    await _prefs?.setString(AppConstants.keyUserId, id);
    await _prefs?.setString(AppConstants.keyMobileNo, mobile);
    await _prefs?.setString(AppConstants.keyUserType, userType);
    await _prefs?.setString(AppConstants.keyName, name);
    await _prefs?.setString(AppConstants.keyDesignation, designation);
    if (profileImage != null) {
      await _prefs?.setString(AppConstants.keyProfilePic, profileImage);
    }
    if (address != null) {
      await _prefs?.setString(AppConstants.keyAddress, address);
    }
    if (division != null) {
      await _prefs?.setString(AppConstants.keyDivision, division);
    }
  }

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    print('💾 saveTokens called - token len: ${token.length}');
    print('📍 Storage instance: $hashCode, _prefs: ${_prefs != null}');
    
    await _prefs?.setBool(AppConstants.keyLogin, true);
    await _secureStorage.write(key: AppConstants.keyToken, value: token);
    await _secureStorage.write(
      key: AppConstants.keyRefreshToken,
      value: refreshToken,
    );
    
    // Verify save worked
    final savedToken = await _secureStorage.read(key: AppConstants.keyToken);
    print('✅ Token saved successfully: ${savedToken != null}');
  }

  Future<void> saveUserModel(UserModel user) async {
    await _prefs?.setString(
      'userModelJson',
      jsonEncode(user.toJson()),
    );
  }

  // ==================== GETTERS ====================

  /// Check if user is logged in - verifies both login flag AND token exists
  Future<bool> get isUserLogin async {
    final loginFlag = _prefs?.getBool(AppConstants.keyLogin) ?? false;
    if (!loginFlag) return false;
    
    // Also verify token exists in secure storage
    final token = await _secureStorage.read(key: AppConstants.keyToken);
    return token != null && token.isNotEmpty;
  }

  String? get userName => _prefs?.getString(AppConstants.keyUserName);
  String? get userType => _prefs?.getString(AppConstants.keyUserType);
  String? get name => _prefs?.getString(AppConstants.keyName);
  String? get division => _prefs?.getString(AppConstants.keyDivision);
  String? get profilePic => _prefs?.getString(AppConstants.keyProfilePic);
  String? get userId => _prefs?.getString(AppConstants.keyUserId);
  String? get mobile => _prefs?.getString(AppConstants.keyMobileNo);
  String? get designation => _prefs?.getString(AppConstants.keyDesignation);
  String? get address => _prefs?.getString(AppConstants.keyAddress);

  Future<String?> get token async {
    return await _secureStorage.read(key: AppConstants.keyToken);
  }

  Future<String?> get refreshToken async {
    return await _secureStorage.read(key: AppConstants.keyRefreshToken);
  }

  UserModel? getUserModel() {
    final userJson = _prefs?.getString('userModelJson');
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // ==================== LOGOUT ====================

  Future<void> clearAll() async {
    await _prefs?.clear();
    await _secureStorage.deleteAll();
  }

  // ==================== FCM TOKEN ====================

  Future<void> saveFcmToken(String fcmToken) async {
    await _prefs?.setString('fcm_token', fcmToken);
  }

  String? getFcmToken() {
    return _prefs?.getString('fcm_token');
  }
}
