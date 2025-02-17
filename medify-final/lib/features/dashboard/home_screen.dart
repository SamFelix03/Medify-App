import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medify/core/constants/app_constants.dart';
import 'package:medify/core/services/auth_service.dart';
import 'package:medify/core/services/medical_record_service.dart';
import 'package:medify/features/records/models/medical_record.dart';
import 'package:medify/features/records/screens/add_record_screen.dart';
import 'package:medify/features/records/screens/record_details_screen.dart';
import 'package:medify/features/profile/screens/profile_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Stream<List<MedicalRecord>> _recordsStream;

  @override
  void initState() {
    super.initState();
    _recordsStream = ref.read(medicalRecordServiceProvider).watchRecords();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(authServiceProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _recordsStream = ref.read(medicalRecordServiceProvider).watchRecords();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, ${user?.email?.split('@').first ?? 'User'}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildRecentRecords(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddRecordScreen(
                initialRecordType: AppConstants.labRecordType,
              ),
            ),
          );
          // Refresh the stream after returning from AddRecordScreen
          setState(() {
            _recordsStream = ref.read(medicalRecordServiceProvider).watchRecords();
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionCard(
          context,
          icon: Icons.science_outlined,
          title: 'Lab Reports',
          color: Colors.blue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddRecordScreen(
                  initialRecordType: AppConstants.labRecordType,
                ),
              ),
            );
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.medication_outlined,
          title: 'Prescriptions',
          color: Colors.green,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddRecordScreen(
                  initialRecordType: AppConstants.prescriptionRecordType,
                ),
              ),
            );
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.healing_outlined,
          title: 'Illnesses',
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddRecordScreen(
                  initialRecordType: AppConstants.illnessRecordType,
                ),
              ),
            );
          },
        ),
        _buildActionCard(
          context,
          icon: Icons.person_outline,
          title: 'Profile',
          color: Colors.purple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentRecords(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Records',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<MedicalRecord>>(
          stream: _recordsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final records = snapshot.data ?? [];

            if (records.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.note_add_outlined,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No records yet',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add your first medical record',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: _buildRecordTypeIcon(record.recordType),
                    title: Text(record.title),
                    subtitle: Text(record.subtitle),
                    trailing: Text(
                      DateFormat('MMM d, y').format(record.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecordDetailsScreen(record: record),
                        ),
                      );
                      // Refresh the stream after returning from RecordDetailsScreen
                      setState(() {
                        _recordsStream = ref.read(medicalRecordServiceProvider).watchRecords();
                      });
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecordTypeIcon(String recordType) {
    switch (recordType) {
      case AppConstants.labRecordType:
        return const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.science_outlined, color: Colors.white),
        );
      case AppConstants.prescriptionRecordType:
        return const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.medication_outlined, color: Colors.white),
        );
      case AppConstants.illnessRecordType:
        return const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.healing_outlined, color: Colors.white),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.description_outlined, color: Colors.white),
        );
    }
  }
} 