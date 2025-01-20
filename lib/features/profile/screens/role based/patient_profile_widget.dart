// lib/features/profile/screens/role_based/patient_profile_widget.dart
import 'package:flutter/material.dart';

import '../../models/profile_model.dart';
import '../widgets/patient/health_metrics_card.dart';
import '../widgets/patient/patient_details_card.dart';

class PatientProfileWidget extends StatelessWidget {
  final Profile profile;

  const PatientProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final patientData = profile.patientData ?? {};

    return Column(
      children: [
        // Health Metrics Card
        HealthMetricsCard(patientData: patientData),

        // Patient Details Card
        PatientDetailsCard(patientData: patientData),
      ],
    );
  }
}