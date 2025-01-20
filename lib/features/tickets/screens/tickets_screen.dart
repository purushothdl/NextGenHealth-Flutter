// lib/features/tickets/screens/tickets__screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../home/screens/home_screen.dart';
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
  String selectedTab = 'pending'; // Track the selected tab

  @override
  void initState() {
    super.initState();
    // Fetch tickets when the screen loads
    Future.microtask(() => _loadTickets());
  }

  Future<void> _loadTickets() async {
    // Fetch tickets using the TicketProvider
    await Provider.of<TicketProvider>(context, listen: false).fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Add this to get the user's role
    final isDoctor = authProvider.currentUser?['role'] == 'doctor'; // Check if the user is a doctor
    final isAdmin = authProvider.currentUser?['role'] == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tickets',
          style: TextStyle(color: Colors.white), // White text for visibility
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeApp()),
            );
          },
        ),
        backgroundColor: Colors.blue, // Blue background
        elevation: 0,
        automaticallyImplyLeading: false, // Disable default back button
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16), // Gap between AppBar and TabBar
          // Custom TabBar with toggle button style
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 237, 237, 237), // Light grey background
                borderRadius: BorderRadius.circular(25), // Circular rectangle shape
                border: Border.all(
                  color: const Color.fromARGB(255, 183, 182, 182), // Light border
                  width: 0.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: _buildTabButton('Pending', 'pending'),
                  ),
                  Flexible(
                    child: _buildTabButton('Resolved', 'resolved'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16), // Gap between TabBar and content
          // Content based on selected tab
          Expanded(
            child: Consumer<TicketProvider>(
              builder: (context, ticketProvider, child) {
                if (ticketProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Force refresh tickets when pulled
                    await ticketProvider.refreshTickets();
                  },
                  child: _buildFilteredTicketList(
                    selectedTab == 'pending'
                        ? ticketProvider.pendingTickets
                        : ticketProvider.resolvedTickets,
                    context,
                    isDoctor,
                    isAdmin,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, String tab) {
    bool isSelected = selectedTab == tab;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20), // Circular rectangle shape
          border: isSelected
              ? Border.all(color: const Color.fromARGB(255, 255, 255, 255), width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.black
                : const Color.fromARGB(255, 128, 128, 128), // Grey text for unselected tabs
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredTicketList(
    List<TicketResponse> tickets,
    BuildContext context,
    bool isDoctor,
    bool isAdmin,
  ) {
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

            // Navigate to TicketDetailsScreen
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TicketDetailsScreen(
                  ticket: ticket,
                  patientDetails: patientDetails,
                  doctorDetails: doctorDetails,
                  isDoctor: isDoctor,
                  isAdmin: isAdmin,
                ),
              ),
            );

            // Reload tickets after returning from TicketDetailsScreen
            await _loadTickets();
          },
        );
      },
    );
  }
}