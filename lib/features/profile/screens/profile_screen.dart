import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../models/profile_model.dart';
import '../widgets/common_profile_widget.dart';
import '../widgets/patient_profile_widget.dart';
import '../widgets/doctor_profile_widget.dart';
import '../widgets/admin_profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user data available.')),
      );
    }

    final profile = Profile.fromJson(user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Common Profile Widget
            CommonProfileWidget(profile: profile),

            // Role-Specific Widgets
            if (profile.role == 'patient') PatientProfileWidget(profile: profile),
            if (profile.role == 'doctor') DoctorProfileWidget(profile: profile),
            if (profile.role == 'admin') AdminProfileWidget(profile: profile),
          ],
        ),
      ),
    );
  }
}