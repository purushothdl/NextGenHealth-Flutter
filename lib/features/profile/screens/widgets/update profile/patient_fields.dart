import 'package:flutter/material.dart';
import 'list_input_field.dart';
import 'fancy_text_field.dart';

class PatientFields extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final Function(String, dynamic) updateField;

  const PatientFields({
    super.key,
    required this.patientData,
    required this.updateField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListInputField(
          label: 'Medical History',
          items: patientData['medical_history'] ?? [],
          onChanged: (value) {
            updateField('patient_data.medical_history', value);
          },
        ),
        const SizedBox(height: 16),
        ListInputField(
          label: 'Medical Conditions',
          items: patientData['medical_conditions'] ?? [],
          onChanged: (value) {
            updateField('patient_data.medical_conditions', value);
          },
        ),
        const SizedBox(height: 16),
        ListInputField(
          label: 'Medications',
          items: patientData['medications'] ?? [],
          onChanged: (value) {
            updateField('patient_data.medications', value);
          },
        ),
        const SizedBox(height: 16),
        ListInputField(
          label: 'Allergies',
          items: patientData['allergies'] ?? [],
          onChanged: (value) {
            updateField('patient_data.allergies', value);
          },
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Physical Metrics'),
        const SizedBox(height: 8),
        FancyTextField(
          label: 'Age',
          value: patientData['age']?.toString().replaceAll(RegExp(r'\.0$'), '') ?? '',
          icon: Icons.cake,
          onChanged: (value) => updateField('patient_data.age', double.tryParse(value)),
          keyboardType: TextInputType.number,
          unit: 'years',
        ),
        const SizedBox(height: 20),
        FancyTextField(
          label: 'Height',
          value: patientData['height']?.toString().replaceAll(RegExp(r'\.0$'), '') ?? '',
          icon: Icons.height,
          onChanged: (value) => updateField('patient_data.height', double.tryParse(value)),
          keyboardType: TextInputType.number,
          unit: 'cm',
        ),
        const SizedBox(height: 20),
        FancyTextField(
          label: 'Weight',
          value: patientData['weight']?.toString().replaceAll(RegExp(r'\.0$'), '') ?? '',
          icon: Icons.monitor_weight,
          onChanged: (value) => updateField('patient_data.weight', double.tryParse(value)),
          keyboardType: TextInputType.number,
          unit: 'kg',
        ),
        const SizedBox(height: 20),
        FancyTextField(
          label: 'Blood Group',
          value: patientData['blood_group'] ?? '',
          icon: Icons.bloodtype,
          onChanged: (value) => updateField('patient_data.blood_group', value),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}