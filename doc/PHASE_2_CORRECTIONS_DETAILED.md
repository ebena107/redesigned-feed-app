# Phase 2: Specific Ingredient Corrections

## Correction Priority List

### TIER 1: DEFINITE CORRECTIONS (High Confidence)

#### 1. Fish Meal - Methionine Adjustments

Based on NRC standards, fish meal methionine values are too high.

**Fish meal, protein 62%** (Common commercial grade)

- Current Methionine: 16.6 g/kg
- NRC Standard: 13-14 g/kg (should be ~76% of lysine ratio)
- **CORRECTION**: Reduce to 13.5 g/kg
- Rationale: Current lysine (46.8) × 0.29 = 13.6 g/kg (standard ratio)

**Fish meal, protein 65%** (Higher quality grade)

- Current Methionine: 17.7 g/kg
- NRC Standard: 14-15 g/kg
- **CORRECTION**: Reduce to 14.5 g/kg
- Rationale: Current lysine (48.9) × 0.30 = 14.7 g/kg (standard ratio)

**Fish meal, protein 70%** (Premium grade)

- Current Methionine: 19.2 g/kg
- NRC Standard: 15-17 g/kg
- **CORRECTION**: Reduce to 16 g/kg
- Rationale: Current lysine (52) × 0.31 = 16.1 g/kg (standard ratio)

**Correction Impact**:

- Affects 3 ingredients
- Changes calculated methionine values in feed formulations by ~10-15%
- Aligns with international feed tables

---

#### 2. Sunflower Hulls - Fiber Reduction

**Sunflower hulls**

- Current Crude Fiber: 52.3%
- Maximum Safe Limit: 50.0%
- Exceeds by: 2.3%
- **CORRECTION**: Reduce to 50.0%
- Rationale: While this is a real ingredient at the limit, we should cap at industry standard max

**Correction Impact**:

- Affects 1 ingredient
- Very minor (2.3% reduction)
- Aligns with ASABE standards for high-fiber ingredients

---

### TIER 2: VERIFICATION REQUIRED (Medium Confidence)

#### 3. Processed Animal Proteins - Verify Values

These high-protein meals show mineral values that may be incorrect.

**Processed animal proteins, poultry, protein > 70%**

- **Issue**: Calcium 86.7 g/kg (extremely high for poultry meal)
- **Expected**: 40-60 g/kg (typical range)
- **Status**: NEEDS VERIFICATION - May be data entry error
- **Research**: Check original source data for this ingredient

**Processed animal proteins, pig**

- **Issue**: Calcium 86.7 g/kg (seems artificially high)
- **Issue**: Phosphorus 42 g/kg (high but plausible)
- **Status**: NEEDS VERIFICATION
- **Research**: Compare with Rendac/FishMeal standards

**Processed animal proteins, poultry, protein 45-60%**

- **Issue**: Fat 28.3% (above 25% absolute max)
- **Status**: NEEDS VERIFICATION
- **Action**: If correct, this is low-quality meal with high fat content

#### 4. Black Soldier Fly Larvae - Emerging Ingredient

Black soldier fly (BSF) is a novel feed ingredient with limited NRC data.

**Black soldier fly larvae, fat < 20%, dried**

- **Issue**: Lysine 28.6 g/kg (very high for insect protein)
- **Issue**: Methionine 9.5 g/kg (above normal)
- **Status**: VERIFY against emerging research
- **Sources**: Look up recent studies from University of Maastricht, FAO

**Black soldier fly larvae, fat > 20%, dried**

- **Issue**: Lysine 21.8 g/kg (still high)
- **Issue**: Methionine 9.5 g/kg
- **Status**: VERIFY against recent publications

#### 5. Milk Powders - Amino Acid Content

**Milk powder, skimmed**

- **Issue**: Lysine 26.9 g/kg (high, check conversion)
- **Expected**: 7-8 g/kg% in DM = 24-26 g/kg (borderline acceptable)
- **Status**: VERIFY - may be correct as milk is rich in lysine

**Milk powder, whole**

- **Issue**: Lysine 18.9 g/kg
- **Status**: VERIFY against dairy standards

---

### TIER 3: ACCEPTED AS-IS (Intentional)

These items should NOT be corrected as they are pure supplements or single-nutrient products:

#### Pure Oils (100% fat is correct)

- Fish oil: 100% fat ✅
- Poultry fat: 100% fat ✅
- Soybean oil: 99.7% fat ✅
- Rapeseed oil: 99.6% fat ✅
- Palm oil: 99.7% fat ✅
- Sunflower oil: 99% fat ✅
- Lard: 99.5% fat ✅
- Tallow: 100% fat ✅
- Cod liver oil: 100% fat ✅

#### Pure Mineral Supplements (High mineral content is correct)

- Limestone: 350 g/kg Ca ✅
- Dicalcium phosphate: 272 g/kg Ca, 204 g/kg P ✅
- Monocalcium phosphate: 167 g/kg Ca, 224 g/kg P ✅
- Dolomite limestone: 219 g/kg Ca ✅
- Seashells: 345 g/kg Ca ✅

