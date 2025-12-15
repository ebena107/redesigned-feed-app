# Implementation Plan: Migrate to Industrial-Grade Ingredient Dataset

## Overview

Migrate from the current basic ingredient dataset (165 ingredients, 8 nutrients) to a comprehensive industrial-grade dataset (120 ingredients, 20+ nutrients) that includes SID amino acids, Net Energy values, phosphorus breakdown, and anti-nutritional factors.

## User Review Required

> [!IMPORTANT]
> **Breaking Changes**: This migration will require database schema changes and may affect existing user data. Custom ingredients created by users will need to be migrated to the new structure.

> [!WARNING]
> **Calculation Changes**: Feed formulations will use SID (Standardized Ileal Digestible) amino acids instead of total amino acids, which may result in different formulation results. This is more accurate but existing formulations may need to be recalculated.

> [!CAUTION]
> **Data Loss Risk**: The new dataset has fewer ingredients (120 vs 165). Some ingredients from the old dataset may not have equivalents in the new dataset. We need to decide how to handle ingredients that users may have used in existing formulations.

---

## Proposed Changes

### Phase 1: Data Model & Schema Updates

#### [NEW] [amino_acids_profile.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/model/amino_acids_profile.dart)

Create a new model class for amino acid profiles:

```dart
class AminoAcidsProfile {
  final num? lysine;
  final num? methionine;
  final num? cystine;
  final num? threonine;
  final num? tryptophan;
  final num? arginine;
  final num? isoleucine;
  final num? leucine;
  final num? valine;
  final num? histidine;
  final num? phenylalanine;
  
  // Constructor, fromJson, toJson, copyWith
}
```

This separates total and SID amino acid profiles for better organization.

---

#### [NEW] [energy_values.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/model/energy_values.dart)

Create a new model class for energy values:

```dart
class EnergyValues {
  final num? dePig;        // Digestible Energy for pigs
  final num? mePig;        // Metabolizable Energy for pigs
  final num? nePig;        // Net Energy for pigs (NEW - modern standard)
  final num? mePoultry;
  final num? meRuminant;
  final num? meRabbit;
  final num? deSalmonids;
  
  // Constructor, fromJson, toJson, copyWith
}
```

This consolidates all energy values and adds the critical NE value.

---

#### [NEW] [anti_nutritional_factors.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/model/anti_nutritional_factors.dart)

Create a new model class for anti-nutritional factors:

```dart
class AntiNutritionalFactors {
  final num? glucosinolatesMicromolG;
  final num? cyanogenicGlycosidesPpm;
  final num? tanninsPpm;
  final num? phyticAcidPpm;
  final num? trypsinInhibitorTuG;
  
  // Constructor, fromJson, toJson, copyWith
}
```

This tracks compounds that limit ingredient inclusion rates.

---

#### [MODIFY] [ingredient.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/model/ingredient.dart)

Major refactoring to support the new comprehensive structure:

**Remove:**
- `lysine` (moved to AminoAcidsProfile)
- `methionine` (moved to AminoAcidsProfile)
- `phosphorus` (replaced by totalPhosphorus)
- `meGrowingPig` (replaced by energy.mePig)
- `meAdultPig` (removed - use mePig for all pigs)
- `mePoultry`, `meRuminant`, `meRabbit`, `deSalmonids` (moved to EnergyValues)

**Add:**
- `num? ash` - Ash content (% DM)
- `num? moisture` - Moisture content (% as-fed basis)
- `num? starch` - Starch content (% DM)
- `num? bulkDensity` - Bulk density (kg/m³)
- `num? totalPhosphorus` - Total phosphorus (g/kg)
- `num? availablePhosphorus` - Available phosphorus (g/kg)
- `num? phytatePhosphorus` - Phytate phosphorus (g/kg)
- `AminoAcidsProfile? aminoAcidsTotal` - Total amino acids
- `AminoAcidsProfile? aminoAcidsSid` - SID amino acids
- `EnergyValues? energy` - All energy values
- `AntiNutritionalFactors? antiNutritionalFactors` - Optional ANFs
- `String? category` - Category name (in addition to categoryId)

**Update JSON parsing** to handle nested objects and new field names.

---

### Phase 2: Business Logic Updates

#### [MODIFY] [feed_calculator.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_update_feed/services/feed_calculator.dart)

