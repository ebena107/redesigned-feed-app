# Phase 3 Implementation Guide: Data Import & Feature Flags

**Status:** ✅ Code Complete | 🟡 Testing Pending  
**Date:** December 22, 2025  
**Phase:** P3 (Data import, feature flags, verification)

---

## Overview

Phase 3 delivers **safe, feature-flagged data import** with automatic integrity verification and instant rollback capability.

### Key Deliverables

| Component | Location | Purpose |
|-----------|----------|---------|
| **FeatureFlags** | `lib/src/core/constants/feature_flags.dart` | Control dataset selection and feature rollout |
| **DataImportService** | `lib/src/core/services/data_import_service.dart` | Import ingredients and verify integrity |
| **Integration** | `lib/src/features/add_ingredients/provider/ingredients_provider.dart` | Auto-import on first launch |
| **Logging** | `lib/src/feed_app.dart` | Log feature flag status on startup |

---

## Feature Flags

### Available Flags

```dart
// lib/src/core/constants/feature_flags.dart

/// PRIMARY CONTROL: Choose ingredient dataset
static const bool useStandardizedIngredients = false; 
// ↑ Set to true to use v9 standardized dataset (201 items)
// ↑ Set to false to use v8 initial dataset (165 items)

/// SECONDARY: Enable per-category inclusion limits
static const bool usePerCategoryLimits = false;
// ↑ Requires useStandardizedIngredients = true
// ↑ Uses AnimalCategoryMapper for granular limits

/// UI: Show standards trust signals
static const bool showStandardsIndicators = false;
// ↑ Phase 4: Display "Standards-based" chips

/// UI: Production stage selector
static const bool enableProductionStageSelector = false;
// ↑ Phase 4: Allow stage selection (nursery, starter, grower, etc.)

/// ENGINE: Enhanced calculation engine (already enabled)
static const bool useEnhancedCalculationEngine = true;
// ↑ Phase 3 complete: All 10 amino acids, phosphorus breakdown, ANF warnings
```

### Helper Methods

```dart
// Get current dataset path
String path = FeatureFlags.ingredientDatasetPath;
// Returns: 'assets/raw/ingredients_standardized.json' or 'assets/raw/initial_ingredients_.json'

// Check if advanced features enabled
bool advanced = FeatureFlags.advancedFeaturesEnabled;
// Returns: true if both standardized ingredients + per-category limits active

// Log all flags on startup
FeatureFlags.logStatus();
// Prints all flag values to console for debugging
```

---

## Data Import Service

### Core Methods

#### 1. Import Ingredients

```dart
import 'package:feed_estimator/src/core/services/data_import_service.dart';

// Auto-import if database empty
final service = ref.read(dataImportService);
final imported = await service.importIngredients();

// Force reimport (clears existing data)
final reimported = await service.importIngredients(forceReimport: true);
```

