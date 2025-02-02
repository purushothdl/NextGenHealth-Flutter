// lib/features/profile/models/profile_model.dart
class Profile {
  final String username;
  final String email;
  final String role;
  final String createdAt;
  final String status;
  final String? profileImageUrl;
  final Map<String, dynamic>? patientData;
  final Map<String, dynamic>? doctorData;
  final Map<String, dynamic>? adminData;

  Profile({
    required this.username,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.status,
    this.profileImageUrl,
    this.patientData,
    this.doctorData,
    this.adminData,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json['username'],
      email: json['email'],
      role: json['role'],
      createdAt: json['created_at'],
      status: json['status'],
      profileImageUrl: json['profileImageUrl'],
      patientData: json['patient_data'],
      doctorData: json['doctor_data'],
      adminData: json['admin_data'],
    );
  }
}