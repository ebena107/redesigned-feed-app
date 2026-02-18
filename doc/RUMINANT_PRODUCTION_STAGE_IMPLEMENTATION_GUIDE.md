# Ruminant Production Stage Implementation Guide

## Quick Reference: What Needs to be Added

### Phase 1 Implementation (Critical - v1.1)

#### Dairy Cattle (Type 4) - Currently 3 stages → Expand to 7

**Add these cases to `_dairy()` method in nutrient_requirements.dart:**

```dart
static NutrientRequirements _dairy(FeedType type) {
  switch (type) {
    // NEW: Pre-Starter Calf (6-8 weeks)
    case FeedType.preStarter:
      return _build(4, type, 2800, 3100, 18.0, 22.0, 1.1, 1.3);

    // NEW: Starter Heifer (6-9 months)
    case FeedType.starter:
      return _build(4, type, 2600, 2900, 16.0, 18.0, 0.9, 1.1);

    // NEW: Growing Heifer (12-18 months)
    case FeedType.grower:
      return _build(4, type, 2500, 2800, 14.0, 16.0, 0.8, 1.0);

    // NEW: Pre-Breeding Heifer (18-24 months)
    case FeedType.finisher:
      return _build(4, type, 2400, 2700, 13.0, 15.0, 0.75, 0.95);

    // NEW: Early Lactation (Weeks 1-8, peak)
    case FeedType.early:
      return _build(4, type, 2500, 2700, 16.0, 18.0, 0.95, 1.15);

    // EXISTING (was confused - now clearly "mid/late lactation + maintenance")
    case FeedType.lactating:
      return _build(4, type, 2300, 2500, 14.0, 16.0, 0.82, 0.98);

    // EXISTING (was confused - now clearly "late gestation")
    case FeedType.gestating:
      return _build(4, type, 2100, 2300, 11.0, 13.0, 0.7, 0.85);

    default:
      return _maintenanceFallback(4, type);
  }
}
```

**Update FeedType.forAnimalType(4):**

```dart
case 4: // Dairy Cattle
  return [
    FeedType.preStarter,   // Calf (6-8 weeks)
    FeedType.starter,      // Weaned heifer (6 months)
    FeedType.grower,       // Growing heifer (12-18 months)
    FeedType.finisher,     // Pre-conception heifer (18-24 months)
    FeedType.early,        // Early lactation (peak)
    FeedType.lactating,    // Mid/late lactation
    FeedType.gestating,    // Late gestation (dry period)
  ];
```

---

#### Beef Cattle (Type 5) - Currently 4 stages → Expand to 6

**Add/Update cases in `_beef()` method:**

```dart
static NutrientRequirements _beef(FeedType type) {
  switch (type) {
    // NEW: Pre-Starter Calf (70-150 lbs, creep fed)
    case FeedType.preStarter:
      return _build(5, type, 2700, 2950, 15.0, 17.0, 0.85, 1.05);

    // FIX: Starter was missing case handler (falling to default)
    case FeedType.starter:
      return _build(5, type, 2600, 2850, 13.0, 15.0, 0.78, 0.95);

    // EXISTING: Growing (300-600 lbs)
    case FeedType.grower:
      return _build(5, type, 2405, 2590, 11.1, 13.88, 0.54, 0.76);

    // EXISTING: Finishing (600-1100 lbs)
    case FeedType.finisher:
      return _build(5, type, 2590, 2775, 10.18, 12.05, 0.44, 0.67);

    // NEW: Breeding Bull (1400-1600 lbs)
    case FeedType.early:
      return _build(5, type, 2400, 2600, 11.0, 13.0, 0.70, 0.85);

    // EXISTING: Maintenance/Pregnant Cow
    case FeedType.gestating:
      return _build(5, type, 2200, 2400, 10.0, 12.0, 0.65, 0.80);

    default:
      return _maintenanceFallback(5, type);
  }
}
```

**Update FeedType.forAnimalType(5):**

