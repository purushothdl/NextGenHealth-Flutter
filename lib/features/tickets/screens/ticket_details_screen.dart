import 'package:flutter/material.dart';

import '../../report/screens/report_details_screen.dart';
import '../../report/screens/report_upload_screen.dart';
import '../models/ticket_model.dart';
import 'analyse_ticket_screen.dart';

class TicketDetailsScreen extends StatelessWidget {
  final TicketResponse ticket;
  final Map<String, dynamic> patientDetails;
  final Map<String, dynamic>? doctorDetails;
  final bool isDoctor; // Add this to check if the user is a doctor

  const TicketDetailsScreen({
    super.key,
    required this.ticket,
    required this.patientDetails,
    this.doctorDetails,
    required this.isDoctor, // Pass this from the parent widget
  });

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ticket Title
              Text(
                ticket.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),

              // Ticket Description
              Text(
                ticket.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Health Metrics
              if (ticket.bp != null || ticket.sugarLevel != null || ticket.weight != null)
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
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
                ),

              // Patient Details
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow('Name', patientDetails['username']),
                      _buildDetailRow('Email', patientDetails['email']),
                      _buildDetailRow('Age', '${patientDetails['patient_data']['age'] ?? 'N/A'} years'),
                      _buildDetailRow('Height', '${patientDetails['patient_data']['height'] ?? 'N/A'} cm'),
                      _buildDetailRow('Weight', '${patientDetails['patient_data']['weight'] ?? 'N/A'} kg'),
                      _buildDetailRow('Blood Group', patientDetails['patient_data']['blood_group'] ?? 'N/A'),
                      const SizedBox(height: 8),
                      _buildListSection(
                        'Medical Conditions',
                        patientDetails['patient_data']['medical_conditions'] ?? [],
                      ),
                      _buildListSection(
                        'Medical History',
                        patientDetails['patient_data']['medical_history'] ?? [],
                      ),
                      _buildListSection(
                        'Medications',
                        patientDetails['patient_data']['medications'] ?? [],
                      ),
                      _buildListSection(
                        'Allergies',
                        patientDetails['patient_data']['allergies'] ?? [],
                      ),
                    ],
                  ),
                ),
              ),

              // Assigned Doctor Details (if available)
              if (doctorDetails != null)
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Assigned Doctor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow('Name', doctorDetails!['username']),
                        _buildDetailRow('Email', doctorDetails!['email']),
                        _buildDetailRow('Age', '${doctorDetails!['doctor_data']['age'] ?? 'N/A'} years'),
                        _buildDetailRow('Experience', '${doctorDetails!['doctor_data']['experience_years'] ?? 'N/A'} years'),
                        _buildDetailRow('Hospital', doctorDetails!['doctor_data']['hospital'] ?? 'N/A'),
                        _buildDetailRow('License Number', doctorDetails!['doctor_data']['license_number'] ?? 'N/A'),
                        const SizedBox(height: 8),
                        _buildListSection(
                          'Qualifications',
                          doctorDetails!['doctor_data']['qualifications'] ?? [],
                        ),
                        _buildListSection(
                          'Specialization',
                          doctorDetails!['doctor_data']['specialization'] ?? [],
                        ),
                      ],
                    ),
                  ),
                ),

              // Analyse Ticket Button (for doctors)
              if (isDoctor)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the AI analysis screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnalyseTicketScreen(ticket: ticket),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
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
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportUploadScreen(ticket: ticket),
            ),
          );
        },
        child: const Text('Upload Report'),
      ),
      const SizedBox(height: 16),
    ],
  ),
  if (!isDoctor) // Show this button only for patients
  Column(
    children: [
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportDetailsScreen(ticketId: ticket.id),
            ),
          );
        },
        child: const Text('View Report'),
      ),
      const SizedBox(height: 16),
    ],
  ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a detail row
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

  // Helper method to build a list section
  Widget _buildListSection(String title, List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return const SizedBox.shrink(); // Hide if no items
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((item) {
            return Text(
              '- $item',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}