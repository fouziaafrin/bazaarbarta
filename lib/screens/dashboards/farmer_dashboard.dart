import 'package:flutter/material.dart';
import '../../services/a_service.dart';
import '../home_screen.dart';

class FarmerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farmer Dashboard"),
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
      body: Center(child: Text("Welcome, Farmer!")),
    );
  }
}
