# Phase 5.1: Bulk Ingredient Import - Detailed Implementation Guide

## Quick Start

**Goal**: Enable farmers to bulk-import ingredient datasets via CSV (NRC/CVB/INRA formats) with automatic duplicate detection and conflict resolution.

**Timeline**: 3-4 days (implement service layer, then UI, then integration testing)

**Test Baseline**: 355 passing tests → target: 365+ passing after Phase 5.1

---

## Step-by-Step Implementation

### Step 1: Create CSV Parser Service (Day 1 Morning)

**File**: `lib/src/features/import_export/service/csv_parser_service.dart`

```dart
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';

const String _tag = 'CsvParserService';

enum CSVFormat {
  nrc,     // NRC (National Research Council) - USA standard
  cvb,     // CVB (Centraal Veevoeder Bureau) - Netherlands
  inra,    // INRA (Institut National de Recherche Agronomique) - France
  unknown
}

class CSVParsingException implements Exception {
  final String message;
  CSVParsingException(this.message);
  
  @override
  String toString() => 'CSVParsingException: $message';
}

/// Parses CSV files with auto-format detection
class CsvParserService {
  /// Parse CSV file and detect format from headers
  /// 
  /// Returns: ParsedCSVFile with headers, rows, and detected format
  /// Throws: CSVParsingException if file invalid or empty
  static Future<ParsedCSVFile> parseCSVFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw CSVParsingException('File not found: $filePath');
      }

      final content = await file.readAsString();
      if (content.trim().isEmpty) {
        throw CSVParsingException('CSV file is empty');
      }

      // Parse CSV
      final rows = const CsvToListConverter().convert(content);
      if (rows.isEmpty) {
        throw CSVParsingException('No rows found in CSV');
      }

      // Extract headers from first row
      final headers = rows[0].map((h) => h.toString().trim().toLowerCase()).toList();
      final dataRows = rows.skip(1).toList();

      if (dataRows.isEmpty) {
        throw CSVParsingException('CSV has headers but no data rows');
      }

      // Detect format
      final format = _detectFormat(headers);

      // Normalize headers to standard names
      final normalizedHeaders = _normalizeHeaders(headers, format);

      AppLogger.info(
        'Parsed CSV: ${dataRows.length} rows, format=$format',
        tag: _tag,
      );

      return ParsedCSVFile(
        headers: normalizedHeaders,
        dataRows: dataRows,
        detectedFormat: format,
        rawRowCount: dataRows.length,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to parse CSV: $e',
        tag: _tag,
        error: e,
        stackTrace: stackTrace,
      );
      throw CSVParsingException('Failed to parse CSV: $e');
    }
  }

  /// Detect CSV format from header row
  /// 
  /// NRC: "Ingredient Name", "Crude Protein", "ME (Growing Pig)"
  /// CVB: "Name", "Crude protein", "Net Energy"
  /// INRA: "Name", "Crude protein %", "NE pig (kcal/kg)"
  static CSVFormat _detectFormat(List<String> headers) {
    final headerString = headers.join('|').toLowerCase();

    if (headerString.contains('crude protein') &&
        headerString.contains('growing pig')) {
      return CSVFormat.nrc;
    }

    if (headerString.contains('net energy') && 
        headerString.contains('cvb')) {
      return CSVFormat.cvb;
    }

    if (headerString.contains('ne pig') || 
        headerString.contains('inra')) {
      return CSVFormat.inra;
    }

    return CSVFormat.unknown;
  }

  /// Normalize headers to standard field names
  /// Maps: "Crude Protein %" → "crude_protein"
  static List<String> _normalizeHeaders(
    List<String> headers,
    CSVFormat format,
  ) {
    const normalizationMap = {
      // Name variants
      'ingredient name': 'name',
      'ingredient_name': 'name',
      'name': 'name',
      'product': 'name',

      // Crude Protein
      'crude protein': 'crude_protein',
      'crude protein %': 'crude_protein',
      'crude protein (%dm)': 'crude_protein',
      'protein %': 'crude_protein',
      'cp %': 'crude_protein',

      // Crude Fiber
      'crude fiber': 'crude_fiber',
      'crude fiber %': 'crude_fiber',
      'fiber %': 'crude_fiber',
      'cf %': 'crude_fiber',

      // Crude Fat
      'crude fat': 'crude_fat',
      'ether extract': 'crude_fat',

      // Calcium
      'calcium': 'calcium',
      'ca': 'calcium',
      'ca %': 'calcium',

      // Phosphorus
      'phosphorus': 'phosphorus',
      'p': 'phosphorus',
      'p %': 'phosphorus',

      // Lysine
      'lysine': 'lysine',
      'lys': 'lysine',
      'lysine (%)': 'lysine',

      // Methionine
      'methionine': 'methionine',
      'met': 'methionine',

      // Energy (pig growing)
      'me (growing pig)': 'me_growing_pig',
      'me growing pig': 'me_growing_pig',
      'me pig': 'me_growing_pig',
      'metabolizable energy': 'me_growing_pig',

      // Energy (poultry)
      'me (poultry)': 'me_poultry',
      'me poultry': 'me_poultry',

      // Price
      'price': 'price_kg',
      'price/kg': 'price_kg',
      'price per kg': 'price_kg',
      'cost': 'price_kg',
      'unit price': 'price_kg',
    };

    return headers.map((h) {
      final normalized = normalizationMap[h] ?? h;
      return normalized;
    }).toList();
  }

  /// Validate required fields are present
  /// For basic import: name, crude_protein required
  /// Returns: List<ValidationError> (empty if valid)
  static List<ValidationError> validateHeaders(List<String> headers) {
    final errors = <ValidationError>[];

    if (!headers.contains('name')) {
      errors.add(ValidationError(
        column: 'name',
        message: 'Required field "name" (ingredient name) not found',
      ));
    }

    if (!headers.any((h) => h.contains('protein'))) {
      errors.add(ValidationError(
        column: 'crude_protein',
        message: 'No protein field found (try "Crude Protein", "CP %")',
      ));
    }

    return errors;
  }

  /// Parse and validate data rows
  /// Returns: List<CSVRow> with parsed values
  /// Rows with critical errors are marked as invalid
  static List<CSVRow> parseDataRows(
    List<String> headers,
    List<List<dynamic>> dataRows,
  ) {
    final parsedRows = <CSVRow>[];

    for (int i = 0; i < dataRows.length; i++) {
      final row = dataRows[i];
      final errors = <String>[];

      // Ensure row has enough columns
      if (row.length < headers.length) {
        errors.add('Row has ${row.length} columns, expected ${headers.length}');
      }

      // Extract data with proper types
      final rowData = <String, dynamic>{};
      for (int j = 0; j < headers.length && j < row.length; j++) {
        final header = headers[j];
        final value = row[j].toString().trim();
        rowData[header] = value;
      }

      parsedRows.add(CSVRow(
        rowNumber: i + 2, // +2 because row 1 is headers, +1 for 1-based indexing
        data: rowData,
        errors: errors,
      ));
    }

    return parsedRows;
  }

  /// Convert CSV row to Ingredient model
  /// Returns: Ingredient object with mapped fields
  /// Throws: ValidationException if required fields invalid
  static Ingredient csvRowToIngredient(CSVRow row) {
    final data = row.data;

    // Extract required fields
    final name = (data['name'] as String?)?.trim();
    if (name == null || name.isEmpty) {
      throw CSVParsingException('Row ${row.rowNumber}: name field required');
    }

    // Parse numeric fields with safety
    num? asNum(String? value) {
      if (value == null || value.isEmpty) return null;
      final trimmed = value.replaceAll(',', '.').trim();
      try {
        return double.parse(trimmed);
      } catch (_) {
        return null;
      }
    }

    return Ingredient(
      name: name,
      crudeProtein: asNum(data['crude_protein'] as String?),
      crudeFiber: asNum(data['crude_fiber'] as String?),
      crudeFat: asNum(data['crude_fat'] as String?),
      calcium: asNum(data['calcium'] as String?),
      phosphorus: asNum(data['phosphorus'] as String?),
      lysine: asNum(data['lysine'] as String?),
      methionine: asNum(data['methionine'] as String?),
      meGrowingPig: asNum(data['me_growing_pig'] as String?)?.toInt(),
      mePoultry: asNum(data['me_poultry'] as String?)?.toInt(),
      priceKg: asNum(data['price_kg'] as String?),
      isCustom: 1, // All imported ingredients are custom
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

class ParsedCSVFile {
  final List<String> headers;
  final List<List<dynamic>> dataRows;
  final CSVFormat detectedFormat;
  final int rawRowCount;

  const ParsedCSVFile({
    required this.headers,
    required this.dataRows,
    required this.detectedFormat,
    required this.rawRowCount,
  });

  /// Get data rows as CSVRow objects
  List<CSVRow> get parsedRows =>
      CsvParserService.parseDataRows(headers, dataRows);
}

class CSVRow {
  final int rowNumber;
  final Map<String, dynamic> data;
  final List<String> errors;

  const CSVRow({
    required this.rowNumber,
    required this.data,
    this.errors = const [],
  });

  bool get isValid => errors.isEmpty;
  String get displayName => data['name']?.toString() ?? 'Unknown';
}

class ValidationError {
  final String column;
  final String message;

  const ValidationError({
    required this.column,
    required this.message,
  });
}
```

