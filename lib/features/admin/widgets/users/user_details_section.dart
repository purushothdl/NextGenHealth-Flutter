// lib/features/admin/widgets/user_details_section.dart
import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';

class UserDetailsSection extends StatelessWidget {
  final String title;
  final Map<String, dynamic> details;
  final bool isPatient;

  const UserDetailsSection({
    Key? key,
    required this.title,
    required this.details,
    required this.isPatient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final patientData = details['patient_data'] as Map<String, dynamic>? ?? {};
    final doctorData = details['doctor_data'] as Map<String, dynamic>? ?? {};

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isPatient ? Icons.health_and_safety_rounded : Icons.medical_services_rounded,
                  color: const Color(0xFF3BAEE9),
                ),
                const SizedBox(width: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF3BAEE9), Color(0xFF6AC8F5)],
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.person_outline_rounded, 'Name', StringUtils.getCapitalisedUsername(details['username'] ?? 'Unknown User')),
            _buildDetailRow(Icons.email_outlined, 'Email', details['email'] ?? 'No email provided'),
            if (isPatient) _buildPatientMetrics(patientData),
            if (!isPatient)
              _buildDetailRow(Icons.work_outline_rounded, 'Experience', 
                  '${doctorData['experience_years'] ?? 'N/A'} years'),
            if (!isPatient)
              _buildDetailRow(Icons.local_hospital_outlined, 'Hospital', 
                  doctorData['hospital'] ?? 'N/A'),
            const SizedBox(height: 16),
            if (isPatient) _buildPatientLists(patientData),
            if (!isPatient) _buildDoctorLists(doctorData),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientMetrics(Map<String, dynamic> patientData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            _buildMetricItem(
              icon: Icons.cake_outlined,
              value: '${patientData['age'] ?? 'N/A'} yrs',
              label: 'Age',
              color: Colors.blue.shade600,
            ),
            const SizedBox(width: 12),
            _buildMetricItem(
              icon: Icons.height,
              value: '${patientData['height'] ?? 'N/A'} cm',
              label: 'Height',
              color: Colors.green.shade600,
            ),
            const SizedBox(width: 12),
            _buildMetricItem(
              icon: Icons.monitor_weight,
              value: '${patientData['weight'] ?? 'N/A'} kg',
              label: 'Weight',
              color: Colors.orange.shade600,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientLists(Map<String, dynamic> patientData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListSection(
          icon: Icons.list_alt_rounded,
          title: 'Medical Conditions',
          items: patientData['medical_conditions'] as List<dynamic>? ?? [],
        ),
        _buildListSection(
          icon: Icons.history_rounded,
          title: 'Medical History',
          items: patientData['medical_history'] as List<dynamic>? ?? [],
        ),
        _buildListSection(
          icon: Icons.medication_rounded,
          title: 'Medications',
          items: patientData['medications'] as List<dynamic>? ?? [],
        ),
        _buildListSection(
          icon: Icons.warning_rounded,
          title: 'Allergies',
          items: patientData['allergies'] as List<dynamic>? ?? [],
        ),
      ],
    );
  }

  Widget _buildDoctorLists(Map<String, dynamic> doctorData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListSection(
          icon: Icons.school_rounded,
          title: 'Qualifications',
          items: doctorData['qualifications'] as List<dynamic>? ?? [],
        ),
        _buildListSection(
          icon: Icons.psychology_rounded,
          title: 'Specialization',
          items: doctorData['specialization'] as List<dynamic>? ?? [],
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey[400], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blueGrey[500],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blueGrey[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection({
    required IconData icon,
    required String title,
    required List<dynamic> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.blue[600]),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue[800],
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        Column(
          children: items.map((item) {
            return AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.circle,
                        color: Colors.blue[600],
                        size: 12,
                      ),
                    ),
                    title: Text(
                      item.toString(),
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}