import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/allergy_provider.dart';
import '../widgets/allergy_card.dart';
import 'add_allergy_screen.dart';
import 'edit_allergy_screen.dart';
import 'package:hugeicons/hugeicons.dart';

class AllergyListScreen extends StatelessWidget {
  const AllergyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allergy Management'),
        actions: [
          PopupMenuButton<String>(
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedFilterMailSquare),
            onSelected: (value) {
              final provider = Provider.of<AllergyProvider>(
                context,
                listen: false,
              );
              if (value == 'Clear') {
                provider.clearFilters();
              } else if ([
                'Food',
                'Drug',
                'Environmental',
                'Insect',
                'Other',
              ].contains(value)) {
                provider.setFilterType(value);
              } else if (['Mild', 'Moderate', 'Severe'].contains(value)) {
                provider.setFilterSeverity(value);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Clear', child: Text('Clear Filters')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter by Type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuItem(value: 'Food', child: Text('Food')),
              const PopupMenuItem(value: 'Drug', child: Text('Drug')),
              const PopupMenuItem(
                value: 'Environmental',
                child: Text('Environmental'),
              ),
              const PopupMenuItem(value: 'Insect', child: Text('Insect')),
              const PopupMenuItem(value: 'Other', child: Text('Other')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text(
                  'Filter by Severity:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const PopupMenuItem(value: 'Mild', child: Text('Mild')),
              const PopupMenuItem(value: 'Moderate', child: Text('Moderate')),
              const PopupMenuItem(value: 'Severe', child: Text('Severe')),
            ],
          ),
        ],
      ),
      body: Consumer<AllergyProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.allergies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedMedicalFile,
                    color: Colors.grey[400],
                    size: 80.0,
                  ),
                  // Icon(Icons.medical_information_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No allergies recorded',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first allergy',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              if (provider.filterType != 'All' ||
                  provider.filterSeverity != 'All')
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Filters: ${provider.filterType != 'All' ? provider.filterType : ''} ${provider.filterSeverity != 'All' ? provider.filterSeverity : ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () => provider.clearFilters(),
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.loadAllergies(),
                  child: ListView.builder(
                    itemCount: provider.allergies.length,
                    itemBuilder: (context, index) {
                      final allergy = provider.allergies[index];
                      return AllergyCard(
                        allergy: allergy,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditAllergyScreen(allergy: allergy),
                            ),
                          );
                        },
                        onDelete: () {
                          provider.deleteAllergy(allergy.id!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Allergy deleted')),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAllergyScreen()),
          );
        },
        icon: const HugeIcon(icon: HugeIcons.strokeRoundedPlusSign),
        label: const Text('Add Allergy'),
      ),
    );
  }
}
