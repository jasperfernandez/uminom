import 'package:uminom/features/home/data/datasources/daily_goal_remote_datasource.dart';
import 'package:uminom/features/home/data/models/daily_goal_model.dart';
import 'package:uminom/features/home/domain/entities/daily_goal.dart';
import 'package:uminom/features/home/domain/repositories/daily_goal_repository.dart';

class DailyGoalRepositoryImpl implements DailyGoalRepository {
  final DailyGoalRemoteDataSource remote;

  const DailyGoalRepositoryImpl(this.remote);

  @override
  Future<void> setGoal(String uid, DailyGoal goal) {
    final model = DailyGoalModel(
      targetMl: goal.targetMl,
      updatedAt: goal.updatedAt,
    );
    return remote.setGoal(uid, model);
  }

  @override
  Stream<DailyGoal> watchGoal(String uid) {
    return remote.watchGoal(uid).map((goal) => goal.toEntity());
  }
}
