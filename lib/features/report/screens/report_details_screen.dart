import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdfx/pdfx.dart';
import '../../shared/widgets/task_result/message_dialog_popup.dart';
import '../../tickets/providers/ticket_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class ReportDetailsScreen extends StatefulWidget {
  final String ticketId;

  const ReportDetailsScreen({super.key, required this.ticketId});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  late Future<Map<String, dynamic>> _reportFuture;

  @override
  void initState() {
    super.initState();
    // Fetch data in initState, not in the build method
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    _reportFuture = ticketProvider.fetchReport(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No report data available.'));
          }

          final report = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report['diagnosis'] != null)
                  _buildDetailSection('Diagnosis', report['diagnosis']),
                const SizedBox(height: 16),
                if (report['recommendations'] != null)
                  _buildDetailSection('Recommendations', report['recommendations']),
                const SizedBox(height: 16),
                if (report['medications'] != null)
                  _buildListSection('Medications', report['medications']),
                const SizedBox(height: 16),
                if (report['image_url'] != null)
                  _buildFileSection('Report Image', report['image_url']),
                const SizedBox(height: 16),
                if (report['docs_url'] != null)
                  _buildPdfSection('Report Document', report['docs_url']),
                const SizedBox(height: 16),
                if (report['created_at'] != null)
                  _buildDetailSection('Report Date', report['created_at']),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildDetailSection(String title, String value) {
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListSection(String title, List<dynamic> items) {
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Text(
                  '- $item',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSection(String title, String fileUrl) {
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
            if (fileUrl.endsWith('.jpg') || fileUrl.endsWith('.jpeg') || fileUrl.endsWith('.png'))
              CachedNetworkImage(
                imageUrl: fileUrl,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) {
                  print('Error loading image: $error');
                  return const Icon(Icons.error);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfSection(String title, String fileUrl) {
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

  // Future<void> _launchUrl(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   print('Attempting to launch URL: $url');
  //   if (await canLaunchUrl(uri)) {
  //     print('Launching URL: $url');
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     print('Could not launch $url');
  //     throw 'Could not launch $url';
  //   }
  // }
}

class PDFViewerScreen extends StatefulWidget {
  final String fileUrl;

  const PDFViewerScreen({Key? key, required this.fileUrl}) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  late PdfControllerPinch _pdfController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  Future<void> loadDocument() async {
    try {
      // Fetch the PDF data from the URL
      final response = await Dio().get(
        widget.fileUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Load the PDF document from the fetched data
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openData(response.data),
      );

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load PDF. Please try again later.';
      });

      // Fallback: Open the PDF in an external viewer
      if (mounted) {
        _openExternalViewer(context);
      }
    }
  }

  Future<void> _openExternalViewer(BuildContext context) async {
    final Uri uri = Uri.parse(widget.fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open PDF viewer'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => _openExternalViewer(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : PdfViewPinch(
                  controller: _pdfController,
                ),
    );
  }
}