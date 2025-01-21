import 'package:flutter/material.dart';
import 'list_input_field.dart';
import 'fancy_text_field.dart';

class DoctorFields extends StatelessWidget {
  final Map<String, dynamic> doctorData;
  final Function(String, dynamic) updateField;

  const DoctorFields({
    super.key,
    required this.doctorData,
    required this.updateField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FancyTextField(
          label: 'Age',
          value: doctorData['age']?.toString() ?? '',
          icon: Icons.cake,
          onChanged: (value) => updateField('doctor_data.age', double.tryParse(value)),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        FancyTextField(
          label: 'Experience Years',
          value: doctorData['experience_years']?.toString() ?? '',
          icon: Icons.work_history,
          onChanged: (value) => updateField('doctor_data.experience_years', int.tryParse(value)),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        FancyTextField(
          label: 'Hospital',
          value: doctorData['hospital'] ?? '',
          icon: Icons.local_hospital,
          onChanged: (value) => updateField('doctor_data.hospital', value),
        ),
        const SizedBox(height: 16),
        FancyTextField(
          label: 'License Number',
          value: doctorData['license_number'] ?? '',
          icon: Icons.assignment,
          onChanged: (value) => updateField('doctor_data.license_number', value),
        ),
        const SizedBox(height: 16),
        ListInputField(
          label: 'Qualifications',
          items: doctorData['qualifications'] ?? [],
          onChanged: (value) {
            updateField('doctor_data.qualifications', value);
          },
        ),
        const SizedBox(height: 16),
        ListInputField(
          label: 'Specialization',
          items: doctorData['specialization'] ?? [],
          onChanged: (value) {
            updateField('doctor_data.specialization', value);
          },
        ),
      ],
    );
  }
}