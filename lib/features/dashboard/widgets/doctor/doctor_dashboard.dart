import 'package:flutter/material.dart';

class DoctorDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const DoctorDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final doctorData = user['doctor_data'] ?? {};

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Text(
              'Welcome Dr. ${user['username']}!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Doctor Details Card
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Specialization
                    if (doctorData['specialization'] != null)
                      _buildDetailSection(
                        title: 'Specialization',
                        content: doctorData['specialization'].join(', '),
                      ),

                    // Qualifications
                    if (doctorData['qualifications'] != null)
                      _buildDetailSection(
                        title: 'Qualifications',
                        content: doctorData['qualifications'].join(', '),
                      ),

                    // Experience
                    if (doctorData['experience_years'] != null)
                      _buildDetailSection(
                        title: 'Experience',
                        content: '${doctorData['experience_years']} years',
                      ),

                    // License Number
                    if (doctorData['license_number'] != null)
                      _buildDetailSection(
                        title: 'License Number',
                        content: doctorData['license_number'],
                      ),

                    // Hospital/Clinic
                    if (doctorData['hospital'] != null)
                      _buildDetailSection(
                        title: 'Hospital/Clinic',
                        content: doctorData['hospital'],
                      ),

                    // Age
                    if (doctorData['age'] != null)
                      _buildDetailSection(
                        title: 'Age',
                        content: '${doctorData['age']} years',
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Doctor Features Section
            const Text(
              'Doctor Features:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('- View Appointments'),
            _buildFeatureItem('- Manage Patients'),
            _buildFeatureItem('- Update Availability'),
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail section
  Widget _buildDetailSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 20, thickness: 1),
        ],
      ),
    );
  }

  // Helper method to build a feature item
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}