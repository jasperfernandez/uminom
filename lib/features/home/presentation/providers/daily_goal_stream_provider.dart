import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/auth/presentation/providers/auth_provider.dart';
import 'package:uminom/features/home/domain/entities/daily_goal.dart';
import 'package:uminom/features/home/presentation/providers/daily_goal_providers.dart';

final dailyGoalProvider = StreamProvider.autoDispose<DailyGoal>((ref) {
  final authState = ref.watch(authStateProvider).value;
  final uid = authState?.uid;
  if (uid == null) {
    return const Stream.empty();
  }

  final usecase = ref.watch(watchDailyGoalProvider);
  return usecase(uid);
});
