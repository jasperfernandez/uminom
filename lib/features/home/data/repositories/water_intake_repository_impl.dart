import 'package:uminom/features/home/data/datasources/water_intake_remote_datasource.dart';
import 'package:uminom/features/home/data/models/water_intake_entry_model.dart';
import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';
import 'package:uminom/features/home/domain/repositories/water_intake_repository.dart';

class WaterIntakeRepositoryImpl implements WaterIntakeRepository {
  final WaterIntakeRemoteDataSource remote;

  const WaterIntakeRepositoryImpl(this.remote);

  @override
  Future<void> logEntry(String uid, WaterIntakeEntry entry) {
    final model = WaterIntakeEntryModel(
      id: entry.id,
      timestamp: entry.timestamp,
      volumeMl: entry.volumeMl,
    );
    return remote.logEntry(uid, model);
  }

  @override
  Stream<List<WaterIntakeEntry>> watchDailyEntries(String uid, DateTime date) {
    return remote
        .watchDailyEntries(uid, date)
        .map((entries) => entries.map((entry) => entry.toEntity()).toList());
  }
}
