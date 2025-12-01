import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/firestore_service.dart';
import '../../services/a_service.dart';
import 'crop_details_screen.dart';

class CropListScreen extends StatelessWidget {
  final firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Crops")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.getFarmerCrops(AuthService().currentUser!.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final crops = snapshot.data!.docs;
          if (crops.isEmpty) return Center(child: Text("No crops added yet."));

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final crop = crops[index];
              final data = crop.data() as Map<String, dynamic>;

              // Safe image handling
              final images = (data['images'] is List) ? data['images'] as List : [];
              final firstImage = images.isNotEmpty && images[0] != null && images[0] != ''
                  ? images[0] as String
                  : null;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: firstImage != null
                      ? Image.network(firstImage, width: 60, height: 60, fit: BoxFit.cover)
                      : Icon(Icons.image),
                  title: Text(data['name'] ?? 'No Name'),
                  subtitle: Text(
                      "${data['category'] ?? 'Unknown'} - ${data['quantity'] ?? 0} units"),
                  trailing: Text("₹${data['price'] ?? 0}"),
                  onTap: () {
                     Navigator.push(context, MaterialPageRoute(
                       builder: (_) => CropDetailsScreen(cropId: crop.id, cropData: data)
                     ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
