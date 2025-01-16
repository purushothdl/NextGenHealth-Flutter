import 'package:flutter/material.dart';

class DoctorForm extends StatelessWidget {
  final TextEditingController specializationController;
  final TextEditingController yearsOfExperienceController;
  final TextEditingController qualificationController;
  final TextEditingController licenseNumberController;
  final TextEditingController certificationsController;
  final TextEditingController ageController;

  const DoctorForm({
    super.key,
    required this.specializationController,
    required this.yearsOfExperienceController,
    required this.qualificationController,
    required this.licenseNumberController,
    required this.certificationsController,
    required this.ageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: specializationController,
          decoration: const InputDecoration(labelText: 'Specialization'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: yearsOfExperienceController,
          decoration: const InputDecoration(labelText: 'Years of Experience'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: qualificationController,
          decoration: const InputDecoration(labelText: 'Qualification'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: licenseNumberController,
          decoration: const InputDecoration(labelText: 'License Number'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: certificationsController,
          decoration: const InputDecoration(labelText: 'Certifications'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ageController,
          decoration: const InputDecoration(labelText: 'Age'),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}