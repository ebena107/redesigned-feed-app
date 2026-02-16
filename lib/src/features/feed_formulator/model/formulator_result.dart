import 'formulator_constraint.dart';

class FormulatorResult {
  const FormulatorResult({
    required this.ingredientPercents,
    required this.costPerKg,
    required this.nutrients,
    required this.status,
    this.warnings = const [],
    this.limitingNutrients = const [],
    this.sensitivity = const {},
  });

  final Map<num, double> ingredientPercents;
  final double costPerKg;
  final Map<NutrientKey, double> nutrients;
  final String status;
  final List<String> warnings;
  final List<NutrientKey> limitingNutrients;
  final Map<num, double> sensitivity;
}
