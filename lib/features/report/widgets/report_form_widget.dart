import 'package:flutter/material.dart';
import 'package:next_gen_health/features/shared/widgets/fields/custom_text_field.dart';
import 'package:provider/provider.dart';
import '../../profile/screens/widgets/update profile/list_input_field.dart';
import '../../tickets/providers/ticket_provider.dart';
import 'file_upload_widget.dart'; // Import the separate file for FileUploadWidget

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
  List<String> _medications = [];
  String? _imagePath;
  String? _documentPath;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

      final success = await ticketProvider.uploadReport(
        ticketId: widget.ticketId,
        diagnosis: _diagnosisController.text,
        recommendations: _recommendationsController.text,
        medications: _medications,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Diagnosis Field
            CustomTextField(
              controller: _diagnosisController,
              label: 'Diagnosis',
              hint: 'Enter the diagnosis',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a diagnosis';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Recommendations Field
            CustomTextField(
              controller: _recommendationsController,
              label: 'Recommendations',
              hint: 'Enter recommendations',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter recommendations';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // Medications Field
            ListInputField(
              label: 'Medications',
              items: _medications,
              onChanged: (items) {
                setState(() {
                  _medications = items.cast<String>();
                });
              },
            ),
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),

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
            const SizedBox(height: 30),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}