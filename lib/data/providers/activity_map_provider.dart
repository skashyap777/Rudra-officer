import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import 'auth_provider.dart';
import 'report_provider.dart';

final activityMapProvider = FutureProvider<ActivityMapData>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const ActivityMapData();
  
  final repository = await ref.watch(reportRepositoryProvider.future);
  return repository.getActivityMap(user.userType);
});
