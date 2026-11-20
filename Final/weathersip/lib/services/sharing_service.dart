import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String get currentUid {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  // Mengirim permintaan izin
  Future<void> requestAccess({
    required String targetUid,
  }) async {
    final requesterUid = currentUid;

    await _db
        .collection('users')
        .doc(targetUid)
        .collection('incomingRequests')
        .doc(requesterUid)
        .set({
      'requesterUid': requesterUid,
      'targetUid': targetUid,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Melihat permintaan yang masuk
  Stream<QuerySnapshot<Map<String, dynamic>>> getIncomingRequests() {
    return _db
        .collection('users')
        .doc(currentUid)
        .collection('incomingRequests')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }

  // Menerima permintaan
  Future<void> acceptRequest({
    required String requesterUid,
  }) async {
    final ownerUid = currentUid;

    final batch = _db.batch();

    final requestRef = _db
        .collection('users')
        .doc(ownerUid)
        .collection('incomingRequests')
        .doc(requesterUid);

    final sharingRef = _db
        .collection('users')
        .doc(ownerUid)
        .collection('sharing')
        .doc(requesterUid);

    batch.update(requestRef, {
      'status': 'accepted',
      'decisionAt': FieldValue.serverTimestamp(),
    });

    batch.set(sharingRef, {
      'viewerUid': requesterUid,
      'allowed': true,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Menolak permintaan
  Future<void> rejectRequest({
    required String requesterUid,
  }) async {
    await _db
        .collection('users')
        .doc(currentUid)
        .collection('incomingRequests')
        .doc(requesterUid)
        .update({
      'status': 'rejected',
      'decisionAt': FieldValue.serverTimestamp(),
    });
  }

  // Mencabut izin
  Future<void> revokeAccess({
    required String viewerUid,
  }) async {
    final ownerUid = currentUid;

    final batch = _db.batch();

    final sharingRef = _db
        .collection('users')
        .doc(ownerUid)
        .collection('sharing')
        .doc(viewerUid);

    batch.delete(sharingRef);

    await batch.commit();
  }

  // Mengecek apakah pengguna boleh melihat data
  Future<bool> canViewUser({
    required String ownerUid,
  }) async {
    if (ownerUid == currentUid) {
      return true;
    }

    final permission = await _db
        .collection('users')
        .doc(ownerUid)
        .collection('sharing')
        .doc(currentUid)
        .get();

    return permission.exists &&
        permission.data()?['allowed'] == true;
  }
}