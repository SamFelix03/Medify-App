class Profile {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? bloodGroup;
  final List<String> allergies;
  final Map<String, dynamic> emergencyContact;
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.bloodGroup,
    this.allergies = const [],
    this.emergencyContact = const {},
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      bloodGroup: json['blood_group'] as String?,
      allergies: List<String>.from(json['allergies'] ?? []),
      emergencyContact: json['emergency_contact'] as Map<String, dynamic>? ?? {},
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'blood_group': bloodGroup,
      'allergies': allergies,
      'emergency_contact': emergencyContact,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? bloodGroup,
    List<String>? allergies,
    Map<String, dynamic>? emergencyContact,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 