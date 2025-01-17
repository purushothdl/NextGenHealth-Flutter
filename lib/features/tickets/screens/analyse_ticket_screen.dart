import 'package:flutter/material.dart';
import '../models/ticket_model.dart';

class AnalyseTicketScreen extends StatelessWidget {
  final TicketResponse ticket;

  const AnalyseTicketScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analyse Ticket'),
      ),
      body: Center(
        child: Text('AI Analysis for Ticket: ${ticket.title}'),
      ),
    );
  }
}