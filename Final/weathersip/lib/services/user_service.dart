import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'dailyGoalMl': 2000,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>?> getUserProfile(
    String uid,
  ) async {
    final snapshot =
        await _db.collection('users').doc(uid).get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  Future<void> updateDailyGoal({
    required String uid,
    required int goal,
  }) async {
    await _db.collection('users').doc(uid).update({
      'dailyGoalMl': goal,
    });
  }
}