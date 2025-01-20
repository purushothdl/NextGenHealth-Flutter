// lib/features/chat/widgets/chat_input_widget.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io'; // For File
import 'chat_file_upload_widget.dart';

class ChatInputWidget extends StatefulWidget {
  final bool enabled;
  final Function(String message, {String? imagePath, String? documentPath}) onSendMessage;

  const ChatInputWidget({
    super.key,
    required this.enabled,
    required this.onSendMessage,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedImagePath;
  String? _selectedDocumentPath;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleSend() {
    if (!mounted) return; // Ensure the widget is still mounted
    if (_controller.text.trim().isNotEmpty || _selectedImagePath != null || _selectedDocumentPath != null) {
      widget.onSendMessage(
        _controller.text.trim(),
        imagePath: _selectedImagePath,
        documentPath: _selectedDocumentPath,
      );
      _controller.clear();
      setState(() {
        _selectedImagePath = null;
        _selectedDocumentPath = null;
      });
    }
  }

  void _onTextChanged(String text) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return; // Ensure the widget is still mounted
      // Perform your update here
    });
  }

  Widget _buildFilePreview() {
    return Row(
      children: [
        if (_selectedImagePath != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                File(_selectedImagePath!),
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
        if (_selectedDocumentPath != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: const Icon(Icons.picture_as_pdf, size: 50, color: Colors.red),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (_selectedImagePath != null || _selectedDocumentPath != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildFilePreview(),
            ),
          Row(
            children: [
              ChatFileUploadWidget(
                onFileSelected: (String? path, UploadType type) {
                  setState(() {
                    if (type == UploadType.image) {
                      _selectedImagePath = path;
                    } else {
                      _selectedDocumentPath = path;
                    }
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _handleSend(),
                  onChanged: _onTextChanged, // Add debounced onChanged
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: widget.enabled ? _handleSend : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}