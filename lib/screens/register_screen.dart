import 'package:flutter/material.dart';
import '../services/a_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String role = 'farmer';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                    TextFormField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                    TextFormField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
                    DropdownButtonFormField<String>(
                      value: role,
                      items: ['farmer', 'buyer'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) => setState(() => role = val!),
                      decoration: InputDecoration(labelText: "Role"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() => loading = true);
                        String? res = await AuthService().register(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          nameController.text.trim(),
                          role,
                        );
                        setState(() => loading = false);
                        if (res == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Successful! Please login.")));
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $res")));
                        }
                      },
                      child: Text("Register"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