**Behavior:**
- Checks if ingredients already exist → skips import if present
- Loads JSON from `FeatureFlags.ingredientDatasetPath`
- Imports each ingredient to database via `IngredientsRepository`
- Continues on individual ingredient errors (doesn't fail entire import)
- Returns count of successfully imported ingredients

#### 2. Verify Data Integrity

```dart
// Run verification checks
final report = await service.verifyDataIntegrity();

// Check status
if (report['status'] == 'PASSED') {
  print('✅ All checks passed');
} else {
  print('❌ Issues found: ${report['issues']}');
}
```

**Checks Performed:**
- Ingredient count matches expected (201 for v9, 165 for v8)
- No duplicate ingredient IDs
- All required fields present (name, etc.)
- **v9-specific:**
  - Count of ingredients with standardized names
  - Count with standard references (NRC, CVB, INRA, FAO)
  - Count with per-category limits in `max_inclusion_json`
  - Verification of separated variants (fish meal: 3, wheat: 3, corn: 4)

#### 3. Generate Verification Report

```dart
// Generate markdown report
final reportMd = await service.generateVerificationReport(report);

// Write to file (manual step)
await File('doc/IMPORT_VERIFICATION.md').writeAsString(reportMd);
```

**Report Includes:**
- Timestamp and dataset path
- Status (PASSED/FAILED)
- Total ingredient count
- Standardized data coverage statistics
- List of issues and warnings
- Pass/fail summary

---

## Integration Flow

### App Startup Sequence

```
1. App starts → FeedApp.build()
   ↓
2. FeatureFlags.logStatus() → Prints all flags to console
   ↓
3. User navigates to ingredient screen
   ↓
4. IngredientNotifier.loadIngredients()
   ↓
5. DataImportService.importIngredients() → Checks if DB empty
   ↓
6. If empty → Loads JSON from FeatureFlags.ingredientDatasetPath
   ↓
7. Imports to database via IngredientsRepository
   ↓
8. Returns ingredient count from database
   ↓
9. UI displays ingredients
```

### Code Integration Points

**1. FeedApp (Logging)**

```dart
// lib/src/feed_app.dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Log feature flags on startup
  FeatureFlags.logStatus();
  // ... rest of build
}
```

**2. IngredientNotifier (Auto-Import)**

```dart
// lib/src/features/add_ingredients/provider/ingredients_provider.dart
loadIngredients() async {
  try {
    // Auto-import if database empty
    final importService = ref.read(dataImportService);
    final imported = await importService.importIngredients();
    
    if (imported > 0) {
      AppLogger.info('Imported $imported ingredients on first launch');
    }

    // Load from database
    final ingList = await ref.watch(ingredientsRepository).getAll();
    state = state.copyWith(ingredients: ingList);
  } catch (e, stackTrace) {
    AppLogger.error('Failed to load ingredients', error: e);
    state = state.copyWith(ingredients: []); // Prevent crash
  }
}
```

---

## Testing Procedure

### Phase 3.1: Test with v8 Dataset (Baseline)

**Goal:** Verify existing functionality still works

1. **Set feature flags:**
   ```dart
   // lib/src/core/constants/feature_flags.dart
   static const bool useStandardizedIngredients = false; // v8 dataset
   ```

2. **Clear database:**
   ```dart
   // Run once to force reimport
   final service = ref.read(dataImportService);
   await service.importIngredients(forceReimport: true);
   ```

3. **Run app:**
   ```bash
   flutter run -d windows --debug
   ```

4. **Check console output:**
   ```
   === Feature Flags Status ===
   useStandardizedIngredients: false
   usePerCategoryLimits: false
   ...
   ===========================
   ```

5. **Verify ingredient count:**
   - Navigate to Stored Ingredients screen
   - Expected: **165 ingredients** (v8 initial dataset)

6. **Run integrity verification:**
   ```dart
   final report = await service.verifyDataIntegrity();
   print(report);
   ```

7. **Expected output:**
   ```json
   {
     "status": "PASSED",
     "totalCount": 165,
     "issues": [],
     "warnings": []
   }
   ```

### Phase 3.2: Test with v9 Dataset (Standardized)

**Goal:** Verify standardized dataset loads correctly

1. **Set feature flags:**
   ```dart
   static const bool useStandardizedIngredients = true; // v9 dataset
   ```

2. **Clear database:**
   ```dart
   await service.importIngredients(forceReimport: true);
   ```

3. **Run app:**
   ```bash
   flutter run -d windows --debug
   ```

4. **Check console output:**
   ```
   === Feature Flags Status ===
   useStandardizedIngredients: true
   ...
   ```

5. **Verify ingredient count:**
   - Expected: **201 ingredients** (v9 standardized dataset)

6. **Spot-check separated variants:**

   **Fish Meal (should be 3 entries):**
   - Fish meal 62% CP
   - Fish meal 65% CP
   - Fish meal 70% CP

   **Wheat Products (should be 3 entries):**
   - Wheat grain
   - Wheat bran
   - Wheat middlings

   **Corn Products (should be 4 entries):**
   - Corn grain
   - Corn meal
   - Corn flour
   - Corn silage

7. **Run integrity verification:**
   ```dart
   final report = await service.verifyDataIntegrity();
   ```

8. **Expected output:**
   ```json
   {
     "status": "PASSED",
     "totalCount": 201,
     "standardizedDataStats": {
       "withStandardizedNames": 201,
       "withStandardReferences": 201,
       "withCategoryLimits": 150+
     },
     "issues": [],
     "warnings": []
   }
   ```

9. **Generate verification report:**
   ```dart
   final reportMd = await service.generateVerificationReport(report);
   await File('doc/IMPORT_VERIFICATION.md').writeAsString(reportMd);
   ```

### Phase 3.3: Test Rollback

**Goal:** Verify instant rollback to v8 if issues arise

1. **Set feature flags:**
   ```dart
   static const bool useStandardizedIngredients = false; // Revert to v8
   ```

2. **Force reimport:**
   ```dart
   await service.importIngredients(forceReimport: true);
   ```

3. **Verify rollback:**
   - Expected: **165 ingredients** back in database
   - App should work normally with v8 data

---

## Troubleshooting

### Issue 1: Import fails with JSON parsing error

**Symptom:**
```
Error: FormatException: Unexpected character
```

**Solution:**
- Check JSON file syntax in `assets/raw/ingredients_standardized.json`
- Validate JSON with linter: `dart format assets/raw/ingredients_standardized.json`
- Fix any syntax errors (missing commas, quotes, brackets)

### Issue 2: Duplicate ingredient IDs detected

**Symptom:**
```
Verification FAILED: Duplicate ingredient IDs detected: 3 duplicates
```

**Solution:**
- Run integrity check to identify duplicates:
  ```dart
  final report = await service.verifyDataIntegrity();
  print(report['issues']);
  ```
- Fix duplicate IDs in JSON file
- Reimport with `forceReimport: true`

### Issue 3: Ingredient count mismatch

**Symptom:**
```
Warning: Ingredient count mismatch: got 198, expected 201
```

**Solution:**
- Check JSON file for missing entries
- Verify import errors in logs (some ingredients may have failed to import)
- Check individual ingredient validation (missing required fields)

### Issue 4: App crashes on ingredient load

**Symptom:**
```
StateError: Bad state: Tried to read state of uninitialized provider
```

**Solution:**
- Check that `WidgetsBinding.instance.addPostFrameCallback()` is used (already implemented)
- Verify error handling in `loadIngredients()` catches exceptions
- Add fallback: `state = state.copyWith(ingredients: [])` on error

---

## Next Steps (Phase 4)

After Phase 3 testing complete:

1. **UI Trust Signals** (P4.1)
   - Add "Standards-based" chip to validated ingredients
   - Show NRC/CVB/INRA reference codes in ingredient details
   - Highlight separation notes for variant ingredients

2. **Production Stage Selector** (P4.2)
   - Add stage dropdown to feed creation form
   - Use stage hint in `AnimalCategoryMapper.getCategoryPreferences()`
   - Display stage-specific inclusion limits

3. **Router & Category UI** (P4.3)
   - Update ingredient selection UI to group by category
   - Add filters for protein grade, processing form
   - Show category descriptions using `AnimalCategoryMapper.getCategoryName()`

---

## File Changes Summary

```
lib/src/core/constants/feature_flags.dart
  └─ NEW (150+ lines): Toggle system for safe rollout

lib/src/core/services/data_import_service.dart
  └─ NEW (350+ lines): Import, verify, generate reports

lib/src/features/add_ingredients/provider/ingredients_provider.dart
  ├─ MODIFIED: Added DataImportService integration
  ├─ MODIFIED: Auto-import on first launch
  └─ MODIFIED: Error handling to prevent crashes

lib/src/feed_app.dart
  └─ MODIFIED: Log feature flags on startup
```

---

## Success Criteria

- [x] Feature flag system created with 5 toggles
- [x] DataImportService created with import/verify/report methods
- [x] Integrated into IngredientNotifier (auto-import on first launch)
- [x] Logging added to FeedApp (feature flags printed on startup)
- [x] All files compile cleanly (0 errors)
- [ ] Tested with v8 dataset (165 ingredients load successfully)
- [ ] Tested with v9 dataset (201 ingredients load successfully)
- [ ] Verification report generated to doc/IMPORT_VERIFICATION.md
- [ ] Rollback tested (v9 → v8 switch works instantly)

---

## Command Reference

### Run App with Debug Logging

```bash
flutter run -d windows --debug
```

### Force Reimport (Development Only)

```dart
// In Dart DevTools Console or temporary test code
final service = ref.read(dataImportService);
await service.importIngredients(forceReimport: true);
```

### Generate Verification Report

```dart
final service = ref.read(dataImportService);
final report = await service.verifyDataIntegrity();
final md = await service.generateVerificationReport(report);
print(md); // Or write to file
```

### Check Feature Flags

```dart
print('Dataset: ${FeatureFlags.ingredientDatasetPath}');
print('Advanced: ${FeatureFlags.advancedFeaturesEnabled}');
```

---

## Phase 3 Status

✅ **Code Complete:** All components implemented and compiling  
🟡 **Testing Pending:** Manual testing required (v8 and v9 datasets)  
⏳ **Documentation Pending:** Verification report generation after testing  

**Next Action:** Run app with feature flags toggled and verify ingredient counts  

**Estimated Testing Time:** 30-45 minutes  

---

Generated: December 22, 2025  
Document: Phase 3 Implementation Guide v1.0
