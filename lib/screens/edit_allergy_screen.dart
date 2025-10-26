import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/allergy.dart';
import '../providers/allergy_provider.dart';

class EditAllergyScreen extends StatefulWidget {
  final Allergy allergy;

  const EditAllergyScreen({super.key, required this.allergy});

  @override
  State<EditAllergyScreen> createState() => _EditAllergyScreenState();
}

class _EditAllergyScreenState extends State<EditAllergyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _allergenNameController;
  late TextEditingController _symptomsController;
  late TextEditingController _treatmentController;
  late TextEditingController _notesController;

  late String _selectedType;
  late String _selectedSeverity;
  late DateTime _selectedDate;
  late bool _isActive;

  final List<String> _types = ['Food', 'Drug', 'Environmental', 'Insect', 'Other'];
  final List<String> _severities = ['Mild', 'Moderate', 'Severe'];

  @override
  void initState() {
    super.initState();
    _allergenNameController = TextEditingController(text: widget.allergy.allergenName);
    _symptomsController = TextEditingController(text: widget.allergy.symptoms);
    _treatmentController = TextEditingController(text: widget.allergy.treatment ?? '');
    _notesController = TextEditingController(text: widget.allergy.notes ?? '');
    
    _selectedType = widget.allergy.allergyType;
    _selectedSeverity = widget.allergy.severity;
    _selectedDate = widget.allergy.diagnosedDate;
    _isActive = widget.allergy.isActive;
  }

  @override
  void dispose() {
    _allergenNameController.dispose();
    _symptomsController.dispose();
    _treatmentController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _updateAllergy() {
    if (_formKey.currentState!.validate()) {
      final updatedAllergy = widget.allergy.copyWith(
        allergenName: _allergenNameController.text,
        allergyType: _selectedType,
        severity: _selectedSeverity,
        symptoms: _symptomsController.text,
        treatment: _treatmentController.text.isEmpty ? null : _treatmentController.text,
        diagnosedDate: _selectedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        isActive: _isActive,
      );

      Provider.of<AllergyProvider>(context, listen: false).updateAllergy(updatedAllergy);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Allergy updated successfully')),
      );
      
      Navigator.pop(context);
    }
  }

  void _deleteAllergy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this allergy?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AllergyProvider>(context, listen: false)
                  .deleteAllergy(widget.allergy.id!);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Allergy deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Allergy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAllergy,
            tooltip: 'Delete',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _allergenNameController,
              decoration: const InputDecoration(
                labelText: 'Allergen Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medical_information),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter allergen name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Allergy Type *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: _types.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Severity *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.warning),
              ),
              items: _severities.map((severity) {
                return DropdownMenuItem(value: severity, child: Text(severity));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _symptomsController,
              decoration: const InputDecoration(
                labelText: 'Symptoms *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.local_hospital),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter symptoms';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _treatmentController,
              decoration: const InputDecoration(
                labelText: 'Treatment',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.medication),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Diagnosed Date'),
              subtitle: Text(DateFormat('MMMM dd, yyyy').format(_selectedDate)),
              leading: const Icon(Icons.calendar_today),
              trailing: const Icon(Icons.edit),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              onTap: _selectDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Currently Active'),
              subtitle: const Text('Is this allergy still active?'),
              value: _isActive,
              onChanged: (value) {
                setState(() {
                  _isActive = value;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _updateAllergy,
              icon: const Icon(Icons.save),
              label: const Text('Update Allergy'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}