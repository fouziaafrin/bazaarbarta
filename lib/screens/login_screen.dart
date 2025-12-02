import 'package:flutter/material.dart';
import '../services/a_service.dart';
import '../services/firestore_service.dart';
import 'dashboards/admin_dashboard.dart';
import 'dashboards/farmer_dashboard.dart';
import 'dashboards/buyer_dashboard.dart';
import 'register_screen.dart';
import 'dashboards/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (v) => v!.contains("@") ? null : "Invalid email",
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => hidePassword = !hidePassword),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? "Enter password" : null,
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ForgotPasswordScreen()),
                      ),
                      child: Text("Forgot Password?"),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() => loading = true);
                      String? res = await AuthService().login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );

                      if (res != null) {
                        setState(() => loading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login Failed: $res")),
                        );
                        return;
                      }

                      final uid = AuthService().currentUser!.uid;
                      String role = await FirestoreService().getUserRole(uid);

                      setState(() => loading = false);

                      if (role == "admin") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => AdminDashboard()),
                        );
                      } else if (role == "farmer") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => FarmerDashboard()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => BuyerDashboard()),
                        );
                      }
                    },
                    child: Text("Login"),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                    child: Text("Don't have an account? Register"),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "© 2025 BazaarBarta",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          if (loading)
            Container(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
