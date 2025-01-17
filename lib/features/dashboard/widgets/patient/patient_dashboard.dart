import 'package:flutter/material.dart';
import 'tickets/raise_ticket_widget.dart'; // Import the ticket widget

class PatientDashboard extends StatelessWidget {
  final Map<String, dynamic> user;

  const PatientDashboard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message
              Text(
                'Welcome ${user['username']}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Raise Ticket Widget
              const RaiseTicketWidget(),
              const SizedBox(height: 16),

              // Latest Ticket Widget
              _buildLatestTicketWidget(),
              const SizedBox(height: 16),

              // Medication Widget
              _buildMedicationWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // Latest Ticket Widget
  Widget _buildLatestTicketWidget() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Ticket',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to "See All" tickets screen
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTicketDetail('Title', 'Headache and Dizziness'),
            _buildTicketDetail('Description', 'Persistent headache for 3 days.'),
            _buildTicketDetail('Blood Pressure', '120/80 mmHg'),
            _buildTicketDetail('Sugar Level', '110 mg/dL'),
            _buildTicketDetail('Weight', '70 kg'),
          ],
        ),
      ),
    );
  }

  // Medication Widget
  Widget _buildMedicationWidget() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Medication',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildMedicationItem('Paracetamol', '500 mg', '8:00 AM'),
            _buildMedicationItem('Metformin', '1000 mg', '1:00 PM'),
            _buildMedicationItem('Vitamin D', '2000 IU', '6:00 PM'),
          ],
        ),
      ),
    );
  }

  // Helper method to build ticket details
  Widget _buildTicketDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build medication items with a checklist
  Widget _buildMedicationItem(String name, String dose, String time) {
    bool isChecked = false; // Local state for checkbox (can be managed with a provider later)

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                // Update state when checkbox is clicked
                isChecked = value ?? false;
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$dose at $time',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}