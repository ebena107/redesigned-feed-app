import 'dart:convert';

import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';

/// Record of a saved feed formulation
class FormulationRecord {
  const FormulationRecord({
    this.id,
    required this.animalTypeId,
    this.feedType,
    this.formulationName,
    required this.createdAt,
    required this.constraints,
    required this.selectedIngredientIds,
    required this.result,
    this.notes,
  });

  final int? id;
  final int animalTypeId;
  final String? feedType;
  final String? formulationName;
  final DateTime createdAt;
  final List<NutrientConstraint> constraints;
  final List<int> selectedIngredientIds;
  final FormulatorResult result;
  final String? notes;

  /// Convert to database JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'animal_type_id': animalTypeId,
      'feed_type': feedType,
      'formulation_name': formulationName,
      'created_at': createdAt.millisecondsSinceEpoch ~/ 1000, // Unix timestamp
      'constraints_json': jsonEncode(
        constraints.map((c) => c.toJson()).toList(),
      ),
      'selected_ingredient_ids': jsonEncode(selectedIngredientIds),
      'result_json': jsonEncode(_resultToJson(result)),
      'status': result.status,
      'cost_per_kg': result.costPerKg,
      'notes': notes,
    };
  }

  /// Create from database JSON
  factory FormulationRecord.fromJson(Map<String, dynamic> json) {
    return FormulationRecord(
      id: json['id'] as int?,
      animalTypeId: json['animal_type_id'] as int,
      feedType: json['feed_type'] as String?,
      formulationName: json['formulation_name'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (json['created_at'] as int) * 1000,
      ),
      constraints: (jsonDecode(json['constraints_json'] as String) as List)
          .map((c) => NutrientConstraint.fromJson(c as Map<String, dynamic>))
          .toList(),
      selectedIngredientIds:
          (jsonDecode(json['selected_ingredient_ids'] as String) as List)
              .map((id) => id as int)
              .toList(),
      result: _resultFromJson(
          jsonDecode(json['result_json'] as String) as Map<String, dynamic>),
      notes: json['notes'] as String?,
    );
  }

  /// Convert FormulatorResult to JSON
  static Map<String, dynamic> _resultToJson(FormulatorResult result) {
    return {
      'ingredientPercents': result.ingredientPercents,
      'costPerKg': result.costPerKg,
      'nutrients':
          result.nutrients.map((key, value) => MapEntry(key.index, value)),
      'status': result.status,
      'warnings': result.warnings,
      'limitingNutrients':
          result.limitingNutrients.map((k) => k.index).toList(),
      'sensitivity': result.sensitivity,
    };
  }

  /// Create FormulatorResult from JSON
  static FormulatorResult _resultFromJson(Map<String, dynamic> json) {
    return FormulatorResult(
      ingredientPercents: (json['ingredientPercents'] as Map<String, dynamic>)
          .map((key, value) =>
              MapEntry(num.parse(key), (value as num).toDouble())),
      costPerKg: (json['costPerKg'] as num).toDouble(),
      nutrients: (json['nutrients'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          NutrientKey.values[int.parse(key)],
          (value as num).toDouble(),
        ),
      ),
      status: json['status'] as String,
      warnings: (json['warnings'] as List).map((w) => w as String).toList(),
      limitingNutrients: (json['limitingNutrients'] as List)
          .map((i) => NutrientKey.values[i as int])
          .toList(),
      sensitivity: (json['sensitivity'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(num.parse(key), (value as num).toDouble())),
    );
  }

  FormulationRecord copyWith({
    int? id,
    int? animalTypeId,
    String? feedType,
    String? formulationName,
    DateTime? createdAt,
    List<NutrientConstraint>? constraints,
    List<int>? selectedIngredientIds,
    FormulatorResult? result,
    String? notes,
  }) {
    return FormulationRecord(
      id: id ?? this.id,
      animalTypeId: animalTypeId ?? this.animalTypeId,
      feedType: feedType ?? this.feedType,
      formulationName: formulationName ?? this.formulationName,
      createdAt: createdAt ?? this.createdAt,
      constraints: constraints ?? this.constraints,
      selectedIngredientIds:
          selectedIngredientIds ?? this.selectedIngredientIds,
      result: result ?? this.result,
      notes: notes ?? this.notes,
    );
  }
}
