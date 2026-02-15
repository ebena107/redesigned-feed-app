# Custom Ingredient Creation - Testing Plan

## Test Execution Status

**Device Status**: v2318 not currently connected
**Alternative Test**: Windows desktop build encountered SQLite3 DLL issue (environment setup, not code-related)
**Code Status**: ✅ Passes flutter analyze, builds successfully
**Next Step**: Test on connected Android device when v2318 is available

---

## Test Plan for Custom Ingredient Creation Fix

### Objective
Verify that custom ingredients are correctly created, saved to database, and appear in ingredient lists.

### Pre-Test Checklist
- [ ] Device v2318 connected via USB
- [ ] Developer mode enabled
- [ ] App not installed (clean install) OR old app uninstalled
- [ ] Device has adequate storage (>200MB)

### Test Scenario 1: Basic Custom Ingredient Creation

**Steps**:
1. Launch app and wait for splash screen
2. Tap "Ingredients" tab
3. Tap "Add New Ingredient" button (or similar)
4. Verify form fields are empty
5. Fill in required fields:
   - Name: "Test Ingredient A"
   - Category: Select any category
   - Crude Protein: "12.5"
   - Crude Fat: "3.5"
   - Crude Fiber: "5.0"
   - All other fields fill with reasonable values
6. Tap "Save" button
7. **EXPECTED**: 
   - ✅ "Ingredient Created Successfully" alert appears
   - ✅ Alert auto-closes after 2 seconds
   - ✅ Form closes and returns to ingredient list
   - ✅ "Test Ingredient A" appears in ingredient list

**Verification Checks**:
- [ ] Success alert displays
- [ ] Alert auto-closes
- [ ] Ingredient appears in list immediately
- [ ] Ingredient details match what was entered
- [ ] Ingredient marked as "Custom" if visible

---

### Test Scenario 2: Ingredient Persistence (Restart Test)

**Steps**:
1. Complete Test Scenario 1
2. Verify "Test Ingredient A" is in the list
3. Close app completely (force stop on Android)
4. Reopen app
5. Wait for splash screen
6. Navigate to Ingredients tab
7. **EXPECTED**:
   - ✅ "Test Ingredient A" still appears in list
   - ✅ All field values are preserved
   - ✅ Custom badge visible (if applicable)

**Verification Checks**:
- [ ] Custom ingredient persists after app restart
- [ ] All field values preserved
- [ ] Appears in same position in list

---

### Test Scenario 3: Multiple Custom Ingredients

**Steps**:
1. Create "Test Ingredient B" (different values)
2. Verify it appears in list
3. Create "Test Ingredient C" (different values)
4. Verify both appear in list
5. Check total count matches

**Expected Results**:
- [ ] All custom ingredients appear in list
- [ ] Each has correct field values
- [ ] Can create multiple in one session

---

### Test Scenario 4: Copy Custom Ingredient

**Steps**:
1. Have "Test Ingredient A" in the list
2. Find it in ingredient list
3. Tap copy button (📋 icon) if visible, or long-press
4. Form opens with pre-filled values from "Test Ingredient A"
5. Modify name to "Test Ingredient A - Copy"
6. Modify one field (e.g., protein)
7. Tap Save
8. **EXPECTED**:
   - ✅ New ingredient created with modified values
   - ✅ Original ingredient unchanged
   - ✅ Both appear in list

**Verification Checks**:
- [ ] Form pre-fills with source ingredient values
- [ ] Can modify fields before saving
- [ ] New ingredient saves correctly
- [ ] Original remains unchanged

---

### Test Scenario 5: Custom Ingredient in Feed Selection

**Steps**:
1. Create a custom ingredient (all tests above)
2. Navigate to Feed/Animal screen
3. Open ingredient selector for a feed
4. Search for or scroll to custom ingredient
5. **EXPECTED**:
   - ✅ Custom ingredient appears in selector
   - ✅ Can be selected for feed
   - ✅ Correctly updates feed

**Verification Checks**:
- [ ] Custom ingredient available in feed selector
- [ ] Can be selected and added to feed
- [ ] Persists in feed after save

---

### Test Scenario 6: Form Validation (Edge Cases)

**Steps**:
1. Open Add Ingredient form
2. Leave all fields empty
3. Tap Save
4. **EXPECTED**: Validation error shown
5. Fill only some required fields
6. Tap Save
7. **EXPECTED**: Validation error shown
8. Fill all required fields
9. Tap Save
10. **EXPECTED**: Ingredient created successfully

**Verification Checks**:
- [ ] Empty form rejected
- [ ] Partial form rejected
- [ ] Complete form accepted
- [ ] Error messages clear and helpful

---

### Test Scenario 7: Database Consistency

**Steps** (Requires ADB access):
```sql
# On device with adb
adb shell
su
sqlite3 /data/data/com.feed_estimator.app/databases/app_db.db

# Run query:
SELECT * FROM ingredients WHERE is_custom = 1;
```

