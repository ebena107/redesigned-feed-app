# Phase 2: Industry Standards Research

## Research Date
2025-12-11

## Sources
- **CVB** (Centraal Veevoeder Bureau) - Netherlands Feed Tables
- **FEEDIPEDIA** - International Feed Database (INRA, CIRAD, AFZ)
- **INRA** - Institut National de la Recherche Agronomique (France)
- **NRC** - National Research Council (USA)

---

## Key Findings

### 1. Fish Meal (Critical Issue: Values Appear to be Unit Errors)

**Industry Standards (FEEDIPEDIA):**
- **Crude Protein**: 63-68% (as fed) or 65.2-70.7% (DM basis) for 65% protein fish meal
- **Lysine**: 7.5% of crude protein (as amino acid percentage)
- **Methionine**: 2.7-2.8% of crude protein (as amino acid percentage)

**Converting to g/kg DM:**
For fish meal with 65% CP:
- Lysine: 7.5% of 650 g/kg = **48.75 g/kg** ✅ (Our value: 48.9 g/kg is CORRECT)
- Methionine: 2.8% of 650 g/kg = **18.2 g/kg** ✅ (Our value: 17.7 g/kg is CORRECT)

> [!IMPORTANT]
> **Fish Meal Values Are CORRECT**
> 
> The audit flagged these as critical because they exceed the 15 g/kg threshold for lysine and 8 g/kg for methionine. However, these thresholds are for TYPICAL feed ingredients. Fish meal is a concentrated protein source and these values are industry-standard.
> 
> **Action**: Update audit tool to allow higher amino acid values for protein concentrates (>60% CP).

---

### 2. Soybean Meal (Critical Issue: Lysine Values Too High)

**Industry Standards (CVB 2018):**
- **Soybean meal, solvent extracted, CF > 70 g/kg**:
  - Lysine: **5.9 g/kg**
  - Methionine: **3.0 g/kg**
- **CVB 1991** (46% protein):
  - Digestible lysine: **5.7-6.5 g/kg**

**Our Current Values:**
- Soybean meal, oil < 5%, 48% protein: Lysine **28.8 g/kg** ❌
- Soybean meal, oil < 5%, 50% protein: Lysine **30.2 g/kg** ❌
- Soybean meal, oil 5-20%: Lysine **27.2 g/kg** ❌

> [!CAUTION]
> **Soybean Meal Lysine Values Are 4-5x TOO HIGH**
> 
> Our values appear to be incorrectly scaled or in wrong units. Industry standard is ~6 g/kg, not ~28 g/kg.
> 
> **Action**: Correct all soybean meal lysine values to industry standards.

**Recommended Corrections:**
```
Soybean meal, oil < 5%, 48% protein + oil, extruded:
  lysine: 28.8 → 6.2 g/kg

Soybean meal, oil < 5%, 50% protein + oil:
  lysine: 30.2 → 6.5 g/kg

Soybean meal, oil 5-20%:
  lysine: 27.2 → 6.0 g/kg
  
Soybean, whole, extruded:
  lysine: 22.4 → 6.0 g/kg
  
Soybean, whole, flaked:
  lysine: 22.4 → 6.0 g/kg
  
Soybean, whole, toasted:
  lysine: 22.2 → 6.0 g/kg
```

---

### 3. Rapeseed/Canola Meal (Critical Issue: Lysine Values Too High)

**Industry Standards (INRA 2018):**
- **Canola meal, oil < 5%**:
  - Digestible lysine: **6.6% PDI** (Protein Digestible in Intestine)
  - Typical lysine content: **20.2 g/kg** (solvent-extracted, as received)
- **Rapeseed meal, oil < 5%**:
  - Digestible lysine: **6.7% PDI**
- **Lysine as % of CP**: 5.5% (vs. 6.3% for soybean)

**Our Current Values:**
- Canola meal, oil < 5%: Lysine **19.5 g/kg** ✅ (Close to industry standard)
- Rapeseed meal, oil < 5%: Lysine **18.1 g/kg** ✅ (Acceptable)
- Rapeseed meal, oil 5-20%: Lysine **16.9 g/kg** ✅ (Acceptable, lower due to oil)

> [!NOTE]
> **Rapeseed/Canola Meal Lysine Values Are ACCEPTABLE**
> 
> These values are flagged as critical (>15 g/kg threshold) but are within industry standards for high-protein rapeseed meals. The INRA data shows 20.2 g/kg for solvent-extracted canola meal.
> 
> **Action**: Update audit tool to allow lysine up to 25 g/kg for protein meals (35-40% CP).

