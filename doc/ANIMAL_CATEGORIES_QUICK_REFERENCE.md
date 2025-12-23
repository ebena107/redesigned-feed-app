# Animal Categories Quick Reference - P2

**For:** Developers integrating granular animal categories  
**TL;DR:** Use `AnimalCategoryMapper` to map `animalTypeId` to category keys; check ingredient `max_inclusion_json` with preference order  
**Location:** `lib/src/core/constants/animal_categories.dart`

---

## Common Usage Patterns

### Pattern 1: Get inclusion limit for an ingredient

```dart
import 'package:feed_estimator/src/core/constants/animal_categories.dart';
import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';

// You have: ingredient data, animalTypeId, and optionally productionStage
final ingredient = ingredientCache[ingredientId];
final animalTypeId = 1; // Pig
final productionStage = 'grower'; // Optional

// Get the preference list (most specific → most generic)
final categoryPrefs = AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: animalTypeId,
  productionStage: productionStage,
);
// Result: ['pig_grower', 'pig_starter', 'pig_finisher', 'pig']

// Check max_inclusion_json in order
double? maxInclusionPct;
if (ingredient.maxInclusionJson != null) {
  for (final key in categoryPrefs) {
    final val = ingredient.maxInclusionJson![key];
    if (val is num) {
      maxInclusionPct = val.toDouble();
      break; // Found a match, use it
    }
  }
}

// Fallback to legacy field if no JSON-based limit found
maxInclusionPct ??= ingredient.maxInclusionPct?.toDouble();

// Use maxInclusionPct for validation
if (maxInclusionPct != null && inclusionPercent > maxInclusionPct) {
  print('ERROR: Exceeds limit of ${maxInclusionPct}%');
}
```

---

### Pattern 2: Display human-readable category name to user

```dart
final categoryKey = 'pig_grower';
final humanName = AnimalCategoryMapper.getCategoryName(categoryKey);
// Result: 'Pig - Grower (25-50 kg)'

// For UI label
Text('Inclusion limit for: $humanName')
```

---

### Pattern 3: Get all categories for a specific animal type

```dart
// Pig (animalTypeId = 1)
final pigCategories = AnimalCategory.allPigCategories;
// Result: ['pig_nursery', 'pig_starter', 'pig_grower', 'pig_finisher', 'pig_gestating', 'pig_lactating', 'pig_sow', 'pig']

// Poultry (animalTypeId = 2)
final poultryCategories = AnimalCategory.allPoultryCategories;
// Result: ['poultry_broiler_starter', ..., 'poultry']
```

---

### Pattern 4: Handle missing or unknown category gracefully

```dart
double? getInclusionLimit(Ingredient ing, String categoryKey) {
  // Try exact match first
  if (ing.maxInclusionJson?.containsKey(categoryKey) == true) {
    final val = ing.maxInclusionJson![categoryKey];
    if (val is num) return val.toDouble();
  }

  // Try fallback keys (order: most specific → generic)
  for (final key in ['default', 'all', 'any']) {
    if (ing.maxInclusionJson?.containsKey(key) == true) {
      final val = ing.maxInclusionJson![key];
      if (val is num) return val.toDouble();
    }
  }

  // Fall back to legacy field
  return ing.maxInclusionPct?.toDouble();
}
```

---

## Constants & Keys

### Animal Type IDs

| ID | Constant | Keys |
|----|----------|------|
| 1 | `AnimalTypeId.pig` | `pig_nursery`, `pig_starter`, `pig_grower`, ... |
| 2 | `AnimalTypeId.poultry` | `poultry_broiler_starter`, `poultry_layer`, ... |
| 3 | `AnimalTypeId.rabbit` | `rabbit_grower`, `rabbit_breeder`, `rabbit` |
| 4 | `AnimalTypeId.ruminant` | `ruminant_dairy`, `ruminant_beef`, ... |
| 5 | `AnimalTypeId.fish` | `fish_freshwater`, `fish_marine`, `fish_salmonids`, ... |

### Category Lists by Animal Type

