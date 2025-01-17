// lib/features/tickets/models/ticket_model.dart
class Ticket {
  final String title;
  final String description;
  final String? bp;
  final String? sugarLevel;
  final double? weight;
  final String? symptoms;
  final String? imagePath;
  final String? documentPath;

  Ticket({
    required this.title,
    required this.description,
    this.bp,
    this.sugarLevel,
    this.weight,
    this.symptoms,
    this.imagePath,
    this.documentPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'bp': bp,
      'sugar_level': sugarLevel,
      'weight': weight,
      'symptoms': symptoms,
      'image': imagePath,
      'document': documentPath,
    };
  }
}


class TicketResponse {
  final String id;
  final String title;
  final String description;
  final String? bp; // Nullable
  final String? sugarLevel; // Nullable
  final double? weight; // Nullable
  final String? symptoms; // Nullable
  final String? imagePath; // Nullable
  final String? documentPath; // Nullable
  final String status; // 'pending' or 'resolved'
  final String patientId;
  final String? assignedDoctorId; // Nullable

  TicketResponse({
    required this.id,
    required this.title,
    required this.description,
    this.bp,
    this.sugarLevel,
    this.weight,
    this.symptoms,
    this.imagePath,
    this.documentPath,
    required this.status,
    required this.patientId,
    this.assignedDoctorId,
  });

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(
      id: json['_id'] as String, // Ensure this is not null
      title: json['title'] as String, // Ensure this is not null
      description: json['description'] as String, // Ensure this is not null
      bp: json['bp'] as String?, // Nullable
      sugarLevel: json['sugar_level'] as String?, // Nullable
      weight: json['weight']?.toDouble(), // Nullable
      symptoms: json['symptoms'] as String?, // Nullable
      imagePath: json['image_path'] as String?, // Nullable
      documentPath: json['document_path'] as String?, // Nullable
      status: json['status'] as String, // Ensure this is not null
      patientId: json['patient_id'] as String, // Ensure this is not null
      assignedDoctorId: json['assigned_doctor_id'] as String?, // Nullable
    );
  }
}