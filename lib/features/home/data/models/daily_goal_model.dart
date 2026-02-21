import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uminom/features/home/domain/entities/daily_goal.dart';

class DailyGoalModel {
  final int targetMl;
  final DateTime? updatedAt;

  const DailyGoalModel({required this.targetMl, this.updatedAt});

  factory DailyGoalModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final updated = data?['updated_at'] as Timestamp?;
    return DailyGoalModel(
      targetMl: (data?['target_ml'] as num?)?.toInt() ?? 2000,
      updatedAt: updated?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'target_ml': targetMl, 'updated_at': FieldValue.serverTimestamp()};
  }

  DailyGoal toEntity() {
    return DailyGoal(targetMl: targetMl, updatedAt: updatedAt);
  }
}
