import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home_screen.dart';
import 'screens/dashboards/admin_dashboard.dart';
import 'screens/dashboards/farmer_dashboard.dart';
import 'screens/dashboards/buyer_dashboard.dart';
import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role Based App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) return HomeScreen();

        // Logged in → get role
        return FutureBuilder<String>(
          future: FirestoreService().getUserRole(snapshot.data!.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (roleSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${roleSnapshot.error}')),
              );
            }

            String role = roleSnapshot.data!;
            if (role == "admin") return AdminDashboard();
            if (role == "farmer") return FarmerDashboard();
            return BuyerDashboard();
          },
        );
      },
    );
  }
}
