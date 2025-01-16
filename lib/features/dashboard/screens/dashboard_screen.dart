import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/register_screen.dart';
import '../widgets/admin/admin_dashboard.dart';
import '../widgets/doctor/doctor_dashboard.dart';
import '../widgets/patient/patient_dashboard.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) =>  RegisterScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildDashboardContent(user),
      ),
    );
  }

  Widget _buildDashboardContent(Map<String, dynamic>? user) {
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