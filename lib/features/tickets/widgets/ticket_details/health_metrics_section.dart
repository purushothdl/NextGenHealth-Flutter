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
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            if (ticket.bp != null)
              _buildDetailRow('Blood Pressure', ticket.bp!),
            if (ticket.sugarLevel != null)
              _buildDetailRow('Sugar Level', ticket.sugarLevel!),
            if (ticket.weight != null)
              _buildDetailRow('Weight', '${ticket.weight} kg'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}