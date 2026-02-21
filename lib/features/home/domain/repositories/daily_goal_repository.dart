import 'package:uminom/features/home/domain/entities/daily_goal.dart';

abstract class DailyGoalRepository {
  Future<void> setGoal(String uid, DailyGoal goal);
  Stream<DailyGoal> watchGoal(String uid);
}
