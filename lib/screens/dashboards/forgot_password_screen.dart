import 'package:flutter/material.dart';
import '../../services/a_service.dart';
import '../../services/firestore_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    "Enter your email to reset password",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                    validator: (v) => v!.contains("@") ? null : "Invalid email",
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50)),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() => loading = true);
                      String? res = await AuthService().resetPassword(emailController.text.trim());
                      setState(() => loading = false);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(res ?? "Reset email sent! Check inbox.")),
                      );
                    },
                    child: Text("Send Reset Link"),
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
