import 'package:equatable/equatable.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

/// Result of import operation
class ImportResult extends Equatable {
  final int importedCount; // New ingredients added
  final int updatedCount; // Existing ingredients replaced
  final int skippedCount; // Duplicates skipped
  final List<Ingredient> createdIngredients;
  final List<Ingredient> updatedIngredients;
  final List<String> errors;
  final DateTime completedAt;

  const ImportResult({
    required this.importedCount,
    required this.updatedCount,
    required this.skippedCount,
    required this.createdIngredients,
    required this.updatedIngredients,
    required this.errors,
    required this.completedAt,
  });

  /// Total ingredients processed (imported + updated + skipped)
  int get totalProcessed => importedCount + updatedCount + skippedCount;

  /// Success rate (0-1)
  double get successRate {
    if (totalProcessed == 0) return 0;
    return (importedCount + updatedCount) / totalProcessed;
  }

  /// Success percentage
  String get successPercent => '${(successRate * 100).toStringAsFixed(1)}%';

  /// Summary text for display
  String get summary {
    final parts = <String>[];
    if (importedCount > 0) parts.add('$importedCount new');
    if (updatedCount > 0) parts.add('$updatedCount updated');
    if (skippedCount > 0) parts.add('$skippedCount skipped');
    if (errors.isNotEmpty) parts.add('${errors.length} errors');
    return parts.join(', ');
  }

  /// Whether import was fully successful
  bool get isSuccessful => errors.isEmpty;

  ImportResult copyWith({
    int? importedCount,
    int? updatedCount,
    int? skippedCount,
    List<Ingredient>? createdIngredients,
    List<Ingredient>? updatedIngredients,
    List<String>? errors,
    DateTime? completedAt,
  }) {
    return ImportResult(
      importedCount: importedCount ?? this.importedCount,
      updatedCount: updatedCount ?? this.updatedCount,
      skippedCount: skippedCount ?? this.skippedCount,
      createdIngredients: createdIngredients ?? this.createdIngredients,
      updatedIngredients: updatedIngredients ?? this.updatedIngredients,
      errors: errors ?? this.errors,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  List<Object?> get props => [
        importedCount,
        updatedCount,
        skippedCount,
        createdIngredients,
        updatedIngredients,
        errors,
        completedAt,
      ];
}
