import 'package:flutter/material.dart';
import '../services/a_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  String role = 'farmer';
  bool loading = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Full Name"),
                    validator: (v) => v!.isEmpty ? "Enter name" : null,
                  ),
                  SizedBox(height: 16),
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
                        icon: Icon(
                          hidePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => hidePassword = !hidePassword),
                      ),
                    ),
                    validator: (v) => v!.length < 6 ? "Password too short" : null,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: role,
                    items: ['farmer', 'buyer']
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (val) => setState(() => role = val!),
                    decoration: InputDecoration(labelText: "Role"),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() => loading = true);
                      String? res = await AuthService().register(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        nameController.text.trim(),
                        role,
                      );
                      setState(() => loading = false);

                      if (res == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Registration successful! Please login.")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: $res")),
                        );
                      }
                    },
                    child: Text("Register"),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => LoginScreen())),
                    child: Text("Already have an account? Login"),
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
