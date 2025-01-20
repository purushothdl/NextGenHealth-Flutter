// lib/features/profile/screens/role_based/common_profile_widget.dart
import 'package:flutter/material.dart';
import '../../models/profile_model.dart';
import '../../../shared/utils/date_utils.dart';

class CommonProfileWidget extends StatelessWidget {
  final Profile profile;

  const CommonProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            _buildProfileItem(Icons.person, 'Username', profile.username),
            _buildProfileItem(Icons.email, 'Email', profile.email),
            _buildProfileItem(Icons.work, 'Role', profile.role),
            _buildProfileItem(Icons.calendar_today, 'Joined On', FormatDateUtils.formatDateString(profile.createdAt),),
            _buildProfileItem(Icons.verified_user, 'Status', profile.status),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}