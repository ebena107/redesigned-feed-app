# Database Migration v12 Testing Guide

**Migration**: v11 → v12 (Add Regional Ingredient Support)  
**Status**: Ready for Testing  
**Test Date**: December 24, 2025

---

## Test Scope

### In Scope

- ✅ Database version increment (11 → 12)
- ✅ Region column creation with correct type/default
- ✅ Index creation (`idx_ingredients_region`)
- ✅ Backward compatibility (v11 apps upgrading)
- ✅ Forward compatibility (new installs)
- ✅ Data integrity (no ingredient loss)
- ✅ Query performance (region-based filtering)

### Out of Scope

- Regional filter UI (tested separately)
- CSV import regional handling
- Cloud sync functionality

---

## Test Categories

### 1. Unit Tests (Database Logic)

#### Test 1.1: Migration Method Exists

**Test**: Verify `_migrationV11ToV12()` method is callable

```dart
test('Migration v11 to v12 method exists and is callable', () async {
  final database = AppDatabase();
  // Method should exist without errors
  expect(() => database._migrationV11ToV12, isNotNull);
});
```

**Expected Result**: ✅ Method exists and has correct signature

---

#### Test 1.2: Version Constant

**Test**: Verify database version is 12

```dart
test('Database version is set to 12', () {
  expect(AppDatabase._currentVersion, 12);
});
```

**Expected Result**: ✅ Current version returns 12

---

### 2. Integration Tests (Database Operations)

#### Test 2.1: Fresh Install Creates Region Column

**Scenario**: New app installation (no existing database)

**Steps**:
1. Delete existing database
2. Start app (cold boot)
3. Create sample ingredient
4. Query region column

**Expected Results**:
- ✅ Database creates without errors
- ✅ region column exists in ingredients table
- ✅ region column type is TEXT
- ✅ default value is 'Global'
- ✅ New ingredient can be inserted with region value

**SQL Verification**:
```sql
PRAGMA table_info(ingredients);
-- Should include: region|TEXT|0|'Global'|0

-- Insert test ingredient
INSERT INTO ingredients (name, region, crude_protein) 
VALUES ('Test Ingredient', 'Africa', 18.0);

-- Query to verify
SELECT * FROM ingredients WHERE name = 'Test Ingredient';
-- Should show region = 'Africa'
```

---

#### Test 2.2: Upgrade from v11 Preserves Data

**Scenario**: Existing v11 app with data is upgraded to v12

**Prerequisites**:
- Save v11 database with test data:
  - 5 real ingredients
  - Feed data
  - User calculations
  
**Steps**:
1. Start app with v11 database
2. Load ingredients and verify count
3. Perform calculation
4. Close app
5. Upgrade to v12 code
6. Start app with saved v11 database
7. Verify migration runs
8. Load ingredients again

**Expected Results**:
- ✅ Migration runs automatically (no user action)
- ✅ No data loss (ingredient count unchanged)
- ✅ All ingredients accessible
- ✅ All feeds accessible
- ✅ Calculations still work
- ✅ All ingredients have region = 'Global' (default)
- ✅ No errors in logs

**Data Integrity Checks**:
```sql
-- Before migration
SELECT COUNT(*) FROM ingredients;  -- Note count (e.g., 211)

-- After migration
SELECT COUNT(*) FROM ingredients;  -- Should be same
SELECT COUNT(*) WHERE region IS NULL;  -- Should be 0
SELECT COUNT(DISTINCT region) FROM ingredients;  -- Should show regions present
```

---

#### Test 2.3: Index Creation

**Scenario**: Verify `idx_ingredients_region` index is created

**Steps**:
1. After migration, query sqlite_master
2. Look for index named `idx_ingredients_region`
3. Verify it's on ingredients table, region column

**SQL Verification**:
```sql
-- Check if index exists
SELECT name, tbl_name, sql 
FROM sqlite_master 
WHERE type='index' AND name='idx_ingredients_region';

-- Expected output:
-- name: idx_ingredients_region
-- tbl_name: ingredients
-- sql: CREATE INDEX idx_ingredients_region ON ingredients(region)
```

**Expected Result**: ✅ Index exists and is correctly defined

---

#### Test 2.4: Region Column Default Value

**Scenario**: Verify all existing ingredients get 'Global' as default

**Steps**:
1. After migration, query all ingredients
2. Count non-NULL regions
3. Verify NULL count is 0

**SQL Verification**:
```sql
-- Check for NULL regions
SELECT COUNT(*) FROM ingredients WHERE region IS NULL;
-- Should return 0

-- Check region distribution
SELECT region, COUNT(*) as count 
FROM ingredients 
GROUP BY region 
ORDER BY count DESC;

-- Example output for 211 ingredients:
-- Global | 165
-- Africa | 1
-- ... (other regions)
```

