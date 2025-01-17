import 'package:flutter/material.dart';

import '../models/profile_model.dart';

class PatientProfileWidget extends StatelessWidget {
  final Profile profile;

  const PatientProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final patientData = profile.patientData ?? {};

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (patientData['medical_conditions'] != null)
              _buildDetailSection('Medical Conditions', patientData['medical_conditions'].join(', ')),
            if (patientData['medications'] != null)
              _buildDetailSection('Medications', patientData['medications'].join(', ')),
            if (patientData['allergies'] != null)
              _buildDetailSection('Allergies', patientData['allergies'].join(', ')),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
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
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}