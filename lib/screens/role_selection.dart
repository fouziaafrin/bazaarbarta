import 'package:flutter/material.dart';
import 'registration.dart';

class RoleSelection extends StatelessWidget {
  const RoleSelection({super.key});

  void navigateToRegistration(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationScreen(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Role')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => navigateToRegistration(context, 'farmer'),
              child: const Text('Farmer'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => navigateToRegistration(context, 'buyer'),
              child: const Text('Buyer'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => navigateToRegistration(context, 'admin'),
              child: const Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
