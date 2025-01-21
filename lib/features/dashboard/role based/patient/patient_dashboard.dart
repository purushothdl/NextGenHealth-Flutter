// lib/features/dashboard/role_based/patient/patient_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/chat/screens/chat_history_screen.dart';
import 'package:next_gen_health/features/profile/screens/profile_screen.dart';
import '../shared/blue_container.dart'; // Reusable blue container
import '../shared/feedback_card.dart'; // Reusable feedback card
import '../shared/service_item.dart'; // Reusable service item
import '../../../tickets/screens/raise_ticket_screen.dart'; // Import RaiseTicketScreen
import '../../../tickets/screens/tickets_screen.dart'; // Import TicketScreen

class PatientDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const PatientDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Card at the Top with "Raise Ticket" Button
            BlueContainer(
              title: 'Welcome, ${user['username']}!',
              subtitle: 'Manage your health and tickets efficiently.',
              buttonText: 'Raise Ticket',
              imagePath: 'assets/images/dashboard/patient_welcome_bg.jpg',
              onButtonPressed: () {
                // Navigate to RaiseTicketScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RaiseTicketScreen(), // Use RaiseTicketScreen
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
                    icon: Icons.list_alt,
                    label: 'Tickets',
                    onPressed: () {
                      // Navigate to TicketScreen
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatHistoryScreen()));
                    },
                  ),
                  ServiceItem(
                    icon: Icons.person,
                    label: 'Profile',
                    onPressed: () {
                      // Navigate to ChatbotScreen
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
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