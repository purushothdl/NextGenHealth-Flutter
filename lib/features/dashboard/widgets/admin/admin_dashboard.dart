import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const AdminDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome Admin ${user['username']}!'),
        const SizedBox(height: 16),
        const Text('Admin Features:'),
        const Text('- Manage Users'),
        const Text('- View Reports'),
        const Text('- System Settings'),
      ],
    );
  }
}