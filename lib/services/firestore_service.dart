import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _crops = FirebaseFirestore.instance.collection('crops');

  // Real-time stream
  Stream<List<Map<String, dynamic>>> getCropsStream() {
    return _crops.orderBy('name_en').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          "name_en": doc['name_en'],
          "name_bn": doc['name_bn'],
          "price": doc['price'],
          "unit": doc['unit'],
        };
      }).toList();
    });
  }

  // One-time fetch (needed by HomeScreen)
  Future<List<Map<String, dynamic>>> getLatestCrops() async {
    final snapshot = await _crops.orderBy('name_en').get();

    return snapshot.docs.map((doc) {
      return {
        "name_en": doc['name_en'],
        "name_bn": doc['name_bn'],
        "price": doc['price'],
        "unit": doc['unit'],
      };
    }).toList();
  }
}
