// lib/features/profile/widgets/patient/health_metrics_card.dart
import 'package:flutter/material.dart';
import 'metric_box.dart';

class HealthMetricsCard extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const HealthMetricsCard({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Metrics',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MetricBox(
                  icon: Icons.person_outline,
                  label: 'Age',
                  value: patientData['age'] ?? 'N/A',
                  unit: 'yrs',
                ),
                const SizedBox(width: 16),
                MetricBox(
                  icon: Icons.favorite_outline,
                  label: 'Weight',
                  value: patientData['weight'] ?? 'N/A',
                  unit: 'kg',
                ),
                const SizedBox(width: 16),
                MetricBox(
                  icon: Icons.water_drop_outlined,
                  label: 'Height',
                  value: patientData['height'] ?? 'N/A',
                  unit: 'cm',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}