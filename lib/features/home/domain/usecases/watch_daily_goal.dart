import 'package:uminom/features/home/domain/entities/daily_goal.dart';
import 'package:uminom/features/home/domain/repositories/daily_goal_repository.dart';

class WatchDailyGoal {
  final DailyGoalRepository repository;

  const WatchDailyGoal(this.repository);

  Stream<DailyGoal> call(String uid) {
    return repository.watchGoal(uid);
  }
}
