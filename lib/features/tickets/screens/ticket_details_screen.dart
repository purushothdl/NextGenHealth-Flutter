// lib/features/tickets/screens/ticket_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../chat/screens/chat_screen.dart';
import '../../report/screens/report_details_screen.dart';
import '../../report/screens/report_upload_screen.dart';
import '../models/ticket_model.dart';
import '../widgets/ticket_details/details_section.dart';
import '../widgets/ticket_details/health_metrics_section.dart';
import '../widgets/ticket_details/image_section.dart';
import '../widgets/ticket_details/pdf_section.dart';
import '../widgets/ticket_details/user_details_section.dart';
import 'analyse_ticket_screen.dart';
import '../../../core/services/api/admin_api_service.dart';


class TicketDetailsScreen extends StatelessWidget {
  final TicketResponse ticket;
  final Map<String, dynamic> patientDetails;
  final Map<String, dynamic>? doctorDetails;
  final bool isDoctor;
  final bool isAdmin; // Add this parameter

  const TicketDetailsScreen({
    Key? key,
    required this.ticket,
    required this.patientDetails,
    this.doctorDetails,
    required this.isDoctor,
    required this.isAdmin, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ticket Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailSection(title: 'Title', value: ticket.title),
            const SizedBox(height: 16),
            DetailSection(title: 'Description', value: ticket.description),
            const SizedBox(height: 16),
            if (ticket.symptoms != null && ticket.symptoms!.isNotEmpty)
              DetailSection(title: 'Symptoms', value: ticket.symptoms!),
            const SizedBox(height: 16),
            if (ticket.bp != null || ticket.sugarLevel != null || ticket.weight != null)
              HealthMetricsSection(ticket: ticket),
            const SizedBox(height: 16),
            if (ticket.imagePath != null)
              ImageSection(title: 'Image Attachment', fileUrl: ticket.imagePath!),
            const SizedBox(height: 16),
            if (ticket.documentPath != null)
              PdfSection(title: 'PDF Attachment', fileUrl: ticket.documentPath!),
            const SizedBox(height: 16),
            UserDetailsSection(
              title: 'Patient Details',
              details: patientDetails,
              isPatient: true,
            ),
            const SizedBox(height: 16),
            if (doctorDetails != null)
              UserDetailsSection(
                title: 'Assigned Doctor',
                details: doctorDetails!,
                isPatient: false,
              ),
            const SizedBox(height: 16),
            if (isDoctor)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(ticketId: ticket.id),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Analyse Ticket',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (isDoctor)
              Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportUploadScreen(ticket: ticket),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Upload Report',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            if (!isDoctor)
              Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailsScreen(ticketId: ticket.id),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'View Report',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            // Only show "Assign to Doctor" button if the user is an admin
            if (isAdmin)
              Column(
                children: [
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _assignTicketToDoctor(context, ticket.id),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Assign to Doctor',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _assignTicketToDoctor(BuildContext context, String ticketId) async {
    final adminApiService = AdminApiService();
    final doctors = await adminApiService.getDoctors();

    final selectedDoctor = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assign to Doctor'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return ListTile(
                  title: Text(doctor['username']),
                  subtitle: Text(doctor['email']),
                  onTap: () {
                    Navigator.pop(context, doctor);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedDoctor != null) {
      try {
        await adminApiService.assignTicketToDoctor(ticketId, selectedDoctor['_id']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket assigned successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to assign ticket: $e')),
        );
      }
    }
  }
}