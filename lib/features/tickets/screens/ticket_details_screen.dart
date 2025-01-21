// lib/features/tickets/screens/ticket_details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../chat/screens/chat_screen.dart';
import '../../report/screens/report_details_screen.dart';
import '../../report/screens/report_upload_screen.dart';
import '../models/ticket_model.dart';
import '../widgets/ticket_details/assign_doctor_widget.dart';
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
  final bool isAdmin;

  const TicketDetailsScreen({
    Key? key,
    required this.ticket,
    required this.patientDetails,
    this.doctorDetails,
    required this.isDoctor,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ticket Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      if (isDoctor) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                context: context,
                                icon: Icons.medical_services_rounded,
                                label: 'Analyse Ticket',
                                color: const Color(0xFF3BAEE9),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreen(ticketId: ticket.id),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildActionButton(
                                context: context,
                                icon: Icons.upload_rounded,
                                label: 'Upload Report',
                                color: const Color(0xFF00BFA5),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReportUploadScreen(ticket: ticket),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (!isDoctor && !isAdmin)
                        _buildActionButton(
                          context: context,
                          icon: Icons.description_rounded,
                          label: 'View Report',
                          color: const Color(0xFF3BAEE9),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReportDetailsScreen(ticketId: ticket.id),
                            ),
                          ),
                        ),
                      if (isAdmin) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                context: context,
                                icon: Icons.description_rounded,
                                label: 'View Report',
                                color: const Color(0xFF3BAEE9),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReportDetailsScreen(ticketId: ticket.id),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: AssignDoctorWidget(ticketId: ticket.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 20, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}