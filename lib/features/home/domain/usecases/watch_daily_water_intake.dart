import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';
import 'package:uminom/features/home/domain/repositories/water_intake_repository.dart';

class WatchDailyWaterIntake {
  final WaterIntakeRepository repository;

  const WatchDailyWaterIntake(this.repository);

  Stream<List<WaterIntakeEntry>> call(String uid, DateTime date) {
    return repository.watchDailyEntries(uid, date);
  }
}
