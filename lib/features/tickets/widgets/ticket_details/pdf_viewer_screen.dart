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
  PdfControllerPinch? _pdfController;
  bool _isLoading = true;
  String? _errorMessage;
  int _totalPages = 0;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      final response = await Dio().get(
        widget.fileUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final document = PdfDocument.openData(response.data);
      _totalPages = (await document).pagesCount;

      setState(() {
        _pdfController = PdfControllerPinch(
          document: document, // Pass the Future<PdfDocument> here
          initialPage: 1,
        );
        _isLoading = false;
      });

      _pdfController?.addListener(() {
        if (mounted) {
          setState(() {
            _currentPage = _pdfController?.page?.round() ?? 1;
          });
        }
      });
    } catch (e) {
      print('PDF Loading Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load document. Trying external viewer...';
        });
        _openExternalViewer();
      }
    }
  }

  Future<void> _openExternalViewer() async {
    try {
      final uri = Uri.parse(widget.fileUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No PDF viewer application found'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Document', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new, color: Colors.white),
            onPressed: _openExternalViewer,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildPageControls(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF3BAEE9)),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey[800],
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3BAEE9),
                foregroundColor: Colors.white,
              ),
              onPressed: _initializePdf,
            ),
          ],
        ),
      );
    }

    return PdfViewPinch(
      controller: _pdfController!,
      scrollDirection: Axis.vertical,
    );
  }

  Widget _buildPageControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.blueGrey[800]),
            onPressed: _currentPage > 1
                ? () => _pdfController?.previousPage(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 300),
                    )
                : null,
          ),
          Text(
            '$_currentPage / $_totalPages',
            style: TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: Colors.blueGrey[800]),
            onPressed: _currentPage < _totalPages
                ? () => _pdfController?.nextPage(
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 300),
                    )
                : null,
          ),
        ],
      ),
    );
  }
}