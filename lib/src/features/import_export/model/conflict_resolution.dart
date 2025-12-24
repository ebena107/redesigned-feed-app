import 'package:equatable/equatable.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

enum MergeStrategy {
  skip, // Keep existing, discard imported
  replace, // Replace existing with imported
  merge, // Combine fields, user reviews conflicts
}

/// Represents a conflict between imported and existing ingredient
class ConflictPair extends Equatable {
  final Ingredient existingIngredient;
  final Ingredient importedIngredient;
  final double nameSimilarity; // 0.0-1.0
  final String
      conflictReason; // Why detected (name similarity, duplicate protein, etc)
  late final MergeStrategy suggestedStrategy;

  ConflictPair({
    required this.existingIngredient,
    required this.importedIngredient,
    required this.nameSimilarity,
    required this.conflictReason,
    MergeStrategy? suggestedStrategy,
  }) {
    // Determine suggested strategy
    if (nameSimilarity >= 0.95) {
      this.suggestedStrategy = MergeStrategy.replace;
    } else if (nameSimilarity >= 0.85) {
      // Check if only prices differ
      final proteinDiff = (existingIngredient.crudeProtein ?? 0) -
          (importedIngredient.crudeProtein ?? 0);
      if (proteinDiff.abs() < 0.5) {
        this.suggestedStrategy = MergeStrategy.skip; // Keep existing
      } else {
        this.suggestedStrategy = MergeStrategy.merge; // Flag for review
      }
    } else {
      this.suggestedStrategy = suggestedStrategy ?? MergeStrategy.skip;
    }
  }

  /// Display name for conflict (existing vs imported)
  String get displayName =>
      '${existingIngredient.name} ↔ ${importedIngredient.name}';

  /// Similarity as percentage
  String get similarityPercent =>
      '${(nameSimilarity * 100).toStringAsFixed(0)}%';

  @override
  List<Object?> get props => [
        existingIngredient,
        importedIngredient,
        nameSimilarity,
        conflictReason,
      ];
}

/// User's decision for a specific conflict
class ConflictDecision extends Equatable {
  final String conflictDisplayName;
  final MergeStrategy decision;
  final String? customNotes;

  const ConflictDecision({
    required this.conflictDisplayName,
    required this.decision,
    this.customNotes,
  });

  @override
  List<Object?> get props => [conflictDisplayName, decision, customNotes];
}
