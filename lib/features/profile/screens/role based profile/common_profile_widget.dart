// lib/features/profile/screens/role_based/common_profile_widget.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';
import '../../models/profile_model.dart';
import '../../../shared/utils/date_utils.dart';

class CommonProfileWidget extends StatelessWidget {
  final Profile profile;

  const CommonProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        margin: const EdgeInsets.only(top: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              // Header with gradient
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.account_circle, 
                        size: 32, 
                        color: Colors.blue.shade800),
                    const SizedBox(width: 16),
                    Text(
                      'General Information'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Profile items with timeline
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    _buildProfileItem(
                      context,
                      icon: Icons.person_outline,
                      label: 'Username',
                      value: StringUtils.getCapitalisedUsername(profile.username),
                      index: 0,
                    ),
                    _buildProfileItem(
                      context,
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: profile.email,
                      index: 1,
                    ),
                    _buildProfileItem(
                      context,
                      icon: Icons.work_outline,
                      label: 'Role',
                      value: StringUtils.getCapitalisedUsername(profile.role),
                      index: 2,
                    ),
                    _buildProfileItem(
                      context,
                      icon: Icons.event_outlined,
                      label: 'Joined On',
                      value: FormatDateUtils.formatDateString(profile.createdAt),
                      index: 3,
                    ),
                    _buildProfileItem(
                      context,
                      icon: Icons.verified_outlined,
                      label: 'Status',
                      value: StringUtils.getCapitalisedUsername(profile.status),
                      index: 4,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              // Decorative footer
              Container(
                height: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade100,
                      Colors.blue.shade300,
                      Colors.blue.shade100,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required int index,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline connector
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.shade300,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.blue.shade100,
                ),
            ],
          ),
          const SizedBox(width: 20),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20, color: Colors.blue.shade600),
                    const SizedBox(width: 12),
                    Text(
                      label.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade600,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade900,
                    height: 1.3,
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