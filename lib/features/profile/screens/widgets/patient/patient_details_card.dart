// lib/features/profile/widgets/patient/patient_details_card.dart
import 'package:flutter/material.dart';
import 'section_item.dart';

class PatientDetailsCard extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientDetailsCard({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
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
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Medical Conditions
            if (patientData['medical_conditions'] != null)
              SectionItem(
                icon: Icons.medical_services,
                title: 'Medical Conditions',
                items: patientData['medical_conditions'],
              ),

            // Medications
            if (patientData['medications'] != null)
              SectionItem(
                icon: Icons.medication,
                title: 'Medications',
                items: patientData['medications'],
              ),

            // Allergies
            if (patientData['allergies'] != null)
              SectionItem(
                icon: Icons.warning,
                title: 'Allergies',
                items: patientData['allergies'],
              ),
          ],
        ),
      ),
    );
  }
}