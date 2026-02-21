import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uminom/features/auth/presentation/providers/auth_provider.dart';
import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';
import 'package:uminom/features/home/presentation/providers/water_intake_providers.dart';

final todayWaterIntakeProvider =
    StreamProvider.autoDispose<List<WaterIntakeEntry>>((ref) {
      final authState = ref.watch(authStateProvider).value;
      final uid = authState?.uid;
      if (uid == null) {
        return const Stream.empty();
      }

      final usecase = ref.watch(watchDailyWaterIntakeProvider);
      final today = DateTime.now();
      return usecase(uid, today);
    });
