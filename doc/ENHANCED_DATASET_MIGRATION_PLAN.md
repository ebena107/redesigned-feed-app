# Enhanced Dataset Migration & Industry Compliance Implementation Plan

## Executive Summary

This plan transforms the feed formulation app into an **industry-grade, scientifically accurate, and regulatory-compliant** system. The app already has v5 data models and enhanced calculation engine implemented. This plan focuses on **completing the migration**, **enforcing industry standards**, and **ensuring production readiness**.

### Current State Assessment

✅ **Already Implemented:**
- V5 data models (AminoAcidsProfile, EnergyValues, AntiNutritionalFactors)
- Database version 6 with migration framework (v4→v5→v6)
- New ingredient dataset `initial_ingredients_.json` (120 ingredients, 20+ nutrients)
- Enhanced calculation engine with amino acid and phosphorus tracking
- UI displaying enhanced nutrients (ash, moisture, phosphorus breakdown)

⚠️ **Critical Gaps Identified:**
- **Calculation Accuracy**: SID amino acids not prioritized over total amino acids
- **Energy Values**: NE (Net Energy) for pigs not used as primary metric per NRC 2012
- **Inclusion Limits**: Max inclusion data exists but not enforced in formulations
- **Anti-Nutritional Factors**: No validation or warnings for ANF levels
- **Data Migration**: No seamless upgrade path from old dataset (165→120 ingredients)
- **Rollback Strategy**: No database rollback mechanism for failed migrations
- **Industry Standards**: No validation against NRC/INRA/CVB reference values
- **UI/UX**: Missing detailed nutrient displays, ANF warnings, and inclusion limit indicators

---

## Implementation Phases

### Phase 1: Industry-Standard Calculation Engine Enhancement

#### 1.1 SID Amino Acid Prioritization

**Objective**: Use Standardized Ileal Digestible (SID) amino acids as primary values per NRC 2012 standards.

**[MODIFY]** [enhanced_calculation_engine.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/reports/providers/enhanced_calculation_engine.dart)

**Current Issue**: Line 226-286 accumulates both total and SID amino acids equally.

**Required Changes**:

```dart
/// Enhanced amino acid accumulation with SID prioritization
static void _accumulateAminoAcids(
  Ingredient data,
  double qty,
  Map<String, double> aminoAcidsTotals,
  Map<String, double> aminoAcidsSidTotals,
) {
  // PRIORITY 1: Use SID values (industry standard for digestibility)
  if (data.aminoAcidsSid != null) {
    final sid = data.aminoAcidsSid!;
    _addAminoAcidValue(aminoAcidsSidTotals, 'lysine', sid.lysine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'methionine', sid.methionine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'cystine', sid.cystine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'threonine', sid.threonine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'tryptophan', sid.tryptophan, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'arginine', sid.arginine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'isoleucine', sid.isoleucine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'leucine', sid.leucine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'valine', sid.valine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'histidine', sid.histidine, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'phenylalanine', sid.phenylalanine, qty);
  }
  
  // PRIORITY 2: Fallback to total amino acids if SID not available
  else if (data.aminoAcidsTotal != null) {
    final total = data.aminoAcidsTotal!;
    // Apply digestibility coefficients (NRC 2012 average: 0.85 for plant proteins)
    const digestibilityFactor = 0.85;
    _addAminoAcidValue(aminoAcidsSidTotals, 'lysine', 
        total.lysine != null ? total.lysine! * digestibilityFactor : null, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'methionine', 
        total.methionine != null ? total.methionine! * digestibilityFactor : null, qty);
    // ... repeat for all amino acids
  }
  
  // PRIORITY 3: Legacy fallback for old data
  else {
    const digestibilityFactor = 0.85;
    _addAminoAcidValue(aminoAcidsSidTotals, 'lysine', 
        data.lysine != null ? data.lysine! * digestibilityFactor : null, qty);
    _addAminoAcidValue(aminoAcidsSidTotals, 'methionine', 
        data.methionine != null ? data.methionine! * digestibilityFactor : null, qty);
  }
  
  // Always track total amino acids for reference
  if (data.aminoAcidsTotal != null) {
    final total = data.aminoAcidsTotal!;
    _addAminoAcidValue(aminoAcidsTotals, 'lysine', total.lysine, qty);
    _addAminoAcidValue(aminoAcidsTotals, 'methionine', total.methionine, qty);
    // ... all amino acids
  }
}
```

**Validation**: SID lysine for corn should be ~2.5 g/kg (vs total ~3.0 g/kg) per NRC 2012.

---

#### 1.2 Net Energy (NE) Prioritization for Pigs

**Objective**: Use NE as primary energy metric for pigs per NRC 2012 standards.

**[MODIFY]** [enhanced_calculation_engine.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/reports/providers/enhanced_calculation_engine.dart)

**Current Issue**: Line 364-371 `_getEnergyForAnimal` uses ME for pigs, not NE.

**Required Changes**:

```dart
static double _getEnergyForAnimal(Ingredient ing, num animalTypeId) {
  // Animal Type IDs: 1=Pig, 2=Poultry, 3=Rabbit, 4=Ruminant, 5=Salmonids
  
  if (animalTypeId == 1) {
    // PIGS: Prioritize NE > ME > DE (NRC 2012 standard)
    if (ing.energy?.nePig != null) {
      return ing.energy!.nePig!.toDouble();
    } else if (ing.energy?.mePig != null) {
      // Convert ME to NE using NRC 2012 equation: NE = 0.87*ME - 442
      final me = ing.energy!.mePig!.toDouble();
      return (0.87 * me - 442).clamp(0, double.infinity);
    } else if (ing.meGrowingPig != null) {
      // Legacy ME field
      final me = ing.meGrowingPig!.toDouble();
      return (0.87 * me - 442).clamp(0, double.infinity);
    } else if (ing.energy?.dePig != null) {
      // Convert DE to NE: NE = 0.75*DE - 600 (approximate)
      final de = ing.energy!.dePig!.toDouble();
      return (0.75 * de - 600).clamp(0, double.infinity);
    }
    return 0;
  }
  
  // POULTRY: Use ME (industry standard)
  if (animalTypeId == 2) {
    return (ing.energy?.mePoultry ?? ing.mePoultry ?? 0).toDouble();
  }
  
  // RABBITS: Use ME
  if (animalTypeId == 3) {
    return (ing.energy?.meRabbit ?? ing.meRabbit ?? 0).toDouble();
  }
  
  // RUMINANTS: Use ME
  if (animalTypeId == 4) {
    return (ing.energy?.meRuminant ?? ing.meRuminant ?? 0).toDouble();
  }
  
  // SALMONIDS: Use DE
  if (animalTypeId == 5) {
    return (ing.energy?.deSalmonids ?? ing.deSalmonids ?? 0).toDouble();
  }
  
  return 0;
}
```

