// lib/features/profile/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/loading_screen.dart';
import '../../home/screens/home_screen.dart';
import '../../shared/utils/string_utils.dart';
import '../models/profile_model.dart';
import 'role based/common_profile_widget.dart';
import 'role based/doctor_profile_widget.dart';
import 'role based/patient_profile_widget.dart';
import 'update_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleRefresh(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAndLoadUser();
  }

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
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UpdateProfileScreen()),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Disable default back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeApp()),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(profile),
              CommonProfileWidget(profile: profile),
              if (profile.role == 'patient') PatientProfileWidget(profile: profile),
              if (profile.role == 'doctor') DoctorProfileWidget(profile: profile),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildProfileHeader(Profile profile) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // Profile Picture (Handles null case)
          CircleAvatar(
            radius: 40,
            backgroundImage: profile.profileImageUrl != null
                ? NetworkImage(profile.profileImageUrl!)
                : null,
            child: profile.profileImageUrl == null
                ? const Icon(Icons.person, size: 40, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),

          // Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${StringUtils.getCapitalisedUsername(profile.username)}!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                StringUtils.getCapitalisedUsername(profile.role),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.logout();

          // Navigate to the LoadingScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoadingScreen(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          backgroundColor: Colors.red.shade100,
          foregroundColor: Colors.red.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        icon: const Icon(Icons.logout),
        label: const Text(
          'Logout',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}