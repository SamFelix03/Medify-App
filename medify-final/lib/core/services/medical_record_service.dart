import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:medify/features/records/models/medical_record.dart';

final medicalRecordServiceProvider = Provider<MedicalRecordService>(
  (ref) => MedicalRecordService(),
);

class MedicalRecordService {
  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();

  Future<List<MedicalRecord>> getRecords() async {
    try {
      final response = await _supabase
          .from('medical_records')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<MedicalRecord>((json) => MedicalRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch records: $e');
    }
  }

  Future<List<MedicalRecord>> getRecordsByType(String type) async {
    try {
      final response = await _supabase
          .from('medical_records')
          .select()
          .eq('record_type', type)
          .order('created_at', ascending: false);

      return response
          .map<MedicalRecord>((json) => MedicalRecord.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch records by type: $e');
    }
  }

  Future<MedicalRecord> createRecord({
    required String recordType,
    required Map<String, dynamic> data,
    List<String> attachments = const [],
  }) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final record = MedicalRecord(
        id: _uuid.v4(),
        userId: userId,
        recordType: recordType,
        data: data,
        attachments: attachments,
        createdAt: DateTime.now(),
      );

      await _supabase.from('medical_records').insert(record.toJson());
      return record;
    } catch (e) {
      throw Exception('Failed to create record: $e');
    }
  }

  Future<void> updateRecord(MedicalRecord record) async {
    try {
      await _supabase
          .from('medical_records')
          .update(record.toJson())
          .eq('id', record.id);
    } catch (e) {
      throw Exception('Failed to update record: $e');
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      await _supabase.from('medical_records').delete().eq('id', recordId);
    } catch (e) {
      throw Exception('Failed to delete record: $e');
    }
  }

  // Future<String> uploadAttachment(String filePath) async {
  //   try {
  //     final fileName = '${_uuid.v4()}_${filePath.split('/').last}';
  //     final response = await _supabase.storage
  //         .from('medical-attachments')
  //         .upload(fileName, filePath);
  //     return response;
  //   } catch (e) {
  //     throw Exception('Failed to upload attachment: $e');
  //   }
  // }

  // Future<void> deleteAttachment(String path) async {
  //   try {
  //     await _supabase.storage.from('medical-attachments').remove([path]);
  //   } catch (e) {
  //     throw Exception('Failed to delete attachment: $e');
  //   }
  // }

  Stream<List<MedicalRecord>> watchRecords() {
    return _supabase
        .from('medical_records')
        .stream(primaryKey: ['id'])
        .eq('user_id', _supabase.auth.currentUser!.id)
        .order('created_at', ascending: false)
        .map((rows) => rows.map(MedicalRecord.fromJson).toList());
  }
} 