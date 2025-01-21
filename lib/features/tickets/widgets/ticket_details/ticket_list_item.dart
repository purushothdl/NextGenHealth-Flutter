// lib/features/tickets/widgets/ticket_details/ticket_list_item.dart

import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';
import '../../models/ticket_model.dart';

class TicketListItem extends StatelessWidget {
  final TicketResponse ticket;
  final VoidCallback onTap;

  const TicketListItem({super.key, required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(ticket.status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Stack(
          children: [
            // ID Badge
            Positioned(
              left: 10,
              top: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fingerprint,
                      size: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '#${ticket.id}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(12, 50, 12, 12), // Adjusted top padding
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: statusColor, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // Title (positioned below the ID badge level)
                  Text(
                    StringUtils.getCapitalisedUsername(ticket.title),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Description
                  if (ticket.description.isNotEmpty)
                    Text(
                      ticket.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 10),

                  // Health Metrics
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      if (ticket.bp != null)
                        _buildMetricChip(
                          icon: Icons.monitor_heart_outlined,
                          value: ticket.bp!,
                          color: Colors.red.shade400,
                        ),
                      if (ticket.sugarLevel != null)
                        _buildMetricChip(
                          icon: Icons.bloodtype_outlined,
                          value: ticket.sugarLevel!,
                          color: Colors.orange.shade400,
                        ),
                      if (ticket.weight != null)
                        _buildMetricChip(
                          icon: Icons.line_weight_outlined,
                          value: '${ticket.weight}kg',
                          color: Colors.blue.shade400,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange.shade400;
      case 'pending':
        return Colors.blue.shade400;
      case 'closed':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}