### Step 2: Create Conflict Detection Service (Day 1 Afternoon)

**File**: `lib/src/features/import_export/service/conflict_detector.dart`

```dart
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';

const String _tag = 'ConflictDetector';

enum MergeStrategy { skip, replace, merge }

/// Finds potential duplicates and suggests merge strategies
class ConflictDetector {
  /// Calculate similarity between two strings (0-1)
  /// Uses Levenshtein distance algorithm
  static double calculateSimilarity(String s1, String s2) {
    final str1 = s1.toLowerCase();
    final str2 = s2.toLowerCase();

    if (str1 == str2) return 1.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;

    // Levenshtein distance
    final matrix = List.generate(
      str2.length + 1,
      (i) => List.generate(str1.length + 1, (j) => 0),
    );

    for (int i = 0; i <= str2.length; i++) matrix[i][0] = i;
    for (int j = 0; j <= str1.length; j++) matrix[0][j] = j;

    for (int i = 1; i <= str2.length; i++) {
      for (int j = 1; j <= str1.length; j++) {
        final cost = str2[i - 1] == str1[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    final distance = matrix[str2.length][str1.length].toDouble();
    final maxLen = [str1.length, str2.length].reduce((a, b) => a > b ? a : b);
    return 1.0 - (distance / maxLen);
  }

  /// Find potential duplicates
  /// Returns: List<ConflictPair> (imported ↔ existing)
  static List<ConflictPair> findDuplicates({
    required List<Ingredient> importedList,
    required List<Ingredient> existingList,
    double similarityThreshold = 0.85,
  }) {
    final conflicts = <ConflictPair>[];

    for (final imported in importedList) {
      final importedName = imported.name ?? '';
      if (importedName.isEmpty) continue;

      for (final existing in existingList) {
        final existingName = existing.name ?? '';
        if (existingName.isEmpty) continue;

        // Calculate name similarity
        final nameSimilarity =
            calculateSimilarity(importedName, existingName);

        if (nameSimilarity >= similarityThreshold) {
          // Potential duplicate found
          conflicts.add(ConflictPair(
            imported: imported,
            existing: existing,
            nameSimilarity: nameSimilarity,
            suggestedStrategy: _suggestStrategy(imported, existing),
          ));
        }
      }
    }

    // Sort by similarity descending
    conflicts.sort((a, b) => b.nameSimilarity.compareTo(a.nameSimilarity));

    AppLogger.info(
      'Found ${conflicts.length} potential conflicts',
      tag: _tag,
    );

    return conflicts;
  }

  /// Suggest merge strategy based on data comparison
  static MergeStrategy _suggestStrategy(
    Ingredient imported,
    Ingredient existing,
  ) {
    // Very similar names (95%+) → Replace
    final nameSim = calculateSimilarity(
      imported.name ?? '',
      existing.name ?? '',
    );
    if (nameSim >= 0.95) {
      return MergeStrategy.replace;
    }

    // Check nutrient similarity
    final proteinDiff = (imported.crudeProtein ?? 0) -
        (existing.crudeProtein ?? 0);

    // If protein differs significantly (>5%) → Merge/review
    if ((proteinDiff.abs() > 5)) {
      return MergeStrategy.merge;
    }

    // Otherwise skip (keep existing)
    return MergeStrategy.skip;
  }

  /// Apply merge strategies to resolve conflicts
  /// Returns: (ingredientsToAdd, ingredientsToUpdate)
  static (List<Ingredient>, List<Ingredient>) resolveConflicts({
    required List<Ingredient> importedList,
    required List<ConflictPair> conflicts,
    required Map<ConflictPair, MergeStrategy> userDecisions,
  }) {
    final toAdd = <Ingredient>[];
    final toUpdate = <Ingredient>[];
    final conflictedIds = <String>{};

    // Process user decisions
    for (final entry in userDecisions.entries) {
      final conflict = entry.key;
      final strategy = entry.value;

      conflictedIds.add(conflict.imported.ingredientId?.toString() ?? '');

      switch (strategy) {
        case MergeStrategy.skip:
          // Keep existing, discard imported
          break;

        case MergeStrategy.replace:
          // Replace existing with imported data
          toUpdate.add(conflict.imported.copyWith(
            ingredientId: conflict.existing.ingredientId,
          ));
          break;

        case MergeStrategy.merge:
          // Merge: keep existing, but update from imported if better
          final merged = conflict.existing.copyWith(
            crudeProtein: conflict.imported.crudeProtein ??
                conflict.existing.crudeProtein,
            lysine:
                conflict.imported.lysine ?? conflict.existing.lysine,
            meGrowingPig: conflict.imported.meGrowingPig ??
                conflict.existing.meGrowingPig,
          );
          toUpdate.add(merged);
          break;
      }
    }

    // Add non-conflicted imported ingredients
    for (final ing in importedList) {
      if (!conflictedIds.contains(ing.ingredientId?.toString() ?? '')) {
        toAdd.add(ing);
      }
    }

    AppLogger.info(
      'Conflict resolution: ${toAdd.length} to add, ${toUpdate.length} to update',
      tag: _tag,
    );

    return (toAdd, toUpdate);
  }
}

class ConflictPair {
  final Ingredient imported;
  final Ingredient existing;
  final double nameSimilarity;
  final MergeStrategy suggestedStrategy;

  const ConflictPair({
    required this.imported,
    required this.existing,
    required this.nameSimilarity,
    required this.suggestedStrategy,
  });

  String get displayName =>
      '${imported.name} ↔ ${existing.name}';

  String get similarityText =>
      '${(nameSimilarity * 100).toStringAsFixed(0)}% match';
}
```