**Expected Result**: ✅ All ingredients have non-NULL region value

---

### 3. Platform-Specific Tests

#### Test 3.1: Android Migration

**Device/Emulator**: Android 11+ or latest emulator

**Steps**:
1. Install v11 app build
2. Create a feed with ingredients
3. Take note of ingredient count
4. Close app
5. Install v12 app build (same user data)
6. Open app and verify migration completes
7. Load stored feeds
8. Verify all feeds still work

**Verification**:
```
✅ No crashes during launch
✅ Migration completes in <5 seconds
✅ Ingredient list loads (211 items)
✅ Feed opens correctly
✅ Calculation still works
✅ Logs show "Migration 11→12: Complete"
```

---

#### Test 3.2: iOS Migration

**Device/Simulator**: iPhone 12+ or latest simulator

**Steps**: (Same as Android)

**Verification**: (Same as Android)

---

#### Test 3.3: Windows Desktop Migration

**Platform**: Windows 10/11

**Steps**: (Same as Android)

**Additional Verification**:
```
✅ Database file created in correct location
✅ sqlite3_flutter_libs loads correctly
✅ Region queries respond <10ms
```

---

#### Test 3.4: macOS Desktop Migration

**Platform**: macOS 11+

**Steps**: (Same as Android)

**Verification**: (Same as Android)

---

### 4. Performance Tests

#### Test 4.1: Index Performance

**Scenario**: Verify region index improves query performance

**Setup**:
```dart
// Create test data with all 211 ingredients
List<Ingredient> ingredients = [...]; // Load from JSON

// Insert all
for (var ing in ingredients) {
  await ingredientRepository.create(ing.toJson());
}
```

**Test Query - Without Index**:
```sql
SELECT * FROM ingredients WHERE region LIKE '%Africa%';
-- Should show execution time: 50-100ms (estimated)
```

**Test Query - With Index**:
```sql
EXPLAIN QUERY PLAN SELECT * FROM ingredients WHERE region = 'Africa';
-- Output should show: SEARCH ingredients USING INDEX idx_ingredients_region
-- Execution time: 5-10ms
```

**Expected Result**: ✅ Index provides 5-10x speedup

---

#### Test 4.2: Migration Time

**Scenario**: Measure migration execution time

**Steps**:
1. Prepare v11 database with 211+ ingredients
2. Start app and monitor logs
3. Record migration start and end times

**Expected Result**: ✅ Migration completes in <2 seconds

```
// Log output should show:
Migration 11→12: Adding region column to ingredients table
Migration 11→12: region column added successfully
Migration 11→12: Complete

// Total time: <2000ms
```

---

### 5. Error Handling Tests

#### Test 5.1: Duplicate Column (Already Exists)

**Scenario**: Migration runs twice (simulate retry)

**Setup**:
- Manually create region column before migration
- Start app

**Expected Result**:
- ✅ SQLite error is caught
- ✅ Error is logged
- ✅ App doesn't crash
- ✅ Error message: "Migration 11→12: Error adding region column: ..."

---

#### Test 5.2: Corrupted Database

**Scenario**: Database file is corrupted

**Setup**:
- Replace database file with corrupted data
- Start app

**Expected Result**:
- ✅ SQLite detects corruption
- ✅ Error is handled gracefully
- ✅ User sees error dialog
- ✅ Option to reset database offered

---

#### Test 5.3: Read-only Database

**Scenario**: Database file has read-only permissions

**Setup**:
- Set database file permissions to read-only
- Start app

**Expected Result**:
- ✅ Migration fails with permission error
- ✅ Error is logged
- ✅ User sees helpful message

---

### 6. Data Validation Tests

#### Test 6.1: Regional Tag Distribution

**Scenario**: Verify all 211 ingredients have correct region tags

**Setup**:
```dart
// Load all ingredients from database
final allIngredients = await ingredientRepository.getAll();

// Check distribution
final regionCounts = <String, int>{};
for (var ing in allIngredients) {
  final regions = ing.region?.split(', ') ?? ['Global'];
  for (var region in regions) {
    regionCounts[region.trim()] = (regionCounts[region.trim()] ?? 0) + 1;
  }
}

print('Region distribution: $regionCounts');
```

**Expected Result**:
```
✅ Total ingredients: 211
✅ Africa: 1
✅ Africa, Asia: 20
✅ Asia: 6
✅ Europe, Americas: 19
✅ Americas, Global: 14
✅ Global: 147
✅ Oceania, Global: 4
✅ SUM: 211 ✅
```

