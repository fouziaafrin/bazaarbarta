import 'package:flutter/material.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome Buyer!'),
            SizedBox(height: 16),
            Text('Here you can browse crops, place orders, etc.'),
          ],
        ),
      ),
    );
  }
}
