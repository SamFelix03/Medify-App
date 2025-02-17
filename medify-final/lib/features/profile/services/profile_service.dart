import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medify/features/profile/models/profile.dart';

final profileServiceProvider = Provider<ProfileService>((ref) => ProfileService());

class ProfileService {
  final _supabase = Supabase.instance.client;

  Future<Profile?> getProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return Profile.fromJson(response);
    } catch (e) {
      if (e is PostgrestException) {
        if (e.code == 'PGRST116') {
          // Profile doesn't exist, create one
          final userId = _supabase.auth.currentUser?.id;
          final email = _supabase.auth.currentUser?.email;
          if (userId != null && email != null) {
            final profile = Profile(
              id: userId,
              email: email,
              updatedAt: DateTime.now(),
            );
            await _supabase.from('profiles').insert(profile.toJson());
            return profile;
          }
        }
      }
      rethrow;
    }
  }

  Future<Profile> updateProfile(Profile profile) async {
    try {
      final updatedProfile = profile.copyWith(
        updatedAt: DateTime.now(),
      );

      await _supabase
          .from('profiles')
          .upsert(updatedProfile.toJson());

      return updatedProfile;
    } catch (e) {
      if (e is PostgrestException) {
        throw Exception('Database error: ${e.message}. Code: ${e.code}');
      }
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> updateEmergencyContact(Map<String, dynamic> contact) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('profiles').update({
        'emergency_contact': contact,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      if (e is PostgrestException) {
        throw Exception('Database error: ${e.message}. Code: ${e.code}');
      }
      throw Exception('Failed to update emergency contact: $e');
    }
  }

  Future<void> updateAllergies(List<String> allergies) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('profiles').update({
        'allergies': allergies,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      if (e is PostgrestException) {
        throw Exception('Database error: ${e.message}. Code: ${e.code}');
      }
      throw Exception('Failed to update allergies: $e');
    }
  }
} 