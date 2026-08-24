import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Auth State
enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Auth State Notifier
class AuthNotifier extends StateNotifier<AsyncValue<AuthState>> {
  final Ref _ref;
  AuthRepository? _authRepository;

  AuthNotifier({required Ref ref})
      : _ref = ref,
        super(const AsyncValue.data(AuthState.initial));

  /// Lazy initialization of dependencies
  Future<AuthRepository> _getAuthRepo() async {
    _authRepository ??= await _ref.read(authRepositoryProvider.future);
    return _authRepository!;
  }

  /// Check if user is already logged in
  Future<void> checkAuthStatus() async {
    state = const AsyncValue.loading();
    
    try {
      final repo = await _getAuthRepo();
      final isLoggedIn = await repo.isLoggedIn();
      
      if (isLoggedIn) {
        state = const AsyncValue.data(AuthState.authenticated);
      } else {
        state = const AsyncValue.data(AuthState.unauthenticated);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Login user
  Future<void> login({
    required String username,
    required String password,
    required String role,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repo = await _getAuthRepo();
      await repo.login(
        username: username,
        password: password,
        role: role,
      );
      
      state = const AsyncValue.data(AuthState.authenticated);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    final repo = await _getAuthRepo();
    await repo.logout();
    state = const AsyncValue.data(AuthState.unauthenticated);
  }

  /// Get current user
  UserModel? get currentUser {
    if (_authRepository == null) {
      // Try to get synchronously if already initialized
      final repoAsync = _ref.read(authRepositoryProvider).valueOrNull;
      if (repoAsync != null) {
        _authRepository = repoAsync;
        return _authRepository!.getCurrentUser();
      }
      return null;
    }
    return _authRepository!.getCurrentUser();
  }
}

// ==================== PROVIDERS ====================

/// Storage Service Provider - Initialized with proper async init
final storageServiceProvider = FutureProvider<StorageService>((ref) async {
  final storage = StorageService();
  await storage.init();
  return storage;
});

/// API Service Provider - Async because it depends on initialized storage
final apiServiceProvider = FutureProvider<ApiService>((ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  return ApiService(storage: storage);
});

/// Auth Repository Provider - Async because it depends on async storage/API
final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final storage = await ref.watch(storageServiceProvider.future);
  final apiService = await ref.watch(apiServiceProvider.future);
  return AuthRepository(
    apiService: apiService,
    storage: storage,
  );
});

/// Auth Notifier Provider
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthState>>((ref) {
  return AuthNotifier(
    ref: ref,
  );
});

/// Current User Provider
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.when(
    data: (state) {
      if (state == AuthState.authenticated) {
        return ref.read(authProvider.notifier).currentUser;
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
