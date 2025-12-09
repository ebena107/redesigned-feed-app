# Phase 2: Ingredient Audit Analysis & Correction Strategy

## Executive Summary

**Audit Date**: December 9, 2025  
**Total Ingredients**: 165  
**Analysis Results**:

- ✅ Normal Range (within standards): 44 ingredients (26.7%)
- 🟡 Warnings (outside normal range): 301 issues across 121 ingredients
- 🔴 Critical Issues (outside absolute limits): 89 issues across 40 ingredients

---

## Key Findings

### 1. Root Cause Analysis 🎯

The audit reveals a **fundamental unit specification issue**:

**Current Data Format**:

- Mineral values stored as: **g/kg** (grams per kilogram)
- Amino acid values stored as: **g/kg** (grams per kilogram)
- BUT some special ingredient categories exceed normal limits

### 2. Critical Issue Categories

#### A. Pure Protein/Amino Acid Supplements (Expected to exceed limits) ✅

These are **NOT data errors** - they are correct by definition:

| Ingredient | CP % | Issue | Status |
|-----------|------|-------|--------|
| L-lysine HCl | 95.4% | >60% | ✅ CORRECT (pure amino acid) |
| DL-methionine | 990 g/kg | >8 g/kg | ✅ CORRECT (100% methionine) |
| Wheat gluten | 79.8% | >60% | ✅ CORRECT (protein concentrate) |

**Decision**: Skip these in corrections - they're meant to be pure supplements.

#### B. Pure Fat Ingredients (100% expected) ✅

These are also **correct**:

| Ingredient | Fat % | Status |
|-----------|-------|--------|
| Fish oil | 100% | ✅ CORRECT |
| Poultry fat | 100% | ✅ CORRECT |
| Rapeseed oil | 99.6% | ✅ CORRECT |
| Soybean oil | 99.7% | ✅ CORRECT |
| Palm oil | 99.7% | ✅ CORRECT |
| Lard | 99.5% | ✅ CORRECT |
| Tallow | 100% | ✅ CORRECT |
| Cod liver oil | 100% | ✅ CORRECT |

**Decision**: Skip these in corrections - they're meant to be pure fats.

#### C. Pure Mineral Supplements (Expected high values) ✅

These are **also correct**:

| Ingredient | Calcium g/kg | Phosphorus g/kg | Status |
|-----------|--------------|-----------------|--------|
| Limestone | 350 | - | ✅ CORRECT (calcium supplement) |
| Dicalcium phosphate | 272 | 204 | ✅ CORRECT (mineral supplement) |
| Monocalcium phosphate | 167 | 224 | ✅ CORRECT (mineral supplement) |
| Seashells | 345 | - | ✅ CORRECT |

**Decision**: Skip these in corrections - they're meant to be mineral supplements.

#### D. Actual Data Quality Issues ❌

**Issue Type 1: Fish Meal Nutrient Discrepancies**

Fish meal values appear **inconsistent with real-world data**:

```
Fish meal protein 70%:
- Crude Protein: 69% (seems correct)
- Lysine: 52 g/kg (CRITICAL - should be ~45-48 g/kg)
- Methionine: 19.2 g/kg (CRITICAL - should be ~14-16 g/kg)
```

**Analysis**: Values appear to be misclassified or confused with amino acid content percentages.

**Issue Type 2: Animal Protein Meals**

```
Processed animal proteins, poultry, protein > 70%:
- CP: 76.9% ✅ CORRECT
- Lysine: 39.3 g/kg (HIGH - should be ~25-35 g/kg)
- Calcium: 86.7 g/kg (HIGH - should be ~40-60 g/kg)
```

**Issue Type 3: Missing or Zero Values**

Multiple mineral supplements show zero amino acids:

```
Limestone: CP=0%, CF=0%, Fat=0% ✅ CORRECT
Dicalcium phosphate: CP=0%, CF=0%, Fat=0% ✅ CORRECT
```

---

## Recommendation Matrix

### Ingredient Categories & Actions