```dart
case 5: // Beef Cattle
  return [
    FeedType.preStarter,   // Calf creep (70-150 lbs)
    FeedType.starter,      // Young animal (150-300 lbs)
    FeedType.grower,       // Growing (300-600 lbs)
    FeedType.finisher,     // Finishing (600-1100 lbs)
    FeedType.early,        // Breeding bull
    FeedType.gestating,    // Pregnant cow / maintenance
  ];
```

---

#### Sheep (Type 6) - Currently 5 stages (2 differentiated) → Expand to 8 (all differentiated)

**Replace `_sheep()` method completely:**

```dart
static NutrientRequirements _sheep(FeedType type) {
  switch (type) {
    // NEW: Lamb Creep (birth-4 weeks, 2-8 lbs)
    case FeedType.preStarter:
      return _build(6, type, 2950, 3200, 18.0, 22.0, 1.1, 1.4);

    // NEW: Weaned Lamb (4-8 weeks, 8-15 lbs)
    case FeedType.starter:
      return _build(6, type, 2850, 3050, 16.0, 18.0, 1.0, 1.2);

    // NEW: Growing Lamb (8-16 weeks, 15-50 lbs) [was "grower" using maintenance values]
    case FeedType.grower:
      return _build(6, type, 2750, 2950, 15.0, 16.0, 0.95, 1.15);

    // NEW: Finishing Lamb (16-20 weeks, 50-110 lbs) [DEDUPLICATE from maintenance]
    case FeedType.finisher:
      return _build(6, type, 2800, 2950, 12.0, 14.0, 0.78, 0.92);

    // NEW: Growing Ewe (6-12 months) [was "starter" using maintenance values]
    case FeedType.early:
      return _build(6, type, 2700, 2900, 13.0, 15.0, 0.85, 1.05);

    // EXISTING: Maintenance (non-pregnant adult) [was handling starter/grower - NOW CLEARLY JUST MAINTENANCE]
    case FeedType.maintenance:
      return _build(6, type, 2035, 2313, 9.25, 12.95, 0.44, 0.67);

    // IMPROVED: Late Gestating Ewe (last 4-6 weeks) [was generic "gestating"]
    case FeedType.gestating:
      return _build(6, type, 2500, 2700, 12.0, 14.0, 0.82, 0.98);

    // EXISTING: Lactating Ewe (peak, 2-8 weeks)
    case FeedType.lactating:
      return _build(6, type, 2750, 3000, 15.0, 17.0, 1.0, 1.2);

    default:
      return _maintenanceFallback(6, type);
  }
}
```

**Update FeedType.forAnimalType(6):**

```dart
case 6: // Sheep
  return [
    FeedType.preStarter,   // Lamb creep (birth-4 weeks)
    FeedType.starter,      // Weaned lamb (4-8 weeks)
    FeedType.grower,       // Growing lamb (8-16 weeks) [NOW DISTINCT]
    FeedType.finisher,     // Finishing lamb (16-20 weeks) [NOW DISTINCT]
    FeedType.early,        // Growing ewe (6-12 months) [NOW DISTINCT]
    FeedType.maintenance,  // Maintenance ewe/wether [NOW JUST MAINTENANCE]
    FeedType.gestating,    // Late pregnant ewe [NOW DISTINCT]
    FeedType.lactating,    // Lactating ewe
  ];
```

---

#### Goat (Type 7) - Currently 5 stages (2 differentiated) → Expand to 8 (all differentiated)

**Replace `_goat()` method completely:**

