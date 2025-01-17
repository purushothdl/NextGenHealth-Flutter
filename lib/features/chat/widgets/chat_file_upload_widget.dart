// lib/features/chat/widgets/chat_widget.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

enum UploadType {
  image,
  document,
}

class ChatFileUploadWidget extends StatelessWidget {
  final Function(String? path, UploadType type) onFileSelected;

  const ChatFileUploadWidget({
    super.key,
    required this.onFileSelected,
  });

  Future<void> _pickDocument(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withReadStream: true, // Use read stream instead of loading the whole file
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
        debugPrint("Selected document path: ${result.files.single.path}");
        onFileSelected(result.files.single.path!, UploadType.document);
      }
    } catch (e) {
      debugPrint('Error picking document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking document: $e')),
      );
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty && result.files.single.path != null) {
        debugPrint("Selected image path: ${result.files.single.path}"); // Debug log
        onFileSelected(result.files.single.path!, UploadType.image);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<UploadType>(
      icon: const Icon(Icons.attach_file),
      onSelected: (UploadType type) {
        if (type == UploadType.image) {
          _pickImage(context); // Pass context here
        } else {
          _pickDocument(context); // Pass context here
        }
      },
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem<UploadType>(
          value: UploadType.document,
          child: ListTile(
            leading: Icon(Icons.picture_as_pdf, color: Colors.red),
            title: Text('Upload PDF'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
        const PopupMenuItem<UploadType>(
          value: UploadType.image,
          child: ListTile(
            leading: Icon(Icons.image, color: Colors.blue),
            title: Text('Upload Image'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }
}