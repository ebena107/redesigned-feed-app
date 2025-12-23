import 'package:feed_estimator/src/core/utils/logger.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/import_export/service/conflict_detector.dart';
import 'package:feed_estimator/src/features/import_export/service/csv_parser_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String _tag = 'ImportWizardProvider';

enum ImportWizardStep {
  fileSelection,
  dataPreview,
  conflictResolution,
  importing
}

class ImportWizardState {
  final ImportWizardStep currentStep;
  final String? selectedFilePath;
  final ParsedCSVFile? parsedCSV;
  final List<Ingredient>? importedIngredients;
  final List<ConflictPair>? conflicts;
  final Map<String, MergeStrategy>? userDecisions; // Key: conflict.displayName
  final int importedCount;
  final int updatedCount;
  final bool isImporting;
  final String? error;

  const ImportWizardState({
    this.currentStep = ImportWizardStep.fileSelection,
    this.selectedFilePath,
    this.parsedCSV,
    this.importedIngredients,
    this.conflicts,
    this.userDecisions,
    this.importedCount = 0,
    this.updatedCount = 0,
    this.isImporting = false,
    this.error,
  });

  ImportWizardState copyWith({
    ImportWizardStep? currentStep,
    String? selectedFilePath,
    ParsedCSVFile? parsedCSV,
    List<Ingredient>? importedIngredients,
    List<ConflictPair>? conflicts,
    Map<String, MergeStrategy>? userDecisions,
    int? importedCount,
    int? updatedCount,
    bool? isImporting,
    String? error,
  }) {
    return ImportWizardState(
      currentStep: currentStep ?? this.currentStep,
      selectedFilePath: selectedFilePath ?? this.selectedFilePath,
      parsedCSV: parsedCSV ?? this.parsedCSV,
      importedIngredients: importedIngredients ?? this.importedIngredients,
      conflicts: conflicts ?? this.conflicts,
      userDecisions: userDecisions ?? this.userDecisions,
      importedCount: importedCount ?? this.importedCount,
      updatedCount: updatedCount ?? this.updatedCount,
      isImporting: isImporting ?? this.isImporting,
      error: error,
    );
  }
}

class ImportWizardNotifier extends Notifier<ImportWizardState> {
  @override
  ImportWizardState build() {
    return const ImportWizardState();
  }

  /// Step 1: Select and parse CSV file
  Future<void> selectAndParseFile(String filePath) async {
    state = state.copyWith(
      selectedFilePath: filePath,
      error: null,
    );

    try {
      final parsed = await CsvParserService.parseCSVFile(filePath);

      // Validate headers
      final headerErrors = CsvParserService.validateHeaders(parsed.headers);
      if (headerErrors.isNotEmpty) {
        state = state.copyWith(
          error:
              'Missing required fields: ${headerErrors.map((e) => e.message).join(', ')}',
        );
        return;
      }

      // Parse data rows
      final rows = CsvParserService.parseDataRows(
        parsed.headers,
        parsed.dataRows,
      );
      final ingredients = <Ingredient>[];
      for (final row in rows) {
        if (!row.isValid) {
          // Skip invalid rows
          continue;
        }
        try {
          final ing = CsvParserService.csvRowToIngredient(row);
          ingredients.add(ing);
        } catch (e) {
          // Log but continue
          AppLogger.warning(
            'Failed to parse row ${row.rowNumber}: $e',
            tag: _tag,
          );
        }
      }

      if (ingredients.isEmpty) {
        state = state.copyWith(
          error: 'No valid ingredients found in CSV',
        );
        return;
      }

      AppLogger.info(
        'Parsed CSV: ${ingredients.length} ingredients from ${filePath}',
        tag: _tag,
      );

      state = state.copyWith(
        parsedCSV: parsed,
        importedIngredients: ingredients,
        currentStep: ImportWizardStep.dataPreview,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to parse CSV: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(error: 'Failed to parse CSV: $e');
    }
  }

  /// Step 2: Review data and proceed to conflict detection
  Future<void> proceedToConflictResolution() async {
    if (state.importedIngredients == null) {
      state = state.copyWith(error: 'No ingredients loaded');
      return;
    }

    try {
      // Get existing ingredients from DB
      final existingIng = await ref.read(ingredientsRepository).getAll();

      // Find conflicts
      final conflicts = ConflictDetector.findDuplicates(
        importedList: state.importedIngredients!,
        existingList: existingIng,
      );

      // Initialize user decisions with suggested strategies
      final decisions = <String, MergeStrategy>{};
      for (final conflict in conflicts) {
        decisions[conflict.displayName] = conflict.suggestedStrategy;
      }

      AppLogger.info(
        'Found ${conflicts.length} conflicts for resolution',
        tag: _tag,
      );

      state = state.copyWith(
        conflicts: conflicts,
        userDecisions: decisions,
        currentStep: ImportWizardStep.conflictResolution,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to detect conflicts: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(error: 'Failed to detect conflicts: $e');
    }
  }

  /// Update user decision for a conflict
  void setConflictDecision(ConflictPair conflict, MergeStrategy strategy) {
    final decisions = Map<String, MergeStrategy>.from(
      state.userDecisions ?? {},
    );
    decisions[conflict.displayName] = strategy;
    state = state.copyWith(userDecisions: decisions);
  }

  /// Step 3: Execute import with conflict resolutions
  Future<void> executeImport() async {
    if (state.importedIngredients == null || state.conflicts == null) {
      state = state.copyWith(error: 'Missing data for import');
      return;
    }

    state = state.copyWith(
      isImporting: true,
      currentStep: ImportWizardStep.importing,
    );

    try {
      // Rebuild conflict decisions map with ConflictPair keys
      final decisionsMap = <ConflictPair, MergeStrategy>{};
      for (final conflict in state.conflicts!) {
        final decision = state.userDecisions?[conflict.displayName];
        if (decision != null) {
          decisionsMap[conflict] = decision;
        }
      }

      final (toAdd, toUpdate) = ConflictDetector.resolveConflicts(
        importedList: state.importedIngredients!,
        conflicts: state.conflicts!,
        userDecisions: decisionsMap,
      );

      final repo = ref.read(ingredientsRepository);

      // Add new ingredients
      for (final ing in toAdd) {
        await repo.create(ing.toJson());
      }

      // Update existing ingredients
      for (final ing in toUpdate) {
        await repo.update(ing.toJson(), ing.ingredientId as num);
      }

      AppLogger.info(
        'Import complete: ${toAdd.length} added, ${toUpdate.length} updated',
        tag: _tag,
      );

      state = state.copyWith(
        isImporting: false,
        importedCount: toAdd.length,
        updatedCount: toUpdate.length,
        error: null,
      );

      // Invalidate ingredients cache
      ref.invalidate(ingredientsRepositoryProvider);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Import failed: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        isImporting: false,
        error: 'Import failed: $e',
      );
    }
  }

  /// Reset wizard to initial state
  void reset() {
    state = const ImportWizardState();
    AppLogger.info('Import wizard reset', tag: _tag);
  }
}

final importWizardProvider =
    NotifierProvider<ImportWizardNotifier, ImportWizardState>(
  ImportWizardNotifier.new,
);
