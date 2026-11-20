import 'package:cloud_firestore/cloud_firestore.dart';

class WaterFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Menambahkan catatan minum
  Future<void> addWaterIntake({
    required String uid,
    required int amountMl,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('waterLogs')
        .add({
      'amountMl': amountMl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Mengambil riwayat minum
  Stream<QuerySnapshot<Map<String, dynamic>>> getWaterLogs(
    String uid,
  ) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('waterLogs')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Menghapus catatan
  Future<void> deleteWaterIntake({
    required String uid,
    required String logId,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('waterLogs')
        .doc(logId)
        .delete();
  }

  // Mengubah catatan
  Future<void> updateWaterIntake({
    required String uid,
    required String logId,
    required int newAmount,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('waterLogs')
        .doc(logId)
        .update({
      'amountMl': newAmount,
    });
  }
}