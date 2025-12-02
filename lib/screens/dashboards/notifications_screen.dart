import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/a_service.dart';

class NotificationsScreen extends StatelessWidget {
  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final userId = AuthService().currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('notifications')
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final notifications = snapshot.data!.docs;
          if (notifications.isEmpty) return Center(child: Text("No notifications yet."));
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              final data = notif.data() as Map<String, dynamic>;
              return Card(
                color: data['read'] ? Colors.white : Colors.blue[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  title: Text(data['message']),
                  subtitle: Text((data['createdAt'] as Timestamp).toDate().toString()),
                  onTap: () {
                    firestore.collection('notifications').doc(notif.id).update({'read': true});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
