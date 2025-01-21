import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/utils/string_utils.dart';
import '../../tickets/models/ticket_model.dart';
import '../../tickets/widgets/ticket_details/details_section.dart';
import '../widgets/report_form_widget.dart';

class ReportUploadScreen extends StatelessWidget {
  final TicketResponse ticket;

  const ReportUploadScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Report', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket Details Section
            DetailSection(
              title: StringUtils.getCapitalisedUsername(ticket.title),
              value: ticket.description,
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