import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Analytics & Reports")),
      body: FutureBuilder(
        future: fetchAnalytics(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final data = snapshot.data as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatCard("Total Users", data['totalUsers'].toString(), Colors.blue),
                _buildStatCard("Total Crops", data['totalCrops'].toString(), Colors.green),
                _buildStatCard("Pending Orders", data['pendingOrders'].toString(), Colors.orange),
                _buildStatCard("Completed Orders", data['completedOrders'].toString(), Colors.purple),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchAnalytics() async {
    int totalUsers = (await firestore.collection('users').get()).docs.length;
    int totalCrops = (await firestore.collection('crops').get()).docs.length;
    int pendingOrders = (await firestore.collection('orders').where('status', isEqualTo: 'pending').get()).docs.length;
    int completedOrders = (await firestore.collection('orders').where('status', isEqualTo: 'accepted').get()).docs.length;

    return {
      'totalUsers': totalUsers,
      'totalCrops': totalCrops,
      'pendingOrders': pendingOrders,
      'completedOrders': completedOrders,
    };
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 12),
            Text(value, style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
