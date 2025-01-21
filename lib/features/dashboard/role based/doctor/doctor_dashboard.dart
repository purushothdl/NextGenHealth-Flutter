// lib/features/dashboard/role_based/doctor/doctor_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/chat/screens/chat_history_screen.dart';
import 'package:next_gen_health/features/profile/models/profile_model.dart';
import 'package:next_gen_health/features/profile/screens/profile_screen.dart';
import '../../../tickets/screens/tickets_screen.dart';
import '../shared/blue_container.dart';
import '../shared/feedback_card.dart';
import '../shared/service_item.dart';

class DoctorDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const DoctorDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Card at the Top with "View Tickets" Button
            BlueContainer(
              title: 'Welcome, Dr. ${user['username']}!',
              subtitle: 'Manage your appointments and tickets efficiently.',
              buttonText: 'View Tickets',
              imagePath: 'assets/images/dashboard/doctor_welcome_bg.jpg',
              onButtonPressed: () {
                // Navigate to TicketScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TicketScreen(),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ServiceItem(
                    icon: Icons.report,
                    label: 'Reports',
                    onPressed: () {
                      // Navigate to TicketScreen (or a specific report screen)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TicketScreen(),
                        ),
                      );
                    },
                  ),
                  ServiceItem(
                    icon: Icons.radio_button_checked_outlined,
                    label: 'Chatbot',
                    onPressed: () {
                      // Navigate to ChatbotScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatHistoryScreen(),
                        ),
                      );
                    },
                  ),
                  ServiceItem(
                    icon: Icons.person,
                    label: 'Profile',
                    onPressed: () {
                      // Navigate to ChatbotScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  ServiceItem(
                    icon: Icons.help_outline,
                    label: 'FAQs',
                    onPressed: () {
                      // Navigate to FAQScreen
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => FAQScreen()));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Feedback Card
FeedbackCard(
  onGiveFeedback: () {
    print('Give Feedback button pressed!');
    // Add your logic here for handling feedback submission
  },
  onViewFeedback: () {
    print('See Your Feedback button pressed!');
    // Add your logic here for navigating to feedback history
  },
)
          ],
        ),
      ),
    );
  }
}