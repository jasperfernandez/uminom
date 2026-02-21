import 'package:uminom/features/home/domain/repositories/water_intake_repository.dart';

class DeleteWaterIntake {
  final WaterIntakeRepository repository;

  const DeleteWaterIntake(this.repository);

  Future<void> call(String uid, String entryId) {
    return repository.deleteEntry(uid, entryId);
  }
}
