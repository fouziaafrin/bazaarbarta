import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  // --- CROPS ---
  Future<String> addCrop(String farmerId, String name, String category, int quantity, double price, List<File> images) async {
    try {
      List<String> imageUrls = [];
      if (images != null && images.isNotEmpty) {
        for (var img in images) {
            final ref = _storage.ref().child('crop_images/$farmerId/${DateTime.now().millisecondsSinceEpoch}_${img.path.split('/').last}');
            await ref.putFile(img);
            String url = await ref.getDownloadURL();
            imageUrls.add(url);
        }
        }

      await _db.collection('crop').add({
        'name': name,
        'category': category,
        'quantity': quantity,
        'price': price,
        'farmerId': farmerId,
        'images': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Stream<QuerySnapshot> getFarmerCrops(String farmerId) {
    return _db.collection('crop').where('farmerId', isEqualTo: farmerId).orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> deleteCrop(String cropId) async {
    await _db.collection('crop').doc(cropId).delete();
  }

  Future<void> updateCrop(String cropId, Map<String, dynamic> data) async {
    await _db.collection('crop').doc(cropId).update(data);
  }
}
