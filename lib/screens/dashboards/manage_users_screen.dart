import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersScreen extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Users")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('user').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final users = snapshot.data!.docs;
          if (users.isEmpty) return Center(child: Text("No users found."));
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(data['name'] ?? "No Name"),
                  subtitle: Text(data['role'] ?? "No Role"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => verifyUser(user.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteUser(user.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void verifyUser(String userId) {
    firestore.collection('users').doc(userId).update({'verified': true});
  }

  void deleteUser(String userId) {
    firestore.collection('users').doc(userId).delete();
  }
}
