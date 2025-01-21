// lib/features/tickets/widgets/ticket_details/health_metrics_section.dart

import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';

class HealthMetricsSection extends StatelessWidget {
  final TicketResponse ticket;

  const HealthMetricsSection({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                const Icon(Icons.monitor_heart_outlined, 
                  color: Color(0xFF3BAEE9)),
                const SizedBox(width: 8),
                Text(
                  'Health Metrics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildMetricRow(
              icon: Icons.favorite_border_rounded,
              label: 'Blood Pressure',
              value: ticket.bp!,
              color: Colors.red[300]!,
            ),
            _buildMetricRow(
              icon: Icons.water_drop_outlined,
              label: 'Sugar Level',
              value: ticket.sugarLevel!,
              color: Colors.green[300]!,
            ),
            if (ticket.weight != null)
              _buildMetricRow(
                icon: Icons.line_weight_outlined,
                label: 'Weight',
                value: '${ticket.weight} kg',
                color: Colors.orange[300]!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
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
}