import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../widgets/doctor_form.dart';
import '../widgets/patient_form.dart';


class ScreeningFormScreen extends StatefulWidget {
  const ScreeningFormScreen({super.key});

  @override
  State<ScreeningFormScreen> createState() => _ScreeningFormScreenState();
}

class _ScreeningFormScreenState extends State<ScreeningFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for Patient Form
  final _medicalHistoryController = TextEditingController();
  final _medicalConditionsController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodGroupController = TextEditingController();

  // Controllers for Doctor Form
  final _specializationController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _doctorAgeController = TextEditingController();

  @override
  void dispose() {
    _medicalHistoryController.dispose();
    _medicalConditionsController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _bloodGroupController.dispose();
    _specializationController.dispose();
    _yearsOfExperienceController.dispose();
    _qualificationController.dispose();
    _licenseNumberController.dispose();
    _certificationsController.dispose();
    _doctorAgeController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context, bool isPatient) async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (isPatient) {
        final updatedData = {
          "patient_data": {
            "medical_history": _medicalHistoryController.text.split(','),
            "medical_conditions": _medicalConditionsController.text.split(','),
            "medications": _medicationsController.text.split(','),
            "allergies": _allergiesController.text.split(','),
            "age": double.tryParse(_ageController.text),
            "height": double.tryParse(_heightController.text),
            "weight": double.tryParse(_weightController.text),
            "blood_group": _bloodGroupController.text,
          },
        };

        final success = await authProvider.updateProfile(updatedData);

        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const DashboardScreen(),
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Failed to update profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        final updatedData = {
          "doctor_data": {
            "qualifications": _qualificationController.text.split(','),
            "specialization": _specializationController.text.split(','),
            "experience_years": int.tryParse(_yearsOfExperienceController.text),
            "license_number": _licenseNumberController.text,
            "hospital": _certificationsController.text,
            "age": int.tryParse(_doctorAgeController.text),
          },
        };

        final success = await authProvider.updateProfile(updatedData);

        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const DashboardScreen(),
            ),
          );
        } else if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.error ?? 'Failed to update profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isPatient = authProvider.currentUser?['role'] == 'patient';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPatient ? 'Patient History' : 'Doctor Details', 
          style: const 
            TextStyle(
              fontWeight: FontWeight.bold),
            ),  
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (isPatient)
                PatientForm(
                  medicalConditionsController: _medicalConditionsController,
                  medicalHistoryController: _medicalHistoryController,
                  medicationsController: _medicationsController,
                  allergiesController: _allergiesController,
                  ageController: _ageController,
                  heightController: _heightController,
                  weightController: _weightController,
                  bloodGroupController: _bloodGroupController,
                )
              else
                DoctorForm(
                  specializationController: _specializationController,
                  yearsOfExperienceController: _yearsOfExperienceController,
                  qualificationController: _qualificationController,
                  licenseNumberController: _licenseNumberController,
                  certificationsController: _certificationsController,
                  ageController: _doctorAgeController,
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _submitForm(context, isPatient),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}