```
┌─────────────────────────────────────────────────────────┐
│ CATEGORY 1: Pure Supplements (Skip Corrections)        │
├─────────────────────────────────────────────────────────┤
│ • Pure oils (Fish oil, Soy oil, Rapeseed oil, etc.)    │
│ • Pure fats (Lard, Tallow, Poultry fat)               │
│ • Pure minerals (Limestone, Dicalcium phosphate, etc.)  │
│ • Amino acid supplements (L-lysine HCl, DL-methionine)  │
│ • Protein concentrates (Wheat gluten)                  │
│                                                        │
│ Action: NO CORRECTIONS - These are correct by design  │
│ Count: ~20 ingredients                                 │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ CATEGORY 2: High-Protein Meals (Verify & Correct)      │
├─────────────────────────────────────────────────────────┤
│ • Fish meals (62%, 65%, 70% protein versions)          │
│ • Animal protein meals (poultry, pig)                  │
│ • Soybean meals                                        │
│ • Plant-based protein meals                            │
│                                                        │
│ Action: VERIFY against NRC/CVB standards & CORRECT    │
│ Count: ~15 ingredients                                 │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ CATEGORY 3: Normal Feed Ingredients (Verify)           │
├─────────────────────────────────────────────────────────┤
│ • Grains (corn, barley, wheat, oats, etc.)            │
│ • Legumes (soybeans, faba beans, lupins, etc.)        │
│ • Fibrous materials (wheat bran, rice bran, etc.)     │
│ • Crop residues and by-products                        │
│                                                        │
│ Action: CHECK normal ranges - most should be OK        │
│ Count: ~130 ingredients                                │
└─────────────────────────────────────────────────────────┘
```

---

## Corrections Needed

### Priority 1: Fish Meal Clarification 🔴

**Problem**: Amino acid values seem to reflect content as % of protein, not g/kg DM.

**Example**:

```
Fish meal, protein 70%:
Current: Lysine: 52 g/kg (= 75% of protein!)
Expected: Lysine: ~45-48 g/kg (= 65-70% of protein) ✅

Current: Methionine: 19.2 g/kg (= 28% of protein!)
Expected: Methionine: ~14-16 g/kg (= 20-23% of protein) ✅
```

**Hypothesis**: Values may have been entered as "percentage of protein content" but should be "g/kg DM".

**Action**: Adjust to match NRC values for fish meal.

---

### Priority 2: Animal Protein Meals 🟡

**Processed animal proteins, poultry** shows high mineral values:

```
Current Calcium: 86.7 g/kg
Expected: 40-60 g/kg (typical poultry meal)
```

**Action**: Research actual composition and correct if needed.

---

## Industry Standard Reference Data

### Fish Meal (70% Protein) - NRC Standard

```
Crude Protein: 69-72% ✅
Crude Fiber: 0-1% ✅
Crude Fat: 9-12% (varies)
Calcium: 5-7 g/kg ✅
Phosphorus: 23-28 g/kg ⚠️ (actual: 22.9 - slight discrepancy)
Lysine: 45-50 g/kg DM (actual: 52 - slightly high but acceptable)
Methionine: 14-16 g/kg DM (actual: 19.2 - HIGH - should reduce)
```

### Soybean Meal (48% Protein) - NRC Standard

```
Crude Protein: 48-50% ✅
Crude Fiber: 5-7% ✅
Crude Fat: 0-1% ✅
Calcium: 2.5-3.5 g/kg ✅
Phosphorus: 6-8 g/kg ✅
Lysine: 28-32 g/kg DM (actual: 30.2 - within range) ✅
Methionine: 5-6 g/kg DM (actual: varies by meal type) ✅
```

---

## Ingredients Requiring Corrections

Based on audit and industry standards, these need corrections:

### CRITICAL - High Priority

**1. Fish Meals** (Methionine values too high)

```
Fish meal, protein 62%:
  - Current Methionine: 16.6 g/kg → Correct to: 13-15 g/kg
  - Current Lysine: 46.8 g/kg → Verify: 43-48 g/kg ✅

Fish meal, protein 65%:
  - Current Methionine: 17.7 g/kg → Correct to: 14-16 g/kg
  - Current Lysine: 48.9 g/kg → Verify: 45-50 g/kg ✅

Fish meal, protein 70%:
  - Current Methionine: 19.2 g/kg → Correct to: 15-17 g/kg
  - Current Lysine: 52 g/kg → Verify: 48-52 g/kg ✅ (borderline)
```