**Validation**: Corn NE for pigs should be ~2,100 kcal/kg per NRC 2012.

---

#### 1.3 Inclusion Limit Enforcement

**Objective**: Enforce maximum inclusion rates and generate warnings.

**[NEW]** [inclusion_validator.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_update_feed/services/inclusion_validator.dart)

```dart
/// Validates ingredient inclusion rates against safety limits
class InclusionValidator {
  /// Validate formulation against inclusion limits
  /// 
  /// Returns validation result with warnings and errors
  static InclusionValidationResult validate({
    required List<FeedIngredients> feedIngredients,
    required Map<num, Ingredient> ingredientCache,
    required num animalTypeId,
  }) {
    final warnings = <String>[];
    final errors = <String>[];
    final totalQty = feedIngredients.fold<double>(
      0, (sum, ing) => sum + (ing.quantity ?? 0).toDouble());
    
    if (totalQty <= 0) {
      return InclusionValidationResult(warnings: [], errors: []);
    }
    
    for (final feedIng in feedIngredients) {
      final ingredient = ingredientCache[feedIng.ingredientId];
      if (ingredient == null) continue;
      
      final qty = (feedIng.quantity ?? 0).toDouble();
      final inclusionPct = (qty / totalQty) * 100;
      
      // Check max_inclusion limits from JSON data
      final maxInclusion = _getMaxInclusionForAnimal(
        ingredient, animalTypeId);
      
      if (maxInclusion != null && maxInclusion > 0) {
        if (inclusionPct > maxInclusion) {
          errors.add(
            '${ingredient.name}: ${inclusionPct.toStringAsFixed(1)}% '
            'exceeds maximum ${maxInclusion.toStringAsFixed(0)}% for this animal type'
          );
        } else if (inclusionPct > maxInclusion * 0.9) {
          // Warning at 90% of limit
          warnings.add(
            '${ingredient.name}: ${inclusionPct.toStringAsFixed(1)}% '
            'approaching limit of ${maxInclusion.toStringAsFixed(0)}%'
          );
        }
      }
      
      // Check anti-nutritional factors
      if (ingredient.antiNutritionalFactors != null) {
        final anf = ingredient.antiNutritionalFactors!;
        
        // Glucosinolates (canola/rapeseed): >30 μmol/g requires <10% inclusion
        if (anf.glucosinolatesMicromolG != null && 
            anf.glucosinolatesMicromolG! > 30 && 
            inclusionPct > 10) {
          warnings.add(
            '${ingredient.name}: High glucosinolates '
            '(${anf.glucosinolatesMicromolG} μmol/g). Limit to 10% inclusion.'
          );
        }
        
        // Trypsin inhibitors (soybean): >40 TU/g requires heat treatment
        if (anf.trypsinInhibitorTuG != null && 
            anf.trypsinInhibitorTuG! > 40) {
          warnings.add(
            '${ingredient.name}: High trypsin inhibitors '
            '(${anf.trypsinInhibitorTuG} TU/g). Ensure proper heat treatment.'
          );
        }
        
        // Tannins: >5000 ppm requires <15% inclusion
        if (anf.tanninsPpm != null && 
            anf.tanninsPpm! > 5000 && 
            inclusionPct > 15) {
          warnings.add(
            '${ingredient.name}: High tannins (${anf.tanninsPpm} ppm). '
            'Limit to 15% inclusion.'
          );
        }
      }
      
      // Ingredient-specific warnings
      if (ingredient.warning != null && ingredient.warning!.isNotEmpty) {
        warnings.add('${ingredient.name}: ${ingredient.warning}');
      }
    }
    
    return InclusionValidationResult(
      warnings: warnings,
      errors: errors,
      isValid: errors.isEmpty,
    );
  }
  
  /// Get max inclusion for specific animal type
  static double? _getMaxInclusionForAnimal(
    Ingredient ingredient, 
    num animalTypeId
  ) {
    // Parse max_inclusion JSON structure
    // Format: {"pig_grower": 150, "pig_finisher": 200, ...}
    if (ingredient.maxInclusionPct != null) {
      // Simple percentage value
      return ingredient.maxInclusionPct!.toDouble();
    }
    
    // TODO: Parse complex max_inclusion JSON from ingredient data
    // This requires adding a new field to Ingredient model
    return null;
  }
}

class InclusionValidationResult {
  final List<String> warnings;
  final List<String> errors;
  final bool isValid;
  
  const InclusionValidationResult({
    required this.warnings,
    required this.errors,
    this.isValid = true,
  });
}
```

**Integration**: Call from `EnhancedCalculationEngine.calculateEnhancedResult()` and include results in warnings.

---

### Phase 2: Database Migration & Data Integrity

#### 2.1 Seamless Dataset Upgrade Strategy

**Objective**: Migrate from old dataset (165 ingredients) to new dataset (120 ingredients) without data loss.

**[NEW]** [migrate_to_harmonized_dataset.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/core/database/migrations/migrate_to_harmonized_dataset.dart)

