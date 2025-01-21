// lib/features/profile/screens/role_based/doctor_profile_widget.dart
import 'package:flutter/material.dart';
import '../../models/profile_model.dart';
import '../widgets/profile/shared/detail_section.dart';
import '../widgets/profile/patient/section_item.dart'; // Reuse SectionItem for list items

class DoctorProfileWidget extends StatelessWidget {
  final Profile profile;

  const DoctorProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final doctorData = profile.doctorData ?? {};

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
              'Doctor Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            if (doctorData['specialization'] != null)
              SectionItem(
                icon: Icons.medical_services,
                title: 'Specialization',
                items: doctorData['specialization'],
              ),
            if (doctorData['qualifications'] != null)
              SectionItem(
                icon: Icons.school,
                title: 'Qualifications',
                items: doctorData['qualifications'],
              ),
            if (doctorData['age'] != null)
              DetailSection(
                icon: Icons.cake,
                title: 'Age',
                content: '${doctorData['age'].toInt()} years', // Convert float to int
              ),
            if (doctorData['hospital'] != null)
              DetailSection(
                icon: Icons.local_hospital,
                title: 'Hospital',
                content: doctorData['hospital'],
              ),
            if (doctorData['experience_years'] != null)
              DetailSection(
                icon: Icons.work_history,
                title: 'Experience',
                content: '${doctorData['experience_years']} years',
              ),
            if (doctorData['license_number'] != null)
              DetailSection(
                icon: Icons.assignment,
                title: 'License Number',
                content: doctorData['license_number'],
              ),
          ],
        ),
      ),
    );
  }
}