import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/a_service.dart';

class CropDetailsBuyerScreen extends StatefulWidget {
  final String cropId;
  final Map<String, dynamic> cropData;

  CropDetailsBuyerScreen({required this.cropId, required this.cropData});

  @override
  _CropDetailsBuyerScreenState createState() => _CropDetailsBuyerScreenState();
}

class _CropDetailsBuyerScreenState extends State<CropDetailsBuyerScreen> {
  final TextEditingController quantityController = TextEditingController();
  bool loading = false;
  final firestore = FirebaseFirestore.instance;

  void placeOrder() async {
    if (quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter quantity")));
      return;
    }

    int qty = int.parse(quantityController.text.trim());
    if (qty <= 0 || qty > widget.cropData['quantity']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid quantity")));
      return;
    }

    setState(() => loading = true);
    await firestore.collection('orders').add({
      'cropId': widget.cropId,
      'buyerId': AuthService().currentUser!.uid,
      'farmerId': widget.cropData['farmerId'],
      'quantity': qty,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Placed!")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.cropData;
    return Scaffold(
      appBar: AppBar(title: Text(data['name'])),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['images'] != null && (data['images'] as List).isNotEmpty)
                    Image.network(data['images'][0], width: double.infinity, height: 200, fit: BoxFit.cover),
                  SizedBox(height: 16),
                  Text("Category: ${data['category']}", style: TextStyle(fontSize: 18)),
                  Text("Price: ₹${data['price']}", style: TextStyle(fontSize: 18)),
                  Text("Available: ${data['quantity']}", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: "Quantity to order"),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: placeOrder,
                    child: Text("Place Order"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  ),
                ],
              ),
            ),
    );
  }
}
