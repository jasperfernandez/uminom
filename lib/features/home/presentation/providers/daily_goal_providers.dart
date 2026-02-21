import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/core/providers/firebase_providers.dart';
import 'package:uminom/features/home/data/datasources/daily_goal_remote_datasource.dart';
import 'package:uminom/features/home/data/repositories/daily_goal_repository_impl.dart';
import 'package:uminom/features/home/domain/repositories/daily_goal_repository.dart';
import 'package:uminom/features/home/domain/usecases/set_daily_goal.dart';
import 'package:uminom/features/home/domain/usecases/watch_daily_goal.dart';
import 'package:uminom/features/home/presentation/controllers/daily_goal_controller.dart';

final dailyGoalRemoteDataSourceProvider = Provider<DailyGoalRemoteDataSource>((
  ref,
) {
  final firestore = ref.watch(firestoreProvider);
  return DailyGoalRemoteDataSource(firestore);
});

final dailyGoalRepositoryProvider = Provider<DailyGoalRepository>((ref) {
  final remote = ref.watch(dailyGoalRemoteDataSourceProvider);
  return DailyGoalRepositoryImpl(remote);
});

final setDailyGoalProvider = Provider<SetDailyGoal>((ref) {
  final repository = ref.watch(dailyGoalRepositoryProvider);
  return SetDailyGoal(repository);
});

final watchDailyGoalProvider = Provider<WatchDailyGoal>((ref) {
  final repository = ref.watch(dailyGoalRepositoryProvider);
  return WatchDailyGoal(repository);
});

final dailyGoalControllerProvider =
    AsyncNotifierProvider<DailyGoalController, void>(DailyGoalController.new);
