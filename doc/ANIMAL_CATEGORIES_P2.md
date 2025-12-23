# Animal Categories & Inclusion Limits - Phase 2 Documentation

**Date:** December 22, 2025  
**Phase:** P2 (Broaden animal categories)  
**Status:** ✅ COMPLETE  

---

## Overview

Feed Estimator now supports **granular animal categories** for precise inclusion limit management, replacing the generic 5-animal-type system with specific production stages and animal types.

### What Changed

- **Before:** `animalTypeId` 1-5 (pig, poultry, rabbit, ruminant, fish) → single inclusion limit per ingredient
- **After:** Granular categories like `pig_grower`, `poultry_broiler_starter`, `ruminant_dairy` → per-category limits in `max_inclusion_json`

---

## Animal Type Mapping (AnimalTypeId)

| ID | Animal Type | Human Name |
|----|-------------|-----------|
| 1 | Swine | Pig (Growing pig, Finishing pig, Sow) |
| 2 | Poultry | Poultry (Broiler, Layer, Breeder) |
| 3 | Rabbit | Rabbit (Grower, Breeder) |
| 4 | Ruminant | Ruminant (Dairy, Beef, Sheep, Goat) |
| 5 | Aquaculture | Fish (Freshwater, Marine, Salmonids, Tilapia, Catfish) |

---

## Granular Categories

### 1. SWINE (animalTypeId = 1)

| Category Key | Description | Weight Range |
|---|---|---|
| `pig_nursery` | Piglets in nursing/early weaning | 3–10 kg |
| `pig_starter` | Post-weaning piglets | 10–25 kg |
| `pig_grower` | Growing pigs | 25–50 kg |
| `pig_finisher` | Market-ready finishing pigs | 50+ kg |
| `pig_gestating` | Pregnant sows | — |
| `pig_lactating` | Lactating/nursing sows | — |
| `pig_sow` | Generic sow (fallback) | — |
| `pig` | Generic pig (fallback for all stages) | — |

**Example Inclusion Limits:**
```json
{
  "name": "Fish meal, 62% protein",
  "max_inclusion_json": {
    "pig_nursery": 3,
    "pig_starter": 5,
    "pig_grower": 8,
    "pig_finisher": 10,
    "pig_gestating": 4,
    "pig_lactating": 6,
    "pig_sow": 5,
    "pig": 8
  }
}
```

### 2. POULTRY (animalTypeId = 2)

| Category Key | Description | Stage |
|---|---|---|
| `poultry_broiler_starter` | Broiler chicks | 0–2 weeks |
| `poultry_broiler_grower` | Growing broilers | 2–6 weeks |
| `poultry_broiler_finisher` | Finishing broilers | 6+ weeks |
| `broiler` | Generic broiler (fallback) | — |
| `poultry_layer` | Laying hens / Pullets | — |
| `poultry_breeder` | Breeding stock | — |
| `poultry` | Generic poultry (fallback) | — |

**Example Inclusion Limits:**
```json
{
  "name": "Cottonseed meal",
  "max_inclusion_json": {
    "poultry_broiler_starter": 10,
    "poultry_broiler_grower": 15,
    "poultry_broiler_finisher": 20,
    "broiler": 15,
    "poultry_layer": 15,
    "poultry_breeder": 10,
    "poultry": 12
  }
}
```

### 3. RUMINANTS (animalTypeId = 4)

| Category Key | Description |
|---|---|
| `ruminant_dairy` | Dairy cattle (highest nutrient demands) |
| `ruminant_beef` | Beef cattle |
| `ruminant_sheep` | Sheep / Small ruminants |
| `ruminant_goat` | Goat / Caprine |
| `ruminant` | Generic ruminant (fallback) |

**Example Inclusion Limits:**
```json
{
  "name": "Urea",
  "max_inclusion_json": {
    "ruminant_dairy": 2,
    "ruminant_beef": 2,
    "ruminant_sheep": 1,
    "ruminant_goat": 1,
    "ruminant": 1
  }
}
```

