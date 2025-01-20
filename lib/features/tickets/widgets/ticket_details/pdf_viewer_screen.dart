import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

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
      final response = await Dio().get(
        widget.fileUrl,
        options: Options(responseType: ResponseType.bytes),
      );

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