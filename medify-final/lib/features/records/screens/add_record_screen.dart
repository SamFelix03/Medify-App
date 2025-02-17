import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:medify/core/constants/app_constants.dart';
import 'package:medify/core/services/medical_record_service.dart';
import 'package:intl/intl.dart';

class AddRecordScreen extends ConsumerStatefulWidget {
  final String initialRecordType;

  const AddRecordScreen({
    super.key,
    required this.initialRecordType,
  });

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedRecordType;
  final Map<String, dynamic> _formData = {};
  // final List<PlatformFile> _selectedFiles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRecordType = widget.initialRecordType;
  }

  // Future<void> _pickFiles() async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  //       allowMultiple: true,
  //     );

  //     if (result != null) {
  //       setState(() {
  //         _selectedFiles.addAll(result.files);
  //       });
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error picking files: $e')),
  //     );
  //   }
  // }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      // const attachments = <String>[];
      
      // Upload attachments
      // for (final file in _selectedFiles) {
      //   final path = await ref
      //       .read(medicalRecordServiceProvider)
      //       .uploadAttachment(file.path!);
      //   attachments.add(path);
      // }

      // Create record
      await ref.read(medicalRecordServiceProvider).createRecord(
            recordType: _selectedRecordType,
            data: _formData,
            attachments: const [],
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record added successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding record: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Widget> _buildFormFields() {
    switch (_selectedRecordType) {
      case AppConstants.labRecordType:
        return [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Test Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter test name' : null,
            onSaved: (value) => _formData['test_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Lab Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter lab name' : null,
            onSaved: (value) => _formData['lab_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Test Date',
              border: OutlineInputBorder(),
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _formData['test_date'] = DateFormat('yyyy-MM-dd').format(date);
              }
            },
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please select test date' : null,
          ),
        ];

      case AppConstants.prescriptionRecordType:
        return [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Medication Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter medication name' : null,
            onSaved: (value) => _formData['medication_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Dosage',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter dosage' : null,
            onSaved: (value) => _formData['dosage'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Frequency',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter frequency' : null,
            onSaved: (value) => _formData['frequency'] = value,
          ),
        ];

      case AppConstants.illnessRecordType:
        return [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Condition Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter condition name' : null,
            onSaved: (value) => _formData['condition_name'] = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Diagnosis Date',
              border: OutlineInputBorder(),
            ),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                _formData['diagnosis_date'] =
                    DateFormat('yyyy-MM-dd').format(date);
              }
            },
            validator: (value) =>
                value?.isEmpty ?? true ? 'Please select diagnosis date' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
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
        title: const Text('Add Medical Record'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedRecordType,
                decoration: const InputDecoration(
                  labelText: 'Record Type',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: AppConstants.labRecordType,
                    child: const Text('Lab Report'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.prescriptionRecordType,
                    child: const Text('Prescription'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.illnessRecordType,
                    child: const Text('Medical Condition'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRecordType = value;
                      _formData.clear();
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              ..._buildFormFields(),
              const SizedBox(height: 24),
              // ElevatedButton.icon(
              //   onPressed: _pickFiles,
              //   icon: const Icon(Icons.attach_file),
              //   label: const Text('Add Attachments'),
              // ),
              // if (_selectedFiles.isNotEmpty) ...[
              //   const SizedBox(height: 16),
              //   Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(8),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           const Text(
              //             'Selected Files:',
              //             style: TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //           const SizedBox(height: 8),
              //           ...(_selectedFiles.map(
              //             (file) => ListTile(
              //               title: Text(file.name),
              //               trailing: IconButton(
              //                 icon: const Icon(Icons.close),
              //                 onPressed: () {
              //                   setState(() {
              //                     _selectedFiles.remove(file);
              //                   });
              //                 },
              //               ),
              //             ),
              //           )),
              //         ],
              //       ),
              //     ),
              //   ),
              // ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 