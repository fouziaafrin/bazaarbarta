import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageCropsScreen extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Crops")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('crop').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final crops = snapshot.data!.docs;
          if (crops.isEmpty) return Center(child: Text("No crops found."));
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: crops.length,
            itemBuilder: (context, index) {
              final crop = crops[index];
              final data = crop.data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text("${data['category']} - ${data['quantity']} units"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => approveCrop(crop.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteCrop(crop.id),
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

  void approveCrop(String cropId) {
    firestore.collection('crops').doc(cropId).update({'approved': true});
  }

  void deleteCrop(String cropId) {
    firestore.collection('crops').doc(cropId).delete();
  }
}
