# Harmonized Dataset Migration Implementation Plan

**Version**: 1.0  
**Date**: December 15, 2025  
**Status**: 🟡 READY FOR REVIEW  
**Migration Target**: Database v4 → v5

---

## Executive Summary

This plan outlines the seamless migration from the current ingredient database to the new harmonized industrial-grade dataset while ensuring:

✅ **Zero data loss** - All existing user data preserved  
✅ **Zero breaking changes** - All existing formulations remain functional  
✅ **Improved accuracy** - Enhanced nutritional calculations with SID amino acids  
✅ **Better UI/UX** - Richer ingredient information and warnings  
✅ **Backward compatibility** - Smooth upgrade path for all users

---

## Current vs New Dataset Comparison

### Current Structure (v4)

```dart
class Ingredient {
  num? ingredientId;
  String? name;
  num? crudeProtein;        // % dry matter
  num? crudeFiber;          // % dry matter
  num? crudeFat;            // % dry matter
  num? calcium;             // g/kg
  num? phosphorus;          // g/kg (total)
  num? lysine;              // g/kg (total)
  num? methionine;          // g/kg (total)
  num? meGrowingPig;        // kcal/kg
  num? meAdultPig;          // kcal/kg
  num? mePoultry;           // kcal/kg
  num? meRuminant;          // kcal/kg
  num? meRabbit;            // kcal/kg
  num? deSalmonids;         // kcal/kg
  // ... metadata fields
}
```

**Limitations:**
- Only 2 amino acids (lysine, methionine)
- Total phosphorus only (no available/phytate breakdown)
- Missing: ash, moisture, starch, bulk density
- No anti-nutritional factor tracking
- No standardized ileal digestibility (SID) values

### New Harmonized Structure (v5 Target)

```json
{
  "id": 1,
  "name": "Alfalfa meal, dehydrated, protein < 16%",
  "crude_protein": 15.5,
  "crude_fiber": 28.0,
  "crude_fat": 2.3,
  "ash": 10.5,
  "moisture": 10.0,
  "starch": null,
  "calcium": 15.0,
  "total_phosphorus": 2.4,
  "available_phosphorus": 0.7,
  "phytate_phosphorus": 1.7,
  "amino_acids_total": {
    "lysine": 6.9,
    "methionine": 1.8,
    "threonine": 5.8,
    "tryptophan": 1.9,
    "isoleucine": 5.4,
    "leucine": 9.2,
    "valine": 6.7,
    "arginine": 6.1,
    "histidine": 2.5,
    "phenylalanine": 7.5
  },
  "amino_acids_sid": {
    "lysine": 6.2,
    "methionine": 1.6,
    // ... all 10 amino acids
  },
  "energy": {
    "me_growing_pig": 2080,
    "me_finishing_pig": 2170,
    "me_adult_pig": 2170,
    "me_poultry": 1310,
    "me_ruminant": 2130,
    "de_salmonids": 2160
  },
  "bulk_density": 450,
  "anti_nutritional_factors": {},
  "price_kg": 0.35,
  "available_qty": 5000,
  "category": "Forages & roughages",
  "category_id": 13,
  "notes": "",
  "warning": "",
  "regulatory_note": ""
}
```

**Enhancements:**
- ✅ 10 essential amino acids (total + SID)
- ✅ Phosphorus breakdown (total, available, phytate)
- ✅ Complete proximate analysis (ash, moisture, starch)
- ✅ Anti-nutritional factors tracking
- ✅ Bulk density for practical formulation
- ✅ Warnings and regulatory notes
- ✅ More granular energy values (finishing pigs)

---

## Migration Strategy

### Phase 1: Database Schema Extension (Non-Breaking)

**Migration v4 → v5** - Add new columns without removing old ones

```sql
-- Add new proximate analysis fields
ALTER TABLE ingredients ADD COLUMN ash REAL;
ALTER TABLE ingredients ADD COLUMN moisture REAL;
ALTER TABLE ingredients ADD COLUMN starch REAL;
ALTER TABLE ingredients ADD COLUMN bulk_density REAL;

-- Expand phosphorus tracking
ALTER TABLE ingredients ADD COLUMN total_phosphorus REAL;
ALTER TABLE ingredients ADD COLUMN available_phosphorus REAL;
ALTER TABLE ingredients ADD COLUMN phytate_phosphorus REAL;

-- Store JSON for complex structures
ALTER TABLE ingredients ADD COLUMN amino_acids_total TEXT; -- JSON
ALTER TABLE ingredients ADD COLUMN amino_acids_sid TEXT;   -- JSON
ALTER TABLE ingredients ADD COLUMN energy TEXT;            -- JSON
ALTER TABLE ingredients ADD COLUMN anti_nutritional_factors TEXT; -- JSON

-- Add new energy field for finishing pigs
ALTER TABLE ingredients ADD COLUMN me_finishing_pig INTEGER;

-- Metadata enhancements
ALTER TABLE ingredients ADD COLUMN category_name TEXT;
ALTER TABLE ingredients ADD COLUMN warning TEXT;
ALTER TABLE ingredients ADD COLUMN regulatory_note TEXT;

-- NEW: Maximum inclusion limits (safety constraints)
ALTER TABLE ingredients ADD COLUMN max_inclusion_pct REAL; -- Maximum % in total formulation
ALTER TABLE ingredients ADD COLUMN inclusion_reason TEXT;  -- Why limit exists

-- CRITICAL: Keep existing columns for backward compatibility
-- Old fields remain: lysine, methionine, phosphorus, etc.
```

