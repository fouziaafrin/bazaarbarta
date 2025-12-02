import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'crop_details_buyer_screen.dart';

class BrowseCropsScreen extends StatefulWidget {
  @override
  _BrowseCropsScreenState createState() => _BrowseCropsScreenState();
}

class _BrowseCropsScreenState extends State<BrowseCropsScreen> {
  final firestore = FirebaseFirestore.instance;
  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Browse Crops")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search crops by name or category",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => search = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('crops').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final crops = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['name'].toString().toLowerCase().contains(search) ||
                      data['category'].toString().toLowerCase().contains(search);
                }).toList();

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
                        leading: data['images'] != null && (data['images'] as List).isNotEmpty
                            ? Image.network(data['images'][0], width: 60, height: 60, fit: BoxFit.cover)
                            : Icon(Icons.image),
                        title: Text(data['name']),
                        subtitle: Text("${data['category']} - ${data['quantity']} units"),
                        trailing: Text("₹${data['price']}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CropDetailsBuyerScreen(cropId: crop.id, cropData: data),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
