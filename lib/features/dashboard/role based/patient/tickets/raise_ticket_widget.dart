import 'package:flutter/material.dart';
import '../../../../tickets/screens/raise_ticket_screen.dart';

class RaiseTicketWidget extends StatelessWidget {
  const RaiseTicketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue, // Background color
        borderRadius: BorderRadius.circular(12.0), // Rounded corners
      ),
      padding: const EdgeInsets.all(16.0),
      height: 150, // Fixed height
      child: Align(
        alignment: Alignment.bottomLeft,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            backgroundColor: Colors.white, // Button background color
            foregroundColor: Colors.blue, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0), // Less rounded corners
            ),
          ),
          onPressed: () {
            // Navigate to the ticket screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RaiseTicketScreen(),
              ),
            ); 
          },
          child: const Text('Raise Ticket'),
        ),
      ),
    );
  }
}