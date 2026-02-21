import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';
import 'package:uminom/features/home/domain/repositories/water_intake_repository.dart';

class LogWaterIntake {
  final WaterIntakeRepository repository;

  const LogWaterIntake(this.repository);

  Future<void> call(String uid, int volumeMl, DateTime timestamp) {
    final entry = WaterIntakeEntry(
      id: '',
      timestamp: timestamp,
      volumeMl: volumeMl,
    );
    return repository.logEntry(uid, entry);
  }
}
