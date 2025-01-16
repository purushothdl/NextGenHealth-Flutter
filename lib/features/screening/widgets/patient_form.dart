import 'package:flutter/material.dart';

class PatientForm extends StatelessWidget {
  final TextEditingController medicalConditionsController;
  final TextEditingController medicalHistoryController;
  final TextEditingController medicationsController;
  final TextEditingController allergiesController;
  final TextEditingController ageController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController bloodGroupController;

  const PatientForm({
    super.key,
    required this.medicalConditionsController,
    required this.medicalHistoryController,
    required this.medicationsController,
    required this.allergiesController,
    required this.ageController,
    required this.heightController,
    required this.weightController,
    required this.bloodGroupController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: medicalConditionsController,
          decoration: const InputDecoration(labelText: 'Medical Conditions (comma-separated)'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: medicalHistoryController,
          decoration: const InputDecoration(labelText: 'Medical History (comma-separated)'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: medicationsController,
          decoration: const InputDecoration(labelText: 'Medications (comma-separated)'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: allergiesController,
          decoration: const InputDecoration(labelText: 'Allergies (comma-separated)'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ageController,
          decoration: const InputDecoration(labelText: 'Age'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: heightController,
          decoration: const InputDecoration(labelText: 'Height (in cm)'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: weightController,
          decoration: const InputDecoration(labelText: 'Weight (in kg)'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: bloodGroupController,
          decoration: const InputDecoration(labelText: 'Blood Group'),
        ),
      ],
    );
  }
}