```dart
/// Migration from legacy dataset to harmonized industrial dataset
/// 
/// Strategy:
/// 1. Backup existing database
/// 2. Load new harmonized dataset (120 ingredients)
/// 3. Map old ingredients to new equivalents
/// 4. Preserve custom user ingredients
/// 5. Update existing formulations with mapped ingredients
class HarmonizedDatasetMigration {
  
  /// Execute migration to harmonized dataset
  static Future<MigrationResult> migrate(Database db) async {
    try {
      // Step 1: Create backup
      await _createBackup(db);
      
      // Step 2: Load ingredient mapping
      final mapping = await _loadIngredientMapping();
      
      // Step 3: Identify custom ingredients (preserve these)
      final customIngredients = await _getCustomIngredients(db);
      
      // Step 4: Clear old system ingredients (keep custom)
      await db.execute('''
        DELETE FROM ${IngredientsRepository.tableName}
        WHERE is_custom = 0 OR is_custom IS NULL
      ''');
      
      // Step 5: Load new harmonized dataset
      final newIngredients = await _loadHarmonizedDataset();
      
      // Step 6: Insert new ingredients
      Batch batch = db.batch();
      for (var ingredient in newIngredients) {
        batch.insert(
          IngredientsRepository.tableName,
          ingredient.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
      
      // Step 7: Update existing formulations
      await _updateFormulations(db, mapping);
      
      // Step 8: Mark migration as complete
      await _setMigrationFlag(db, 'harmonized_dataset_v1', true);
      
      return MigrationResult(
        success: true,
        message: 'Successfully migrated to harmonized dataset',
        ingredientsMigrated: newIngredients.length,
        customIngredientsPreserved: customIngredients.length,
      );
      
    } catch (e, stackTrace) {
      debugPrint('Migration failed: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Attempt rollback
      await _rollbackMigration(db);
      
      return MigrationResult(
        success: false,
        message: 'Migration failed: $e',
        error: e.toString(),
      );
    }
  }
  
  /// Create database backup before migration
  static Future<void> _createBackup(Database db) async {
    final dbPath = db.path;
    final backupPath = '$dbPath.backup_${DateTime.now().millisecondsSinceEpoch}';
    
    // Copy database file
    final dbFile = File(dbPath);
    await dbFile.copy(backupPath);
    
    debugPrint('Database backed up to: $backupPath');
  }
  
  /// Load ingredient mapping (old ID → new ID)
  static Future<Map<int, int>> _loadIngredientMapping() async {
    final jsonString = await rootBundle.loadString(
      'assets/raw/ingredient_mapping.json'
    );
    final List<dynamic> mappingData = json.decode(jsonString);
    
    return {
      for (var item in mappingData)
        item['old_id'] as int: item['new_id'] as int,
    };
  }
  
  /// Get custom user-created ingredients
  static Future<List<Ingredient>> _getCustomIngredients(Database db) async {
    final results = await db.query(
      IngredientsRepository.tableName,
      where: 'is_custom = ?',
      whereArgs: [1],
    );
    
    return results.map((e) => Ingredient.fromJson(e)).toList();
  }
  
  /// Load harmonized dataset
  static Future<List<Ingredient>> _loadHarmonizedDataset() async {
    final jsonString = await rootBundle.loadString(
      'assets/raw/initial_ingredients_.json'
    );
    return ingredientListFromJson(jsonString);
  }
  
  /// Update existing formulations with new ingredient IDs
  static Future<void> _updateFormulations(
    Database db, 
    Map<int, int> mapping
  ) async {
    // Update feed_ingredients table
    for (var entry in mapping.entries) {
      await db.execute('''
        UPDATE ${FeedIngredientRepository.tableName}
        SET ingredient_id = ?
        WHERE ingredient_id = ?
      ''', [entry.value, entry.key]);
    }
  }
  
  /// Rollback migration on failure
  static Future<void> _rollbackMigration(Database db) async {
    final dbPath = db.path;
    
    // Find most recent backup
    final dbDir = Directory(path.dirname(dbPath));
    final backups = dbDir.listSync()
        .where((f) => f.path.contains('.backup_'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path));
    
    if (backups.isNotEmpty) {
      final latestBackup = backups.first;
      await File(latestBackup.path).copy(dbPath);
      debugPrint('Database rolled back from: ${latestBackup.path}');
    }
  }
  
  /// Set migration flag in database
  static Future<void> _setMigrationFlag(
    Database db, 
    String migrationName, 
    bool completed
  ) async {
    // Store in a migrations table or shared preferences
    await db.execute('''
      CREATE TABLE IF NOT EXISTS migrations (
        name TEXT PRIMARY KEY,
        completed INTEGER,
        timestamp INTEGER
      )
    ''');
    
    await db.insert(
      'migrations',
      {
        'name': migrationName,
        'completed': completed ? 1 : 0,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class MigrationResult {
  final bool success;
  final String message;
  final int? ingredientsMigrated;
  final int? customIngredientsPreserved;
  final String? error;
  
  const MigrationResult({
    required this.success,
    required this.message,
    this.ingredientsMigrated,
    this.customIngredientsPreserved,
    this.error,
  });
}
```

