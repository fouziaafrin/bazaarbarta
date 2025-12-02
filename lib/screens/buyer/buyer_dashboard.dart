import 'package:flutter/material.dart';
import 'browse_crops_screen.dart';
import 'orders_screen.dart';
import '../../services/a_service.dart';
import '../home_screen.dart';
import 'profile_screen.dart';
import 'buyer_requests_screen.dart';
import 'notifications_screen.dart';

class BuyerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buyer Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Quick Overview Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOverviewCard("My Orders", "2", Colors.orange),
                _buildOverviewCard("Pending Orders", "1", Colors.red),
              ],
            ),
            SizedBox(height: 20),
            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BrowseCropsScreen()));
              },
              icon: Icon(Icons.search),
              label: Text("Browse Crops"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => OrdersScreen()));
              },
              icon: Icon(Icons.shopping_cart),
              label: Text("My Orders"),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
            ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
            },
            icon: Icon(Icons.notifications),
            label: Text("Notifications"),
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
            },
            icon: Icon(Icons.person),
            label: Text("Profile"),
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
          ),

          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: color,
      child: Container(
        width: 150,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 12),
            Text(value, style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

