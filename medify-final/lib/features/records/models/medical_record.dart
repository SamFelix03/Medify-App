import 'dart:convert';

class MedicalRecord {
  final String id;
  final String userId;
  final String recordType;
  final Map<String, dynamic> data;
  final List<String> attachments;
  final DateTime createdAt;
  final bool encrypted;

  MedicalRecord({
    required this.id,
    required this.userId,
    required this.recordType,
    required this.data,
    required this.attachments,
    required this.createdAt,
    this.encrypted = false,
  });

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordType: json['record_type'] as String,
      data: json['data'] as Map<String, dynamic>,
      attachments: List<String>.from(json['attachments'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
      encrypted: json['encrypted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'record_type': recordType,
      'data': data,
      'attachments': attachments,
      'created_at': createdAt.toIso8601String(),
      'encrypted': encrypted,
    };
  }

  String get title {
    switch (recordType) {
      case 'lab':
        return data['test_name'] ?? 'Lab Report';
      case 'prescription':
        return data['medication_name'] ?? 'Prescription';
      case 'illness':
        return data['condition_name'] ?? 'Medical Condition';
      default:
        return 'Medical Record';
    }
  }

  String get subtitle {
    switch (recordType) {
      case 'lab':
        return data['lab_name'] ?? 'Unknown Lab';
      case 'prescription':
        return '${data['dosage'] ?? ''} ${data['frequency'] ?? ''}';
      case 'illness':
        return data['diagnosis_date'] ?? 'Unknown Date';
      default:
        return createdAt.toString();
    }
  }

  MedicalRecord copyWith({
    String? id,
    String? userId,
    String? recordType,
    Map<String, dynamic>? data,
    List<String>? attachments,
    DateTime? createdAt,
    bool? encrypted,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      recordType: recordType ?? this.recordType,
      data: data ?? this.data,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      encrypted: encrypted ?? this.encrypted,
    );
  }
} 