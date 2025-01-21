import 'package:flutter/material.dart';
import '../../profile/screens/widgets/update profile/list_input_field.dart';
import 'text_input_field.dart';

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
        ListInputField(
          label: 'Medical Conditions',
          items: medicalConditionsController.text.split(',').where((item) => item.isNotEmpty).toList(),
          onChanged: (items) {
            medicalConditionsController.text = items.join(',');
          },
        ),
        ListInputField(
          label: 'Medical History',
          items: medicalHistoryController.text.split(',').where((item) => item.isNotEmpty).toList(),
          onChanged: (items) {
            medicalHistoryController.text = items.join(',');
          },
        ),
        ListInputField(
          label: 'Medications',
          items: medicationsController.text.split(',').where((item) => item.isNotEmpty).toList(),
          onChanged: (items) {
            medicationsController.text = items.join(',');
          },
        ),
        ListInputField(
          label: 'Allergies',
          items: allergiesController.text.split(',').where((item) => item.isNotEmpty).toList(),
          onChanged: (items) {
            allergiesController.text = items.join(',');
          },
        ),
        const SizedBox(height: 16),
        TextInputField(
          controller: ageController,
          labelText: 'Age',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your age';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextInputField(
          controller: heightController,
          labelText: 'Height (in cm)',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your height';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextInputField(
          controller: weightController,
          labelText: 'Weight (in kg)',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your weight';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextInputField(
          controller: bloodGroupController,
          labelText: 'Blood Group',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your blood group';
            }
            return null;
          },
        ),
      ],
    );
  }
}