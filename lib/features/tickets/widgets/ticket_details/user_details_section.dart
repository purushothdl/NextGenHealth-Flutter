import 'package:flutter/material.dart';

class UserDetailsSection extends StatelessWidget {
  final String title;
  final Map<String, dynamic> details;
  final bool isPatient;

  const UserDetailsSection({
    Key? key,
    required this.title,
    required this.details,
    required this.isPatient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Name', details['username']),
            _buildDetailRow('Email', details['email']),
            if (isPatient)
              _buildDetailRow('Age', '${details['patient_data']['age'] ?? 'N/A'} years'),
            if (!isPatient)
              _buildDetailRow('Experience', '${details['doctor_data']['experience_years'] ?? 'N/A'} years'),
            if (isPatient)
              _buildDetailRow('Blood Group', details['patient_data']['blood_group'] ?? 'N/A'),
            if (!isPatient)
              _buildDetailRow('Hospital', details['doctor_data']['hospital'] ?? 'N/A'),
            const SizedBox(height: 8),
            _buildListSection(
              isPatient ? 'Medical Conditions' : 'Qualifications',
              isPatient
                  ? details['patient_data']['medical_conditions'] ?? []
                  : details['doctor_data']['qualifications'] ?? [],
            ),
            _buildListSection(
              isPatient ? 'Medical History' : 'Specialization',
              isPatient
                  ? details['patient_data']['medical_history'] ?? []
                  : details['doctor_data']['specialization'] ?? [],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return const SizedBox.shrink(); // Hide if no items
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) {
            return Text(
              '- $item',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}