### 4. RABBITS (animalTypeId = 3)

| Category Key | Description |
|---|---|
| `rabbit_grower` | Growing rabbits for meat |
| `rabbit_breeder` | Breeding stock |
| `rabbit` | Generic rabbit (fallback) |

**Example:**
```json
{
  "name": "Alfalfa meal",
  "max_inclusion_json": {
    "rabbit_grower": 100,
    "rabbit_breeder": 80,
    "rabbit": 90
  }
}
```

### 5. FISH & AQUACULTURE (animalTypeId = 5)

| Category Key | Description |
|---|---|
| `fish_freshwater` | Freshwater fish (Tilapia, Catfish) |
| `fish_marine` | Marine fish (Seabass, Seabream) |
| `fish_salmonids` | Salmon, Trout (coldwater) |
| `fish_tilapia` | Tilapia species |
| `fish_catfish` | Catfish species |
| `fish` | Generic fish (fallback) |
| `aquaculture` | Generic aquaculture (ultimate fallback) |

**Example:**
```json
{
  "name": "Fish meal, 62% protein",
  "max_inclusion_json": {
    "fish_freshwater": 8,
    "fish_marine": 10,
    "fish_salmonids": 15,
    "fish_tilapia": 10,
    "fish_catfish": 10,
    "fish": 10,
    "aquaculture": 8
  }
}
```

---

## Implementation: AnimalCategoryMapper

### Location

`lib/src/core/constants/animal_categories.dart`

### Key Methods

#### 1. Get Category Preferences

```dart
List<String> getCategoryPreferences({
  required num animalTypeId,
  String? productionStage,
})
```

Returns a **priority-ordered list** of category keys to check in `max_inclusion_json`, from most specific to most generic.

**Examples:**
```dart
// Pig grower
AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: 1,
  productionStage: 'grower',
)
// Returns: ['pig_grower', 'pig_starter', 'pig_finisher', 'pig']

// Broiler starter
AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: 2,
  productionStage: 'starter',
)
// Returns: ['poultry_broiler_starter', 'broiler', 'poultry']

// Generic dairy cattle
AnimalCategoryMapper.getCategoryPreferences(animalTypeId: 4)
// Returns: ['ruminant_dairy', 'ruminant_beef', 'ruminant_sheep', 'ruminant_goat', 'ruminant']
```

#### 2. Get Human-Readable Names

```dart
// Animal type
String name = AnimalCategoryMapper.getAnimalTypeName(1);
// Returns: 'Swine (Pig)'

// Category
String categoryName = AnimalCategoryMapper.getCategoryName('pig_grower');
// Returns: 'Pig - Grower (25-50 kg)'
```

---

## Integration: InclusionValidator

The `InclusionValidator` now uses `AnimalCategoryMapper` to resolve inclusion limits:

### Lookup Flow

1. **Check `max_inclusion_json`** (if present)
   - Build preference list using `AnimalCategoryMapper.getCategoryPreferencesForAnimalType(animalTypeId)`
   - Iterate through preference list and return first match
   - Fallback: pick the most conservative (minimum) positive limit if no preferred key exists

2. **Check `maxInclusionPct`** (legacy single-value field)
   - Applied if `max_inclusion_json` is absent or empty
   - Maintains backward compatibility with v8 data

3. **Hardcoded rules** (legacy fallback)
   - Toxicity limits (urea=0, cottonseed=15, etc.)
   - These remain for unmapped ingredients

### Code Example

```dart
// In InclusionValidator._getMaxInclusionForAnimal()
final map = ingredient.maxInclusionJson;
if (map != null && map.isNotEmpty) {
  final preference = 
    AnimalCategoryMapper.getCategoryPreferencesForAnimalType(animalTypeId);
  
  for (final key in preference) {
    final val = map[key];
    if (val is num) return val.toDouble();
  }
  // ... last-resort fallback logic
}

// Fallback to legacy field
if (ingredient.maxInclusionPct != null) {
  return ingredient.maxInclusionPct!.toDouble();
}

return null;
```