**Backward Compatibility Strategy:**
1. **Keep all v4 columns** - No data deletion
2. **Map old to new** - Populate new fields from old values during migration
3. **Fallback logic** - Application uses old fields if new fields are NULL

### Phase 2: Data Migration & Enrichment

```dart
Future<void> _migrationV4ToV5(Database db) async {
  debugPrint('Migration 4→5: Upgrading to harmonized dataset');
  
  try {
    // Step 1: Add new columns (schema above)
    await _addV5Columns(db);
    
    // Step 2: Load new harmonized data
    final String jsonString = await rootBundle.loadString(
      'assets/raw/initial_ingredients_.json'
    );
    final List<dynamic> harmonizedData = json.decode(jsonString);
    
    // Step 3: Update existing ingredients with enriched data
    Batch batch = db.batch();
    for (var newData in harmonizedData) {
      // Match by name (case-insensitive, fuzzy)
      final existingId = await _findMatchingIngredient(db, newData['name']);
      
      if (existingId != null) {
        // UPDATE: Enrich existing ingredient
        batch.update(
          IngredientsRepository.tableName,
          _buildUpdateMap(newData),
          where: 'ingredient_id = ?',
          whereArgs: [existingId],
        );
      } else {
        // INSERT: Add new ingredient from harmonized dataset
        batch.insert(
          IngredientsRepository.tableName,
          _buildInsertMap(newData),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
    
    await batch.commit(noResult: true);
    
    // Step 4: Migrate old phosphorus → total_phosphorus
    await db.execute('''
      UPDATE ${IngredientsRepository.tableName}
      SET total_phosphorus = phosphorus
      WHERE total_phosphorus IS NULL AND phosphorus IS NOT NULL
    ''');
    
    // Step 5: Migrate old lysine/methionine to JSON structure
    await _migrateAminoAcidsToJSON(db);
    
    // Step 6: Validate migration
    final validationResult = await _validateMigration(db);
    debugPrint('Migration 4→5: Validation result: $validationResult');
    
    debugPrint('Migration 4→5: Complete - ${harmonizedData.length} ingredients processed');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Migration 4→5 failed',
      tag: 'AppDatabase',
      error: e,
      stackTrace: stackTrace,
    );
    rethrow;
  }
}

/// Build update map preserving user customizations
Map<String, dynamic> _buildUpdateMap(Map<String, dynamic> newData) {
  return {
    // Proximate analysis
    'ash': newData['ash'],
    'moisture': newData['moisture'],
    'starch': newData['starch'],
    
    // Enhanced phosphorus
    'total_phosphorus': newData['total_phosphorus'],
    'available_phosphorus': newData['available_phosphorus'],
    'phytate_phosphorus': newData['phytate_phosphorus'],
    
    // JSON structures
    'amino_acids_total': json.encode(newData['amino_acids_total'] ?? {}),
    'amino_acids_sid': json.encode(newData['amino_acids_sid'] ?? {}),
    'energy': json.encode(newData['energy'] ?? {}),
    'anti_nutritional_factors': json.encode(
      newData['anti_nutritional_factors'] ?? {}
    ),
    
    // Practical data
    'bulk_density': newData['bulk_density'],
    'category_name': newData['category'],
    
    // Warnings and notes (only if empty)
    'warning': newData['warning'],
    'regulatory_note': newData['regulatory_note'],
    
    // DON'T update: price_kg, available_qty, favourite (user data)
    // DON'T update: is_custom, created_by, notes (user metadata)
  };
}

/// Migrate old amino acid columns to JSON structure
Future<void> _migrateAminoAcidsToJSON(Database db) async {
  final ingredients = await db.query(IngredientsRepository.tableName);
  
  Batch batch = db.batch();
  for (var ing in ingredients) {
    // Only migrate if new structure is empty
    if (ing['amino_acids_total'] == null && 
        (ing['lysine'] != null || ing['methionine'] != null)) {
      
      final aminoAcidsTotal = {
        'lysine': ing['lysine'],
        'methionine': ing['methionine'],
      };
      
      batch.update(
        IngredientsRepository.tableName,
        {'amino_acids_total': json.encode(aminoAcidsTotal)},
        where: 'ingredient_id = ?',
        whereArgs: [ing['ingredient_id']],
      );
    }
  }
  
  await batch.commit(noResult: true);
}
```

### Phase 3: Model Layer Updates