### Step 3: Create Import Wizard Provider (Day 2 Morning)

**File**: `lib/src/features/import_export/provider/import_wizard_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:feed_estimator/src/features/import_export/service/csv_parser_service.dart';
import 'package:feed_estimator/src/features/import_export/service/conflict_detector.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';

part 'import_wizard_provider.g.dart';

enum ImportWizardStep { fileSelection, dataPreview, conflictResolution, importing }

class ImportWizardState {
  final ImportWizardStep currentStep;
  final String? selectedFilePath;
  final ParsedCSVFile? parsedCSV;
  final List<Ingredient>? importedIngredients;
  final List<ConflictPair>? conflicts;
  final Map<ConflictPair, MergeStrategy>? userDecisions;
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
    Map<ConflictPair, MergeStrategy>? userDecisions,
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
      error: error ?? this.error,
    );
  }
}

@riverpod
class ImportWizardNotifier extends _$ImportWizardNotifier {
  @override
  ImportWizardState build() {
    return const ImportWizardState();
  }

  /// Step 1: Select and parse CSV file
  Future<void> selectAndParseFile(String filePath) async {
    state = state.copyWith(selectedFilePath: filePath, error: null);

    try {
      final parsed = await CsvParserService.parseCSVFile(filePath);
      
      // Validate headers
      final headerErrors = CsvParserService.validateHeaders(parsed.headers);
      if (headerErrors.isNotEmpty) {
        state = state.copyWith(
          error: 'Missing required fields: ${headerErrors.map((e) => e.message).join(', ')}',
        );
        return;
      }

      // Parse data rows
      final rows = parsed.parsedRows;
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
          AppLogger.warning('Failed to parse row ${row.rowNumber}: $e', tag: 'ImportWizard');
        }
      }

      if (ingredients.isEmpty) {
        state = state.copyWith(
          error: 'No valid ingredients found in CSV',
        );
        return;
      }

      state = state.copyWith(
        parsedCSV: parsed,
        importedIngredients: ingredients,
        currentStep: ImportWizardStep.dataPreview,
      );
    } catch (e) {
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
      final existingIng =
          await ref.read(ingredientsRepository).getAll();

      // Find conflicts
      final conflicts = ConflictDetector.findDuplicates(
        importedList: state.importedIngredients!,
        existingList: existingIng,
      );

      // Initialize user decisions with suggested strategies
      final decisions = <ConflictPair, MergeStrategy>{};
      for (final conflict in conflicts) {
        decisions[conflict] = conflict.suggestedStrategy;
      }

      state = state.copyWith(
        conflicts: conflicts,
        userDecisions: decisions,
        currentStep: ImportWizardStep.conflictResolution,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to detect conflicts: $e');
    }
  }

  /// Update user decision for a conflict
  void setConflictDecision(ConflictPair conflict, MergeStrategy strategy) {
    final decisions = Map<ConflictPair, MergeStrategy>.from(
      state.userDecisions ?? {},
    );
    decisions[conflict] = strategy;
    state = state.copyWith(userDecisions: decisions);
  }

  /// Step 3: Execute import with conflict resolutions
  Future<void> executeImport() async {
    if (state.importedIngredients == null ||
        state.userDecisions == null) {
      state = state.copyWith(error: 'Missing data for import');
      return;
    }

    state = state.copyWith(isImporting: true, currentStep: ImportWizardStep.importing);

    try {
      final (toAdd, toUpdate) = ConflictDetector.resolveConflicts(
        importedList: state.importedIngredients!,
        conflicts: state.conflicts ?? [],
        userDecisions: state.userDecisions!,
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

      state = state.copyWith(
        isImporting: false,
        importedCount: toAdd.length,
        updatedCount: toUpdate.length,
        error: null,
      );

      // Invalidate ingredients cache
      ref.invalidate(ingredientsRepositoryProvider);

      AppLogger.info(
        'Import complete: ${toAdd.length} added, ${toUpdate.length} updated',
        tag: 'ImportWizard',
      );
    } catch (e) {
      state = state.copyWith(
        isImporting: false,
        error: 'Import failed: $e',
      );
    }
  }

  /// Reset wizard to initial state
  void reset() {
    state = const ImportWizardState();
  }
}

final importWizardProvider = NotifierProvider<
    ImportWizardNotifier,
    ImportWizardState>(ImportWizardNotifier.new);
```

