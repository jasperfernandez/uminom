import 'package:uminom/features/home/domain/entities/daily_goal.dart';
import 'package:uminom/features/home/domain/repositories/daily_goal_repository.dart';

class SetDailyGoal {
  final DailyGoalRepository repository;

  const SetDailyGoal(this.repository);

  Future<void> call(String uid, int targetMl, DateTime updatedAt) {
    final goal = DailyGoal(targetMl: targetMl, updatedAt: updatedAt);
    return repository.setGoal(uid, goal);
  }
}