```dart
class Ingredient {
  // ===== EXISTING FIELDS (PRESERVED) =====
  num? ingredientId;
  String? name;
  num? crudeProtein;
  num? crudeFiber;
  num? crudeFat;
  
  // LEGACY: Keep for backward compatibility
  num? calcium;
  num? phosphorus;        // Deprecated: Use totalPhosphorus
  num? lysine;            // Deprecated: Use aminoAcidsTotal['lysine']
  num? methionine;        // Deprecated: Use aminoAcidsTotal['methionine']
  
  // LEGACY: Energy fields kept for fallback
  num? meGrowingPig;
  num? meAdultPig;
  num? mePoultry;
  num? meRuminant;
  num? meRabbit;
  num? deSalmonids;
  
  // User metadata (preserved)
  num? priceKg;
  num? availableQty;
  num? categoryId;
  num? favourite;
  num? isCustom;
  String? createdBy;
  num? createdDate;
  String? notes;
  
  // ===== NEW FIELDS (v5) =====
  num? ash;
  num? moisture;
  num? starch;
  num? bulkDensity;
  
  // Enhanced phosphorus tracking
  num? totalPhosphorus;
  num? availablePhosphorus;
  num? phytatePhosphorus;
  
  // Finishing pig energy (new)
  num? meFinishingPig;
  
  // Complex structures as JSON
  Map<String, num>? aminoAcidsTotal;
  Map<String, num>? aminoAcidsSID;
  Map<String, num>? energyValues;
  Map<String, dynamic>? antiNutritionalFactors;
  
  // Metadata
  String? categoryName;
  String? warning;
  String? regulatoryNote;
  
  // NEW: Maximum inclusion limits
  num? maxInclusionPct;        // Maximum % in formulation (e.g., 10 = 10%)
  String? inclusionReason;     // Why limit exists
  
  // ===== SMART GETTERS (Fallback Logic) =====
  
  /// Get lysine value with fallback to old column
  num? get lysineValue => 
    aminoAcidsTotal?['lysine'] ?? lysine;
  
  /// Get methionine value with fallback
  num? get methionineValue => 
    aminoAcidsTotal?['methionine'] ?? methionine;
  
  /// Get total phosphorus with fallback
  num? get phosphorusValue => 
    totalPhosphorus ?? phosphorus;
  
  /// Get ME for growing pig with fallback
  num? getMEGrowingPig() => 
    energyValues?['me_growing_pig'] ?? meGrowingPig;
  
  // Similar fallback methods for other energy values...
}
```

---

## Calculation Algorithm Improvements

### Current Algorithm (result_provider.dart)

```dart
// Simple weighted average - CORRECT but limited
totalProtein += (ingredient.crudeProtein ?? 0) * quantity;
totalLysine += (ingredient.lysine ?? 0) * quantity;
// ...
_cProtein = totalProtein / _totalQuantity;  // %
_lyzine = totalLysine / _totalQuantity;     // g/kg
```

**Issues:**
1. Only 2 amino acids tracked
2. No SID (Standardized Ileal Digestibility) calculations
3. Missing available phosphorus calculations
4. No anti-nutritional factor warnings

### Enhanced Algorithm (v5)

```dart
Future<void> calculateResult() async {
  final ingList = _feed.feedIngredients;
  if (ingList == null || ingList.isEmpty) return;

  await _loadIngredientCache();
  _totalQuantity = _calcTotalQuantity(ingList);
  if (_totalQuantity <= 0) return;

  // Initialize accumulators
  double totalEnergy = 0;
  double totalProtein = 0;
  double totalFat = 0;
  double totalFiber = 0;
  
  // Enhanced tracking
  double totalAsh = 0;
  double totalMoisture = 0;
  Map<String, double> aminoAcidsTotal = {};
  Map<String, double> aminoAcidsSID = {};
  double totalCalcium = 0;
  double totalPhosphorus = 0;
  double totalAvailablePhosphorus = 0;
  double totalPhytatePhosphorus = 0;
  
  List<String> warnings = [];
  
  // Calculate weighted averages
  for (var feedIng in ingList) {
    final ingredient = _ingredientCache[feedIng.ingredientId];
    if (ingredient == null) continue;
    
    final qty = (feedIng.quantity ?? 0).toDouble();
    if (qty <= 0) continue;
    
    // Basic proximate analysis
    totalProtein += (ingredient.crudeProtein ?? 0) * qty;
    totalFat += (ingredient.crudeFat ?? 0) * qty;
    totalFiber += (ingredient.crudeFiber ?? 0) * qty;
    totalAsh += (ingredient.ash ?? 0) * qty;
    totalMoisture += (ingredient.moisture ?? 0) * qty;
    
    // Energy (with fallback)
    final energy = ingredient.getMEForAnimal(_feed.animalId);
    totalEnergy += energy * qty;
    
    // Enhanced amino acid tracking
    if (ingredient.aminoAcidsTotal != null) {
      for (var entry in ingredient.aminoAcidsTotal!.entries) {
        aminoAcidsTotal[entry.key] = 
          (aminoAcidsTotal[entry.key] ?? 0) + (entry.value * qty);
      }
    }
    
    if (ingredient.aminoAcidsSID != null) {
      for (var entry in ingredient.aminoAcidsSID!.entries) {
        aminoAcidsSID[entry.key] = 
          (aminoAcidsSID[entry.key] ?? 0) + (entry.value * qty);
      }
    }
    
    // Enhanced phosphorus tracking
    totalCalcium += (ingredient.calcium ?? 0) * qty;
    totalPhosphorus += (ingredient.phosphorusValue ?? 0) * qty;
    totalAvailablePhosphorus += (ingredient.availablePhosphorus ?? 0) * qty;
    totalPhytatePhosphorus += (ingredient.phytatePhosphorus ?? 0) * qty;
    
    // Collect warnings
    if (ingredient.warning != null && ingredient.warning!.isNotEmpty) {
      warnings.add('${ingredient.name}: ${ingredient.warning}');
    }
    if (ingredient.regulatoryNote != null && 
        ingredient.regulatoryNote!.isNotEmpty) {
      warnings.add('⚠️ ${ingredient.name}: ${ingredient.regulatoryNote}');
    }
  }
  
  // Calculate per-unit values
  _cProtein = totalProtein / _totalQuantity;
  _cFat = totalFat / _totalQuantity;
  _cFibre = totalFiber / _totalQuantity;
  _mEnergy = totalEnergy / _totalQuantity;
  
  // Enhanced results
  _ash = totalAsh / _totalQuantity;
  _moisture = totalMoisture / _totalQuantity;
  _calcium = totalCalcium / _totalQuantity;
  _totalPhosphorus = totalPhosphorus / _totalQuantity;
  _availablePhosphorus = totalAvailablePhosphorus / _totalQuantity;
  _phytatePhosphorus = totalPhytatePhosphorus / _totalQuantity;
  
  // Amino acid results (g/kg)
  Map<String, double> aminoAcidsResult = {};
  Map<String, double> aminoAcidsSIDResult = {};
  
  for (var aa in aminoAcidsTotal.keys) {
    aminoAcidsResult[aa] = aminoAcidsTotal[aa]! / _totalQuantity;
  }
  
  for (var aa in aminoAcidsSID.keys) {
    aminoAcidsSIDResult[aa] = aminoAcidsSID[aa]! / _totalQuantity;
  }
  
  // Legacy field population (backward compatibility)
  _lyzine = aminoAcidsResult['lysine'] ?? 0;
  _methionine = aminoAcidsResult['methionine'] ?? 0;
  _phosphorus = _totalPhosphorus;
  
  // Build enhanced result
  _newResult = Result(
    feedId: _feed.feedId,
    mEnergy: _mEnergy,
    cProtein: _cProtein,
    cFat: _cFat,
    cFibre: _cFibre,
    
    // Legacy fields
    calcium: _calcium,
    phosphorus: _phosphorus,
    lysine: _lyzine,
    methionine: _methionine,
    
    // NEW: Enhanced fields
    ash: _ash,
    moisture: _moisture,
    aminoAcidsTotal: aminoAcidsResult,
    aminoAcidsSID: aminoAcidsSIDResult,
    totalPhosphorus: _totalPhosphorus,
    availablePhosphorus: _availablePhosphorus,
    phytatePhosphorus: _phytatePhosphorus,
    warnings: warnings,
    
    // Cost tracking (unchanged)
    costPerUnit: _costPerUnit,
    totalCost: _totalCost,
    totalQuantity: _totalQuantity,
  );
}
```

