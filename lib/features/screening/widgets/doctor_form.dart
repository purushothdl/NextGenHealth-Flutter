import 'package:flutter/material.dart';
import '../../profile/screens/widgets/update profile/list_input_field.dart';
import 'text_input_field.dart';

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
        ListInputField(
          label: 'Specialization',
          items: specializationController.text.split(',').where((item) => item.isNotEmpty).toList(),
          onChanged: (items) {
            specializationController.text = items.join(',');
          },
        ),

        const SizedBox(height: 16),
        ListInputField(
          label: 'Qualifications',
          items: qualificationController.text.split(',').where((item) => item.isNotEmpty).toList(),
          onChanged: (items) {
            qualificationController.text = items.join(',');
          },
        ),

        const SizedBox(height: 16),
        TextInputField(
          controller: certificationsController,
          labelText: 'Hospital',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the hospital name';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),
        TextInputField(
          controller: yearsOfExperienceController,
          labelText: 'Years of Experience',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter years of experience';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),
        TextInputField(
          controller: licenseNumberController,
          labelText: 'License Number',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter license number';
            }
            return null;
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
      ],
    );
  }
}