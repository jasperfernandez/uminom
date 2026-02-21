import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/core/providers/firebase_providers.dart';
import 'package:uminom/features/home/data/datasources/water_intake_remote_datasource.dart';
import 'package:uminom/features/home/data/repositories/water_intake_repository_impl.dart';
import 'package:uminom/features/home/domain/repositories/water_intake_repository.dart';
import 'package:uminom/features/home/domain/usecases/delete_water_intake.dart';
import 'package:uminom/features/home/domain/usecases/log_water_intake.dart';
import 'package:uminom/features/home/domain/usecases/watch_daily_water_intake.dart';
import 'package:uminom/features/home/presentation/controllers/water_log_controller.dart';

final waterIntakeRemoteDataSourceProvider =
    Provider<WaterIntakeRemoteDataSource>((ref) {
      final firestore = ref.watch(firestoreProvider);
      return WaterIntakeRemoteDataSource(firestore);
    });

final waterIntakeRepositoryProvider = Provider<WaterIntakeRepository>((ref) {
  final remote = ref.watch(waterIntakeRemoteDataSourceProvider);
  return WaterIntakeRepositoryImpl(remote);
});

final logWaterIntakeProvider = Provider<LogWaterIntake>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  return LogWaterIntake(repository);
});

final deleteWaterIntakeProvider = Provider<DeleteWaterIntake>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  return DeleteWaterIntake(repository);
});

final watchDailyWaterIntakeProvider = Provider<WatchDailyWaterIntake>((ref) {
  final repository = ref.watch(waterIntakeRepositoryProvider);
  return WatchDailyWaterIntake(repository);
});

final waterLogControllerProvider =
    AsyncNotifierProvider<WaterLogController, void>(WaterLogController.new);
