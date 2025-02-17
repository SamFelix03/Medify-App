import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medify/core/services/auth_service.dart';
import 'package:medify/features/profile/models/profile.dart';
import 'package:medify/features/profile/services/profile_service.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditing = false;
  Profile? _profile;

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedBloodGroup;
  final List<String> _allergies = [];
  final Map<String, dynamic> _emergencyContact = {};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ref.read(profileServiceProvider).getProfile();
      if (profile != null) {
        setState(() {
          _profile = profile;
          _fullNameController.text = profile.fullName ?? '';
          _phoneController.text = profile.phoneNumber ?? '';
          _selectedDate = profile.dateOfBirth;
          if (_selectedDate != null) {
            _dateController.text = DateFormat('MMM d, y').format(_selectedDate!);
          }
          _selectedBloodGroup = profile.bloodGroup;
          _allergies.clear();
          _allergies.addAll(profile.allergies);
          _emergencyContact.clear();
          _emergencyContact.addAll(profile.emergencyContact);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = ref.read(authServiceProvider).currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final updatedProfile = Profile(
        id: userId,
        email: ref.read(authServiceProvider).currentUser!.email!,
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        dateOfBirth: _selectedDate,
        bloodGroup: _selectedBloodGroup,
        allergies: _allergies,
        emergencyContact: _emergencyContact,
        updatedAt: DateTime.now(),
      );

      await ref.read(profileServiceProvider).updateProfile(updatedProfile);

      setState(() {
        _profile = updatedProfile;
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _dateController.text = DateFormat('MMM d, y').format(date);
      });
    }
  }

  void _addAllergy() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Allergy'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Allergy',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _allergies.add(controller.text.trim());
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updateEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(
          text: _emergencyContact['name'] as String? ?? '',
        );
        final relationController = TextEditingController(
          text: _emergencyContact['relation'] as String? ?? '',
        );
        final phoneController = TextEditingController(
          text: _emergencyContact['phone'] as String? ?? '',
        );

        return AlertDialog(
          title: const Text('Emergency Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: relationController,
                decoration: const InputDecoration(
                  labelText: 'Relation',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _emergencyContact['name'] = nameController.text.trim();
                  _emergencyContact['relation'] = relationController.text.trim();
                  _emergencyContact['phone'] = phoneController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personal Information',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _fullNameController,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                              enabled: _isEditing,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'Please enter your name'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                border: OutlineInputBorder(),
                              ),
                              enabled: _isEditing,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date of Birth',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                                hintText: 'YYYY-MM-DD',
                              ),
                              enabled: _isEditing,
                              readOnly: false,
                              onChanged: (value) {
                                try {
                                  if (value.isNotEmpty) {
                                    final date = DateTime.parse(value);
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                  }
                                } catch (e) {
                                  // Invalid date format
                                }
                              },
                              onTap: _isEditing ? () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  setState(() {
                                    _selectedDate = date;
                                    _dateController.text = DateFormat('yyyy-MM-dd').format(date);
                                  });
                                }
                              } : null,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  try {
                                    DateTime.parse(value);
                                    return null;
                                  } catch (e) {
                                    return 'Please enter a valid date (YYYY-MM-DD)';
                                  }
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedBloodGroup,
                              decoration: const InputDecoration(
                                labelText: 'Blood Group',
                                border: OutlineInputBorder(),
                              ),
                              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                                  .map((group) => DropdownMenuItem(
                                        value: group,
                                        child: Text(group),
                                      ))
                                  .toList(),
                              onChanged: _isEditing
                                  ? (value) {
                                      setState(
                                          () => _selectedBloodGroup = value);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Allergies',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                if (_isEditing)
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: _addAllergy,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: _allergies.map((allergy) {
                                return Chip(
                                  label: Text(allergy),
                                  onDeleted: _isEditing
                                      ? () {
                                          setState(() {
                                            _allergies.remove(allergy);
                                          });
                                        }
                                      : null,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Emergency Contact',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                if (_isEditing)
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: _updateEmergencyContact,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_emergencyContact.isNotEmpty) ...[
                              ListTile(
                                title: Text(_emergencyContact['name'] ?? ''),
                                subtitle: Text(
                                    '${_emergencyContact['relation'] ?? ''} • ${_emergencyContact['phone'] ?? ''}'),
                              ),
                            ] else
                              const Text('No emergency contact added'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Save Changes'),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
} 