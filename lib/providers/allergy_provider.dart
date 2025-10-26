import 'package:flutter/foundation.dart';
import '../models/allergy.dart';
import '../database/allergy_database.dart';

class AllergyProvider with ChangeNotifier {
  List<Allergy> _allergies = [];
  bool _isLoading = false;
  String _filterType = 'All';
  String _filterSeverity = 'All';

  List<Allergy> get allergies {
    if (_filterType != 'All' && _filterSeverity != 'All') {
      return _allergies
          .where((a) => a.allergyType == _filterType && a.severity == _filterSeverity)
          .toList();
    } else if (_filterType != 'All') {
      return _allergies.where((a) => a.allergyType == _filterType).toList();
    } else if (_filterSeverity != 'All') {
      return _allergies.where((a) => a.severity == _filterSeverity).toList();
    }
    return _allergies;
  }

  bool get isLoading => _isLoading;
  String get filterType => _filterType;
  String get filterSeverity => _filterSeverity;

  AllergyProvider() {
    loadAllergies();
  }

  Future<void> loadAllergies() async {
    _isLoading = true;
    notifyListeners();

    _allergies = await AllergyDatabase.instance.readAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addAllergy(Allergy allergy) async {
    final newAllergy = await AllergyDatabase.instance.create(allergy);
    _allergies.insert(0, newAllergy);
    notifyListeners();
  }

  Future<void> updateAllergy(Allergy allergy) async {
    await AllergyDatabase.instance.update(allergy);
    final index = _allergies.indexWhere((a) => a.id == allergy.id);
    if (index != -1) {
      _allergies[index] = allergy;
      notifyListeners();
    }
  }

  Future<void> deleteAllergy(int id) async {
    await AllergyDatabase.instance.delete(id);
    _allergies.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  void setFilterType(String type) {
    _filterType = type;
    notifyListeners();
  }

  void setFilterSeverity(String severity) {
    _filterSeverity = severity;
    notifyListeners();
  }

  void clearFilters() {
    _filterType = 'All';
    _filterSeverity = 'All';
    notifyListeners();
  }

  Map<String, int> getTypeStatistics() {
    final stats = <String, int>{};
    for (var allergy in _allergies) {
      stats[allergy.allergyType] = (stats[allergy.allergyType] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> getSeverityStatistics() {
    final stats = <String, int>{};
    for (var allergy in _allergies) {
      stats[allergy.severity] = (stats[allergy.severity] ?? 0) + 1;
    }
    return stats;
  }
}