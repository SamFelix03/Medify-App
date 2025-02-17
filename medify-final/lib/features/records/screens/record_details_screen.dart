import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medify/core/constants/app_constants.dart';
import 'package:medify/core/services/medical_record_service.dart';
import 'package:medify/features/records/models/medical_record.dart';
import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

class RecordDetailsScreen extends ConsumerStatefulWidget {
  final MedicalRecord record;

  const RecordDetailsScreen({
    super.key,
    required this.record,
  });

  @override
  ConsumerState<RecordDetailsScreen> createState() => _RecordDetailsScreenState();
}

class _RecordDetailsScreenState extends ConsumerState<RecordDetailsScreen> {
  late MedicalRecord _record;
  bool _isEditing = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  void initState() {
    super.initState();
    _record = widget.record;
    _formData.addAll(_record.data);
  }

  Future<void> _deleteRecord() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    setState(() => _isLoading = true);

    try {
      // Delete attachments first
      // for (final attachment in _record.attachments) {
      //   await ref.read(medicalRecordServiceProvider).deleteAttachment(attachment);
      // }

      // Delete the record
      await ref.read(medicalRecordServiceProvider).deleteRecord(_record.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record deleted successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting record: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateRecord() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final updatedRecord = _record.copyWith(data: _formData);
      await ref.read(medicalRecordServiceProvider).updateRecord(updatedRecord);

      setState(() {
        _record = updatedRecord;
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating record: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Future<void> _openAttachment(String path) async {
  //   try {
  //     final url = await ref
  //         .read(medicalRecordServiceProvider)
  //         ._supabase
  //         .storage
  //         .from('medical-attachments')
  //         .createSignedUrl(path, 3600); // 1 hour expiry

  //     if (await canLaunchUrl(Uri.parse(url))) {
  //       await launchUrl(Uri.parse(url));
  //     } else {
  //       throw 'Could not launch $url';
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error opening attachment: $e')),
  //       );
  //     }
  //   }
  // }

  List<Widget> _buildFormFields() {
    switch (_record.recordType) {
      case AppConstants.labRecordType:
        return [
          TextFormField(
            initialValue: _formData['test_name'],
            decoration: const InputDecoration(
              labelText: 'Test Name',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter test name' : null,
            onSaved: (value) => _formData['test_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _formData['lab_name'],
            decoration: const InputDecoration(
              labelText: 'Lab Name',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter lab name' : null,
            onSaved: (value) => _formData['lab_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _formData['test_date'],
            decoration: const InputDecoration(
              labelText: 'Test Date',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please select test date' : null,
            onSaved: (value) => _formData['test_date'] = value,
          ),
        ];

      case AppConstants.prescriptionRecordType:
        return [
          TextFormField(
            initialValue: _formData['medication_name'],
            decoration: const InputDecoration(
              labelText: 'Medication Name',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter medication name' : null,
            onSaved: (value) => _formData['medication_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _formData['dosage'],
            decoration: const InputDecoration(
              labelText: 'Dosage',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter dosage' : null,
            onSaved: (value) => _formData['dosage'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _formData['frequency'],
            decoration: const InputDecoration(
              labelText: 'Frequency',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter frequency' : null,
            onSaved: (value) => _formData['frequency'] = value,
          ),
        ];

      case AppConstants.illnessRecordType:
        return [
          TextFormField(
            initialValue: _formData['condition_name'],
            decoration: const InputDecoration(
              labelText: 'Condition Name',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter condition name' : null,
            onSaved: (value) => _formData['condition_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _formData['diagnosis_date'],
            decoration: const InputDecoration(
              labelText: 'Diagnosis Date',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please select diagnosis date' : null,
            onSaved: (value) => _formData['diagnosis_date'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            initialValue: _formData['notes'],
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
            enabled: _isEditing,
            maxLines: 3,
            onSaved: (value) => _formData['notes'] = value,
          ),
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_record.title),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deleteRecord,
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        'Record Information',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      ..._buildFormFields(),
                    ],
                  ),
                ),
              ),
              // if (_record.attachments.isNotEmpty) ...[
              //   const SizedBox(height: 24),
              //   Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Attachments',
              //             style: Theme.of(context).textTheme.titleLarge,
              //           ),
              //           const SizedBox(height: 16),
              //           ...(_record.attachments.map(
              //             (path) => ListTile(
              //               leading: const Icon(Icons.attachment),
              //               title: Text(path.split('/').last),
              //               onTap: () => _openAttachment(path),
              //             ),
              //           )),
              //         ],
              //       ),
              //     ),
              //   ),
              // ],
              const SizedBox(height: 24),
              if (_isEditing)
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateRecord,
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