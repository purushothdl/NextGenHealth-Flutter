import 'package:flutter/material.dart';
import '../../tickets/models/ticket_model.dart';
import '../widgets/report_form_widget.dart';

class ReportUploadScreen extends StatelessWidget {
  final TicketResponse ticket;

  const ReportUploadScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket Details Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ticket.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Report Form
            ReportFormWidget(ticketId: ticket.id),
          ],
        ),
      ),
    );
  }
}