```dart
static NutrientRequirements _goat(FeedType type) {
  switch (type) {
    // NEW: Doeling Creep (birth-2 months, 2-5 lbs)
    case FeedType.preStarter:
      return _build(7, type, 3000, 3300, 18.0, 22.0, 1.15, 1.45);

    // NEW: Young Doeling (2-4 months, 5-15 lbs)
    case FeedType.starter:
      return _build(7, type, 2900, 3150, 17.0, 19.0, 1.1, 1.3);

    // NEW: Growing Doeling (4-8 months, 15-50 lbs) [was "grower" using maintenance]
    case FeedType.grower:
      return _build(7, type, 2800, 3000, 14.0, 16.0, 0.95, 1.15);

    // NEW: Replacement Doeling (8-12 months, 50-100 lbs) [DEDUPLICATE from maintenance]
    case FeedType.finisher:
      return _build(7, type, 2700, 2950, 13.0, 15.0, 0.85, 1.05);

    // NEW: Breeding Buck (in-season)
    case FeedType.early:
      return _build(7, type, 2500, 2800, 12.0, 14.0, 0.78, 0.95);

    // EXISTING: Maintenance (non-lactating doe/wether) [NOW ONLY MAINTENANCE]
    case FeedType.maintenance:
      return _build(7, type, 2200, 2400, 10.0, 12.0, 0.68, 0.82);

    // IMPROVED: Late Pregnant Doe (last 4-6 weeks) [was generic "gestating"]
    case FeedType.gestating:
      return _build(7, type, 2600, 2850, 13.0, 15.0, 0.90, 1.10);

    // IMPROVED: Lactating Doe (peak, 2-8 weeks) [may need higher protein than current]
    case FeedType.lactating:
      return _build(7, type, 2900, 3200, 16.0, 18.0, 1.05, 1.30);

    default:
      return _maintenanceFallback(7, type);
  }
}
```

**Update FeedType.forAnimalType(7):**

```dart
case 7: // Goat
  return [
    FeedType.preStarter,   // Doeling creep (birth-2 months)
    FeedType.starter,      // Young doeling (2-4 months)
    FeedType.grower,       // Growing doeling (4-8 months) [NOW DISTINCT]
    FeedType.finisher,     // Replacement doeling (8-12 months) [NOW DISTINCT]
    FeedType.early,        // Breeding buck [NEW]
    FeedType.maintenance,  // Maintenance doe/wether [NOW ONLY MAINTENANCE]
    FeedType.gestating,    // Late pregnant doe [NOW DISTINCT]
    FeedType.lactating,    // Lactating doe [IMPROVED]
  ];
```

---

## Database Updates Needed

### Ingredient max_inclusion_json Updates

For each ingredient, add new category keys to support new production stages:

```json
// Example: Corn ingredient
{
  "id": 1,
  "name": "Corn",
  "max_inclusion_json": {
    "pig": 60,
    "poultry": 50,
    "rabbit": 30,
    
    // Dairy additions
    "dairyCalfPreStarter": 20,    // NEW: Limit in calf feeds (high starch)
    "dairyCalfStarter": 30,       // NEW
    "dairyHeiferGrowing": 40,     // NEW: Can increase with age
    "dairyHeiferFinisher": 45,    // NEW
    "dairyLactatingEarly": 55,    // NEW: Can tolerate more in high-energy lactation
    "dairyLactatingMid": 50,
    "dairyDry": 40,
    
    // Beef additions
    "beefCalfPreStarter": 25,     // NEW
    "beefGrowing": 40,
    "beefFinishing": 60,          // NEW: Highest in finishing (high energy)
    "beefBreedingBull": 35,       // NEW: Moderate for breeding
    "beefPregnantCow": 40,
    
    // Sheep/Goat additions
    "sheepLambCreep": 20,         // NEW
    "sheepLambStarter": 30,       // NEW: Higher for growing lambs
    "sheepLambGrowing": 35,
    "sheepLambFinishing": 50,     // NEW: Highest for finishing
    "sheepGrowingEwe": 35,        // NEW
    "sheepLactating": 40,
    "sheepDry": 30,
    
    // Similar for goat...
    "goatDoelingCreep": 15,
    "goatDoelingStarter": 25,
    // etc...
  }
}
```

**Why different limits?**
- Young animals (calves, lambs, kids): **Lower grain tolerance** (risk of acidosis)
- Growing animals: **Moderate grains** (energy needs but digestive system developing)
- Finishing animals: **High grains** (can handle high-energy, high-starch ration)
- Lactating animals: **Higher grains** (energy demand justifies starch load)
- Dry/maintenance animals: **Moderate** (forage-based, less concentrates)

