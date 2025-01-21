// lib/features/dashboard/role_based/shared/header_widget.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';
import '../../../shared/utils/greeting_utils.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String? profileImageUrl;
  final VoidCallback onNotificationPressed;

  const HeaderWidget({
    super.key,
    required this.username,
    this.profileImageUrl,
    required this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.blue.withOpacity(0.1),
      title: Row(
        children: [
          // Profile Avatar with Shadow
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blue.shade50,
              backgroundImage: profileImageUrl != null
                  ? NetworkImage(profileImageUrl!)
                  : null,
              child: profileImageUrl == null
                  ? Icon(Icons.person_rounded, 
                      size: 24, 
                      color: Colors.blue.shade800)
                  : null,
            ),
          ),
          const SizedBox(width: 16),

          // Greeting and Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GreetingUtils.getGreeting(),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                StringUtils.getCapitalisedUsername(username),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Notification Icon with Badge Potential
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade50,
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_outlined,
                  color: Colors.blue.shade800),
              splashRadius: 20,
              onPressed: onNotificationPressed,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}