class Allergy {
  int? id;
  String allergenName;
  String allergyType;
  String severity;
  String symptoms;
  String? treatment;
  DateTime diagnosedDate;
  String? notes;
  bool isActive;

  Allergy({
    this.id,
    required this.allergenName,
    required this.allergyType,
    required this.severity,
    required this.symptoms,
    this.treatment,
    required this.diagnosedDate,
    this.notes,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'allergen_name': allergenName,
      'allergy_type': allergyType,
      'severity': severity,
      'symptoms': symptoms,
      'treatment': treatment,
      'diagnosed_date': diagnosedDate.toIso8601String(),
      'notes': notes,
      'is_active': isActive ? 1 : 0,
    };
  }

  factory Allergy.fromMap(Map<String, dynamic> map) {
    return Allergy(
      id: map['id'],
      allergenName: map['allergen_name'],
      allergyType: map['allergy_type'],
      severity: map['severity'],
      symptoms: map['symptoms'],
      treatment: map['treatment'],
      diagnosedDate: DateTime.parse(map['diagnosed_date']),
      notes: map['notes'],
      isActive: map['is_active'] == 1,
    );
  }

  Allergy copyWith({
    int? id,
    String? allergenName,
    String? allergyType,
    String? severity,
    String? symptoms,
    String? treatment,
    DateTime? diagnosedDate,
    String? notes,
    bool? isActive,
  }) {
    return Allergy(
      id: id ?? this.id,
      allergenName: allergenName ?? this.allergenName,
      allergyType: allergyType ?? this.allergyType,
      severity: severity ?? this.severity,
      symptoms: symptoms ?? this.symptoms,
      treatment: treatment ?? this.treatment,
      diagnosedDate: diagnosedDate ?? this.diagnosedDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }
}