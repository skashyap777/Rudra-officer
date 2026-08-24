import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../repositories/notification_repository.dart';
import 'auth_provider.dart';

/// Notification Notifier - Manages notification state
class NotificationNotifier extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final Ref _ref;
  NotificationRepository? _notificationRepository;

  NotificationNotifier({required Ref ref})
      : _ref = ref,
        super(const AsyncValue.loading()) {
    loadNotifications();
  }

  Future<NotificationRepository> _getRepo() async {
    _notificationRepository ??= await _ref.read(notificationRepositoryProvider.future);
    return _notificationRepository!;
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh) {
      state = const AsyncValue.loading();
    }

    try {
      final repo = await _getRepo();
      final notifications = await repo.getNotifications();
      state = AsyncValue.data(notifications);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// ==================== PROVIDERS ====================

final notificationRepositoryProvider = FutureProvider<NotificationRepository>((ref) async {
  final apiService = await ref.watch(apiServiceProvider.future);
  return NotificationRepository(apiService);
});

final notificationProvider = StateNotifierProvider<NotificationNotifier, AsyncValue<List<NotificationModel>>>((ref) {
  return NotificationNotifier(ref: ref);
});
