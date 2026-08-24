import '../../core/constants/api_endpoints.dart';
import '../models/notification_model.dart';
import '../services/api_service.dart';

class NotificationRepository {
  final ApiService _apiService;

  NotificationRepository(this._apiService);

  Future<List<NotificationModel>> getNotifications({int page = 1, int limit = 100}) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.getNotification,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.data['status'] == 'success') {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAsRead(int notificationId) async {
    // Note: Android didn't have a specific markAsRead API endpoint listed in API.java
    // but the UI had a TODO. If there's an endpoint later, implement it here.
  }

  Future<void> markAllAsRead() async {
    // Same as above
  }
}