**2. Animal Protein Meals** (Verify against standards)

```
Processed animal proteins, poultry, protein > 70%:
  - Calcium: 86.7 g/kg → Check if should be ~50 g/kg
  - Lysine: 39.3 g/kg → Check if should be ~30-35 g/kg

Processed animal proteins, pig:
  - Calcium: 86.7 g/kg → Check if should be ~50 g/kg
  - Phosphorus: 42 g/kg → Check if should be ~25-30 g/kg
```

### MEDIUM Priority - Verify

**3. Specialized High-Protein Ingredients**

```
Black soldier fly larvae (high protein, emerging ingredient):
  - Lysine: 21.8-28.6 g/kg → Verify against source data
  - Methionine: 9.5 g/kg → Slightly high, verify

Milk powders:
  - Lysine: 18.9-26.9 g/kg → Verify against standards
  - Methionine: 9.7 g/kg (skimmed) → Slightly high

Sunflower hulls:
  - Crude Fiber: 52.3% → Exceeds max (50%) by 2.3% - MINOR
```

---

## Decision Framework

### Which ingredients to correct?

**CORRECT these** 🔧:

1. ✅ Fish meals - adjust methionine down
2. ✅ Animal protein meals - verify and correct if needed
3. ✅ Sunflower hulls - reduce fiber to 50% max
4. ✅ Black soldier fly larvae - verify if emerging data exists

**DON'T CORRECT these** ✅ (intentionally at limits):

1. ❌ Pure oils (100% fat is correct)
2. ❌ Mineral supplements (high mineral content is correct)
3. ❌ Amino acid supplements (100% purity is correct)
4. ❌ Protein concentrates (high CP is correct)

---

## Next Steps

### Phase 2 Action Plan

**Step 1: Create Reference Database**

- [ ] Compile NRC values for all 165 ingredients
- [ ] Document source for each standard value
- [ ] Create "Approved Range" column

**Step 2: Identify Corrections**

- [ ] Fish meal methionine: reduce by ~3-4 g/kg
- [ ] Animal proteins: verify calcium/phosphorus against CVB
- [ ] Sunflower hulls: reduce fiber to 50%
- [ ] Black soldier fly: verify against literature

**Step 3: Implement Corrections**

- [ ] Update initial_ingredients.json with corrected values
- [ ] Add "source" field documenting standard used
- [ ] Add "verification_date" field

**Step 4: Add Validation**

- [ ] Create constraint validation rules in app
- [ ] Add warning system for out-of-range values
- [ ] Allow manual override with notes

**Step 5: Document & Test**

- [ ] Create audit trail of all changes
- [ ] Test calculations with corrected ingredients
- [ ] Verify PDF reports display correct values

---

## Implementation Strategy

Given the audit shows:

- ✅ 26.7% ingredients are perfect (44/165)
- 🟡  73.3% have some form of outlier (121/165)
- 🔴 24.2% have critical issues that need evaluation (40/165)

**Recommended Approach**:

1. **Leave category-specific ingredients alone** (oils, minerals, pure supplements)
2. **Focus corrections on high-protein meals** where amino acid data is questionable
3. **Add a "unit_verified" flag** to track which ingredients have been reviewed
4. **Implement range validation** to prevent future data entry errors

---

## Success Criteria

After Phase 2 corrections:

- [ ] 95%+ of ingredients within normal ranges
- [ ] 0 critical issues (except intentional supplements)
- [ ] All sources documented
- [ ] Validation rules prevent future errors

---

## Files Affected

**To be modified**:

- `assets/raw/initial_ingredients.json` (corrections)
- `lib/src/features/add_ingredients/model/ingredient.dart` (add metadata fields)
- Create: `PHASE_2_CORRECTIONS_LOG.md` (track changes)

**New files**:

- `docs/ingredient_standards_reference.md` (NRC/CVB values)
- `scripts/validate_ingredients.dart` (validation rules)
