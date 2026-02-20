import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/nutrient_requirements.dart';

/// Input parameters for feed formulation
sealed class FormulatorInput {
  const FormulatorInput({
    required this.animalTypeId,
    required this.feedType,
    required this.constraints,
    required this.selectedIngredientIds,
    required this.enforceMaxInclusion,
    required this.priceOverrides,
    required this.maxInclusionOverrides,
  });

  final int animalTypeId;
  final FeedType feedType;
  final List<NutrientConstraint> constraints;
  final Set<num> selectedIngredientIds;
  final bool enforceMaxInclusion;

  /// User-defined overrides for ingredient price per kg
  final Map<num, double> priceOverrides;

  /// User-defined overrides for ingredient maximum inclusion percentage
  final Map<num, double> maxInclusionOverrides;

  FormulatorInput copyWith({
    int? animalTypeId,
    FeedType? feedType,
    List<NutrientConstraint>? constraints,
    Set<num>? selectedIngredientIds,
    bool? enforceMaxInclusion,
    Map<num, double>? priceOverrides,
    Map<num, double>? maxInclusionOverrides,
  });

  static FormulatorInput initial() {
    // Load default requirements for Pig/Starter
    final defaults = NutrientRequirements.getDefaults(1, FeedType.starter);
    return _FormulatorInput(
      animalTypeId: 1,
      feedType: FeedType.starter,
      constraints: defaults.constraints,
      selectedIngredientIds: {},
      enforceMaxInclusion: true,
      priceOverrides: {},
      maxInclusionOverrides: {},
    );
  }
}

/// Private implementation of FormulatorInput
class _FormulatorInput extends FormulatorInput {
  const _FormulatorInput({
    required super.animalTypeId,
    required super.feedType,
    required super.constraints,
    required super.selectedIngredientIds,
    required super.enforceMaxInclusion,
    required super.priceOverrides,
    required super.maxInclusionOverrides,
  });

  @override
  FormulatorInput copyWith({
    int? animalTypeId,
    FeedType? feedType,
    List<NutrientConstraint>? constraints,
    Set<num>? selectedIngredientIds,
    bool? enforceMaxInclusion,
    Map<num, double>? priceOverrides,
    Map<num, double>? maxInclusionOverrides,
  }) {
    return _FormulatorInput(
      animalTypeId: animalTypeId ?? this.animalTypeId,
      feedType: feedType ?? this.feedType,
      constraints: constraints ?? this.constraints,
      selectedIngredientIds:
          selectedIngredientIds ?? this.selectedIngredientIds,
      enforceMaxInclusion: enforceMaxInclusion ?? this.enforceMaxInclusion,
      priceOverrides: priceOverrides ?? this.priceOverrides,
      maxInclusionOverrides:
          maxInclusionOverrides ?? this.maxInclusionOverrides,
    );
  }
}