Update all feed formulation calculations:

**Amino Acid Calculations:**
- Switch from `ingredient.lysine` to `ingredient.aminoAcidsSid?.lysine ?? ingredient.aminoAcidsTotal?.lysine`
- Prefer SID values for digestibility calculations
- Add calculations for all 11 amino acids

**Energy Calculations:**
- For pigs: Prefer `energy.nePig` over `energy.mePig` when available
- Update energy summation logic to use nested energy object
- Add dry matter conversion: `energyDM = energyAsFed * (100 - moisture) / 100`

**Phosphorus Calculations:**
- Use `availablePhosphorus` for nutritional requirements
- Track `totalPhosphorus` for regulatory compliance
- Calculate phytase effect on phytate phosphorus

**Anti-Nutritional Factor Warnings:**
- Check ANF levels against safe limits
- Generate warnings when inclusion rates exceed recommendations
- Example: Canola meal with glucosinolates > 30 μmol/g should be limited to 10% inclusion

---

#### [MODIFY] [ingredient_validator.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/services/ingredient_validator.dart)

Add validation for new required fields:

```dart
// Validate amino acid profiles
if (ingredient.aminoAcidsTotal == null && ingredient.aminoAcidsSid == null) {
  errors.add('At least one amino acid profile is required');
}

// Validate energy values
if (ingredient.energy == null) {
  errors.add('Energy values are required');
}

// Validate phosphorus breakdown
if (ingredient.totalPhosphorus != null && ingredient.availablePhosphorus != null) {
  if (ingredient.availablePhosphorus! > ingredient.totalPhosphorus!) {
    errors.add('Available phosphorus cannot exceed total phosphorus');
  }
}
```

---

### Phase 3: Data Migration

#### [NEW] [migrate_ingredients_v2.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/core/database/migrations/migrate_ingredients_v2.dart)

Create a migration script to transform existing data:

**Mapping Strategy:**
1. **Amino Acids**: Map `lysine` and `methionine` to `aminoAcidsTotal`, leave other amino acids null
2. **Energy**: Map `meGrowingPig` → `energy.mePig`, `meAdultPig` → `energy.mePig` (average if different)
3. **Phosphorus**: Map `phosphorus` → `totalPhosphorus`, set `availablePhosphorus` to 30% of total (conservative estimate)
4. **New Fields**: Set defaults - `moisture: 10`, `ash: 5`, `bulkDensity: 500`

**Custom Ingredients**: Preserve all user-created ingredients with backward compatibility.

---

#### [MODIFY] [initial_data_uploader.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/core/database/initial_data_uploader.dart)

Update to load the new dataset:

```dart
Future<String> _loadIngredientDataAssets() async {
  return await rootBundle.loadString('assets/raw/initial_ingredients_.json');
}
```

---

#### [MODIFY] [assets.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/generated/assets.dart)

Update asset reference:

```dart
static const String rawInitialIngredients = 'assets/raw/initial_ingredients_.json';
```

---

### Phase 4: UI/UX Updates

#### [MODIFY] [ingredient_detail_screen.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/store_ingredients/view/ingredient_detail_screen.dart)

Enhance ingredient display to show comprehensive nutritional data:

**Add Sections:**
1. **Proximate Analysis**: CP, CF, Fat, Ash, Moisture, Starch
2. **Amino Acid Profile** (Expandable):
   - Toggle between Total and SID values
   - Display all 11 amino acids in a table
3. **Energy Values** (Expandable):
   - Show DE, ME, NE for each animal type
   - Highlight NE for pigs as the preferred value
4. **Phosphorus Breakdown**:
   - Total, Available, Phytate phosphorus
   - Show availability percentage
5. **Physical Properties**: Bulk density
6. **Anti-Nutritional Factors** (if present):
   - Display with warning icons
   - Show safe inclusion limits

---

#### [MODIFY] [add_ingredient_screen.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/view/add_ingredient_screen.dart)

Update ingredient input form:

**Add Input Sections:**
1. **Basic Nutrients**: Existing fields + ash, moisture, starch
2. **Amino Acids** (Collapsible):
   - Two tabs: "Total" and "SID"
   - 11 input fields per tab
3. **Energy Values** (Collapsible):
   - Inputs for all 7 energy types
