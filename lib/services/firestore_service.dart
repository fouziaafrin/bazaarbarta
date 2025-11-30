import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _crops = FirebaseFirestore.instance.collection('crops');

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
}