### Step 4: Create Import Wizard UI (Day 2 Afternoon - Day 3 Morning)

**File**: `lib/src/features/import_export/view/import_wizard_screen.dart`

Basic structure:
```dart
class ImportWizardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importWizardProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Import Ingredients')),
      body: Column(
        children: [
          // Stepper showing steps
          Stepper(
            currentStep: _getCurrentStep(state.currentStep),
            steps: [
              Step(title: const Text('Select File'), isActive: true),
              Step(title: const Text('Review Data'), isActive: true),
              Step(title: const Text('Resolve Conflicts'), isActive: true),
            ],
          ),
          // Step content
          Expanded(child: _buildStepContent(state, context, ref)),
        ],
      ),
    );
  }

  Widget _buildStepContent(
    ImportWizardState state,
    BuildContext context,
    WidgetRef ref,
  ) {
    switch (state.currentStep) {
      case ImportWizardStep.fileSelection:
        return _FileSelectionStep();
      case ImportWizardStep.dataPreview:
        return _DataPreviewStep();
      case ImportWizardStep.conflictResolution:
        return _ConflictResolutionStep();
      case ImportWizardStep.importing:
        return const _ImportingStep();
    }
  }
}
```

---

## Testing Strategy (Day 3)

**Test File**: `test/integration/import_integration_test.dart`

