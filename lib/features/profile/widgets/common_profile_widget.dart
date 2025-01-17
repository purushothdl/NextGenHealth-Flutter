import 'package:flutter/material.dart';

import '../models/profile_model.dart';

class CommonProfileWidget extends StatelessWidget {
  final Profile profile;

  const CommonProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileItem('Username', profile.username),
            _buildProfileItem('Email', profile.email),
            _buildProfileItem('Role', profile.role),
            _buildProfileItem('Created At', profile.createdAt),
            _buildProfileItem('Status', profile.status),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}