4. **Phosphorus**:
   - Total, Available, Phytate inputs
   - Auto-calculate phytate if total and available are provided
5. **Physical Properties**: Bulk density input
6. **Anti-Nutritional Factors** (Optional, Collapsible)

---

#### [MODIFY] [feed_result_screen.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_update_feed/view/feed_result_screen.dart)

Update formulation results display:

**Enhanced Results:**
1. **Amino Acid Summary**:
   - Show SID totals for all 11 amino acids
   - Compare against requirements
   - Highlight limiting amino acids
2. **Energy Summary**:
   - Display NE total for pigs (primary metric)
   - Show ME and DE as secondary metrics
3. **Phosphorus Summary**:
   - Total vs Available phosphorus
   - Environmental compliance indicator
4. **Warnings**:
   - Anti-nutritional factor alerts
   - Ingredient inclusion limit warnings

---

### Phase 5: Database Schema Updates

#### [MODIFY] [database_helper.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/core/database/database_helper.dart)

Update database schema (version bump required):

**New Columns:**
```sql
ALTER TABLE ingredients ADD COLUMN ash REAL;
ALTER TABLE ingredients ADD COLUMN moisture REAL;
ALTER TABLE ingredients ADD COLUMN starch REAL;
ALTER TABLE ingredients ADD COLUMN bulk_density REAL;
ALTER TABLE ingredients ADD COLUMN total_phosphorus REAL;
ALTER TABLE ingredients ADD COLUMN available_phosphorus REAL;
ALTER TABLE ingredients ADD COLUMN phytate_phosphorus REAL;
ALTER TABLE ingredients ADD COLUMN amino_acids_total TEXT; -- JSON
ALTER TABLE ingredients ADD COLUMN amino_acids_sid TEXT; -- JSON
ALTER TABLE ingredients ADD COLUMN energy TEXT; -- JSON
ALTER TABLE ingredients ADD COLUMN anti_nutritional_factors TEXT; -- JSON
ALTER TABLE ingredients ADD COLUMN category TEXT;
```

**Migration Logic:**
```sql
-- Migrate old phosphorus to total_phosphorus
UPDATE ingredients SET total_phosphorus = phosphorus WHERE phosphorus IS NOT NULL;

-- Set conservative defaults for available phosphorus
UPDATE ingredients SET available_phosphorus = total_phosphorus * 0.3 WHERE total_phosphorus IS NOT NULL;

-- Migrate old amino acids to JSON structure
UPDATE ingredients SET amino_acids_total = json_object(
  'lysine', lysine,
  'methionine', methionine
) WHERE lysine IS NOT NULL OR methionine IS NOT NULL;
```

---

## Verification Plan

### Automated Tests

**Unit Tests:**
```bash
flutter test test/models/amino_acids_profile_test.dart
flutter test test/models/energy_values_test.dart
flutter test test/models/ingredient_test.dart
flutter test test/services/feed_calculator_test.dart
```

**Integration Tests:**
```bash
flutter test integration_test/data_migration_test.dart
flutter test integration_test/feed_formulation_test.dart
```

### Manual Verification

1. **Data Migration Verification**:
   - Export database before migration
   - Run migration script
   - Verify all existing ingredients are preserved
   - Check custom user ingredients are intact
   - Validate formulations produce similar results

2. **Calculation Accuracy**:
   - Create test formulation with known ingredients
   - Compare SID amino acid totals with manual calculations
   - Verify NE calculations match industry standards
   - Test phosphorus availability calculations

3. **UI Testing**:
   - Navigate through all ingredient screens
   - Verify amino acid profiles display correctly
   - Test energy value displays
   - Check anti-nutritional factor warnings
   - Test ingredient creation with new fields

4. **Performance Testing**:
   - Load time for ingredient list (should be < 1s)
   - Formulation calculation time (should be < 500ms)
   - Database query performance with new JSON columns

### Validation Criteria

✅ All existing formulations can be recalculated with new data structure  
✅ Custom user ingredients are preserved and functional  
✅ SID amino acid calculations match industry standards (±2% tolerance)  
✅ NE calculations align with NRC (National Research Council) values  
✅ No data loss during migration  
✅ UI displays all new nutritional data correctly  
✅ Performance remains acceptable (no regression > 20%)
