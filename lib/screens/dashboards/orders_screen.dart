import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/a_service.dart';

class OrdersScreen extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final buyerId = AuthService().currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('orders')
            .where('buyerId', isEqualTo: buyerId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final orders = snapshot.data!.docs;
          if (orders.isEmpty) return Center(child: Text("No orders placed."));

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;
              final cropId = data['cropId'];

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: FutureBuilder<DocumentSnapshot>(
                    future: firestore.collection('crop').doc(cropId).get(),
                    builder: (context, cropSnapshot) {
                      if (!cropSnapshot.hasData) return Text("Crop: Loading...");
                      final cropData = cropSnapshot.data!.data() as Map<String, dynamic>;
                      return Text("Crop: ${cropData['name']}");
                    },
                  ),
                  subtitle: Text("Qty: ${data['quantity']} | Status: ${data['status']}"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
