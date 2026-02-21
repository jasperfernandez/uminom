import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uminom/features/home/domain/entities/water_intake_entry.dart';

class WaterIntakeEntryModel {
  final String id;
  final DateTime timestamp;
  final int volumeMl;

  const WaterIntakeEntryModel({
    required this.id,
    required this.timestamp,
    required this.volumeMl,
  });

  factory WaterIntakeEntryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final timestamp = data?['timestamp'] as Timestamp?;
    return WaterIntakeEntryModel(
      id: doc.id,
      timestamp: timestamp?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
      volumeMl: (data?['volume_ml'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'volume_ml': volumeMl,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  WaterIntakeEntry toEntity() {
    return WaterIntakeEntry(id: id, timestamp: timestamp, volumeMl: volumeMl);
  }
}
