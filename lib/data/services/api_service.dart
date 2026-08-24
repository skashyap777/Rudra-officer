import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/constants/app_constants.dart';
import 'storage_service.dart';

/// API Service - Replaces Android Volley/Retrofit with Dio
class ApiService {
  late final Dio _dio;
  final StorageService _storage;
  final _logger = Logger();

  ApiService({required StorageService storage}) : _storage = storage {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _storage.token;
          
          // DEBUG: Log token retrieval
          _logger.i('🔐 Token from storage: ${token != null ? "EXISTS (len:${token.length})" : "NULL"}');
          _logger.i('📍 Storage instance: ${_storage.hashCode}');
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            _logger.i('✅ Added Authorization header');
          } else {
            _logger.w('⚠️ No token found - request will be unauthorized');
          }

          if (kDebugMode) {
            _logger.i('Request: ${options.method} ${options.path}');
            _logger.d('Headers: ${options.headers}');
            _logger.d('Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            _logger.i('Response: ${response.statusCode} ${response.requestOptions.path}');
            _logger.d('Data: ${response.data}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            _logger.e('Error: ${e.response?.statusCode} ${e.requestOptions.path}');
            _logger.e('Message: ${e.message}');
            _logger.e('⛔ Response Body: ${e.response?.data}');
          }

          // Handle 401 - Token expired
          if (e.response?.statusCode == 401) {
            final success = await _refreshToken();
            if (success) {
              // Retry original request
              final opts = e.requestOptions;
              final token = await _storage.token;
              opts.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(opts);
              return handler.resolve(response);
            }
          }

          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.refreshToken;
      if (refreshToken == null) return false;

      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken}, // Fixed payload key to match TokenManager.java
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final newToken = response.data['data']['token']; // Unnested from 'data' block
        final newRefreshToken = response.data['data']['refreshToken'];
        await _storage.saveTokens(
          token: newToken,
          refreshToken: newRefreshToken,
        );
        return true;
      }
    } catch (e) {
      _logger.e('Token refresh failed: $e');
    }
    return false;
  }

  // HTTP Methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // Multipart for image uploads
  Future<Response> postMultipart(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
  }) async {
    return await _dio.post(
      path,
      data: formData,
      queryParameters: queryParameters,
      onSendProgress: onSendProgress,
    );
  }
}
