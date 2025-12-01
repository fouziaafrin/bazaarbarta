import 'package:flutter/material.dart';
import '../services/a_service.dart';
import '../services/firestore_service.dart';
import 'dashboards/admin_dashboard.dart';
import 'dashboards/farmer_dashboard.dart';
import 'dashboards/buyer_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                  TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      String? res = await AuthService().login(emailController.text.trim(), passwordController.text.trim());
                      setState(() => loading = false);
                      if (res == null) {
                        String role = await FirestoreService().getUserRole(AuthService().currentUser!.uid);
                        if (role == "admin") {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
                        } else if (role == "farmer") {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => FarmerDashboard()));
                        } else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BuyerDashboard()));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Failed: $res")));
                      }
                    },
                    child: Text("Login"),
                  )
                ],
              ),
            ),
    );
  }
}
