import 'package:flutter/material.dart';
// import 'add_crop_screen.dart';
// import 'crop_list_screen.dart';
// import 'crop_details_screen.dart';
// import 'buyer_requests_screen.dart';
import '../../services/a_service.dart';
import '../home_screen.dart';

// Farmer Home Page
class FarmerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) return Center(child: CircularProgressIndicator());

          final userName = userSnapshot.data!['name'] ?? 'Farmer';

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $userName!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  
                  // Statistics Cards
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('farmerId', isEqualTo: userId)
                        .snapshots(),
                    builder: (context, productSnapshot) {
                      int totalProducts = productSnapshot.hasData ? productSnapshot.data!.docs.length : 0;
                      int lowStockProducts = 0;
                      
                      if (productSnapshot.hasData) {
                        lowStockProducts = productSnapshot.data!.docs.where((doc) {
                          int quantity = doc['quantity'] ?? 0;
                          return quantity < 10;
                        }).length;
                      }

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('orders')
                            .where('farmerId', isEqualTo: userId)
                            .snapshots(),
                        builder: (context, orderSnapshot) {
                          int totalOrders = orderSnapshot.hasData ? orderSnapshot.data!.docs.length : 0;
                          int pendingOrders = 0;
                          double totalRevenue = 0;

                          if (orderSnapshot.hasData) {
                            pendingOrders = orderSnapshot.data!.docs.where((doc) => doc['status'] == 'pending').length;
                            
                            for (var doc in orderSnapshot.data!.docs) {
                              if (doc['status'] == 'completed') {
                                totalRevenue += (doc['totalPrice'] ?? 0).toDouble();
                              }
                            }
                          }

                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      title: 'Total Products',
                                      value: totalProducts.toString(),
                                      icon: Icons.inventory,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: _StatCard(
                                      title: 'Total Orders',
                                      value: totalOrders.toString(),
                                      icon: Icons.shopping_bag,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Product Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetailRow(label: 'Product', value: order['productName']),
                          _DetailRow(label: 'Quantity', value: '${order['quantity']} ${order['unit']}'),
                          _DetailRow(label: 'Price per unit', value: '\${order['pricePerUnit'].toStringAsFixed(2)}'),
                          Divider(),
                          _DetailRow(
                            label: 'Total Price',
                            value: '\${order['totalPrice'].toStringAsFixed(2)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Buyer Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(order['buyerId']).get(),
                    builder: (context, buyerSnapshot) {
                      if (!buyerSnapshot.hasData) {
                        return Card(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                      }

                      var buyer = buyerSnapshot.data!;
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DetailRow(label: 'Name', value: buyer['name'] ?? 'N/A'),
                              _DetailRow(label: 'Email', value: buyer['email'] ?? 'N/A'),
                              if (order['deliveryAddress'] != null)
                                _DetailRow(label: 'Delivery Address', value: order['deliveryAddress']),
                              if (order['contactNumber'] != null)
                                _DetailRow(label: 'Contact', value: order['contactNumber']),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16),
                  if (order['status'] == 'pending')
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderId)
                                  .update({'status': 'accepted'});
                              
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order accepted'), backgroundColor: Colors.green),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text('Accept Order', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc(orderId)
                                  .update({'status': 'cancelled'});
                              
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Order cancelled'), backgroundColor: Colors.red),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text('Reject Order', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  if (order['status'] == 'accepted')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(orderId)
                              .update({'status': 'completed'});
                          
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Order completed'), backgroundColor: Colors.green),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text('Mark as Completed', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  _DetailRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
