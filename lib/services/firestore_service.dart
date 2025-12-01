import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(String uid, String email, String name, String role) async {
    await _db.collection('user').doc(uid).set({
      'email': email,
      'name': name,
      'role': role,
    });
  }

  Future<String> getUserRole(String uid) async {
    var doc = await _db.collection('user').doc(uid).get();
    return doc['role'];
  }
}
