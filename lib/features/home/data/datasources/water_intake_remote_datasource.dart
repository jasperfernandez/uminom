import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uminom/features/home/data/models/water_intake_entry_model.dart';

class WaterIntakeRemoteDataSource {
  final FirebaseFirestore firestore;

  const WaterIntakeRemoteDataSource(this.firestore);

  CollectionReference<Map<String, dynamic>> _collection(String uid) {
    return firestore.collection('users').doc(uid).collection('water_logs');
  }

  Future<void> logEntry(String uid, WaterIntakeEntryModel entry) async {
    await _collection(uid).add(entry.toFirestore());
  }

  Future<void> deleteEntry(String uid, String entryId) async {
    await _collection(uid).doc(entryId).delete();
  }

  Stream<List<WaterIntakeEntryModel>> watchDailyEntries(
    String uid,
    DateTime date,
  ) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    return _collection(uid)
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('timestamp', isLessThan: Timestamp.fromDate(end))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(WaterIntakeEntryModel.fromFirestore).toList(),
        );
  }
}
