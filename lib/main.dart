import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/role_selection.dart';
import 'screens/login.dart';
import 'screens/farmer_dashboard.dart';
import 'screens/buyer_dashboard.dart';
import 'screens/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BazaarBarta',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const RoleSelection(),
        '/login': (context) => const LoginScreen(),
        '/farmer_dashboard': (context) => const FarmerDashboard(),
        '/buyer_dashboard': (context) => const BuyerDashboard(),
        '/admin_dashboard': (context) => const AdminDashboard(),
      },
      initialRoute: '/',
    );
  }
}
