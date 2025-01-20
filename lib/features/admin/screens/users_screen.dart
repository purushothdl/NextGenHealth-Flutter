// lib/features/admin/screens/users_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../admin/providers/admin_provider.dart';
import 'user_details_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure data is loaded when the screen is built
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    adminProvider.loadDoctors();
    adminProvider.loadPatients();

    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Patients'),
              Tab(text: 'Doctors'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PatientsTab(), // Patients tab content
            DoctorsTab(), // Doctors tab content
          ],
        ),
      ),
    );
  }
}

class PatientsTab extends StatelessWidget {
  const PatientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    Future<void> refreshData() async {
      await adminProvider.loadPatients(forceReload: true); // Force reload patients
    }

    return RefreshIndicator(
      onRefresh: refreshData, // Trigger refresh
      child: _buildPatientsList(adminProvider),
    );
  }

  Widget _buildPatientsList(AdminProvider adminProvider) {

    if (adminProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (adminProvider.error != null) {
      return Center(child: Text('Error: ${adminProvider.error}'));
    } else if (adminProvider.patients.isEmpty) {
      return const Center(child: Text('No patients found.'));
    }

    return ListView.builder(
      itemCount: adminProvider.patients.length,
      itemBuilder: (context, index) {
        final patient = adminProvider.patients[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: Text(
              patient['username'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(patient['email']),
            onTap: () {
              // Navigate to UserDetailsScreen for the selected patient
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(userId: patient['_id']),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class DoctorsTab extends StatelessWidget {
  const DoctorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    Future<void> refreshData() async {
      await adminProvider.loadDoctors(forceReload: true); // Force reload doctors
    }

    return RefreshIndicator(
      onRefresh: refreshData, // Trigger refresh
      child: _buildDoctorsList(adminProvider),
    );
  }

  Widget _buildDoctorsList(AdminProvider adminProvider) {

    if (adminProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (adminProvider.error != null) {
      return Center(child: Text('Error: ${adminProvider.error}'));
    } else if (adminProvider.doctors.isEmpty) {
      return const Center(child: Text('No doctors found.'));
    }

    return ListView.builder(
      itemCount: adminProvider.doctors.length,
      itemBuilder: (context, index) {
        final doctor = adminProvider.doctors[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 2.0,
          child: ListTile(
            leading: const Icon(Icons.medical_services, color: Colors.green),
            title: Text(
              doctor['username'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(doctor['email']),
            onTap: () {
              // Navigate to UserDetailsScreen for the selected doctor
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetailsScreen(userId: doctor['_id']),
                ),
              );
            },
          ),
        );
      },
    );
  }
}