**Improvements:**
1. ✅ Tracks all 10 essential amino acids
2. ✅ Calculates SID values for precise digestibility
3. ✅ Phosphorus breakdown (total, available, phytate)
4. ✅ Ash and moisture tracking for dry matter calculations
5. ✅ Collects and displays warnings/regulatory notes
6. ✅ Validates maximum inclusion limits with real-time alerts
7. ✅ Maintains backward compatibility with legacy fields

---

## Maximum Inclusion Limit Validation

### Database Schema for Limits

```sql
-- Max inclusion stored in ingredients table
max_inclusion_pct REAL          -- e.g., 5.0 = maximum 5% of total formulation
inclusion_reason TEXT           -- e.g., "High gossypol - toxic above 5%"
```

**Examples from Harmonized Dataset:**
```json
{
  "name": "Cottonseed meal",
  "max_inclusion_pct": 15.0,
  "inclusion_reason": "Free gossypol toxicity - limit to 15% of diet"
},
{
  "name": "Urea",
  "max_inclusion_pct": 1.0,
  "inclusion_reason": "DANGEROUS - Ruminants only, can cause ammonia toxicity"
},
{
  "name": "Moringa leaf meal",
  "max_inclusion_pct": 10.0,
  "inclusion_reason": "High oxalate and saponin content - limit 5-10%"
}
```

### Validation Algorithm

