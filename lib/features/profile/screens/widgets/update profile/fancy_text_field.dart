import 'package:flutter/material.dart';

class FancyTextField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Function(String) onChanged;
  final TextInputType? keyboardType;
  final String? unit;

  const FancyTextField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onChanged,
    this.keyboardType,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label above the field
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.blue[600],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12,
            ),
          ),
        ),
        // Input field
        Container(
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
            keyboardType: keyboardType,
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            decoration: InputDecoration(
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
              suffixText: unit,
              suffixStyle: TextStyle(
                color: Colors.blue[400],
                fontWeight: FontWeight.bold,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
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
            ),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter $label';
              if (keyboardType == TextInputType.number && double.tryParse(value) == null) {
                return 'Invalid number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}