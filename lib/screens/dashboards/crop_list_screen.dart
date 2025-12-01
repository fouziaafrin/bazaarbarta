import 'package:flutter/material.dart';

class CropListScreen extends StatelessWidget {
  // Dummy data for UI
  final List<Map<String, String>> crops = [
    {"name": "Tomato", "category": "Vegetable", "quantity": "20", "price": "50"},
    {"name": "Mango", "category": "Fruit", "quantity": "10", "price": "200"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Crops")),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: crops.length,
        itemBuilder: (context, index) {
          final crop = crops[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(crop['name']!),
              subtitle: Text("${crop['category']} - ${crop['quantity']} units"),
              trailing: Text("₹${crop['price']}"),
              onTap: () {
                // TODO: Navigate to crop details / edit screen
              },
            ),
          );
        },
      ),
    );
  }
}