```dart
/// Validates ingredient inclusion percentages against maximum limits
class InclusionLimitValidator {
  /// Check if formulation violates any ingredient limits
  static InclusionValidationResult validateFormulation(
    List<FeedIngredients> ingredients,
    Map<num, Ingredient> ingredientCache,
  ) {
    final violations = <InclusionViolation>[];
    final warnings = <InclusionWarning>[];
    
    // Calculate total quantity
    final totalQty = ingredients.fold<double>(
      0.0, 
      (sum, ing) => sum + (ing.quantity ?? 0).toDouble()
    );
    
    if (totalQty <= 0) {
      return InclusionValidationResult.empty();
    }
    
    // Check each ingredient against its limit
    for (var feedIng in ingredients) {
      final ingredient = ingredientCache[feedIng.ingredientId];
      if (ingredient == null) continue;
      
      final qty = (feedIng.quantity ?? 0).toDouble();
      final percentageInFormulation = (qty / totalQty) * 100;
      
      // Check maximum inclusion limit
      if (ingredient.maxInclusionPct != null) {
        final maxLimit = ingredient.maxInclusionPct!.toDouble();
        
        if (percentageInFormulation > maxLimit) {
          // VIOLATION: Exceeds safe limit
          violations.add(InclusionViolation(
            ingredientName: ingredient.name ?? 'Unknown',
            currentPercentage: percentageInFormulation,
            maxPercentage: maxLimit,
            reason: ingredient.inclusionReason ?? 'Safety limit exceeded',
            severity: _determineSeverity(percentageInFormulation, maxLimit),
          ));
        } else if (percentageInFormulation > (maxLimit * 0.8)) {
          // WARNING: Approaching limit (>80% of max)
          warnings.add(InclusionWarning(
            ingredientName: ingredient.name ?? 'Unknown',
            currentPercentage: percentageInFormulation,
            maxPercentage: maxLimit,
            reason: ingredient.inclusionReason ?? 'Approaching safety limit',
          ));
        }
      }
      
      // Check anti-nutritional factor warnings
      if (ingredient.antiNutritionalFactors != null &&
          ingredient.antiNutritionalFactors!.isNotEmpty) {
        warnings.add(InclusionWarning(
          ingredientName: ingredient.name ?? 'Unknown',
          currentPercentage: percentageInFormulation,
          maxPercentage: ingredient.maxInclusionPct?.toDouble(),
          reason: 'Contains anti-nutritional factors: '
                  '${ingredient.antiNutritionalFactors!.keys.join(", ")}',
        ));
      }
    }
    
    return InclusionValidationResult(
      violations: violations,
      warnings: warnings,
      isValid: violations.isEmpty,
    );
  }
  
  /// Determine severity based on how much limit is exceeded
  static ViolationSeverity _determineSeverity(
    double current, 
    double max,
  ) {
    final excessPercent = ((current - max) / max) * 100;
    
    if (excessPercent > 50) return ViolationSeverity.critical;  // >50% over limit
    if (excessPercent > 20) return ViolationSeverity.high;      // >20% over limit
    return ViolationSeverity.medium;                             // <20% over limit
  }
  
  /// Calculate suggested maximum quantity for an ingredient
  static double calculateMaxQuantity(
    Ingredient ingredient,
    double totalQuantity,
  ) {
    if (ingredient.maxInclusionPct == null) {
      return double.infinity; // No limit
    }
    
    return (ingredient.maxInclusionPct!.toDouble() / 100) * totalQuantity;
  }
}

/// Result of inclusion limit validation
class InclusionValidationResult {
  final List<InclusionViolation> violations;
  final List<InclusionWarning> warnings;
  final bool isValid;
  
  const InclusionValidationResult({
    required this.violations,
    required this.warnings,
    required this.isValid,
  });
  
  factory InclusionValidationResult.empty() => const InclusionValidationResult(
    violations: [],
    warnings: [],
    isValid: true,
  );
  
  bool get hasViolations => violations.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasIssues => hasViolations || hasWarnings;
}

/// Represents a hard violation of inclusion limits
class InclusionViolation {
  final String ingredientName;
  final double currentPercentage;
  final double maxPercentage;
  final String reason;
  final ViolationSeverity severity;
  
  const InclusionViolation({
    required this.ingredientName,
    required this.currentPercentage,
    required this.maxPercentage,
    required this.reason,
    required this.severity,
  });
  
  String get message =>
      '$ingredientName: ${currentPercentage.toStringAsFixed(1)}% '
      '(max: ${maxPercentage.toStringAsFixed(1)}%) - $reason';
}

/// Represents a warning about approaching limits
class InclusionWarning {
  final String ingredientName;
  final double currentPercentage;
  final double? maxPercentage;
  final String reason;
  
  const InclusionWarning({
    required this.ingredientName,
    required this.currentPercentage,
    this.maxPercentage,
    required this.reason,
  });
  
  String get message {
    if (maxPercentage != null) {
      return '$ingredientName: ${currentPercentage.toStringAsFixed(1)}% '
             '(approaching max: ${maxPercentage!.toStringAsFixed(1)}%) - $reason';
    }
    return '$ingredientName: ${currentPercentage.toStringAsFixed(1)}% - $reason';
  }
}

enum ViolationSeverity {
  medium,   // Slightly over limit
  high,     // Significantly over limit
  critical, // Dangerously over limit
}
```

### Integration with Result Calculation

```dart
// In result_provider.dart - Enhanced calculateResult()
Future<void> calculateResult() async {
  final ingList = _feed.feedIngredients;
  if (ingList == null || ingList.isEmpty) return;

  await _loadIngredientCache();
  _totalQuantity = _calcTotalQuantity(ingList);
  if (_totalQuantity <= 0) return;

  // ... existing calculation code ...
  
  // NEW: Validate inclusion limits
  final validationResult = InclusionLimitValidator.validateFormulation(
    ingList,
    _ingredientCache,
  );
  
  // Add violations to warnings list
  if (validationResult.hasViolations) {
    for (var violation in validationResult.violations) {
      warnings.add('🔴 LIMIT EXCEEDED: ${violation.message}');
    }
  }
  
  // Add warnings about approaching limits
  if (validationResult.hasWarnings) {
    for (var warning in validationResult.warnings) {
      warnings.add('⚠️ ${warning.message}');
    }
  }
  
  // Build enhanced result with validation status
  _newResult = Result(
    // ... existing fields ...
    warnings: warnings,
    inclusionViolations: validationResult.violations,
    inclusionWarnings: validationResult.warnings,
    isInclusionValid: validationResult.isValid,
  );
}
```

---

## UI/UX Enhancements

