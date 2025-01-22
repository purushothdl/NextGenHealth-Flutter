// lib/features/admin/screens/users_screen.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';
import 'package:provider/provider.dart';
import '../../admin/providers/admin_provider.dart';
import 'user_details_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String selectedTab = 'patients'; // Track the selected tab

  @override
  void initState() {
    super.initState();
    // Load data when the screen is first opened
    Future.microtask(() => _loadData());
  }

  Future<void> _loadData() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    await adminProvider.loadPatients();
    await adminProvider.loadDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16), // Gap between AppBar and TabBar
          // Custom TabBar with toggle button style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // Light grey background
                borderRadius: BorderRadius.circular(25), // Circular rectangle shape
                border: Border.all(
                  color: const Color(0xFFE0E0E0), // Light border
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _buildTabButton('Patients', 'patients'),
                  ),
                  Flexible(
                    child: _buildTabButton('Doctors', 'doctors'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16), // Gap between TabBar and content
          // Content based on selected tab
          Expanded(
            child: Consumer<AdminProvider>(
              builder: (context, adminProvider, child) {
                if (adminProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Force refresh data when pulled
                    if (selectedTab == 'patients') {
                      await adminProvider.loadPatients(forceReload: true);
                    } else {
                      await adminProvider.loadDoctors(forceReload: true);
                    }
                  },
                  child: selectedTab == 'patients'
                      ? _buildPatientsList(adminProvider)
                      : _buildDoctorsList(adminProvider),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String tab) {
    bool isSelected = selectedTab == tab;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20), // Circular rectangle shape
          border: isSelected
              ? Border.all(color: const Color(0xFFE0E0E0), width: 1.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildPatientsList(AdminProvider adminProvider) {
    if (adminProvider.error != null) {
      return Center(child: Text('Error: ${adminProvider.error}'));
    }

    if (adminProvider.patients.isEmpty) {
      return const Center(
        child: Text(
          'No patients found.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: adminProvider.patients.length,
      itemBuilder: (context, index) {
        final patient = adminProvider.patients[index];
        return _buildUserCard(
          context,
          patient,
          icon: Icons.person_rounded,
          color: Colors.orange.shade600,
        );
      },
    );
  }

  Widget _buildDoctorsList(AdminProvider adminProvider) {
    if (adminProvider.error != null) {
      return Center(child: Text('Error: ${adminProvider.error}'));
    }

    if (adminProvider.doctors.isEmpty) {
      return const Center(
        child: Text(
          'No doctors found.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: adminProvider.doctors.length,
      itemBuilder: (context, index) {
        final doctor = adminProvider.doctors[index];
        return _buildUserCard(
          context,
          doctor,
          icon: Icons.medical_services_rounded,
          color: Colors.blue.shade600,
        );
      },
    );
  }

  Widget _buildUserCard(
    BuildContext context,
    Map<String, dynamic> user, {
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
        
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailsScreen(userId: user['_id']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringUtils.getCapitalisedUsername(user['username']),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user['email'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}