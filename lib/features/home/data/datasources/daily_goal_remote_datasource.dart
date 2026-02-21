import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uminom/features/home/data/models/daily_goal_model.dart';

class DailyGoalRemoteDataSource {
  final FirebaseFirestore firestore;

  const DailyGoalRemoteDataSource(this.firestore);

  DocumentReference<Map<String, dynamic>> _doc(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('daily_goal')
        .doc('current');
  }

  Future<void> setGoal(String uid, DailyGoalModel goal) async {
    await _doc(uid).set(goal.toFirestore(), SetOptions(merge: true));
  }

  Stream<DailyGoalModel> watchGoal(String uid) {
    return _doc(uid).snapshots().map((doc) {
      if (!doc.exists) {
        return const DailyGoalModel(targetMl: 2000, updatedAt: null);
      }
      return DailyGoalModel.fromFirestore(doc);
    });
  }
}
