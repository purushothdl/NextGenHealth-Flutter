import 'package:flutter/material.dart';
import '../../../../core/services/api/admin_api_service.dart';

class AssignDoctorWidget extends StatelessWidget {
  final String ticketId;

  const AssignDoctorWidget({Key? key, required this.ticketId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _assignTicketToDoctor(context, ticketId),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        backgroundColor: const Color(0xFF9C27B0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_add_alt_1_rounded, size: 20, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Assign Doctor',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

Future<void> _assignTicketToDoctor(BuildContext context, String ticketId) async {
  final adminApiService = AdminApiService();
  final doctors = await adminApiService.getDoctors();

  final selectedDoctor = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Assign to Doctor',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4, // Adjust height as needed
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[50],
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.blue[800],
                          ),
                        ),
                        title: Text(
                          doctor['username'],
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          doctor['email'],
                          style: TextStyle(
                            color: Colors.blueGrey[600],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.blueGrey[400],
                        ),
                        onTap: () {
                          Navigator.pop(context, doctor);
                        },
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 1, thickness: 1),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (selectedDoctor != null) {
    try {
      await adminApiService.assignTicketToDoctor(ticketId, selectedDoctor['_id']);
      await _showAssignmentPopup(context, true); // Success popup
    } catch (e) {
      await _showAssignmentPopup(context, false, 'Failed to assign ticket: $e'); // Error popup
    }
  }
}
}

Future<void> _showAssignmentPopup(BuildContext context, bool isSuccess, [String? errorMessage]) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
      
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
                size: 64,
                color: isSuccess ? const Color(0xFF00BFA5) : const Color(0xFFE53935),
              ),
              const SizedBox(height: 16),
              Text(
                isSuccess ? 'Ticket Assigned!' : 'Assignment Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isSuccess ? const Color(0xFF00BFA5) : const Color(0xFFE53935),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSuccess
                    ? 'The ticket has been successfully assigned to the doctor.'
                    : errorMessage ?? 'An error occurred while assigning the ticket.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 0),
                  backgroundColor: isSuccess ? const Color(0xFF00BFA5) : const Color(0xFFE53935),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}