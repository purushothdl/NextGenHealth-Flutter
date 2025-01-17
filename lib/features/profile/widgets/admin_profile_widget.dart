import 'package:flutter/material.dart';

import '../models/profile_model.dart';

class AdminProfileWidget extends StatelessWidget {
  final Profile profile;

  const AdminProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final adminData = profile.adminData ?? {};

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admin Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (adminData['permissions'] != null)
              _buildDetailSection('Permissions', adminData['permissions'].join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}