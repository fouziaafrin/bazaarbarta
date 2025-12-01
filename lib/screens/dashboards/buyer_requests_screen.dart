import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import '../../services/a_service.dart';

class BuyerRequestsScreen extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final farmerId = AuthService().currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Buyer Requests")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('orders').where('farmerId', isEqualTo: farmerId).where('status', isEqualTo: 'pending').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final orders = snapshot.data!.docs;
          if (orders.isEmpty) return Center(child: Text("No requests yet."));
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text("Buyer: ${data['buyerId']}"),
                  subtitle: Text("Crop: ${data['cropId']} | Qty: ${data['quantity']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => updateOrderStatus(order.id, 'accepted', context),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => updateOrderStatus(order.id, 'declined', context),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void updateOrderStatus(String orderId, String status, BuildContext context) async {
    await firestore.collection('orders').doc(orderId).update({'status': status});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order $status")));
  }
}