### 1. Enhanced Ingredient Detail View

```dart
// lib/src/features/add_ingredients/widget/ingredient_detail_card.dart
class IngredientDetailCard extends StatelessWidget {
  final Ingredient ingredient;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Basic info (unchanged)
        _buildBasicInfo(),
        
        // NEW: Amino Acid Profile Section
        if (ingredient.aminoAcidsTotal != null)
          _buildAminoAcidSection(),
        
        // NEW: Phosphorus Breakdown
        if (ingredient.availablePhosphorus != null)
          _buildPhosphorusSection(),
        
        // NEW: Anti-nutritional Factors
        if (ingredient.antiNutritionalFactors != null && 
            ingredient.antiNutritionalFactors!.isNotEmpty)
          _buildAntiNutritionalSection(),
        
        // NEW: Warnings Banner
        if (ingredient.warning != null || ingredient.regulatoryNote != null)
          _buildWarningBanner(),
      ],
    );
  }
  
  Widget _buildAminoAcidSection() {
    return ExpansionTile(
      title: Text('Amino Acid Profile (10 essential)'),
      children: [
        _buildAminoAcidTable(),
        if (ingredient.aminoAcidsSID != null)
          _buildSIDComparison(),
      ],
    );
  }
  
  Widget _buildPhosphorusSection() {
    return Card(
      child: Column(
        children: [
          _buildNutrientRow(
            'Total Phosphorus',
            '${ingredient.totalPhosphorus} g/kg'
          ),
          _buildNutrientRow(
            'Available Phosphorus',
            '${ingredient.availablePhosphorus} g/kg',
            subtitle: 'Bioavailable for animal'
          ),
          _buildNutrientRow(
            'Phytate Phosphorus',
            '${ingredient.phytatePhosphorus} g/kg',
            subtitle: 'Requires phytase'
          ),
          _buildAvailabilityIndicator(),
        ],
      ),
    );
  }
  
  Widget _buildWarningBanner() {
    return Container(
      color: Colors.amber.shade100,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if (ingredient.warning != null)
            Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(child: Text(ingredient.warning!)),
              ],
            ),
          if (ingredient.regulatoryNote != null)
            Row(
              children: [
                Icon(Icons.gavel, color: Colors.red),
                SizedBox(width: 8),
                Expanded(child: Text(ingredient.regulatoryNote!)),
              ],
            ),
          // NEW: Maximum inclusion limit display
          if (ingredient.maxInclusionPct != null)
            Row(
              children: [
                Icon(Icons.rule, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Maximum inclusion: ${ingredient.maxInclusionPct}% of diet\n'
                    '${ingredient.inclusionReason ?? "Safety limit"}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

### 4. Real-Time Inclusion Validation Widget

```dart
// lib/src/features/add_update_feed/widget/inclusion_limit_indicator.dart

class InclusionLimitIndicator extends ConsumerWidget {
  final num ingredientId;
  final double currentQuantity;
  final double totalQuantity;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredient = ref.watch(ingredientCache(ingredientId));
    
    if (ingredient?.maxInclusionPct == null) {
      return SizedBox.shrink();
    }
    
    final maxLimit = ingredient!.maxInclusionPct!.toDouble();
    final currentPct = (currentQuantity / totalQuantity) * 100;
    final percentOfLimit = (currentPct / maxLimit) * 100;
    
