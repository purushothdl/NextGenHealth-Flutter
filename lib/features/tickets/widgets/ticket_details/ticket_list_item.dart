import 'package:flutter/material.dart';
import '../../models/ticket_model.dart';

class TicketListItem extends StatelessWidget {
  final TicketResponse ticket;
  final VoidCallback onTap;

  const TicketListItem({super.key, required this.ticket, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(ticket.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.description),
            const SizedBox(height: 8),
            Row(
              children: [
                if (ticket.bp != null) Text('BP: ${ticket.bp}'),
                const SizedBox(width: 16),
                if (ticket.sugarLevel != null) Text('Sugar: ${ticket.sugarLevel}'),
                const SizedBox(width: 16),
                if (ticket.weight != null) Text('Weight: ${ticket.weight} kg'),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}