```dart
// Pig
AnimalCategory.pig_nursery
AnimalCategory.pig_starter
AnimalCategory.pig_grower
AnimalCategory.pig_finisher
AnimalCategory.pig_gestating
AnimalCategory.pig_lactating
AnimalCategory.pig_sow
AnimalCategory.pig

// Poultry
AnimalCategory.poultry_broiler_starter
AnimalCategory.poultry_broiler_grower
AnimalCategory.poultry_broiler_finisher
AnimalCategory.broiler
AnimalCategory.poultry_layer
AnimalCategory.poultry_breeder
AnimalCategory.poultry

// Ruminant
AnimalCategory.ruminant_dairy
AnimalCategory.ruminant_beef
AnimalCategory.ruminant_sheep
AnimalCategory.ruminant_goat
AnimalCategory.ruminant

// Rabbit
AnimalCategory.rabbit_grower
AnimalCategory.rabbit_breeder
AnimalCategory.rabbit

// Fish
AnimalCategory.fish_freshwater
AnimalCategory.fish_marine
AnimalCategory.fish_salmonids
AnimalCategory.fish_tilapia
AnimalCategory.fish_catfish
AnimalCategory.fish
AnimalCategory.aquaculture
```

---

## Data Format Examples

### Ingredient with per-category limits

```json
{
  "ingredient_id": 42,
  "name": "Fish meal, 62% protein",
  "max_inclusion_pct": 10,
  "max_inclusion_json": {
    "pig_nursery": 3,
    "pig_starter": 5,
    "pig_grower": 8,
    "pig_finisher": 10,
    "poultry_broiler_starter": 5,
    "poultry_broiler_grower": 8,
    "poultry_broiler_finisher": 10,
    "ruminant_dairy": 5,
    "fish_salmonids": 15,
    "default": 10
  }
}
```

### Usage in validation

```dart
// User creating pig grower feed
final ingredient = ingredientCache[42];
final animalTypeId = 1; // Pig

// Lookup flow:
// 1. Get preference list: ['pig_grower', 'pig_starter', 'pig_finisher', 'pig']
// 2. Check max_inclusion_json['pig_grower'] → 8.0 ✓ Found!
// 3. Use 8% as the limit

final prefs = AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: 1,
  productionStage: 'grower',
);
// ['pig_grower', 'pig_starter', 'pig_finisher', 'pig']

// Check max_inclusion_json in order
for (final key in prefs) {
  if (ingredient.maxInclusionJson?.containsKey(key) == true) {
    final limit = ingredient.maxInclusionJson![key];
    if (limit is num) {
      print('Found limit: ${limit}% for category: $key');
      // Result: "Found limit: 8.0% for category: pig_grower"
      break;
    }
  }
}
```

---

## Migration from Old Code

### Before (v8 - hardcoded switch)

```dart
double? getMaxInclusion(Ingredient ing, num animalTypeId) {
  switch (animalTypeId) {
    case 1: // Pig
      return ing.maxInclusionPct ?? 8.0;
    case 2: // Poultry
      return ing.maxInclusionPct ?? 10.0;
    // ... more cases ...
    default:
      return null;
  }
}
```

### After (v9 - mapper + JSON)

```dart
double? getMaxInclusion(Ingredient ing, num animalTypeId, {String? stage}) {
  if (ing.maxInclusionJson?.isNotEmpty == true) {
    // Try category-specific limits
    final prefs = AnimalCategoryMapper.getCategoryPreferences(
      animalTypeId: animalTypeId,
      productionStage: stage,
    );
    for (final key in prefs) {
      final val = ing.maxInclusionJson![key];
      if (val is num) return val.toDouble();
    }
  }
  // Fallback
  return ing.maxInclusionPct?.toDouble();
}
```

---

## Methods Cheat Sheet

### Get Category Preference List

```dart
List<String> prefs = AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: 1,
  productionStage: 'grower', // Optional
);
```

**Returns:** Ordered list from most specific to most generic (e.g., `['pig_grower', 'pig_starter', ..., 'pig']`)

---

### Get Human-Readable Animal Type Name

```dart
String name = AnimalCategoryMapper.getAnimalTypeName(1);
// Result: 'Swine (Pig)'
```

---

### Get Human-Readable Category Name

```dart
String name = AnimalCategoryMapper.getCategoryName('pig_grower');
// Result: 'Pig - Grower (25-50 kg)'
```

