import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/home/domain/usecases/set_daily_goal.dart';
import 'package:uminom/features/home/presentation/providers/daily_goal_providers.dart';

class DailyGoalController extends AsyncNotifier<void> {
  late final SetDailyGoal _setDailyGoal;

  @override
  Future<void> build() async {
    _setDailyGoal = ref.read(setDailyGoalProvider);
  }

  Future<void> setGoal(String uid, int targetMl) async {
    state = const AsyncLoading();
    final now = DateTime.now();
    state = await AsyncValue.guard(() {
      return _setDailyGoal(uid, targetMl, now);
    });
  }
}
