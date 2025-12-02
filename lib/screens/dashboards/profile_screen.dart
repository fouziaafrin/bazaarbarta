import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/a_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firestore = FirebaseFirestore.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService().currentUser!;
    emailController.text = user.email ?? "";
    // Load additional profile info
    firestore.collection('users').doc(user.uid).get().then((doc) {
      if (doc.exists) nameController.text = doc['name'] ?? "";
    });
  }

  void updateProfile() async {
    setState(() => loading = true);
    await firestore.collection('users').doc(AuthService().currentUser!.uid).update({
      'name': nameController.text.trim(),
    });
    setState(() => loading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
                  TextField(controller: emailController, decoration: InputDecoration(labelText: "Email"), readOnly: true),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: updateProfile,
                    child: Text("Update Profile"),
                    style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                  )
                ],
              ),
            ),
    );
  }
}
