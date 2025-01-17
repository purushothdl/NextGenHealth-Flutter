// lib/features/tickets/widgets/file_upload_widget.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadWidget extends StatelessWidget {
  final String label;
  final String? filePath;
  final Function(String?) onFileSelected;

  const FileUploadWidget({
    super.key,
    required this.label,
    this.filePath,
    required this.onFileSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
            );

            if (result != null) {
              final filePath = result.files.single.path;
              onFileSelected(filePath);
            }
          },
          child: Text(filePath == null ? 'Upload $label' : 'Change $label'),
        ),
        if (filePath != null) ...[
          const SizedBox(height: 8),
          Text(
            'Selected file: ${filePath!.split('/').last}',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ],
    );
  }
}