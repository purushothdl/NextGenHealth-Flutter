// lib/features/admin/screens/user_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/api/admin_api_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/models/profile_model.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final adminApiService = AdminApiService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
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
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Email: ${profile.email}'),
                        Text('Role: ${profile.role}'),
                        Text('Status: ${profile.status}'),
                        Text('Created At: ${profile.createdAt}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (profile.patientData != null) _buildPatientDetails(profile.patientData!),
                if (profile.doctorData != null) _buildDoctorDetails(profile.doctorData!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPatientDetails(Map<String, dynamic> patientData) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Age: ${patientData['age']}'),
            Text('Height: ${patientData['height']}'),
            Text('Weight: ${patientData['weight']}'),
            Text('Blood Group: ${patientData['blood_group']}'),
            const SizedBox(height: 8),
            const Text(
              'Medical Conditions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...(patientData['medical_conditions'] as List).map((condition) => Text('- $condition')).toList(),
            const SizedBox(height: 8),
            const Text(
              'Medical History:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...(patientData['medical_history'] as List).map((history) => Text('- $history')).toList(),
            const SizedBox(height: 8),
            const Text(
              'Medications:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...(patientData['medications'] as List).map((medication) => Text('- $medication')).toList(),
            const SizedBox(height: 8),
            const Text(
              'Allergies:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...(patientData['allergies'] as List).map((allergy) => Text('- $allergy')).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorDetails(Map<String, dynamic> doctorData) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Doctor Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Specialization: ${doctorData['specialization']}'),
            Text('License Number: ${doctorData['license_number']}'),
            Text('Hospital: ${doctorData['hospital']}'),
          ],
        ),
      ),
    );
  }
}