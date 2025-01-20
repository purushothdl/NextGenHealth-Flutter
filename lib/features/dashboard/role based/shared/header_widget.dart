// lib/features/dashboard/role_based/shared/header_widget.dart
import 'package:flutter/material.dart';

import '../../../shared/utils/greeting_utils.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String role;
  final String? profileImageUrl; // Nullable profile image URL
  final VoidCallback onNotificationPressed;

  const HeaderWidget({
    super.key,
    required this.username,
    required this.role,
    this.profileImageUrl, // Nullable
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Remove the back button
      backgroundColor: Colors.white,
      elevation: 0, // No shadow
      title: Row(
        children: [
          // Profile Picture (Handles null case)
          CircleAvatar(
            radius: 20,
            backgroundImage: profileImageUrl != null
                ? NetworkImage(profileImageUrl!) // Load image if URL is provided
                : null, // No image if URL is null
            child: profileImageUrl == null
                ? const Icon(Icons.person, size: 24, color: Colors.white) // Placeholder icon
                : null,
          ),
          const SizedBox(width: 12),

          // Greeting and Role
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GreetingUtils.getGreeting(username),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const Spacer(), // Push the notification icon to the right

          // Notification Icon Button
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.black87,
            onPressed: onNotificationPressed,
          ),
        ],
      ),
    );
  }



  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Default AppBar height
}