import 'package:cloud_firestore/cloud_firestore.dart';

class MarketplaceService {
  final col = FirebaseFirestore.instance.collection("marketplace");

  Future<void> addItem(Map<String, dynamic> item) async {
    await col.add(item);
  }

  Stream<List<Map<String, dynamic>>> getItems() {
    return col.orderBy("timestamp", descending: true).snapshots().map(
          (snap) => snap.docs.map((d) => d.data()).toList(),
        );
  }
}