---

#### Test 6.2: Region Field Consistency

**Scenario**: Verify region field is consistent across app

**Test**:
```dart
test('All ingredients have valid region values', () {
  final ingredients = await ingredientRepository.getAll();
  
  for (var ing in ingredients) {
    expect(ing.region, isNotNull);
    expect(ing.region, isNotEmpty);
    expect(['Africa', 'Asia', 'Europe', 'Americas', 'Oceania', 'Global']
        .any((r) => ing.region!.contains(r)), true);
  }
});
```

**Expected Result**: ✅ All 211 ingredients pass validation

---

### 7. Backward Compatibility Tests

#### Test 7.1: Old Code Still Works

**Scenario**: Existing queries that don't use region still work

**Test**:
```dart
// Old query format (doesn't use region)
final ingredients = await db.select('ingredients', 'crude_protein', 18);

// Should still work
expect(ingredients, isNotEmpty);
expect(ingredients.first['crude_protein'], greaterThanOrEqualTo(18));
```

**Expected Result**: ✅ Existing queries unaffected

---

#### Test 7.2: Region Column Optional

**Scenario**: New ingredients can be created without specifying region

**Test**:
```dart
final newIngredient = Ingredient(
  name: 'Test Ingredient',
  crudeProtein: 20.0,
  // region not specified
);

await ingredientRepository.create(newIngredient.toJson());

final saved = await ingredientRepository.getSingle(newIngredient.ingredientId);
expect(saved.region, 'Global'); // Defaults to Global
```

**Expected Result**: ✅ Region defaults to 'Global' automatically

---

## Test Execution Plan

### Phase 1: Unit Tests (30 minutes)

- Test 1.1: Migration method exists
- Test 1.2: Version constant
- Test 1.3: Database constants defined

### Phase 2: Integration Tests (1 hour)

- Test 2.1: Fresh install
- Test 2.2: Upgrade from v11
- Test 2.3: Index creation
- Test 2.4: Default values

### Phase 3: Platform Tests (2 hours)

- Test 3.1: Android
- Test 3.2: iOS
- Test 3.3: Windows
- Test 3.4: macOS

### Phase 4: Performance Tests (30 minutes)

- Test 4.1: Index performance
- Test 4.2: Migration time

### Phase 5: Error Handling (30 minutes)

- Test 5.1: Duplicate column
- Test 5.2: Corrupted database
- Test 5.3: Read-only database

### Phase 6: Data Validation (30 minutes)

- Test 6.1: Region distribution
- Test 6.2: Consistency

### Phase 7: Backward Compatibility (20 minutes)

- Test 7.1: Old code
- Test 7.2: Optional region

**Total Time**: ~5 hours for comprehensive testing

---

## Test Results Template

```markdown
## Test Results - Migration v12

**Date**: [DATE]  
**Tester**: [NAME]  
**Platform**: [ANDROID/iOS/WINDOWS/macOS]  

### Summary
- Unit Tests: ✅ [X/X] Passed
- Integration Tests: ✅ [X/X] Passed
- Platform Tests: ✅ [X/X] Passed
- Performance Tests: ✅ [X/X] Passed
- Error Tests: ✅ [X/X] Passed
- Data Validation: ✅ [X/X] Passed
- Backward Compatibility: ✅ [X/X] Passed

**Total**: ✅ [X/X] Tests Passed

### Issues Found
(List any failures or anomalies)

### Performance Metrics
- Migration Time: [XXms]
- Region Query (without index): [XXms]
- Region Query (with index): [XXms]
- Speedup Factor: [X]x

### Recommendations
(Any improvements or follow-ups)

### Sign-off
Approved by: [NAME]  
Date: [DATE]
```

---

## Deployment Gate

✅ **Pre-Deployment Checklist**

- [ ] Unit tests passed
- [ ] Integration tests passed
- [ ] All platforms tested (Android, iOS, Windows, macOS)
- [ ] Performance meets expectations
- [ ] Error handling verified
- [ ] Data integrity confirmed
- [ ] Backward compatibility verified
- [ ] Release notes updated
- [ ] Database backup available
- [ ] Rollback plan reviewed

**Status**: Ready for deployment once all tests pass ✅

---

## References

- **Migration Code**: `lib/src/core/database/app_db.dart`
- **Test Location**: `test/integration/database_migration_v12_test.dart` (to be created)
- **Schema Reference**: `lib/src/features/add_ingredients/repository/ingredients_repository.dart`

---

Prepared: December 24, 2025  
Last Updated: December 24, 2025  
Status: **READY FOR TESTING** ✅
