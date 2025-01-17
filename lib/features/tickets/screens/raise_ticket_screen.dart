// lib/features/tickets/screens/ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared widgets/task_result/message_dialog_popup.dart';
import '../providers/ticket_provider.dart';
import '../models/ticket_model.dart';
import '../widgets/raise_ticket/file_upload_widget.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
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
        title: const Text('Raise a Ticket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bpController,
                decoration: const InputDecoration(labelText: 'Blood Pressure'),
              ),
              TextFormField(
                controller: _sugarLevelController,
                decoration: const InputDecoration(labelText: 'Sugar Level'),
              ),
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(labelText: 'Weight'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _symptomsController,
                decoration: const InputDecoration(labelText: 'Symptoms'),
              ),
              const SizedBox(height: 16),
              FileUploadWidget(
                label: 'Image',
                filePath: _imagePath,
                onFileSelected: (path) {
                  setState(() {
                    _imagePath = path;
                  });
                },
              ),
              const SizedBox(height: 16),
              FileUploadWidget(
                label: 'Document',
                filePath: _documentPath,
                onFileSelected: (path) {
                  setState(() {
                    _documentPath = path;
                  });
                },
              ),
              const SizedBox(height: 16),
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
                child: const Text('Submit Ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}