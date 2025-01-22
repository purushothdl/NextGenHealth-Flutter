// lib/features/dashboard/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../notifications/screens/notification_screen.dart';
import '../role based/admin/admin_dashboard_screen.dart';
import '../role based/doctor/doctor_dashboard.dart';
import '../role based/patient/patient_dashboard.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/register_screen.dart';
import '../role based/shared/header_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: HeaderWidget(
        username: user?['username'] ?? 'User', 
        profileImageUrl: user?['profileImageUrl'],
        onNotificationPressed: () {
          // Navigate to Notifications Screen
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
        },
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildDashboardContent(user, context),
      ),
    );
  }

  Widget _buildDashboardContent(Map<String, dynamic>? user, BuildContext context) {
    if (user == null) {
      return const Center(child: Text('No user data available.'));
    }

    final role = user['role'];

    switch (role) {
      case 'admin':
        return AdminDashboard(user: user); 
      case 'patient':
        return PatientDashboard(user: user); 
      case 'doctor':
        return DoctorDashboard(user: user); 
      default:
        return const Center(child: Text('Invalid role.'));
    }
  }
}