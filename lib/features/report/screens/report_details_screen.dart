import 'package:flutter/material.dart';
import 'package:next_gen_health/features/report/widgets/list_item_widget.dart';
import 'package:next_gen_health/features/shared/utils/date_utils.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdfx/pdfx.dart';
import '../../shared/widgets/task_result/message_dialog_popup.dart';
import '../../tickets/providers/ticket_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import '../../tickets/widgets/ticket_details/details_section.dart';
import '../../tickets/widgets/ticket_details/image_section.dart';
import '../../tickets/widgets/ticket_details/pdf_section.dart';
import '../widgets/no_report_widget.dart';

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
        title: const Text('Report Details', style: TextStyle(fontWeight: FontWeight.bold),),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const NoReportDataWidget();
          }
          final report = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (report['diagnosis'] != null)
                  DetailSection(title: 'Diagnosis', value: report['diagnosis']),
                const SizedBox(height: 16),
                if (report['recommendations'] != null)
                  DetailSection(title: 'Recommendations', value: report['recommendations']),
                const SizedBox(height: 16),
                if (report['medications'] != null)
                  ListItemsWidget(title: 'Medications', items: report['medications']),
                const SizedBox(height: 16),
                if (report['created_at'] != null)
                  DetailSection(title: 'Report Date', value: FormatDateUtils.formatDateString(report['created_at'])),
                const SizedBox(height: 16),
                if (report['image_url'] != null)
                  ImageSection(title: 'Report Image', fileUrl: report['image_url']),
                const SizedBox(height: 16),
                if (report['docs_url'] != null)
                  PdfSection(title: 'Report Document', fileUrl: report['docs_url']),
              ],
            ),
          );
        },
      ),
    );
  }


}