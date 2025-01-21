// lib/features/profile/widgets/update_profile/common_fields.dart
import 'package:flutter/material.dart';
import '../../../models/profile_model.dart';

class CommonFields extends StatelessWidget {
  final Profile profile;
  final Function(String, dynamic) updateField;

  const CommonFields({
    super.key,
    required this.profile,
    required this.updateField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFancyTextField(
          context: context,
          label: 'Username',
          value: profile.username,
          icon: Icons.person,
          onChanged: (value) => updateField('username', value),
        ),
        const SizedBox(height: 20),
        _buildFancyTextField(
          context: context,
          label: 'Email',
          value: profile.email,
          icon: Icons.email,
          onChanged: (value) => updateField('email', value),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFancyTextField({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: value,
        style: TextStyle(
          color: Colors.blue[900],
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label.toUpperCase(),
          labelStyle: TextStyle(
            color: Colors.blue[600],
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
            ),
            child: Icon(icon, color: Colors.blue[700], size: 24),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.blue[400]!,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: Icon(
            Icons.edit_note,
            color: Colors.blue[300],
            size: 28,
          ),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (label == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }
}