    // Determine color based on usage
    Color indicatorColor;
    if (percentOfLimit > 100) {
      indicatorColor = Colors.red;       // Exceeded
    } else if (percentOfLimit > 80) {
      indicatorColor = Colors.orange;    // Warning zone
    } else {
      indicatorColor = Colors.green;     // Safe
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.1),
        border: Border.all(color: indicatorColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.rule, size: 16, color: indicatorColor),
          SizedBox(width: 4),
          Text(
            '${currentPct.toStringAsFixed(1)}% / ${maxLimit.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: indicatorColor,
            ),
          ),
          if (percentOfLimit > 100)
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: Tooltip(
                message: ingredient.inclusionReason ?? 'Limit exceeded',
                child: Icon(Icons.error, size: 16, color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
```

### 2. Enhanced Result Display

```dart
// lib/src/features/reports/widget/enhanced_result_card.dart
class EnhancedResultCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(resultProvider).myResult;
    
    return Column(
      children: [
        // Existing energy/protein/fat/fiber cards
        _buildPrimaryMetrics(result),
        
        // NEW: Amino Acid Summary
        _buildAminoAcidSummary(result),
        
        // NEW: Phosphorus Availability
        _buildPhosphorusCard(result),
        
        // NEW: Warnings Section
        if (result.warnings != null && result.warnings!.isNotEmpty)
          _buildWarningsSection(result.warnings!),
        
        // NEW: Dry Matter Basis Toggle
        _buildDryMatterToggle(),
      ],
    );
  }
  
  Widget _buildAminoAcidSummary(Result result) {
    return Card(
      child: Column(
        children: [
          Text('Essential Amino Acids', 
            style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              _buildAAChip('Lysine', result.aminoAcidsTotal?['lysine']),
              _buildAAChip('Methionine', result.aminoAcidsTotal?['methionine']),
              _buildAAChip('Threonine', result.aminoAcidsTotal?['threonine']),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () => _showFullAminoAcidDialog(context, result),
              ),
            ],
          ),
          if (result.aminoAcidsSID != null)
            Text('SID values available', 
              style: TextStyle(fontSize: 12, color: Colors.blue)),
        ],
      ),
    );
  }
  
  Widget _buildPhosphorusCard(Result result) {
    final availability = result.availablePhosphorus != null && 
                         result.totalPhosphorus != null
      ? (result.availablePhosphorus! / result.totalPhosphorus! * 100)
      : 0.0;
    
    return Card(
      child: Column(
        children: [
          Text('Phosphorus Breakdown'),
          LinearProgressIndicator(
            value: availability / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              availability > 60 ? Colors.green : Colors.orange
            ),
          ),
          Text('${availability.toStringAsFixed(1)}% Available'),
          Text(
            '${result.availablePhosphorus?.toStringAsFixed(2)} / '
            '${result.totalPhosphorus?.toStringAsFixed(2)} g/kg',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWarningsSection(List<String> warnings) {
    return Card(
      color: Colors.amber.shade50,
      child: ExpansionTile(
        leading: Icon(Icons.warning, color: Colors.orange),
        title: Text('Formulation Warnings (${warnings.length})'),
        children: warnings.map((w) => 
          ListTile(
            dense: true,
            title: Text(w, style: TextStyle(fontSize: 13)),
          )
        ).toList(),
      ),
    );
  }
}
```

### 3. PDF Report Enhancements

```dart
// lib/src/features/reports/widget/pdf_export/pdf/enhanced_pdf_export.dart

// Add sections for:
// 1. Complete amino acid table
// 2. Phosphorus availability chart
// 3. Warnings and regulatory notes
// 4. SID digestibility values
// 5. Anti-nutritional factor summary
```

---

## Validation & Testing Plan

### Pre-Migration Validation

```powershell
# 1. Backup current database
flutter test test/integration/database_backup_test.dart

# 2. Export all user data
flutter run --dart-define=EXPORT_USER_DATA=true

# 3. Count existing formulations
flutter test test/integration/formulation_count_test.dart
```

### Post-Migration Validation

```dart
// test/integration/migration_v5_validation_test.dart

group('Migration v4→v5 Validation', () {
  test('All existing ingredients preserved', () async {
    final preCount = await getIngredientCount(dbV4);
    await runMigration();
    final postCount = await getIngredientCount(dbV5);
    
    expect(postCount, greaterThanOrEqualTo(preCount));
  });
  
  test('User custom ingredients intact', () async {
    final customIngredients = await getCustomIngredients(dbV5);
    
    for (var ing in customIngredients) {
      expect(ing.isCustom, equals(1));
      expect(ing.name, isNotNull);
      expect(ing.priceKg, isNotNull);
    }
  });
  
  test('Existing formulations produce similar results (±5%)', () async {
    final formulations = await getAllFormulations(dbV4);
    await runMigration();
    
    for (var formulation in formulations) {
      final oldResult = await calculateResult(dbV4, formulation);
      final newResult = await calculateResult(dbV5, formulation);
      
      // Energy should be within ±5%
      expect(
        (newResult.mEnergy - oldResult.mEnergy).abs() / oldResult.mEnergy,
        lessThan(0.05),
      );
      
      // Protein should be within ±3%
      expect(
        (newResult.cProtein - oldResult.cProtein).abs() / oldResult.cProtein,
        lessThan(0.03),
      );
    }
  });
  
  test('New ingredients have complete amino acid profiles', () async {
    final newIngredients = await getIngredientsAddedInV5(dbV5);
    
    for (var ing in newIngredients) {
      if (ing.aminoAcidsTotal != null) {
        expect(ing.aminoAcidsTotal!.keys, contains('lysine'));
        expect(ing.aminoAcidsTotal!.keys, contains('methionine'));
        expect(ing.aminoAcidsTotal!.keys.length, greaterThanOrEqualTo(2));
      }
    }
  });
  
  test('Phosphorus migration correct', () async {
    await runMigration();
    final ingredients = await getAllIngredients(dbV5);
    
    for (var ing in ingredients) {
      if (ing.phosphorus != null) {
        // Old phosphorus value should be migrated to totalPhosphorus
        expect(ing.totalPhosphorus, equals(ing.phosphorus));
      }
    }
  });
  
  test('UI displays new fields correctly', () {
    // Widget test for amino acid display
  });
  
  test('PDF generation includes new data', () async {
    final result = await calculateEnhancedResult(sampleFormulation);
    final pdf = await generatePDF(result);
    
    expect(pdfContains(pdf, 'Amino Acid Profile'), isTrue);
    expect(pdfContains(pdf, 'Available Phosphorus'), isTrue);
  });
});
```

### Performance Benchmarks

```dart
// test/performance/calculation_performance_test.dart

test('Calculation time remains < 500ms', () async {
  final stopwatch = Stopwatch()..start();
  await calculateEnhancedResult(largeFormulation);
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(500));
});

test('Ingredient list load time < 1s', () async {
  final stopwatch = Stopwatch()..start();
  await loadAllIngredients();
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(1000));
});
```

---

## Rollout Plan

### Phase 0: Preparation (Week 1)

- [ ] Review and approve this migration plan
- [ ] Create feature branch: `feature/harmonized-dataset-v5`
- [ ] Set up database v5 test environment
- [ ] Create comprehensive backup scripts

### Phase 1: Schema & Model Updates (Week 1-2)

- [ ] Implement database migration v4→v5
- [ ] Update Ingredient model with new fields
- [ ] Add fallback logic for backward compatibility
- [ ] Write unit tests for model changes

### Phase 2: Calculation Engine Enhancement (Week 2-3)

- [ ] Update result_provider.dart with enhanced algorithm
- [ ] Add amino acid calculation logic
- [ ] Implement phosphorus breakdown calculations
- [ ] Add warning collection system
- [ ] Write calculation unit tests

### Phase 3: UI/UX Updates (Week 3-4)

- [ ] Update ingredient detail views
- [ ] Enhance result display cards
- [ ] Add amino acid profile widgets
- [ ] Implement warning banners
- [ ] Update PDF generation
- [ ] Widget tests for new UI components

### Phase 4: Testing & Validation (Week 4-5)

- [ ] Run full test suite
- [ ] Perform migration validation tests
- [ ] Manual QA testing on test devices
- [ ] Performance benchmarking
- [ ] User acceptance testing (beta users)

### Phase 5: Deployment (Week 5-6)

- [ ] Merge to main branch
- [ ] Build release APK
- [ ] Staged rollout (10% → 50% → 100%)
- [ ] Monitor crash reports and feedback
- [ ] Hot-fix preparation if needed

---

## Risk Mitigation

### Risk 1: Data Loss During Migration

**Mitigation:**
- Automatic database backup before migration
- Export user data to JSON file
- Rollback mechanism to restore v4 database
- Manual data recovery procedures documented

### Risk 2: Breaking Changes to Formulations

**Mitigation:**
- Keep all v4 columns active
- Fallback logic in calculations
- Validation tests ensure ±5% accuracy
- Gradual rollout allows quick rollback

### Risk 3: Performance Degradation

**Mitigation:**
- Comprehensive performance benchmarks
- JSON column indexing strategies
- Lazy loading for complex data
- Caching improvements

### Risk 4: User Confusion with New Features

**Mitigation:**
- In-app tutorial for new features
- Tooltips explaining SID, available phosphorus
- Gradual feature announcement
- Help documentation updates

---

## Success Criteria

✅ **Zero data loss** - All user ingredients and formulations preserved  
✅ **Calculation accuracy** - Results within ±5% of v4 (expected variance due to data quality)  
✅ **Performance** - No regression > 20% in any operation  
✅ **User adoption** - < 1% rollback requests  
✅ **Crash rate** - < 0.1% increase post-migration  
✅ **User feedback** - > 80% positive reviews on new features  

---

## Monitoring & Support

### Post-Deployment Monitoring

```dart
// Track migration success
AnalyticsService.trackEvent('migration_v5_start');
AnalyticsService.trackEvent('migration_v5_complete');
AnalyticsService.trackEvent('migration_v5_failed', {'error': e.toString()});

// Track feature adoption
AnalyticsService.trackEvent('amino_acid_view_opened');
AnalyticsService.trackEvent('phosphorus_breakdown_viewed');
AnalyticsService.trackEvent('warning_banner_shown');
```

### Support Resources

- Migration FAQ document
- Video tutorial for new features
- In-app help tooltips
- Direct support email for migration issues

---

## Appendix

### A. Ingredient Matching Algorithm

```dart
/// Fuzzy match ingredient names for migration enrichment
Future<int?> _findMatchingIngredient(
  Database db, 
  String newName
) async {
  // Exact match
  var result = await db.query(
    IngredientsRepository.tableName,
    where: 'LOWER(name) = ?',
    whereArgs: [newName.toLowerCase()],
  );
  
  if (result.isNotEmpty) {
    return result.first['ingredient_id'] as int;
  }
  
  // Fuzzy match (Levenshtein distance < 5)
  final allIngredients = await db.query(IngredientsRepository.tableName);
  
  for (var ing in allIngredients) {
    final existingName = ing['name'] as String;
    if (_levenshteinDistance(
      existingName.toLowerCase(), 
      newName.toLowerCase()
    ) < 5) {
      return ing['ingredient_id'] as int;
    }
  }
  
  return null; // No match - will be inserted as new
}
```

### B. JSON Schema Examples

```dart
// amino_acids_total column (TEXT/JSON)
{
  "lysine": 6.9,
  "methionine": 1.8,
  "threonine": 5.8,
  "tryptophan": 1.9,
  "isoleucine": 5.4,
  "leucine": 9.2,
  "valine": 6.7,
  "arginine": 6.1,
  "histidine": 2.5,
  "phenylalanine": 7.5
}

// energy column (TEXT/JSON)
{
  "me_growing_pig": 2080,
  "me_finishing_pig": 2170,
  "me_adult_pig": 2170,
  "me_poultry": 1310,
  "me_ruminant": 2130,
  "de_salmonids": 2160
}

// anti_nutritional_factors column (TEXT/JSON)
{
  "glucosinolates_micromol_g": 10.0,
  "trypsin_inhibitor_tiu_mg": 2.5,
  "free_gossypol_ppm": 1200
}
```

---

**Document Status**: Ready for technical review and approval  
**Next Action**: Schedule review meeting with development team  
**Owner**: Development Team  
**Reviewers**: Product Manager, QA Lead, Database Architect
