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
  });

  final int animalTypeId;
  final FeedType feedType;
  final List<NutrientConstraint> constraints;
  final Set<num> selectedIngredientIds;
  final bool enforceMaxInclusion;

  FormulatorInput copyWith({
    int? animalTypeId,
    FeedType? feedType,
    List<NutrientConstraint>? constraints,
    Set<num>? selectedIngredientIds,
    bool? enforceMaxInclusion,
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
  });

  @override
  FormulatorInput copyWith({
    int? animalTypeId,
    FeedType? feedType,
    List<NutrientConstraint>? constraints,
    Set<num>? selectedIngredientIds,
    bool? enforceMaxInclusion,
  }) {
    return _FormulatorInput(
      animalTypeId: animalTypeId ?? this.animalTypeId,
      feedType: feedType ?? this.feedType,
      constraints: constraints ?? this.constraints,
      selectedIngredientIds:
          selectedIngredientIds ?? this.selectedIngredientIds,
      enforceMaxInclusion: enforceMaxInclusion ?? this.enforceMaxInclusion,
    );
  }
}
