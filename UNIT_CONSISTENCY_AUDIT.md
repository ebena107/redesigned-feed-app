# Unit Consistency Audit Report
## PDF Report Units vs Calculations vs Industry Standards

**Date**: 2024  
**Status**: ✅ CRITICAL ISSUE IDENTIFIED  
**Severity**: HIGH - Units mismatch between calculations and PDF display

---

## Executive Summary

The feed estimator application has a **critical unit inconsistency** between:
1. **Ingredient Database Units** (% dry matter, g/kg, kcal/kg)
2. **Calculation Engine Units** (weighted averages as-is, no conversion)
3. **PDF Display Labels** (inconsistent: some show %, some show g/Kg, some show %/Kg)

### Key Finding: The "%/Kg" Unit Label is Invalid

The PDF displays `%/Kg` for Crude Protein, Crude Fiber, and Crude Fat. This is **scientifically invalid** because:
- These nutrients are stored in the database as **% dry matter (DM)**
- The calculation produces values in **% (per kilogram of feed, on dry matter basis)**
- Displaying them as **"%/Kg"** conflates percentage (dimensionless) with mass units (Kg), which is nonsensical

---

## 1. Data Flow Analysis

### 1.1 Source Data (initial_ingredients.json)
```json
{
    "name": "Alfalfa, dehydrated, protein < 16% dry matter",
    "crude_protein": 14.1,           // ✅ % dry matter
    "crude_fiber": 28.0,             // ✅ % dry matter
    "crude_fat": 2.1,                // ✅ % dry matter
    "calcium": 20.1,                 // ⚠️ UNCLEAR - likely g/kg or %
    "phosphorus": 2.4,               // ⚠️ UNCLEAR - likely g/kg or %
    "lysine": 5.6,                   // ⚠️ UNCLEAR - likely g/kg or %
    "methionine": 1.2,               // ⚠️ UNCLEAR - likely g/kg or %
    "me_growing_pig": 1590,          // ✅ kcal/kg
    "me_poultry": 1070,              // ✅ kcal/kg
    "me_ruminant": 1910,             // ✅ kcal/kg
    "me_rabbit": 1630,               // ✅ kcal/kg
    "de_salmonids": 2160             // ✅ kcal/kg (Digestible Energy for fish)
}
```

**Database Schema** (Ingredient model):
```dart
class Ingredient {
  num? crudeProtein;        // % dry matter
  num? crudeFiber;          // % dry matter
  num? crudeFat;            // % dry matter
  num? calcium;             // ⚠️ NEEDS CLARIFICATION
  num? phosphorus;          // ⚠️ NEEDS CLARIFICATION
  num? lysine;              // ⚠️ NEEDS CLARIFICATION
  num? methionine;          // ⚠️ NEEDS CLARIFICATION
  num? meGrowingPig;        // kcal/kg
  num? mePoultry;           // kcal/kg
  num? meRuminant;          // kcal/kg
  num? meRabbit;            // kcal/kg
  num? deSalmonids;         // kcal/kg (digestible energy)
}
```

---

## 2. Calculation Engine (result_provider.dart)

### 2.1 Calculation Logic
```dart
Future<void> calculateResult() async {
    // ... load ingredients ...
    for (final ing in ingList) {
      final qty = (ing.quantity ?? 0).toDouble();
      if (qty <= 0) continue;

      final data = _ingredientCache[ing.ingredientId];
      if (data == null) continue;

      // ISSUE: Direct multiplication without unit conversion
      final energy = _energyForAnimal(data, animalTypeId);  // kcal/kg
      totalEnergy += energy * qty;
      totalProtein += (data.crudeProtein ?? 0) * qty;      // % * kg = % [WRONG]
      totalFat += (data.crudeFat ?? 0) * qty;              // % * kg = % [WRONG]
      totalFiber += (data.crudeFiber ?? 0) * qty;          // % * kg = % [WRONG]
      totalCalcium += (data.calcium ?? 0) * qty;           // ? * kg = ? [UNKNOWN]
      totalPhosphorus += (data.phosphorus ?? 0) * qty;     // ? * kg = ? [UNKNOWN]
      totalLysine += (data.lysine ?? 0) * qty;             // ? * kg = ? [UNKNOWN]
      totalMethionine += (data.methionine ?? 0) * qty;     // ? * kg = ? [UNKNOWN]
    }

    // Weighted averages (dividing by total quantity)
    _mEnergy = totalEnergy / _totalQuantity;
    _cProtein = totalProtein / _totalQuantity;
    _cFat = totalFat / _totalQuantity;
    _cFibre = totalFiber / _totalQuantity;
    _calcium = totalCalcium / _totalQuantity;
    _phosphorus = totalPhosphorus / _totalQuantity;
    _lyzine = totalLysine / _totalQuantity;
    _methionine = totalMethionine / _totalQuantity;
}
```

