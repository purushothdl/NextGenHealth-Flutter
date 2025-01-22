// lib/features/dashboard/role based/admin/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../../../admin/screens/pending_approvals_screen.dart';
import '../../../admin/screens/users_screen.dart';
import '../../../chat/screens/chat_history_screen.dart';
import '../../../feedback and FAQ/screens/faq_screen.dart';
import '../../../feedback and FAQ/screens/post_feedback_screen.dart';
import '../../../feedback and FAQ/screens/view_feedback_screen.dart';
import '../../../tickets/screens/tickets_screen.dart';
import '../shared/blue_container.dart';
import '../shared/feedback_card.dart';
import '../shared/service_item.dart';

class AdminDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const AdminDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Card at the Top
            BlueContainer(
              title: 'Welcome, ${user['username']}!',
              subtitle: 'Manage your platform efficiently with the admin dashboard.',
              buttonText: 'View Users',
              imagePath: 'assets/images/dashboard/admin_welcome_bg.jpg',
              onButtonPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UsersScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Services Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Single Row of Icon Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ServiceItem(
                    icon: Icons.list_alt,
                    label: 'Tickets',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TicketScreen(),
                        ),
                      );
                    },
                  ),
                  ServiceItem(
                    icon: Icons.verified_user,
                    label: 'Approve',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PendingApprovalsScreen(),
                        ),
                      );
                    },
                  ),
                  ServiceItem(
                    icon: Icons.radio_button_checked_outlined,
                    label: 'Chatbot',
                    onPressed: () {
                      // Navigate to ChatbotScreen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatHistoryScreen()));
                    },
                  ),

                  ServiceItem(
                    icon: Icons.help_outline,
                    label: 'FAQs',
                    onPressed: () {
                      // Add functionality for View Feedback
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen()));
                    },
                  ),
                ],
              ),
            ),
                        const SizedBox(height: 24),

            // Feedback Card
            FeedbackCard(
              onGiveFeedback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PostFeedbackScreen(), // Replace with your screen
                  ),
                );
              },
              onViewFeedback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewFeedbackScreen(), // Replace with your screen
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}