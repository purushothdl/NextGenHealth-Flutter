import 'package:flutter/material.dart';

import 'tickets/raise_ticket_widget.dart'; // Import the ticket widget

class PatientDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const PatientDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final patientData = user['patient_data'] ?? {};

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message
              Text(
                'Welcome ${user['username']}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Raise Ticket Widget
              const RaiseTicketWidget(), // Add the new ticket widget
              const SizedBox(height: 16),

              // Patient Details Card
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Medical Conditions
                      if (patientData['medical_conditions'] != null)
                        _buildDetailSection(
                          title: 'Medical Conditions',
                          content: patientData['medical_conditions'].join(', '),
                        ),

                      // Medical History
                      if (patientData['medical_history'] != null)
                        _buildDetailSection(
                          title: 'Medical History',
                          content: patientData['medical_history'].join(', '),
                        ),

                      // Medications
                      if (patientData['medications'] != null)
                        _buildDetailSection(
                          title: 'Medications',
                          content: patientData['medications'].join(', '),
                        ),

                      // Allergies
                      if (patientData['allergies'] != null)
                        _buildDetailSection(
                          title: 'Allergies',
                          content: patientData['allergies'].join(', '),
                        ),

                      // Age
                      if (patientData['age'] != null)
                        _buildDetailSection(
                          title: 'Age',
                          content: '${patientData['age']} years',
                        ),

                      // Height
                      if (patientData['height'] != null)
                        _buildDetailSection(
                          title: 'Height',
                          content: '${patientData['height']} cm',
                        ),

                      // Weight
                      if (patientData['weight'] != null)
                        _buildDetailSection(
                          title: 'Weight',
                          content: '${patientData['weight']} kg',
                        ),

                      // Blood Group
                      if (patientData['blood_group'] != null)
                        _buildDetailSection(
                          title: 'Blood Group',
                          content: patientData['blood_group'],
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Patient Features Section
              const Text(
                'Patient Features:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('- Book Appointments'),
              _buildFeatureItem('- View Health Records'),
              _buildFeatureItem('- Track Medications'),
              _buildFeatureItem('- Manage Allergies'),
            ],
          ),
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