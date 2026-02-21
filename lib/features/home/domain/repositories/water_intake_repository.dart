import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';

abstract class WaterIntakeRepository {
  Future<void> logEntry(String uid, WaterIntakeEntry entry);
  Stream<List<WaterIntakeEntry>> watchDailyEntries(String uid, DateTime date);
}
