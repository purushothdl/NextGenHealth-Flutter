// lib/features/admin/screens/user_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/api/admin_api_service.dart';
import '../../profile/models/profile_model.dart';
import '../widgets/users/user_details_section.dart'; // Import the modularized widget

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final adminApiService = AdminApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: adminApiService.getUserProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No user data available.'));
          }

          final userData = snapshot.data!;
          final profile = Profile.fromJson(userData);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Details Section
                UserDetailsSection(
                  title: profile.role == 'patient' ? 'Patient Details' : 'Doctor Details',
                  details: userData,
                  isPatient: profile.role == 'patient',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}