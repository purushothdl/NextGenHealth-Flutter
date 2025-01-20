import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../screens/ticket_details_screen.dart';
import 'pdf_viewer_screen.dart';

class PdfSection extends StatelessWidget {
  final String title;
  final String fileUrl;

  const PdfSection({
    Key? key,
    required this.title,
    required this.fileUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerScreen(fileUrl: fileUrl),
                  ),
                );
              },
              child: const Text('View PDF'),
            ),
          ],
        ),
      ),
    );
  }
}