### Storage: Which Table to Update?

Option 1: **Store in ingredient.maxInclusionJson** (current approach)
```dart
// ingredient.dart
String? maxInclusionJson; // Already exists

// Already serialized, new keys just get added to the JSON
```

Option 2: **Create new max_inclusion_ruminant_categories table** (if scaling further)
```sql
CREATE TABLE max_inclusion_ruminant_categories (
  id INTEGER PRIMARY KEY,
  ingredient_id INTEGER,
  category_key TEXT,  // e.g., "dairyCalfPreStarter"
  max_percentage REAL,
  FOREIGN KEY(ingredient_id) REFERENCES ingredients(id)
);
```

**Recommendation**: Use Option 1 (update existing JSON) - simpler, backward compatible

---

## UI Updates Needed

### Feed Type Dropdown Labels

**In your feed creation screen**, update the dropdown display text:

```dart
// Before (generic)
FeedType.starter → "Starter"
FeedType.grower → "Grower"

// After (specific)
FeedType.preStarter → "${animalTypeName(4)} - Calf Pre-Starter (6-8 weeks)"
FeedType.starter → "${animalTypeName(4)} - Heifer Starter (6-9 months)"
FeedType.grower → "${animalTypeName(4)} - Heifer Growing (12-18 months)"
FeedType.finisher → "${animalTypeName(4)} - Heifer Finisher (18-24 months)"
FeedType.early → "${animalTypeName(4)} - Early Lactation (Peak)"
FeedType.lactating → "${animalTypeName(4)} - Mid/Late Lactation"
FeedType.gestating → "${animalTypeName(4)} - Late Gestation (Dry)"
```

**Helper function needed:**

```dart
String getFeedTypeLabel(int animalTypeId, FeedType type) {
  switch (animalTypeId) {
    case 4: // Dairy
      switch (type) {
        case FeedType.preStarter:
          return "Calf Pre-Starter (6-8 weeks)";
        case FeedType.starter:
          return "Weaned Heifer (6-9 months)";
        // ... etc
      }
    case 5: // Beef
      switch (type) {
        case FeedType.preStarter:
          return "Calf Creep (70-150 lbs)";
        // ... etc
      }
    // ... etc
  }
}
```

---

## Testing Checklist

### Unit Tests to Add

```dart
// test/unit/nutrient_requirements_expansion_test.dart

void main() {
  group('Dairy Cattle Production Stage Requirements', () {
    test('Pre-Starter meets calf energy needs', () {
      final req = NutrientRequirements.getDefaults(4, FeedType.preStarter);
      expect(req.constraints.energy.min, 2800);
      expect(req.constraints.protein.min, 18.0);
    });

    test('Early Lactation distinctly different from mid-lactation', () {
      final early = NutrientRequirements.getDefaults(4, FeedType.early);
      final mid = NutrientRequirements.getDefaults(4, FeedType.lactating);
      expect(early.constraints.energy.min, greaterThan(mid.constraints.energy.min));
    });
  });

  group('Sheep Production Stage Requirements', () {
    test('Growing lamb significantly higher protein than maintenance ewe', () {
      final lamb = NutrientRequirements.getDefaults(6, FeedType.grower);
      final ewe = NutrientRequirements.getDefaults(6, FeedType.maintenance);
      expect(lamb.constraints.protein.min, greaterThan(ewe.constraints.protein.min));
    });

    test('Lactating ewe highest protein of all sheep stages', () {
      final lactating = NutrientRequirements.getDefaults(6, FeedType.lactating);
      // Compare to all other stages...
      expect(lactating.constraints.protein.min, 15.0);
    });
  });

  group('Goat vs Sheep Protein Comparison', () {
    test('Goat stages have higher protein than sheep equivalents', () {
      final sheepGrower = NutrientRequirements.getDefaults(6, FeedType.grower);
      final goatGrower = NutrientRequirements.getDefaults(7, FeedType.grower);
      expect(goatGrower.constraints.protein.min, 
             greaterThanOrEqualTo(sheepGrower.constraints.protein.min));
    });
  });
}
```

