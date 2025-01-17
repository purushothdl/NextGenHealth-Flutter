import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const AdminDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome Admin ${user['username']}!'),
          const SizedBox(height: 16),
          const Text(
            'Admin Features:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildFeatureItem('- Manage Users'),
          _buildFeatureItem('- View Reports'),
          _buildFeatureItem('- System Settings'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}