```dart
void main() {
  group('Bulk CSV Import Integration', () {
    test('parses NRC format CSV correctly', () async {
      // Load test/fixtures/nrc_sample.csv
      // Verify headers detected
      // Verify 10 ingredients parsed
    });

    test('detects duplicate fish meal with 95% similarity', () async {
      // Insert existing "Fish Meal" in DB
      // Import CSV with "Fish Meal (salted)"
      // Should detect as conflict
    });

    test('resolves conflicts and imports new ingredients', () async {
      // Create conflicts map with SKIP for duplicates
      // Execute import
      // Verify: only new ingredients added
    });

    test('validates required fields present', () async {
      // Create CSV missing "name" column
      // Should return validation error
    });

    test('handles malformed numeric values gracefully', () async {
      // Create CSV with "abc" in protein field
      // Should parse as null, not crash
    });
  });
}
```

---

## File Structure After Phase 5.1

```
lib/src/features/import_export/
├── model/
│   └── import_result.dart         # (to be created)
├── provider/
│   └── import_wizard_provider.dart  # ✅ CREATED
├── repository/
│   └── csv_import_repository.dart   # (to be created if needed)
├── service/
│   ├── csv_parser_service.dart      # ✅ CREATED
│   ├── conflict_detector.dart       # ✅ CREATED
│   └── ingredient_mapper.dart       # (optional refinement)
└── view/
    ├── import_wizard_screen.dart    # (to be created)
    ├── step_1_file_selection.dart   # (to be created)
    ├── step_2_data_preview.dart     # (to be created)
    └── step_3_conflict_resolution.dart # (to be created)

test/fixtures/
├── nrc_sample.csv                   # Sample data for testing
├── cvb_sample.csv
└── inra_sample.csv
```

---

## Success Criteria

- ✅ CSV files (NRC, CVB, INRA) parse correctly
- ✅ Duplicate detection finds 95%+ similar names
- ✅ Conflict resolution (skip/replace/merge) works
- ✅ Import adds new + updates existing in DB
- ✅ 365+ tests passing (10+ new unit tests)
- ✅ UI wizard 3-step flow works end-to-end
- ✅ No new lint errors

---

**Next**: Start with CSV Parser Service implementation. Create test CSV files first, then implement parser TDD-style (tests → implementation).