---

## Migration & Data Preparation

### Preparing `max_inclusion_json` in Ingredients

**Old format (v8):**
```json
{
  "ingredient_id": 1,
  "name": "Fish meal, 62% protein",
  "max_inclusion_pct": 10,
  ...
}
```

**New format (v9):**
```json
{
  "ingredient_id": 1,
  "name": "Fish meal, 62% protein",
  "max_inclusion_pct": 10,  // Keep for backward compat
  "max_inclusion_json": {   // NEW: per-category limits
    "pig_nursery": 3,
    "pig_starter": 5,
    "pig_grower": 8,
    "pig_finisher": 10,
    "poultry_broiler_starter": 5,
    "poultry_broiler_grower": 8,
    "poultry_broiler_finisher": 10,
    "ruminant_dairy": 5,
    "ruminant_beef": 8,
    "fish_salmonids": 15,
    "default": 10  // Fallback if no category match
  },
  ...
}
```

### Gradual Rollout

1. **Phase 1:** Store `max_inclusion_json` in DB, use it when present
2. **Phase 2:** Populate v9 ingredients_standardized.json with category-specific limits
3. **Phase 3:** Gradually migrate existing ingredients to new schema
4. **Fallback:** Always check `max_inclusion_pct` if `max_inclusion_json` missing

---

## Benefits

| Benefit | Impact |
|---------|--------|
| **Precision** | Inclusion limits tailored to production stage (e.g., broiler starter ≠ layer) |
| **Safety** | Per-species ANF handling (e.g., tannins safe for ruminants, problematic for pigs) |
| **Flexibility** | Easy to add new animal types without schema changes |
| **Backward Compatibility** | Legacy `maxInclusionPct` field still honored; migration gradual |
| **Standards Alignment** | Matches NRC, CVB, INRA per-stage recommendations |

---

## Next Steps (P3)

1. Import `ingredients_standardized.json` (211 items) with per-category `max_inclusion_json` populated
2. Verify calculation engine compatibility
3. Add UI trust signals (standards chip) for flagged ingredients
4. Run end-to-end tests with new categorization

---

## Constants File Reference

**File:** `lib/src/core/constants/animal_categories.dart`

**Exports:**
- `AnimalTypeId` — Legacy animal type IDs (1–5)
- `AnimalCategory` — String constants for category keys
- `AnimalCategoryMapper` — Utility class for category resolution
  - `getCategoryPreferences()` — Get preference list for animalTypeId ± stage
  - `getCategoryPreferencesForAnimalType()` — Legacy version (animalTypeId only)
  - `getAnimalTypeName()` — Human-readable animal type
  - `getCategoryName()` — Human-readable category with weight range or stage

---

## Testing Checklist

- [ ] `AnimalCategoryMapper.getCategoryPreferences()` returns correct order for each animal type
- [ ] Production stages (starter, grower, finisher) map to correct categories
- [ ] Fallback to generic category if specific stage not found in `max_inclusion_json`
- [ ] Backward compatibility: ingredients with only `maxInclusionPct` still work
- [ ] UI displays category names correctly using `getCategoryName()`
- [ ] Inclusion validator rejects over-limit ingredients with correct error message
- [ ] Validation warnings trigger at 90% of limit for each category

---

## Questions & Support

For issues with animal categories or mapping:
1. Check `AnimalCategoryMapper.getCategoryPreferences()` logic
2. Verify `max_inclusion_json` keys match constants in `AnimalCategory`
3. Review InclusionValidator integration in `_getMaxInclusionForAnimal()`
4. Test with `ingredients_standardized.json` (contains pre-populated limits)
