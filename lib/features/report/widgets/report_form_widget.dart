import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/api/ticket_api_service.dart';
import '../../tickets/providers/ticket_provider.dart';
import '../../tickets/widgets/raise_ticket/file_upload_widget.dart';

class ReportFormWidget extends StatefulWidget {
  final String ticketId;

  const ReportFormWidget({super.key, required this.ticketId});

  @override
  State<ReportFormWidget> createState() => _ReportFormWidgetState();
}

class _ReportFormWidgetState extends State<ReportFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _recommendationsController = TextEditingController();
  final _medicationsController = TextEditingController();
  String? _imagePath;
  String? _documentPath;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _recommendationsController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

Future<void> _submitReport() async {
  if (_formKey.currentState!.validate()) {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    final success = await ticketProvider.uploadReport(
      ticketId: widget.ticketId,
      diagnosis: _diagnosisController.text,
      recommendations: _recommendationsController.text,
      medications: _medicationsController.text.split(','),
      imagePath: _imagePath,
      documentPath: _documentPath,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report uploaded successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload report: ${ticketProvider.error}')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Diagnosis Field
          TextFormField(
            controller: _diagnosisController,
            decoration: const InputDecoration(
              labelText: 'Diagnosis',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a diagnosis';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Recommendations Field
          TextFormField(
            controller: _recommendationsController,
            decoration: const InputDecoration(
              labelText: 'Recommendations',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter recommendations';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Medications Field
          TextFormField(
            controller: _medicationsController,
            decoration: const InputDecoration(
              labelText: 'Medications (comma-separated)',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter medications';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Image Upload
          FileUploadWidget(
            label: 'Upload Image',
            filePath: _imagePath,
            onFileSelected: (path) {
              setState(() {
                _imagePath = path;
              });
            },
          ),
          const SizedBox(height: 16),

          // Document Upload
          FileUploadWidget(
            label: 'Upload Document',
            filePath: _documentPath,
            onFileSelected: (path) {
              setState(() {
                _documentPath = path;
              });
            },
          ),
          const SizedBox(height: 24),

          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Submit Report',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}