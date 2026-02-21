import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/home/domain/usecases/delete_water_intake.dart';
import 'package:uminom/features/home/domain/usecases/log_water_intake.dart';
import 'package:uminom/features/home/presentation/providers/water_intake_providers.dart';

class WaterLogController extends AsyncNotifier<void> {
  late final LogWaterIntake _logWaterIntake;
  late final DeleteWaterIntake _deleteWaterIntake;

  @override
  Future<void> build() async {
    _logWaterIntake = ref.read(logWaterIntakeProvider);
    _deleteWaterIntake = ref.read(deleteWaterIntakeProvider);
  }

  Future<void> logIntake(String uid, int volumeMl) async {
    state = const AsyncLoading();
    final now = DateTime.now();
    state = await AsyncValue.guard(() {
      return _logWaterIntake(uid, volumeMl, now);
    });
  }

  Future<void> deleteIntake(String uid, String entryId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return _deleteWaterIntake(uid, entryId);
    });
  }
}