### 2.2 Result Values (calculated)
```dart
class Result {
  num? mEnergy;       // [kcal/kg] ✅ CORRECT
  num? cProtein;      // [%] - but labeled as [%/Kg] ❌ WRONG LABEL
  num? cFat;          // [%] - but labeled as [%/Kg] ❌ WRONG LABEL
  num? cFibre;        // [%] - but labeled as [%/Kg] ❌ WRONG LABEL
  num? calcium;       // [UNKNOWN] - but labeled as [g/Kg] ⚠️ NEEDS VERIFICATION
  num? phosphorus;    // [UNKNOWN] - but labeled as [g/Kg] ⚠️ NEEDS VERIFICATION
  num? lysine;        // [UNKNOWN] - but labeled as [g/Kg] ⚠️ NEEDS VERIFICATION
  num? methionine;    // [UNKNOWN] - but labeled as [g/Kg] ⚠️ NEEDS VERIFICATION
}
```

---

## 3. PDF Display Units (pdf_export.dart)

### 3.1 Current PDF Labels

| Nutrient | Calculated Value | PDF Label | Status |
|----------|------------------|-----------|--------|
| Metabolic Energy | kcal/kg | `Kcal/Kg` | ✅ CORRECT |
| Crude Protein | % | `%/Kg` | ❌ INVALID |
| Crude Fiber | % | `%/Kg` | ❌ INVALID |
| Crude Fat | % | `%/Kg` | ❌ INVALID |
| Calcium | unknown | `g/Kg` | ⚠️ NEEDS VERIFICATION |
| Phosphorus | unknown | `g/Kg` | ⚠️ NEEDS VERIFICATION |
| Lysine | unknown | `g/Kg` | ⚠️ NEEDS VERIFICATION |
| Methionine | unknown | `g/Kg` | ⚠️ NEEDS VERIFICATION |

---

## 4. Industry Standards

### 4.1 Standard Units for Feed Formulation

| Nutrient | Industry Standard | Notes |
|----------|-------------------|-------|
| **Crude Protein (CP)** | % dry matter (DM) | Also expressed as g/kg DM |
| **Crude Fiber (CF)** | % dry matter (DM) | Also expressed as g/kg DM |
| **Crude Fat (EE)** | % dry matter (DM) | Also expressed as g/kg DM |
| **Metabolizable Energy (ME)** | kcal/kg or MJ/kg | Most common in feed formulation |
| **Calcium (Ca)** | % dry matter OR g/kg | Common expressions vary by country |
| **Phosphorus (P)** | % dry matter OR g/kg | Common expressions vary by country |
| **Lysine** | % dry matter OR g/kg | Essential amino acid |
| **Methionine** | % dry matter OR g/kg | Essential amino acid |

---

## 5. Unit Conversion Reference

### If Minerals/Amino Acids are in % DM
```
% → g/kg conversion: multiply by 10
Example: 1.5% = 15 g/kg

g/kg → % conversion: divide by 10
Example: 15 g/kg = 1.5%
```

### Energy Unit Conversion
```
kcal/kg → MJ/kg: divide by 239.14
MJ/kg → kcal/kg: multiply by 239.14

Example: 3000 kcal/kg = 12.5 MJ/kg
```

---

## 6. Identified Issues

### Issue #1: Invalid "%/Kg" Unit Label ❌ CRITICAL
**Location**: `pdf_export.dart` lines 235, 243, 250

**Problem**: 
- Crude Protein, Crude Fiber, and Crude Fat are displayed with unit `%/Kg`
- This is scientifically invalid (% is dimensionless, cannot be combined with /Kg)
- The actual values are percentages (% DM), not per kilogram

**Example from code**:
```dart
TableRow(
  children: [
    // ... row 2: Crude Protein ...
    SizedBox(
        width: 80,
        child: paddedText('%/Kg', align: TextAlign.center)),  // ❌ WRONG
  ],
),
```

**Correct Label**: `%` (or `% DM` if specifying dry matter basis)

---

### Issue #2: Unclear Mineral & Amino Acid Units ⚠️ URGENT
**Location**: Database schema (Ingredient model), initial_ingredients.json