**EXPECTED**:
- [ ] Custom ingredients appear in database
- [ ] All fields populated correctly
- [ ] is_custom field = 1
- [ ] timestamp field has valid value
- [ ] created_by field populated

---

## Bug Verification Tests

### Test: Verify Response Validation Fix
*Verifies the response > 0 check works correctly*

**Indirect Test** (via UI):
1. Create ingredient → If success alert appears and ingredient persists, response validation is working ✅
2. If ingredient doesn't appear, response validation failed ❌

### Test: Verify State Refresh (loadIngredients)
*Verifies ingredients list updates after save*

**Test Steps**:
1. Before creating ingredient, count visible ingredients
2. Create new ingredient
3. Verify new ingredient appears WITHOUT navigating away
4. **RESULT**: If ingredient visible immediately, state refresh is working ✅

### Test: Verify No Duplicate Method Calls
*Verifies createIngredient isn't called twice*

**Test via Logging** (if logs are visible):
1. Create ingredient
2. Check logs for validation messages
3. Should see validation log once, not multiple times
4. **RESULT**: If validation appears once, no duplicate calls ✅

---

## Test Results Template

```
TEST EXECUTION REPORT
=====================

Device: v2318
OS: Android X.Y.Z
App Version: 1.1.5+14
Test Date: YYYY-MM-DD
Tester: [Name]

SCENARIO 1 - Basic Creation:        [PASS / FAIL]
  - Alert displayed                 [PASS / FAIL]
  - Ingredient in list              [PASS / FAIL]
  - Values correct                  [PASS / FAIL]

SCENARIO 2 - Persistence:           [PASS / FAIL]
  - After restart                   [PASS / FAIL]
  - Values preserved                [PASS / FAIL]

SCENARIO 3 - Multiple:              [PASS / FAIL]
  - All created                     [PASS / FAIL]
  - All visible                     [PASS / FAIL]

SCENARIO 4 - Copy:                  [PASS / FAIL]
  - Pre-fill works                  [PASS / FAIL]
  - New ingredient saved            [PASS / FAIL]
  - Original unchanged              [PASS / FAIL]

SCENARIO 5 - Feed Selection:        [PASS / FAIL]
  - In selector                     [PASS / FAIL]
  - Can be selected                 [PASS / FAIL]

SCENARIO 6 - Validation:            [PASS / FAIL]
  - Empty rejected                  [PASS / FAIL]
  - Partial rejected                [PASS / FAIL]
  - Complete accepted               [PASS / FAIL]

SCENARIO 7 - Database:              [PASS / FAIL]
  - Records found                   [PASS / FAIL]
  - Fields populated                [PASS / FAIL]
  - is_custom = 1                   [PASS / FAIL]

OVERALL RESULT: [PASS / FAIL]

Notes:
[Space for observations, issues, screenshots]
```

---

## Known Issues During Testing

### Windows Desktop Build Error
- **Error**: SQLite3 DLL not found
- **Cause**: Windows environment configuration (not code-related)
- **Resolution**: Test on Android device instead
- **Impact**: No impact on code quality - APK/AAB builds succeed

---

## What the Fixes Should Enable

### ✅ Test Success Indicators

1. **Response Validation Working** 
   - Save succeeds only when database insert returns > 0
   - Save fails when return value is 0 or null
   - Error messages logged clearly

2. **State Refresh Working**
   - Recent ingredients list reloads from database
   - New ingredient visible immediately after save
   - No manual refresh needed

3. **Clean Code Flow**
   - No duplicate validations
   - Form closes after save
   - success callback executes upon actual database success

---

## Test Schedule

**When v2318 Available**:
1. Run all scenarios above
2. Document results in template
3. Verify all checkboxes pass
4. Create test report

**Before Play Store Release**:
- [ ] All scenarios pass
- [ ] No regressions
- [ ] Code analysis clean
- [ ] APK/AAB ready

---

## Rollback Plan

If test finds issues:
1. Check `git log` for fix commit
2. If needed: `git revert [commit-hash]`
3. Identify new issue
4. Implement additional fix
5. Re-test

---

## References

- Bug Details: [CUSTOM_INGREDIENT_BUG_FIX.md](./CUSTOM_INGREDIENT_BUG_FIX.md)
- Implementation: [CUSTOM_INGREDIENT_FIX_IMPLEMENTATION.md](./CUSTOM_INGREDIENT_FIX_IMPLEMENTATION.md)
- Status: [CUSTOM_INGREDIENT_BUG_FIX_STATUS.md](./CUSTOM_INGREDIENT_BUG_FIX_STATUS.md)
- Code Changes: [ingredients_provider.dart](../lib/src/features/add_ingredients/provider/ingredients_provider.dart#L1097-L1123)

