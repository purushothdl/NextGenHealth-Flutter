import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../report/widgets/file_upload_widget.dart';
import '../../shared/widgets/task_result/message_dialog_popup.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket_model.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<RaiseTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bpController = TextEditingController();
  final _sugarLevelController = TextEditingController();
  final _weightController = TextEditingController();
  final _symptomsController = TextEditingController();
  String? _imagePath;
  String? _documentPath;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _bpController.dispose();
    _sugarLevelController.dispose();
    _weightController.dispose();
    _symptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raise a Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter the ticket title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description Field
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter a detailed description',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Blood Pressure Field
              _buildTextField(
                controller: _bpController,
                label: 'Blood Pressure',
                hint: 'Enter your blood pressure',
              ),
              const SizedBox(height: 20),

              // Sugar Level Field
              _buildTextField(
                controller: _sugarLevelController,
                label: 'Sugar Level',
                hint: 'Enter your sugar level',
              ),
              const SizedBox(height: 20),

              // Weight Field (Custom Integer Input)
              _buildWeightField(),
              const SizedBox(height: 20),

              // Symptoms Field
              _buildTextField(
                controller: _symptomsController,
                label: 'Symptoms',
                hint: 'Enter your symptoms',
              ),
              const SizedBox(height: 20),

              // Image Upload
              FileUploadWidget(
                label: 'Image',
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
                label: 'Document',
                filePath: _documentPath,
                onFileSelected: (path) {
                  setState(() {
                    _documentPath = path;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final ticket = Ticket(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      bp: _bpController.text.isEmpty ? null : _bpController.text,
                      sugarLevel: _sugarLevelController.text.isEmpty ? null : _sugarLevelController.text,
                      weight: _weightController.text.isEmpty ? null : double.tryParse(_weightController.text),
                      symptoms: _symptomsController.text.isEmpty ? null : _symptomsController.text,
                      imagePath: _imagePath,
                      documentPath: _documentPath,
                    );

                    final success = await ticketProvider.createTicket(ticket);
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => SuccessErrorPopup(
                          isSuccess: success,
                          message: success ? 'Ticket created successfully!' : (ticketProvider.error ?? 'Failed to create ticket'),
                        ),
                      );

                      if (success) {
                        // Clear the form and close the screen after a short delay
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.of(context).pop();
                        });
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Ticket',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  String? Function(String?)? validator,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.blue,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          maxLines: null, // Allows for unlimited lines
          keyboardType: TextInputType.multiline, // Enables multiline input
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.blueGrey[300],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.blueGrey[100]!,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: TextStyle(
            color: Colors.blueGrey[800],
            fontSize: 14,
          ),
          validator: validator,
        ),
      ),
    ],
  );
}
  Widget _buildWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weight',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter your weight (in kg)',
              hintStyle: TextStyle(
                color: Colors.blueGrey[300],
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.blueGrey[100]!,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.blue,
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: const Icon(
                Icons.scale,
                color: Colors.blueGrey,
              ),
            ),
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}