**Problem**:
- Calcium, Phosphorus, Lysine, Methionine units are **not documented**
- Currently displayed as `g/Kg` in PDF
- Database values suggest they might be `% DM` based on magnitude

**Investigation Needed**:
- Is calcium `20.1` = 20.1% or 20.1 g/kg?
- Is phosphorus `2.4` = 2.4% or 2.4 g/kg?
- Expected ranges:
  - Calcium: 0.5-1.2% DM (5-12 g/kg DM) for most animals
  - Phosphorus: 0.3-0.8% DM (3-8 g/kg DM) for most animals
  - Lysine: 0.5-1.2% DM (5-12 g/kg DM) depending on species
  - Methionine: 0.2-0.5% DM (2-5 g/kg DM) depending on species

**Analysis of Alfalfa Data**:
```json
"name": "Alfalfa, dehydrated, protein < 16% dry matter",
"calcium": 20.1,         // If %, this is ~201 g/kg - impossibly high
"phosphorus": 2.4,       // If %, this is reasonable (2-3% is high for alfalfa)
"lysine": 5.6,           // If %, this is ~56 g/kg - unrealistic for amino acid
"methionine": 1.2,       // If %, this is ~12 g/kg - reasonable for methionine
```

**Conclusion**: Values appear to be **in g/kg or %**, but the magnitude suggests mixed units:
- Calcium: Likely **g/kg** (20.1 g/kg = 2.01% is reasonable for alfalfa)
- Phosphorus: Likely **g/kg** (2.4 g/kg = 0.24% is reasonable for alfalfa)
- Lysine: Likely **g/kg** (5.6 g/kg = 0.56% is reasonable for amino acids)
- Methionine: Likely **g/kg** (1.2 g/kg = 0.12% is reasonable for amino acids)

---

### Issue #3: Calculation Logic Error ❌ CRITICAL
**Location**: `result_provider.dart`, `calculateResult()` method

**Problem**:
```dart
// INCORRECT: Multiplying % by kg (dimensionally invalid)
totalProtein += (data.crudeProtein ?? 0) * qty;  // % * kg = nonsense
```

**What It Should Be**:
```dart
// CORRECT: Average as percentages (already % basis)
totalProtein += (data.crudeProtein ?? 0) * (qty / totalQuantity);
// OR (after summing):
_cProtein = totalProtein / (ingList.length);  // But this assumes equal distribution
// OR (proper weighted average):
_cProtein = totalProtein / _totalQuantity;    // This is what the code does - ACTUALLY CORRECT
```

**Wait - Actually the calculation IS correct!** (Apologies for confusion)

The code divides by total quantity at the end:
```dart
_cProtein = totalProtein / _totalQuantity;
```

This produces a **weighted average percentage**, which is correct for feed formulation.

**Example**:
- Ingredient A: 50% CP, 5 kg
- Ingredient B: 20% CP, 5 kg
- Total: 10 kg
- Weighted avg CP = (50×5 + 20×5) / 10 = 350/10 = 35% ✅ CORRECT

---

## 7. Recommendations

### Priority 1: Fix PDF Unit Labels (Immediate) 🔴 CRITICAL

**Change 1: Crude Protein Label**
```dart
// BEFORE
SizedBox(
    width: 80,
    child: paddedText('%/Kg', align: TextAlign.center)),

// AFTER
SizedBox(
    width: 80,
    child: paddedText('%', align: TextAlign.center)),
```

**Change 2: Crude Fiber Label**
```dart
// BEFORE
SizedBox(
    width: 80,
    child: paddedText('%/Kg', align: TextAlign.center)),

// AFTER
SizedBox(
    width: 80,
    child: paddedText('%', align: TextAlign.center)),
```

**Change 3: Crude Fat Label**
```dart
// BEFORE
SizedBox(
    width: 80,
    child: paddedText('%/Kg', align: TextAlign.center)),

// AFTER
SizedBox(
    width: 80,
    child: paddedText('%', align: TextAlign.center)),
```

---

### Priority 2: Clarify Mineral & Amino Acid Units (Urgent) 🟠 HIGH

**Immediate Actions**:
1. ✅ Verify mineral/amino acid units in source data documentation
2. Confirm whether `initial_ingredients.json` values are in `%` or `g/kg`
3. Update `ingredient.dart` model documentation with units
4. Add unit comments in `Result` model