---

### 4. Whole Oilseeds - Crude Fat Content

**Industry Standards:**

**Rapeseed, whole:**
- FEEDIPEDIA: **44.1% crude fat** (as fed), range 34.8-49.7%
- Typical oil content: **40-45%**
- Our value: **44.1%** ✅ (Within industry range)

**Sunflower seed, whole:**
- FEEDIPEDIA: **44.9% crude fat** (as fed)
- Literature range: **37-65%** (varies by variety)
- Typical: **45-50%**
- Our value: **44.5%** ✅ (Within industry range)

> [!WARNING]
> **Whole Oilseed Fat Values Are CORRECT**
> 
> The audit flagged these as critical (>25% threshold) but whole oilseeds naturally contain 40-50% fat. The 25% threshold is for PROCESSED feeds, not whole seeds.
> 
> **Action**: Update audit tool to allow crude fat up to 50% for whole oilseeds.

---

### 5. Specialty Protein Sources

**Blood Meal:**
- Industry standard CP: **80-90%** (can legitimately exceed 60%)
- Our value: **87.7%** ✅ (Within industry range)
- Lysine: Industry data shows high values for blood meal
- **Action**: Update audit CP threshold to 90% for blood meal

**Feather Meal:**
- Industry standard CP: **75-85%**
- Our value: **78.9%** ✅ (Within industry range)
- **Action**: Update audit CP threshold to 85% for feather meal

**Wheat Gluten:**
- Industry standard CP: **75-80%**
- Our value: **79.8%** ✅ (Within industry range)
- **Action**: Update audit CP threshold to 85% for wheat gluten

---

## Summary of Required Actions

### ✅ Values That Are CORRECT (Update Audit Thresholds)

1. **Fish meals** - High lysine/methionine are expected for 60-70% CP
2. **Rapeseed/Canola meals** - Lysine 18-20 g/kg is industry standard
3. **Whole oilseeds** - Fat 40-50% is normal
4. **Blood meal, Feather meal, Wheat gluten** - CP 75-90% is normal
5. **Pure oils** - 99-100% fat is expected
6. **Mineral supplements** - Very high Ca/P is expected
7. **Amino acid supplements** - Very high specific AA is expected

### ❌ Values That Need CORRECTION

1. **Soybean meals** - Lysine values are 4-5x too high
   - Should be ~6 g/kg, not ~28 g/kg
2. **Soybean whole products** - Lysine values too high
   - Should be ~6 g/kg, not ~22 g/kg
3. **Other protein meals** - Need to verify against industry standards

---

## Recommended Audit Tool Updates

### New Category-Specific Thresholds

```dart
// Protein Concentrates (CP > 60%)
if (ingredient.crudeProtein > 60) {
  lysineMax = 60.0;      // Allow up to 60 g/kg
  methionineMax = 25.0;  // Allow up to 25 g/kg
}

// Protein Meals (CP 35-50%)
if (ingredient.crudeProtein >= 35 && ingredient.crudeProtein <= 50) {
  lysineMax = 25.0;      // Allow up to 25 g/kg
  methionineMax = 10.0;  // Allow up to 10 g/kg
}

// Whole Oilseeds
if (ingredient.category == IngredientCategory.wholeOilseed) {
  crudeFatMax = 50.0;    // Allow up to 50%
}

// Specialty Proteins
if (ingredient.name.contains('Blood meal') || 
    ingredient.name.contains('Feather meal') ||
    ingredient.name.contains('Wheat gluten')) {
  crudeProteinMax = 90.0; // Allow up to 90%
}

// Pure Oils
if (ingredient.category == IngredientCategory.pureOil) {
  crudeFatMax = 100.0;   // Allow 100%
}

// Mineral Supplements
if (ingredient.category == IngredientCategory.mineralSupplement) {
  calciumMax = 400.0;    // Allow up to 400 g/kg
  phosphorusMax = 250.0; // Allow up to 250 g/kg
}

// Amino Acid Supplements
if (ingredient.category == IngredientCategory.aminoAcid) {
  lysineMax = 1000.0;    // Allow up to 1000 g/kg for L-lysine HCl
  methionineMax = 1000.0; // Allow up to 1000 g/kg for DL-methionine
}
```

---

## Next Steps

1. ✅ Research complete - Industry standards validated
2. [ ] Update audit tool with category-specific thresholds
3. [ ] Create correction script for soybean products
4. [ ] Re-run audit to verify remaining issues
5. [ ] Document final corrections
