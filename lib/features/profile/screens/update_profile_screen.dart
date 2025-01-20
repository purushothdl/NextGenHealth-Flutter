// lib/features/profile/screens/update_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/profile_model.dart';

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
      // Handle nested patient_data fields
      final patientDataKey = key.replaceFirst('patient_data.', '');
      _updatedFields['patient_data'] ??= {}; // Initialize patient_data if it doesn't exist
      _updatedFields['patient_data'][patientDataKey] = value;
    } else if (key.startsWith('doctor_data.')) {
      // Handle nested doctor_data fields
      final doctorDataKey = key.replaceFirst('doctor_data.', '');
      _updatedFields['doctor_data'] ??= {}; // Initialize doctor_data if it doesn't exist
      _updatedFields['doctor_data'][doctorDataKey] = value;
    } else {
      // Handle top-level fields (e.g., username, email)
      _updatedFields[key] = value;
    }
  });
}


Future<void> _saveProfile() async {
  if (_formKey.currentState!.validate()) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Ensure only updated fields are sent
    final payload = _updatedFields;

    final success = await authProvider.updateProfile(payload);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context); // Return to the previous screen
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
        title: const Text('Update Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Common Fields
              _buildTextField('Username', _profile.username, (value) {
                _updateField('username', value);
              }),
              _buildTextField('Email', _profile.email, (value) {
                _updateField('email', value);
              }),

              // Role-Specific Fields
              if (_profile.role == 'patient') ..._buildPatientFields(),
              if (_profile.role == 'doctor') ..._buildDoctorFields(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, Function(String) onChanged) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

List<Widget> _buildPatientFields() {
  final patientData = _profile.patientData ?? {};
  return [
    _buildTextField('Medical Conditions', patientData['medical_conditions']?.join(', ') ?? '', (value) {
      _updateField('patient_data.medical_conditions', value.split(', '));
    }),
    _buildTextField('Medical History', patientData['medical_history']?.join(', ') ?? '', (value) {
      _updateField('patient_data.medical_history', value.split(', '));
    }),
    _buildTextField('Medications', patientData['medications']?.join(', ') ?? '', (value) {
      _updateField('patient_data.medications', value.split(', '));
    }),
    _buildTextField('Allergies', patientData['allergies']?.join(', ') ?? '', (value) {
      _updateField('patient_data.allergies', value.split(', '));
    }),
    _buildTextField('Age', patientData['age']?.toString() ?? '', (value) {
      _updateField('patient_data.age', double.tryParse(value));
    }),
    _buildTextField('Height', patientData['height']?.toString() ?? '', (value) {
      _updateField('patient_data.height', double.tryParse(value));
    }),
    _buildTextField('Weight', patientData['weight']?.toString() ?? '', (value) {
      _updateField('patient_data.weight', double.tryParse(value));
    }),
    _buildTextField('Blood Group', patientData['blood_group'] ?? '', (value) {
      _updateField('patient_data.blood_group', value);
    }),
  ];
}

  List<Widget> _buildDoctorFields() {
    final doctorData = _profile.doctorData ?? {};
    return [
      _buildTextField('Age', doctorData['age']?.toString() ?? '', (value) {
        _updateField('doctor_data.age', int.tryParse(value));
      }),
      _buildTextField('Experience Years', doctorData['experience_years']?.toString() ?? '', (value) {
        _updateField('doctor_data.experience_years', int.tryParse(value));
      }),
      _buildTextField('Hospital', doctorData['hospital'] ?? '', (value) {
        _updateField('doctor_data.hospital', value);
      }),
      _buildTextField('License Number', doctorData['license_number'] ?? '', (value) {
        _updateField('doctor_data.license_number', value);
      }),
      _buildTextField('Qualifications', doctorData['qualifications']?.join(', ') ?? '', (value) {
        _updateField('doctor_data.qualifications', value.split(', '));
      }),
      _buildTextField('Specialization', doctorData['specialization']?.join(', ') ?? '', (value) {
        _updateField('doctor_data.specialization', value.split(', '));
      }),
    ];
  }
}