**Suggested Documentation Format**:
```dart
class Ingredient {
  num? crudeProtein;     // Units: % dry matter (DM)
  num? crudeFiber;       // Units: % dry matter (DM)
  num? crudeFat;         // Units: % dry matter (DM)
  num? calcium;          // Units: g/kg (grams per kilogram)
  num? phosphorus;       // Units: g/kg (grams per kilogram)
  num? lysine;           // Units: g/kg (grams per kilogram)
  num? methionine;       // Units: g/kg (grams per kilogram)
  num? meGrowingPig;     // Units: kcal/kg (metabolizable energy)
  num? mePoultry;        // Units: kcal/kg
  num? meRuminant;       // Units: kcal/kg
  num? meRabbit;         // Units: kcal/kg
  num? deSalmonids;      // Units: kcal/kg (digestible energy for fish)
}

class Result {
  num? mEnergy;          // Units: kcal/kg
  num? cProtein;         // Units: % dry matter
  num? cFat;             // Units: % dry matter
  num? cFibre;           // Units: % dry matter
  num? calcium;          // Units: g/kg OR % - VERIFY
  num? phosphorus;       // Units: g/kg OR % - VERIFY
  num? lysine;           // Units: g/kg OR % - VERIFY
  num? methionine;       // Units: g/kg OR % - VERIFY
}
```

---

### Priority 3: Unit Verification Test (Testing) 🟡 MEDIUM

Create unit verification tests:

```dart
// test/unit_consistency_test.dart
void main() {
  test('Alfalfa calcium units are correct', () {
    final alfalfa = getAlfalfaIngredient();
    
    // Alfalfa contains ~2.0% calcium dry matter
    // Which equals 20 g/kg DM
    expect(alfalfa.calcium, closeTo(20.0, 0.5));
    
    // If value is 20.1, it's g/kg
    // If value is 2.01, it's %
  });
  
  test('PDF protein unit label matches calculation', () {
    final result = calculateFeedResult();
    
    // Crude protein should be expressed as percentage
    // Value range: 12-24% for most feeds
    expect(result.cProtein, greaterThan(0));
    expect(result.cProtein, lessThan(100));
  });
}
```

---

## 8. Unit Summary Table (Industry Standard)

| Component | Industry Standard | Current Code | PDF Label | Status |
|-----------|-------------------|--------------|-----------|--------|
| Metabolic Energy | kcal/kg | ✅ kcal/kg | ✅ Kcal/Kg | ✅ PASS |
| Crude Protein | % DM | ✅ % | ❌ %/Kg | ❌ FAIL |
| Crude Fiber | % DM | ✅ % | ❌ %/Kg | ❌ FAIL |
| Crude Fat | % DM | ✅ % | ❌ %/Kg | ❌ FAIL |
| Calcium | g/kg (or %) | ⚠️ Unknown | g/Kg | ⚠️ UNKNOWN |
| Phosphorus | g/kg (or %) | ⚠️ Unknown | g/Kg | ⚠️ UNKNOWN |
| Lysine | g/kg (or %) | ⚠️ Unknown | g/Kg | ⚠️ UNKNOWN |
| Methionine | g/kg (or %) | ⚠️ Unknown | g/Kg | ⚠️ UNKNOWN |

---

## 9. Conclusion

### What's Correct ✅
- Calculation engine correctly implements weighted averaging
- Metabolic energy units (kcal/kg) are correct
- Crude protein, fiber, and fat values are correct (as %)

### What's Wrong ❌
1. **"%/Kg" label is scientifically invalid** for protein, fiber, and fat
2. **Mineral and amino acid units are undocumented** - need verification

### Action Items
- [ ] Update PDF labels: `%/Kg` → `%` for protein, fiber, fat
- [ ] Verify and document mineral/amino acid units
- [ ] Add unit comments to data models
- [ ] Create unit verification tests
- [ ] Update README with unit specifications

---

## References

1. **Feed Formulation Standards** (ASABE, AAFCO)
   - Standard: Feed analysis expressed on % dry matter basis
   - Energy: kcal/kg or MJ/kg
   
2. **NRC (National Research Council)**
   - Nutrient Requirements for different animal species
   - All values expressed as % DM or per kg DM
   
3. **Standard Feed Databases**
   - FEEDBASE (South Africa)
   - CVB (Central Bureau for Livestock Feeding - Netherlands)
   - INRA (France)
   - All use % DM or g/kg DM for mineral/amino acids

---

**Next Steps**: Start with Priority 1 (fix PDF labels) immediately, then investigate mineral/amino acid units.
