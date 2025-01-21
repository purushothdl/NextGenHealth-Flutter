// lib/features/chat/widgets/chat_input_widget.dart
import 'dart:io';

import 'package:flutter/material.dart';
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
  int _textFieldLines = 1; // Track the number of lines in the TextField

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_controller.text.trim().isEmpty &&
        _selectedImagePath == null &&
        _selectedDocumentPath == null) return;

    widget.onSendMessage(
      _controller.text.trim(),
      imagePath: _selectedImagePath,
      documentPath: _selectedDocumentPath,
    );
    _controller.clear();
    setState(() {
      _selectedImagePath = null;
      _selectedDocumentPath = null;
      _textFieldLines = 1; // Reset to 1 line after sending
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_selectedImagePath != null || _selectedDocumentPath != null)
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (_selectedImagePath != null)
                    _buildPreviewCard(
                      context,
                      _selectedImagePath!,
                      Icons.image,
                      Colors.purple,
                      () => setState(() => _selectedImagePath = null),
                    ),
                  if (_selectedDocumentPath != null)
                    _buildPreviewCard(
                      context,
                      _selectedDocumentPath!,
                      Icons.picture_as_pdf,
                      Colors.red,
                      () => setState(() => _selectedDocumentPath = null),
                    ),
                ],
              ),
            ),
          Row(
            children: [
              ChatFileUploadWidget(
                onFileSelected: (path, type) => setState(() {
                  if (type == UploadType.image) {
                    _selectedImagePath = path;
                  } else {
                    _selectedDocumentPath = path;
                  }
                }),
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: _textFieldLines * 24.0 + 32.0, // Adjust height dynamically
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null, // Allow unlimited lines
                    minLines: 1, // Start with 1 line
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (text) {
                      // Update the number of lines based on the text
                      final lines = (text.split('\n').length + text.split('').length ~/ 30);
                      setState(() {
                        _textFieldLines = lines.clamp(1, 5); // Limit to 5 lines max
                      });
                    },
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan.shade100, Colors.blue.shade100],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.send_rounded, color: Colors.blue.shade800),
                  onPressed: widget.enabled ? _handleSend : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, String path, IconData icon, Color color, VoidCallback onRemove) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: path.endsWith('.pdf')
                  ? Icon(icon, color: color)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(File(path), fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  path.split('/').last,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${File(path).lengthSync() / 1024 ~/ 1} KB',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, size: 16, color: Colors.grey.shade600),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilePreviewCard extends StatelessWidget {
  final String path;
  final IconData icon;
  final Color color;
  final VoidCallback onRemove;

  const _FilePreviewCard({
    required this.path,
    required this.icon,
    required this.color,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            // offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Preview Image or Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: path.endsWith('.pdf')
                ? Icon(icon, color: color, size: 24)
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(path),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(width: 8),

          // File Name and Size
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                path.split('/').last,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${File(path).lengthSync() / 1024 ~/ 1} KB',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),

          // Remove Button
          IconButton(
            icon: Icon(Icons.close_rounded, size: 16, color: Colors.grey.shade600),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}