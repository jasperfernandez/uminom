import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/home/domain/usecases/log_water_intake.dart';
import 'package:uminom/features/home/presentation/providers/water_intake_providers.dart';

class WaterLogController extends AsyncNotifier<void> {
  late final LogWaterIntake _logWaterIntake;

  @override
  Future<void> build() async {
    _logWaterIntake = ref.read(logWaterIntakeProvider);
  }

  Future<void> logIntake(String uid, int volumeMl) async {
    state = const AsyncLoading();
    final now = DateTime.now();
    state = await AsyncValue.guard(() {
      return _logWaterIntake(uid, volumeMl, now);
    });
  }
}