---

## Common Mistakes to Avoid

❌ **Don't:** Hardcode category keys in validators
```dart
// BAD
if (ing.maxInclusionJson?['pig_grower'] != null) { ... }
if (ing.maxInclusionJson?['poultry'] != null) { ... }
// → Maintenance nightmare if categories change
```

✅ **Do:** Use AnimalCategoryMapper
```dart
// GOOD
final prefs = AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: animalTypeId,
  productionStage: stage,
);
for (final key in prefs) {
  if (ing.maxInclusionJson?.containsKey(key) == true) { ... }
}
```

---

❌ **Don't:** Ignore backward compatibility
```dart
// BAD
double limit = ing.maxInclusionJson!['pig_grower']!.toDouble();
// → Crashes on old ingredients without max_inclusion_json
```

✅ **Do:** Fallback to legacy field
```dart
// GOOD
double? limit = ing.maxInclusionJson?['pig_grower']?.toDouble() 
  ?? ing.maxInclusionPct?.toDouble();
```

---

❌ **Don't:** Use arbitrary stage names
```dart
// BAD
AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: 1,
  productionStage: 'big pig', // Not standardized!
);
```

✅ **Do:** Use standard stage names
```dart
// GOOD
AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: 1,
  productionStage: 'grower', // Matches category keys
);
```

---

## Where to Use This in the App

| Component | Usage | Reference |
|-----------|-------|-----------|
| **InclusionValidator** | Map animalTypeId → category preference list | `lib/src/features/add_update_feed/services/inclusion_validator.dart` |
| **FeedProvider** | Get limit for current formulation | `lib/src/features/add_update_feed/providers/feed_provider.dart` |
| **ReportPage** | Display per-category limits in analysis | `lib/src/features/reports/view/report.dart` |
| **AnimalTypeSelector** | Show category options to user | Future UI (P4+) |
| **InclusionLimitValidator** | Pre-check limits before save | `lib/src/features/reports/model/inclusion_limit_validator.dart` |

---

## Testing Examples

```dart
// Test category preference list for pig grower
test('pig_grower returns correct preference list', () {
  final prefs = AnimalCategoryMapper.getCategoryPreferences(
    animalTypeId: 1,
    productionStage: 'grower',
  );
  expect(prefs.first, 'pig_grower');
  expect(prefs.contains('pig'), true);
});

// Test fallback to generic category
test('fallback to generic pig category if specific not found', () {
  final ingredient = Ingredient(
    maxInclusionJson: {'pig': 5.0}, // Only generic limit
  );
  final limit = getMaxInclusionForAnimal(ingredient, 1, 'grower');
  expect(limit, 5.0); // Falls back to generic
});

// Test backward compatibility
test('legacy maxInclusionPct still works', () {
  final ingredient = Ingredient(
    maxInclusionJson: null, // No JSON limits
    maxInclusionPct: 8.0, // Only legacy field
  );
  final limit = getMaxInclusionForAnimal(ingredient, 1);
  expect(limit, 8.0); // Uses legacy field
});
```

---

## Debugging Tips

**Q: Why isn't my category key matching?**  
A: Check the exact key spelling. Use `AnimalCategory.{categoryName}` constants instead of string literals.

**Q: How do I see all available categories?**  
A: Use `AnimalCategory.allPigCategories`, `AnimalCategory.allPoultryCategories`, etc.

**Q: What if productionStage doesn't match any category?**  
A: `getCategoryPreferences()` still returns a full fallback list (generic categories). It never returns empty.

**Q: Can I add a new animal type?**  
A: Yes! Add to `AnimalTypeId`, create new category constants, and add preference logic in `getCategoryPreferences()`. Update `_migrationV8ToV9()` if new category needs indexed lookup.

---

## Links

- **Main documentation:** [doc/ANIMAL_CATEGORIES_P2.md](ANIMAL_CATEGORIES_P2.md)
- **Full Phase 2 report:** [doc/PHASE_2_COMPLETION_SUMMARY.md](PHASE_2_COMPLETION_SUMMARY.md)
- **Source file:** `lib/src/core/constants/animal_categories.dart`
- **Validator integration:** `lib/src/features/add_update_feed/services/inclusion_validator.dart`
