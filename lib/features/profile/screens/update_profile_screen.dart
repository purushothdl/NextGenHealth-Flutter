// lib/features/profile/screens/update_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/profile_model.dart';
import 'widgets/update profile/common_field.dart';
import 'widgets/update profile/doctor_fields.dart';
import 'widgets/update profile/patient_fields.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late Profile _profile;
  late Map<String, dynamic> _updatedFields;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _profile = Profile.fromJson(authProvider.currentUser!);
    _updatedFields = {};
    _isLoading = false;
  }

  void _updateField(String key, dynamic value) {
    setState(() {
      if (key.startsWith('patient_data.')) {
        _updatedFields['patient_data'] ??= {};
        _updatedFields['patient_data'][key.replaceFirst('patient_data.', '')] = value;
      } else if (key.startsWith('doctor_data.')) {
        _updatedFields['doctor_data'] ??= {};
        _updatedFields['doctor_data'][key.replaceFirst('doctor_data.', '')] = value;
      } else {
        _updatedFields[key] = value;
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.updateProfile(_updatedFields);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${authProvider.error}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Common Fields
              CommonFields(
                profile: _profile,
                updateField: _updateField,
              ),

              // Role-Specific Fields
              if (_profile.role == 'patient')
                PatientFields(
                  patientData: _profile.patientData ?? {},
                  updateField: _updateField,
                ),
              if (_profile.role == 'doctor')
                DoctorFields(
                  doctorData: _profile.doctorData ?? {},
                  updateField: _updateField,
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveProfile,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}