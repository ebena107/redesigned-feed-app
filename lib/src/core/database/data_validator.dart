import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

/// Result of nutritional data validation
class ValidationResult {
  final bool isValid;
  final List<String> errors;

  const ValidationResult({
    required this.isValid,
    required this.errors,
  });

  factory ValidationResult.success() {
    return const ValidationResult(isValid: true, errors: []);
  }

  factory ValidationResult.failure(List<String> errors) {
    return ValidationResult(isValid: false, errors: errors);
  }
}

/// Validates nutritional data for ingredients to prevent data quality issues
class NutritionalDataValidator {
  /// Validates an ingredient's nutritional data
  static ValidationResult validate(Ingredient ingredient) {
    final errors = <String>[];

    // Check for negative values
    if (ingredient.crudeProtein != null && ingredient.crudeProtein! < 0) {
      errors.add('Protein cannot be negative');
    }
    if (ingredient.crudeFiber != null && ingredient.crudeFiber! < 0) {
      errors.add('Fiber cannot be negative');
    }
    if (ingredient.crudeFat != null && ingredient.crudeFat! < 0) {
      errors.add('Fat cannot be negative');
    }
    if (ingredient.calcium != null && ingredient.calcium! < 0) {
      errors.add('Calcium cannot be negative');
    }
    if (ingredient.phosphorus != null && ingredient.phosphorus! < 0) {
      errors.add('Phosphorus cannot be negative');
    }
    if (ingredient.lysine != null && ingredient.lysine! < 0) {
      errors.add('Lysine cannot be negative');
    }
    if (ingredient.methionine != null && ingredient.methionine! < 0) {
      errors.add('Methionine cannot be negative');
    }

    // Check for impossible values - fiber should not be zero for bran products
    if (ingredient.name != null &&
        ingredient.name!.toLowerCase().contains('bran') &&
        (ingredient.crudeFiber == null || ingredient.crudeFiber == 0.0)) {
      errors.add('Bran products should have fiber content greater than zero');
    }

    // Check total nutritional content doesn't exceed 100%
    // Note: Exclude mineral supplements and additives from this check
    final isMineralSupplement = ingredient.name != null &&
        (ingredient.name!.toLowerCase().contains('calcium') ||
            ingredient.name!.toLowerCase().contains('phosphate') ||
            ingredient.name!.toLowerCase().contains('limestone') ||
            ingredient.name!.toLowerCase().contains('shell') ||
            ingredient.name!.toLowerCase().contains('bone meal') ||
            ingredient.name!.toLowerCase().contains('dolomite'));

    if (!isMineralSupplement) {
      final protein = ingredient.crudeProtein ?? 0;
      final fat = ingredient.crudeFat ?? 0;
      final fiber = ingredient.crudeFiber ?? 0;

      final total = protein + fat + fiber;
      if (total > 100) {
        errors.add(
            'Total nutritional content (protein + fat + fiber) exceeds 100%');
      }
    }

    // Check energy values are within reasonable range
    // Industry standards:
    // - Pure oils/fats (>90% fat): up to 10000 kcal/kg
    // - High-fat ingredients (>40% fat): up to 6000 kcal/kg
    // - Amino acid supplements: up to 6000 kcal/kg (pure amino acids have high energy)
    // - Regular ingredients: up to 5000 kcal/kg
    final fatContent = ingredient.crudeFat ?? 0;
    final isAminoAcid = ingredient.name != null &&
        (ingredient.name!.toLowerCase().contains('methionine') ||
            ingredient.name!.toLowerCase().contains('lysine') ||
            ingredient.name!.toLowerCase().contains('threonine') ||
            ingredient.name!.toLowerCase().contains('tryptophan'));

    final maxME = fatContent > 90
        ? 10000
        : (fatContent > 40 || isAminoAcid ? 6000 : 5000);

    if (ingredient.meGrowingPig != null && ingredient.meGrowingPig! > maxME) {
      errors.add('ME for growing pig seems unusually high (>$maxME kcal/kg)');
    }
    if (ingredient.mePoultry != null && ingredient.mePoultry! > maxME) {
      errors.add('ME for poultry seems unusually high (>$maxME kcal/kg)');
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }

  /// Validates a list of ingredients
  static Map<int, ValidationResult> validateBatch(
      List<Ingredient> ingredients) {
    final results = <int, ValidationResult>{};

    for (var ingredient in ingredients) {
      if (ingredient.ingredientId != null) {
        final id = ingredient.ingredientId!.toInt();
        results[id] = validate(ingredient);
      }
    }

    return results;
  }
}
