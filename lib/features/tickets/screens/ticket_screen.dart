import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/ticket_model.dart';
import '../providers/ticket_provider.dart';
import '../widgets/ticket_details/ticket_list_item.dart';
import 'ticket_details_screen.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tickets when the screen loads (use cached data if available)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketProvider>(context, listen: false).fetchTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context); // Add this to get the user's role
    final isDoctor = authProvider.currentUser?['role'] == 'doctor'; // Check if the user is a doctor

    // Debug logs
    print('Pending Tickets: ${ticketProvider.pendingTickets}');
    print('Resolved Tickets: ${ticketProvider.resolvedTickets}');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tickets'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'Resolved'),
            ],
          ),
        ),
        body: ticketProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  // Pending Tickets Tab
                  RefreshIndicator(
                    onRefresh: () async {
                      // Force refresh tickets when pulled
                      await ticketProvider.refreshTickets();
                    },
                    child: _buildTicketList(ticketProvider.pendingTickets, context, isDoctor),
                  ),

                  // Resolved Tickets Tab
                  RefreshIndicator(
                    onRefresh: () async {
                      // Force refresh tickets when pulled
                      await ticketProvider.refreshTickets();
                    },
                    child: _buildTicketList(ticketProvider.resolvedTickets, context, isDoctor),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildTicketList(List<TicketResponse> tickets, BuildContext context, bool isDoctor) {
    if (tickets.isEmpty) {
      return const Center(child: Text('No tickets found.'));
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return TicketListItem(
          ticket: ticket,
          onTap: () async {
            final patientDetails = await context.read<TicketProvider>().getUserDetails(ticket.patientId);
            final doctorDetails = ticket.assignedDoctorId != null
                ? await context.read<TicketProvider>().getUserDetails(ticket.assignedDoctorId!)
                : null;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TicketDetailsScreen(
                  ticket: ticket,
                  patientDetails: patientDetails,
                  doctorDetails: doctorDetails,
                  isDoctor: isDoctor, // Pass the user's role
                ),
              ),
            );
          },
        );
      },
    );
  }
}