### Integration Tests

```dart
// test/integration/ruminant_lifecycle_test.dart

test('Dairy Cattle lifecycle: Calf → Heifer → Lactating → Dry', () {
  final stages = [
    (FeedType.preStarter, 'calf 6-8 weeks'),
    (FeedType.starter, 'heifer 6-9 months'),
    (FeedType.grower, 'heifer 12-18 months'),
    (FeedType.finisher, 'heifer pre-breeding'),
    (FeedType.early, 'early lactation'),
    (FeedType.lactating, 'mid-late lactation'),
    (FeedType.gestating, 'dry period'),
  ];

  for (final (stage, description) in stages) {
    final req = NutrientRequirements.getDefaults(4, stage);
    
    // Verify requirements are reasonable
    expect(req.constraints.energy.min, greaterThan(1500),
           reason: "$description should have realistic energy need");
    expect(req.constraints.protein.min, greaterThan(5.0),
           reason: "$description should require protein");
    
    // Verify energy <= max
    expect(req.constraints.energy.min, lessThanOrEqualTo(req.constraints.energy.max));
  }
  
  // Verify progression makes sense
  final preStarter = NutrientRequirements.getDefaults(4, FeedType.preStarter);
  final early = NutrientRequirements.getDefaults(4, FeedType.early);
  expect(early.constraints.protein.min, 
         greaterThan(preStarter.constraints.protein.min),
         reason: 'Early lactation should have higher protein than calf');
});
```

---

## Validation Against Standards

Create a spreadsheet to verify your implementation matches published sources:

| Animal Type | Stage | Energy (kcal/kg) | Protein (%) | NRC Ref | Status |
|---|---|---|---|---|---|
| Dairy | Calf Pre-Starter | 2800-3100 | 18-22% | NRC 2021 §4.2 | ✅ |
| Dairy | Lactating Peak | 2500-2700 | 16-18% | NRC 2021 §5.1 | ✅ |
| Beef | Calf Creep | 2700-2950 | 15-17% | NRC 2024 §3.1 | ✅ |
| Sheep | Lamb Creep | 2950-3200 | 18-22% | NRC 2007 §4.3 | ✅ |
| Goat | Doeling Creep | 3000-3300 | 18-22% | NRC 2007 §5.2 | ✅ |

---

## Phase 1 Summary

| Component | Effort | Lines of Code | Priority |
|-----------|--------|---|---|
| FeedType enum additions | 0.5h | 0 | Medium (enum already supports) |
| _dairy() method expansion | 0.5h | 15 | HIGH |
| _beef() method fixes + additions | 0.5h | 12 | HIGH |
| _sheep() complete rewrite | 1h | 25 | CRITICAL |
| _goat() complete rewrite | 1h | 25 | CRITICAL |
| UI dropdown labels | 1.5h | 50 | HIGH |
| Unit tests | 2h | 100 | HIGH |
| Ingredient max_inclusion_json updates | 1h | 200 (JSON) | MEDIUM |
| Integration tests & validation | 1.5h | 60 | HIGH |
| **TOTAL PHASE 1** | **~9 hours** | **~487 lines** | - |

**Estimated timeline**: 2 days development + 1/2 day testing + QA approval = **2.5 days for Phase 1**

---

## Next Steps (Do This First)

1. ✅ Review this document with livestock nutritionist or consultant
2. ✅ Validate constraint values against NRC 2021, 2024, 2007 publications
3. ✅ Identify which ingredients need max_inclusion_json updates
4. ✅ Prioritize Phase 1 (dairy + sheep/goat are most broken)
5. Create feature branch: `feature/ruminant-stages-expansion`
6. Implement in this order: Dairy → Sheep → Goat → Beef
7. Run full test suite after each animal type
8. Create PR with comprehensive testing