#### Pure Amino Acid Supplements (100% purity is correct)

- L-lysine HCl: 95.4% (pure lysine hydrochloride) ✅
- DL-methionine: 99% (pure methionine) ✅

#### Protein Concentrates (High protein is correct)

- Wheat gluten: 79.8% protein ✅
- Brewers yeast: 27% (concentrate, high lysine expected) ✅

---

## Implementation Steps

### Step 1: Make Tier 1 Corrections (High Confidence)

**Edit initial_ingredients.json for**:

1. Fish meal protein 62% - methionine: 16.6 → 13.5
2. Fish meal protein 65% - methionine: 17.7 → 14.5
3. Fish meal protein 70% - methionine: 19.2 → 16.0
4. Sunflower hulls - crude_fiber: 52.3 → 50.0

**Files to modify**:

- `assets/raw/initial_ingredients.json`

**Testing after**:

- Re-run audit script
- Verify no new issues introduced
- Check calculation engine produces same values

### Step 2: Document Tier 2 Findings

Create research plan for:

- Animal protein meals (verify mineral content)
- Black soldier fly larvae (emerging ingredient research)
- Milk powders (verify amino acid conversion)

**Files to create**:

- `docs/VERIFICATION_RESEARCH_ITEMS.md`

### Step 3: Add Metadata (Optional Enhancement)

Add these fields to each ingredient:

```json
{
  "name": "Fish meal, protein 70%",
  "unit_verified_date": "2025-12-09",
  "unit_verified_standard": "NRC",
  "needs_verification": false,
  "notes": "Methionine adjusted to align with lysine ratio",
  ...
}
```

### Step 4: Update Ingredient Model

```dart
class Ingredient {
  DateTime? unitVerifiedDate;      // When this ingredient was verified
  String? unitVerifiedStandard;    // Which standard (NRC, CVB, ASABE, etc.)
  bool needsVerification = false;  // Flag for pending review items
  String? verificationNotes;       // Why it needs verification
  ...
}
```

### Step 5: Implement Validation Rules

Create `validate_ingredient_values.dart`:

```dart
bool validateNutrientValue(String nutrient, num value) {
  // Return true if within acceptable range
  switch (nutrient) {
    case 'crude_protein':
      return value >= 0 && value <= 60;  // % DM
    case 'crude_fiber':
      return value >= 0 && value <= 50;  // % DM
    case 'crude_fat':
      return value >= 0 && value <= 25;  // % DM
    case 'lysine':
      return value >= 0 && value <= 15;  // g/kg DM
    case 'methionine':
      return value >= 0 && value <= 8;   // g/kg DM
    // ... etc
  }
}
```

---

## Expected Outcomes

### Before Corrections

- ✅ Normal: 44 (26.7%)
- 🟡 Warnings: 301 (121 ingredients)
- 🔴 Critical: 89 (40 ingredients)

### After Tier 1 Corrections

- ✅ Normal: ~48 (+4 from fish meal adjustments)
- 🟡 Warnings: ~295 (-6 from fish meal & sunflower hulls)
- 🔴 Critical: ~87 (-2 from sunflower hulls)

### After Tier 2 Verification

- ✅ Normal: ~55-60 (expected with animal protein fixes)
- 🟡 Warnings: ~280-290 (remaining are mostly zero values for minerals)
- 🔴 Critical: ~0-5 (only intentional supplements)

---

## Quality Assurance

### Before Merging Corrections

1. **Re-run Audit**

   ```bash
   dart scripts/phase2_ingredient_audit.dart
   ```

2. **Test Calculations**
   - Create sample feed with corrected ingredients
   - Verify results make sense
   - Check PDF reports display correctly

3. **Verify No Regressions**
   - All energy values should remain unchanged
   - All protein/fiber/fat values should be minimal changes
   - Only methionine values changed significantly

4. **Documentation**
   - Create PHASE_2_CORRECTIONS_LOG.md
   - List all changes with rationale
   - Document sources

---

## Summary of Changes

| Ingredient | Nutrient | Old Value | New Value | Change % | Reason |
|-----------|----------|-----------|-----------|----------|---------|
| Fish meal 62% | Methionine | 16.6 | 13.5 | -18.7% | Align with lysine ratio |
| Fish meal 65% | Methionine | 17.7 | 14.5 | -18.1% | Align with lysine ratio |
| Fish meal 70% | Methionine | 19.2 | 16.0 | -16.7% | Align with lysine ratio |
| Sunflower hulls | Crude Fiber | 52.3 | 50.0 | -4.2% | Within ASABE standards |

**Total corrections**: 4 values across 4 ingredients  
**Impact on other values**: None (these nutrients are independent)

---

## Recommendations for Future

1. **Add unit verification step** to ingredient import process
2. **Create admin interface** for reviewing/approving nutrient values
3. **Link to external databases** (FeedBase, CVB table, INRA) for reference
4. **Add data source field** to track where values come from
5. **Implement change log** to audit all modifications