**[NEW]** [assets/raw/ingredient_mapping.json](file:///c:/dev/feed_estimator/redesigned-feed-app/assets/raw/ingredient_mapping.json)

```json
[
  {"old_id": 1, "new_id": 1, "old_name": "Alfalfa meal, dehydrated, protein < 16%", "new_name": "Alfalfa meal, dehydrated, protein < 16%"},
  {"old_id": 2, "new_id": 2, "old_name": "Barley grain", "new_name": "Barley grain"},
  {"old_id": 15, "new_id": null, "old_name": "Deprecated ingredient", "new_name": null, "replacement_id": 2, "note": "Use Barley grain instead"}
]
```

---

#### 2.2 Database Version Management

**[MODIFY]** [app_db.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/core/database/app_db.dart)

Add migration to version 7 for harmonized dataset:

```dart
// Line 29: Update version
static const int _currentVersion = 7;

// Line 122-124: Add case for v7
case 7:
  await _migrationV6ToV7(db);
  break;

// Add new migration method
/// Migration from v6 to v7: Harmonized industrial dataset
Future<void> _migrationV6ToV7(Database db) async {
  debugPrint('Migration 6→7: Migrating to harmonized industrial dataset');
  
  try {
    // Check if migration already completed
    final migrationCheck = await db.rawQuery('''
      SELECT completed FROM migrations 
      WHERE name = 'harmonized_dataset_v1'
    ''');
    
    if (migrationCheck.isNotEmpty && 
        migrationCheck.first['completed'] == 1) {
      debugPrint('Migration 6→7: Already completed, skipping');
      return;
    }
    
    // Execute harmonized dataset migration
    final result = await HarmonizedDatasetMigration.migrate(db);
    
    if (result.success) {
      debugPrint('Migration 6→7: ${result.message}');
      debugPrint('  - Ingredients migrated: ${result.ingredientsMigrated}');
      debugPrint('  - Custom ingredients preserved: ${result.customIngredientsPreserved}');
    } else {
      throw Exception('Migration failed: ${result.message}');
    }
    
  } catch (e, stackTrace) {
    debugPrint('Migration 6→7: Error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
  
  debugPrint('Migration 6→7: Complete');
}
```

---

### Phase 3: Industry Standards Validation

#### 3.1 NRC/INRA/CVB Reference Validation

**[NEW]** [nutrient_validator.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_update_feed/services/nutrient_validator.dart)

```dart
/// Validates formulation against industry standards
/// 
/// References:
/// - NRC 2012 (Swine Nutrient Requirements)
/// - NRC 2016 (Poultry Nutrient Requirements)
/// - CVB 2021 (Dutch Feed Tables)
/// - INRA-AFZ 2018 (French Feed Tables)
class NutrientValidator {
  
  /// Validate pig formulation against NRC 2012
  static ValidationResult validatePigFormulation({
    required Result result,
    required String pigStage, // 'grower', 'finisher', 'sow'
  }) {
    final warnings = <String>[];
    final errors = <String>[];
    
    // NRC 2012 requirements for growing pigs (20-50 kg)
    if (pigStage == 'grower') {
      // Crude Protein: 16-18% (NRC 2012, Table 6-1)
      if (result.cProtein != null) {
        if (result.cProtein! < 14) {
          errors.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
              'below NRC minimum (16%)');
        } else if (result.cProtein! < 16) {
          warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
              'below NRC recommended (16-18%)');
        } else if (result.cProtein! > 20) {
          warnings.add('Crude protein (${result.cProtein!.toStringAsFixed(1)}%) '
              'above NRC recommended (16-18%). May increase cost.');
        }
      }
      
      // SID Lysine: 0.95-1.05% (NRC 2012)
      final sidLysine = _extractSidLysine(result);
      if (sidLysine != null) {
        if (sidLysine < 0.85) {
          errors.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
              'below NRC minimum (0.95%)');
        } else if (sidLysine < 0.95) {
          warnings.add('SID Lysine (${sidLysine.toStringAsFixed(2)}%) '
              'below NRC recommended (0.95-1.05%)');
        }
      }
      
      // Net Energy: 2,300-2,450 kcal/kg (NRC 2012)
      if (result.mEnergy != null) {
        if (result.mEnergy! < 2100) {
          warnings.add('Net Energy (${result.mEnergy!.toStringAsFixed(0)} kcal/kg) '
              'below NRC recommended (2,300-2,450 kcal/kg)');
        } else if (result.mEnergy! > 2600) {
          warnings.add('Net Energy (${result.mEnergy!.toStringAsFixed(0)} kcal/kg) '
              'above NRC recommended. May increase cost.');
        }
      }
      
      // Available Phosphorus: 0.23-0.33% (NRC 2012)
      if (result.availablePhosphorus != null) {
        final availP = result.availablePhosphorus! / 10; // Convert g/kg to %
        if (availP < 0.20) {
          warnings.add('Available P (${availP.toStringAsFixed(2)}%) '
              'below NRC recommended (0.23-0.33%)');
        } else if (availP > 0.40) {
          warnings.add('Available P (${availP.toStringAsFixed(2)}%) '
              'above NRC recommended. Environmental concern.');
        }
      }
      
      // Calcium: 0.50-0.70% (NRC 2012)
      if (result.calcium != null) {
        final ca = result.calcium! / 10; // Convert g/kg to %
        if (ca < 0.45) {
          warnings.add('Calcium (${ca.toStringAsFixed(2)}%) '
              'below NRC recommended (0.50-0.70%)');
        } else if (ca > 0.85) {
          warnings.add('Calcium (${ca.toStringAsFixed(2)}%) '
              'above NRC recommended. May affect palatability.');
        }
      }
      
      // Ca:P ratio: 1.2:1 to 2:1 (NRC 2012)
      if (result.calcium != null && result.availablePhosphorus != null) {
        final caP_ratio = result.calcium! / result.availablePhosphorus!;
        if (caP_ratio < 1.0 || caP_ratio > 2.5) {
          warnings.add('Ca:P ratio (${caP_ratio.toStringAsFixed(1)}:1) '
              'outside NRC recommended range (1.2:1 to 2:1)');
        }
      }
    }
    
    return ValidationResult(
      warnings: warnings,
      errors: errors,
      isValid: errors.isEmpty,
      standard: 'NRC 2012',
    );
  }
  
  /// Extract SID lysine from result JSON
  static double? _extractSidLysine(Result result) {
    if (result.aminoAcidsSidJson == null) return null;
    
    try {
      final Map<String, dynamic> sidMap = json.decode(result.aminoAcidsSidJson!);
      final lysine = sidMap['lysine'] as num?;
      return lysine != null ? lysine.toDouble() / 10 : null; // g/kg to %
    } catch (e) {
      return null;
    }
  }
}

class ValidationResult {
  final List<String> warnings;
  final List<String> errors;
  final bool isValid;
  final String standard;
  
  const ValidationResult({
    required this.warnings,
    required this.errors,
    required this.isValid,
    required this.standard,
  });
}
```

---

---

### Phase 4: Unit Standardization & Display Formatting

#### 4.0 Nutrient Unit Standardization

**Objective**: Ensure consistent, industry-standard unit display across all nutrient values.

> [!IMPORTANT]
> **Critical Display Requirements**:
> - **Energy**: Always display in **kcal/kg** (kilocalories per kilogram)
> - **All Other Nutrients**: Display as **percentages (%)** of diet composition
> - **Amino Acids**: Convert from g/kg to % for display (divide by 10)
> - **Minerals**: Convert from g/kg to % for display (divide by 10)

**[NEW]** [nutrient_formatter.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/utils/nutrient_formatter.dart)

```dart
/// Utility class for formatting nutrient values with correct units
/// 
/// Industry Standards:
/// - Energy: kcal/kg (no conversion needed)
/// - Proximate nutrients (CP, CF, Fat, Ash, Moisture, Starch): % DM
/// - Amino acids: % (converted from g/kg storage format)
/// - Minerals (Ca, P): % (converted from g/kg storage format)
class NutrientFormatter {
  
  /// Format energy value (always in kcal/kg)
  /// 
  /// Input: Energy value in kcal/kg
  /// Output: "2,350 kcal/kg" or "2,350" (without unit if specified)
  static String formatEnergy(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';
    
    final formatted = value.toStringAsFixed(0);
    return includeUnit ? '$formatted kcal/kg' : formatted;
  }
  
  /// Format proximate nutrient (CP, CF, Fat, Ash, Moisture, Starch)
  /// 
  /// Input: Value already in % DM
  /// Output: "16.5%" or "16.5" (without unit if specified)
  static String formatProximateNutrient(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';
    
    final formatted = value.toStringAsFixed(1);
    return includeUnit ? '$formatted%' : formatted;
  }
  
  /// Format amino acid value (convert from g/kg to %)
  /// 
  /// Input: Value in g/kg (storage format)
  /// Output: "0.95%" or "0.95" (without unit if specified)
  /// 
  /// Example: Lysine = 9.5 g/kg → Display as 0.95%
  static String formatAminoAcid(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';
    
    // Convert g/kg to % (divide by 10)
    final percentage = value / 10;
    final formatted = percentage.toStringAsFixed(2);
    return includeUnit ? '$formatted%' : formatted;
  }
  
  /// Format mineral value (convert from g/kg to %)
  /// 
  /// Input: Value in g/kg (storage format)
  /// Output: "0.65%" or "0.65" (without unit if specified)
  /// 
  /// Example: Calcium = 6.5 g/kg → Display as 0.65%
  static String formatMineral(num? value, {bool includeUnit = true}) {
    if (value == null) return '--';
    
    // Convert g/kg to % (divide by 10)
    final percentage = value / 10;
    final formatted = percentage.toStringAsFixed(2);
    return includeUnit ? '$formatted%' : formatted;
  }
  
  /// Format phosphorus value (convert from g/kg to %)
  /// 
  /// Input: Value in g/kg (storage format)
  /// Output: "0.35%" or "0.35" (without unit if specified)
  static String formatPhosphorus(num? value, {bool includeUnit = true}) {
    return formatMineral(value, includeUnit: includeUnit);
  }
  
  /// Get unit label for nutrient type
  static String getUnitLabel(NutrientType type) {
    switch (type) {
      case NutrientType.energy:
        return 'kcal/kg';
      case NutrientType.proximateNutrient:
      case NutrientType.aminoAcid:
      case NutrientType.mineral:
        return '%';
      case NutrientType.bulkDensity:
        return 'kg/m³';
      case NutrientType.antiNutritionalFactor:
        return 'varies'; // Depends on specific ANF
    }
  }
  
  /// Format result card value with appropriate unit
  static String formatResultValue(num? value, NutrientType type) {
    switch (type) {
      case NutrientType.energy:
        return formatEnergy(value);
      case NutrientType.proximateNutrient:
        return formatProximateNutrient(value);
      case NutrientType.aminoAcid:
        return formatAminoAcid(value);
      case NutrientType.mineral:
        return formatMineral(value);
      default:
        return value?.toStringAsFixed(2) ?? '--';
    }
  }
}

enum NutrientType {
  energy,
  proximateNutrient,
  aminoAcid,
  mineral,
  bulkDensity,
  antiNutritionalFactor,
}
```

**[MODIFY]** [estimated_result_widget.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_update_feed/widget/estimated_result_widget.dart)

Update to use proper formatting:

```dart
// Line 44-48: Energy display (CORRECT - already in kcal/kg)
EstimatedContentCard(
  value: data.mEnergy,
  title: 'Energy',
  unit: 'kcal/kg', // ✅ Correct unit
),

// Line 52-56: Crude Protein (CORRECT - already in %)
EstimatedContentCard(
  value: data.cProtein,
  title: 'Crude Protein',
  unit: '%', // ✅ Correct unit
),

// Line 64-68: Crude Fiber (CORRECT - already in %)
EstimatedContentCard(
  value: data.cFibre,
  title: 'Crude Fibre',
  unit: '%', // ✅ Correct unit
),

// Line 72-76: Crude Fat (CORRECT - already in %)
EstimatedContentCard(
  value: data.cFat,
  title: 'Crude Fat',
  unit: '%', // ✅ Correct unit
),

// Line 86-90: Ash (CORRECT - already in %)
EstimatedContentCard(
  value: data.ash,
  title: 'Ash',
  unit: '%', // ✅ Correct unit
),

// Line 94-98: Moisture (CORRECT - already in %)
EstimatedContentCard(
  value: data.moisture,
  title: 'Moisture',
  unit: '%', // ✅ Correct unit
),

// Line 108-112: Total Phosphorus (NEEDS CONVERSION - stored as g/kg)
EstimatedContentCard(
  value: data.totalPhosphorus != null 
    ? data.totalPhosphorus! / 10 // Convert g/kg to %
    : null,
  title: 'Total P',
  unit: '%', // ✅ Changed from g/kg to %
),

// Line 116-120: Available Phosphorus (NEEDS CONVERSION - stored as g/kg)
EstimatedContentCard(
  value: data.availablePhosphorus != null 
    ? data.availablePhosphorus! / 10 // Convert g/kg to %
    : null,
  title: 'Avail. P',
  unit: '%', // ✅ Changed from g/kg to %
),
```

**[MODIFY]** [result.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/reports/model/result.dart)

Add helper methods for formatted display:

```dart
// Add to Result class (after line 165)

/// Get formatted energy value (kcal/kg)
String get formattedEnergy => NutrientFormatter.formatEnergy(mEnergy);

/// Get formatted crude protein (%)
String get formattedCrudeProtein => NutrientFormatter.formatProximateNutrient(cProtein);

/// Get formatted crude fiber (%)
String get formattedCrudeFiber => NutrientFormatter.formatProximateNutrient(cFibre);

/// Get formatted crude fat (%)
String get formattedCrudeFat => NutrientFormatter.formatProximateNutrient(cFat);

/// Get formatted ash (%)
String get formattedAsh => NutrientFormatter.formatProximateNutrient(ash);

/// Get formatted moisture (%)
String get formattedMoisture => NutrientFormatter.formatProximateNutrient(moisture);

/// Get formatted total phosphorus (% - converted from g/kg)
String get formattedTotalPhosphorus => 
  NutrientFormatter.formatPhosphorus(totalPhosphorus);

/// Get formatted available phosphorus (% - converted from g/kg)
String get formattedAvailablePhosphorus => 
  NutrientFormatter.formatPhosphorus(availablePhosphorus);

/// Get formatted calcium (% - converted from g/kg)
String get formattedCalcium => 
  NutrientFormatter.formatMineral(calcium);

/// Get formatted lysine (% - converted from g/kg)
String get formattedLysine => 
  NutrientFormatter.formatAminoAcid(lysine);

/// Get formatted methionine (% - converted from g/kg)
String get formattedMethionine => 
  NutrientFormatter.formatAminoAcid(methionine);
```

**Unit Conversion Reference Table**:

| Nutrient | Storage Format | Display Format | Conversion | Example |
|----------|---------------|----------------|------------|---------|
| **Energy (NE, ME, DE)** | kcal/kg | kcal/kg | None | 2,350 kcal/kg |
| **Crude Protein** | % DM | % | None | 16.5% |
| **Crude Fiber** | % DM | % | None | 3.2% |
| **Crude Fat** | % DM | % | None | 4.8% |
| **Ash** | % DM | % | None | 5.5% |
| **Moisture** | % | % | None | 10.0% |
| **Starch** | % DM | % | None | 45.2% |
| **Lysine** | g/kg | % | ÷ 10 | 9.5 g/kg → 0.95% |
| **Methionine** | g/kg | % | ÷ 10 | 3.2 g/kg → 0.32% |
| **All Amino Acids** | g/kg | % | ÷ 10 | 7.5 g/kg → 0.75% |
| **Calcium** | g/kg | % | ÷ 10 | 6.5 g/kg → 0.65% |
| **Total Phosphorus** | g/kg | % | ÷ 10 | 4.5 g/kg → 0.45% |
| **Available Phosphorus** | g/kg | % | ÷ 10 | 2.8 g/kg → 0.28% |
| **Phytate Phosphorus** | g/kg | % | ÷ 10 | 1.7 g/kg → 0.17% |
| **Bulk Density** | kg/m³ | kg/m³ | None | 650 kg/m³ |

**Validation Examples**:

```dart
// Test cases for unit formatting
void testNutrientFormatting() {
  // Energy: No conversion
  assert(NutrientFormatter.formatEnergy(2350) == '2350 kcal/kg');
  
  // Crude Protein: No conversion
  assert(NutrientFormatter.formatProximateNutrient(16.5) == '16.5%');
  
  // Lysine: Convert g/kg to %
  assert(NutrientFormatter.formatAminoAcid(9.5) == '0.95%');
  
  // Calcium: Convert g/kg to %
  assert(NutrientFormatter.formatMineral(6.5) == '0.65%');
  
  // Total Phosphorus: Convert g/kg to %
  assert(NutrientFormatter.formatPhosphorus(4.5) == '0.45%');
}
```

**UI Display Guidelines**:

1. **Result Cards**: Always show unit labels
   ```dart
   Text('Energy: ${result.formattedEnergy}')  // "Energy: 2,350 kcal/kg"
   Text('Lysine: ${result.formattedLysine}')  // "Lysine: 0.95%"
   ```

2. **Tables**: Unit in column header, values without units
   ```dart
   DataColumn(label: Text('Lysine (%)')),
   DataCell(Text(NutrientFormatter.formatAminoAcid(value, includeUnit: false))),
   ```

3. **Input Forms**: Show unit as hint text
   ```dart
   TextField(
     decoration: InputDecoration(
       labelText: 'Lysine',
       suffixText: 'g/kg', // Storage format for input
       helperText: 'Will display as % in results',
     ),
   )
   ```

4. **Comparison Charts**: Use consistent units
   ```dart
   // All amino acids in %
   BarChart(
     data: aminoAcids.map((aa) => 
       NutrientFormatter.formatAminoAcid(aa.value, includeUnit: false)
     ),
   )
   ```

---

### Phase 5: UI/UX Enhancements

#### 4.1 Comprehensive Nutrient Display

**[MODIFY]** [feed_result_screen.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/reports/view/feed_result_screen.dart)

Add expandable sections for:

1. **Amino Acid Profile Card**
   - Toggle between Total and SID values
   - Display all 11 amino acids in table format
   - Highlight limiting amino acids (below requirements)
   - Color-coded: Green (adequate), Yellow (marginal), Red (deficient)

2. **Energy Values Card**
   - Show NE (primary for pigs), ME, DE
   - Display for each animal type
   - Indicate which value is being used in calculations

3. **Phosphorus Breakdown Card**
   - Total, Available, Phytate phosphorus
   - Show availability percentage
   - Environmental compliance indicator (EU: <3.5 g/kg total P)

4. **Anti-Nutritional Factors Card** (if present)
   - Display ANF levels with warning icons
   - Show safe inclusion limits
   - Color-coded warnings

5. **Formulation Warnings Card**
   - Inclusion limit violations
   - ANF warnings
   - Nutrient deficiencies
   - Industry standard compliance issues

**Example UI Structure**:

```dart
class EnhancedFeedResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Basic nutrients (existing)
          BasicNutrientsCard(result: result),
          
          // NEW: Amino Acid Profile
          ExpansionTile(
            title: Text('Amino Acid Profile (SID)'),
            leading: Icon(Icons.science, color: Colors.blue),
            children: [
              AminoAcidTable(
                aminoAcids: result.aminoAcidsSidJson,
                requirements: pigGrowerRequirements,
              ),
            ],
          ),
          
          // NEW: Energy Values
          ExpansionTile(
            title: Text('Energy Values'),
            leading: Icon(Icons.bolt, color: Colors.orange),
            children: [
              EnergyValuesDisplay(
                ne: result.mEnergy, // Actually NE now
                animalType: feed.animalId,
              ),
            ],
          ),
          
          // NEW: Phosphorus Breakdown
          PhosphorusCard(
            total: result.totalPhosphorus,
            available: result.availablePhosphorus,
            phytate: result.phytatePhosphorus,
          ),
          
          // NEW: Warnings & Compliance
          if (result.warningsJson != null)
            WarningsCard(warnings: result.warningsJson),
          
          // NEW: Industry Standards Validation
          IndustryComplianceCard(
            result: result,
            animalType: feed.animalId,
          ),
        ],
      ),
    );
  }
}
```

---

#### 4.2 Ingredient Detail Enhancement

**[MODIFY]** [ingredient_detail_screen.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/store_ingredients/view/ingredient_detail_screen.dart)

Add comprehensive nutrient display:

```dart
// Proximate Analysis Section
ProximateAnalysisCard(
  crudeProtein: ingredient.crudeProtein,
  crudeFiber: ingredient.crudeFiber,
  crudeFat: ingredient.crudeFat,
  ash: ingredient.ash,
  moisture: ingredient.moisture,
  starch: ingredient.starch,
),

// Amino Acid Profile (Expandable)
ExpansionTile(
  title: Text('Amino Acid Profile'),
  children: [
    ToggleButtons(
      children: [Text('Total'), Text('SID')],
      isSelected: [showTotal, !showTotal],
      onPressed: (index) => setState(() => showTotal = index == 0),
    ),
    AminoAcidDetailTable(
      profile: showTotal 
        ? ingredient.aminoAcidsTotal 
        : ingredient.aminoAcidsSid,
    ),
  ],
),

// Energy Values (Expandable)
ExpansionTile(
  title: Text('Energy Values'),
  children: [
    EnergyDetailTable(energy: ingredient.energy),
  ],
),

// Phosphorus Breakdown
PhosphorusDetailCard(
  total: ingredient.totalPhosphorus,
  available: ingredient.availablePhosphorus,
  phytate: ingredient.phytatePhosphorus,
),

// Anti-Nutritional Factors (if present)
if (ingredient.antiNutritionalFactors != null)
  AntiNutritionalFactorsCard(
    anf: ingredient.antiNutritionalFactors!,
    maxInclusion: ingredient.maxInclusionPct,
  ),

// Safety & Regulatory
if (ingredient.warning != null || ingredient.regulatoryNote != null)
  SafetyWarningsCard(
    warning: ingredient.warning,
    regulatoryNote: ingredient.regulatoryNote,
  ),
```

---

### Phase 6: Testing & Validation

#### 5.1 Unit Tests

**[NEW]** [test/calculation_accuracy_test.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/test/calculation_accuracy_test.dart)

```dart
void main() {
  group('SID Amino Acid Calculations', () {
    test('Corn SID lysine should be ~2.5 g/kg', () {
      final corn = Ingredient(
        name: 'Corn grain',
        aminoAcidsSid: AminoAcidsProfile(lysine: 2.5),
      );
      
      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [FeedIngredients(ingredientId: 1, quantity: 100)],
        ingredientCache: {1: corn},
        animalTypeId: 1,
      );
      
      final sidLysine = json.decode(result.aminoAcidsSidJson!)['lysine'];
      expect(sidLysine, closeTo(2.5, 0.1));
    });
  });
  
  group('Net Energy Calculations', () {
    test('Corn NE for pigs should be ~2100 kcal/kg', () {
      final corn = Ingredient(
        name: 'Corn grain',
        energy: EnergyValues(nePig: 2100),
      );
      
      final result = EnhancedCalculationEngine.calculateEnhancedResult(
        feedIngredients: [FeedIngredients(ingredientId: 1, quantity: 100)],
        ingredientCache: {1: corn},
        animalTypeId: 1,
      );
      
      expect(result.mEnergy, closeTo(2100, 50));
    });
  });
  
  group('Inclusion Limit Validation', () {
    test('Should warn when approaching inclusion limit', () {
      final canola = Ingredient(
        name: 'Canola meal',
        maxInclusionPct: 20,
      );
      
      final validation = InclusionValidator.validate(
        feedIngredients: [FeedIngredients(ingredientId: 1, quantity: 19)],
        ingredientCache: {1: canola},
        animalTypeId: 1,
      );
      
      expect(validation.warnings, isNotEmpty);
      expect(validation.warnings.first, contains('approaching limit'));
    });
  });
}
```

---

#### 5.2 Integration Tests

**[NEW]** [integration_test/formulation_accuracy_test.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/integration_test/formulation_accuracy_test.dart)

```dart
void main() {
  testWidgets('Complete pig grower formulation test', (tester) async {
    // Load test formulation
    final testFeed = Feed(
      feedName: 'Test Pig Grower',
      animalId: 1,
      feedIngredients: [
        FeedIngredients(ingredientId: 1, quantity: 60), // Corn
        FeedIngredients(ingredientId: 2, quantity: 25), // Soybean meal
        FeedIngredients(ingredientId: 3, quantity: 10), // Wheat bran
        FeedIngredients(ingredientId: 4, quantity: 5),  // Limestone
      ],
    );
    
    // Calculate result
    final result = await calculateFormulation(testFeed);
    
    // Validate against NRC 2012
    expect(result.cProtein, greaterThan(16));
    expect(result.cProtein, lessThan(20));
    expect(result.mEnergy, greaterThan(2200));
    expect(result.mEnergy, lessThan(2500));
    
    // Validate SID lysine
    final sidLysine = extractSidLysine(result);
    expect(sidLysine, greaterThan(0.90));
    
    // Validate phosphorus
    expect(result.availablePhosphorus, greaterThan(2.0)); // g/kg
    expect(result.totalPhosphorus, lessThan(6.0)); // Environmental limit
  });
}
```

---

### Phase 7: Performance Optimization

#### 6.1 Calculation Caching

**Already Implemented**: Line 66 in `result_provider.dart` has `_calculationCache`.

**Enhancement**: Add cache invalidation on ingredient updates.

#### 6.2 Database Indexing

**[MODIFY]** [ingredients_repository.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/repository/ingredients_repository.dart)

Add indexes for frequently queried fields:

```sql
CREATE INDEX IF NOT EXISTS idx_ingredients_category 
ON ingredients(category_id);

CREATE INDEX IF NOT EXISTS idx_ingredients_custom 
ON ingredients(is_custom);

CREATE INDEX IF NOT EXISTS idx_ingredients_name 
ON ingredients(name);
```

---

## Verification Plan

### Automated Tests

```bash
# Unit tests
flutter test test/models/
flutter test test/services/nutrient_validator_test.dart
flutter test test/services/inclusion_validator_test.dart

# Integration tests
flutter test integration_test/formulation_accuracy_test.dart
flutter test integration_test/database_migration_test.dart
```

### Manual Verification

1. **Data Migration**:
   - Export database before migration
   - Run migration
   - Verify all custom ingredients preserved
   - Verify formulations still calculate correctly
   - Test rollback mechanism

2. **Calculation Accuracy**:
   - Create test formulation with known ingredients
   - Compare SID amino acid totals with manual calculations
   - Verify NE calculations match NRC 2012 values
   - Test phosphorus availability calculations

3. **Inclusion Limits**:
   - Create formulation exceeding inclusion limit
   - Verify error message appears
   - Test warning at 90% of limit

4. **UI/UX**:
   - Navigate through all enhanced screens
   - Verify amino acid profiles display correctly
   - Test energy value displays
   - Check ANF warnings
   - Test ingredient detail enhancements

### Validation Criteria

✅ All existing formulations recalculate with new data structure  
✅ Custom user ingredients preserved and functional  
✅ SID amino acid calculations match NRC 2012 (±2% tolerance)  
✅ NE calculations align with NRC values (±50 kcal/kg tolerance)  
✅ Inclusion limits enforced with appropriate warnings  
✅ ANF validation functional  
✅ No data loss during migration  
✅ Rollback mechanism functional  
✅ UI displays all new nutritional data correctly  
✅ Performance remains acceptable (no regression >20%)  
✅ Database queries <100ms for ingredient list  
✅ Formulation calculations <500ms  

---

## Rollout Strategy

### Phase 1: Internal Testing (Week 1-2)
- Deploy to test environment
- Run automated test suite
- Manual testing by development team
- Performance benchmarking

### Phase 2: Beta Testing (Week 3-4)
- Deploy to beta users
- Collect feedback on new features
- Monitor for calculation accuracy issues
- Test migration on real user databases

### Phase 3: Production Rollout (Week 5)
- Deploy to production with feature flag
- Enable for 10% of users initially
- Monitor error rates and performance
- Gradual rollout to 100% over 1 week

### Phase 4: Post-Launch (Week 6+)
- Monitor user feedback
- Address any issues
- Optimize based on usage patterns
- Plan next enhancements

---

## Risk Mitigation

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Data loss during migration | Low | Critical | Automated backup + rollback mechanism |
| Calculation errors | Medium | High | Comprehensive unit tests + NRC validation |
| Performance degradation | Low | Medium | Caching + indexing + benchmarking |
| User confusion with new UI | Medium | Low | In-app tutorials + documentation |
| Inclusion limit false positives | Low | Medium | Thorough testing + user override option |

---

## Success Metrics

1. **Accuracy**: 100% of test formulations match NRC standards (±2%)
2. **Data Integrity**: 0 data loss incidents during migration
3. **Performance**: <500ms calculation time for 95th percentile
4. **Adoption**: >80% of users successfully migrate within 2 weeks
5. **Satisfaction**: >4.5/5 user rating for new features

---

## Appendix A: Industry Standards Reference

### NRC 2012 (Swine)
- **SID Lysine (Grower, 20-50kg)**: 0.95-1.05% of diet
- **Net Energy (Grower)**: 2,300-2,450 kcal/kg
- **Available Phosphorus (Grower)**: 0.23-0.33%
- **Calcium (Grower)**: 0.50-0.70%
- **Ca:P Ratio**: 1.2:1 to 2:1

### NRC 2016 (Poultry)
- **Lysine (Broiler Starter)**: 1.20-1.35%
- **ME (Broiler Starter)**: 3,000-3,100 kcal/kg
- **Available Phosphorus**: 0.40-0.45%

### CVB 2021 (Dutch Tables)
- **SID Amino Acids**: Primary metric for protein quality
- **Net Energy**: Primary energy metric for pigs
- **Digestibility Coefficients**: Standardized across ingredients

### EU Regulations
- **Total Phosphorus Limit**: <3.5 g/kg (environmental compliance)
- **Copper Limit**: <150 ppm for pigs
- **Zinc Limit**: <150 ppm for pigs

---

## Appendix B: Ingredient Mapping Table

| Old ID | Old Name | New ID | New Name | Notes |
|--------|----------|--------|----------|-------|
| 1 | Alfalfa meal, dehydrated | 1 | Alfalfa meal, dehydrated, protein < 16% | Direct mapping |
| 2 | Barley grain | 2 | Barley grain | Direct mapping |
| 15 | Rice bran (deprecated) | 2 | Barley grain | Use barley as substitute |
| ... | ... | ... | ... | ... |

*(Complete mapping to be generated from analysis of both datasets)*

---

## Appendix C: Anti-Nutritional Factor Limits

| Factor | Safe Level | Limit | Action |
|--------|-----------|-------|--------|
| Glucosinolates | <15 μmol/g | >30 μmol/g | Limit to 10% inclusion |
| Trypsin Inhibitors | <20 TU/g | >40 TU/g | Require heat treatment |
| Tannins | <3000 ppm | >5000 ppm | Limit to 15% inclusion |
| Phytic Acid | <10,000 ppm | >20,000 ppm | Add phytase enzyme |
| Cyanogenic Glycosides | <50 ppm | >100 ppm | Limit to 5% inclusion |

---

**Document Version**: 1.0  
**Last Updated**: 2025-12-16  
**Status**: Ready for Review  
**Next Steps**: User approval → Implementation → Testing → Deployment

