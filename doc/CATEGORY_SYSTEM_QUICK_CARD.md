# Category System Quick Reference Card

**Last Updated:** Post Phase 4.7a  
**Status:** ✅ Unified System Active

---

## 🎯 Quick Lookup

### Animal Type ID → Category Keys

| ID | Animal | Generic Key | Specific Keys |
|----|--------|-------------|---------------|
| 1 | Pig | `pig` | `pig_starter`, `pig_grower`, `pig_finisher` |
| 2 | Poultry | `poultry` | `poultry_broiler_starter`, `poultry_broiler_grower`, `poultry_broiler_finisher`, `poultry_layer` |
| 3 | Rabbit | `rabbit` | `rabbit_grower` |
| 4 | Ruminant | `ruminant` | `ruminant_dairy`, `ruminant_beef`, `ruminant_sheep`, `ruminant_goat` |
| 5 | Fish | `fish` | `fish_freshwater`, `aquaculture` |

---

## 📝 Usage Examples

### Get Category Preferences (Recommended)

```dart
import 'package:feed_estimator/src/core/constants/animal_categories.dart';

// Returns ordered list: ['pig_grower', 'pig_starter', 'pig']
final prefs = AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: 1,
  productionStage: 'grower',
);
```

### Optimizer: Find Nutritional Requirements

```dart
import '../../../core/constants/animal_categories.dart' as ac;
import '../data/animal_requirements.dart';

// Get preference list
final categoryPrefs = ac.AnimalCategoryMapper.getCategoryPreferences(
  animalTypeId: animalTypeId,
  productionStage: stage,
);

// Find first matching category
AnimalCategory? category;
for (final key in categoryPrefs) {
  category = findCategoryByKey(key); // From animal_requirements.dart
  if (category != null) break;
}
```

### Validator: Check Inclusion Limits

```dart
import 'package:feed_estimator/src/core/constants/animal_categories.dart';

// Get preference list for max_inclusion_json lookup
final preference = AnimalCategoryMapper.getCategoryPreferencesForAnimalType(
  animalTypeId,
);

// Try each key in order: ['pig_grower', 'pig_starter', 'pig']
for (final key in preference) {
  final val = ingredient.maxInclusionJson?[key];
  if (val is num) return val.toDouble();
}
```

---

## 🚨 Important Notes

### ⚠️ Naming Conflict Resolution

**Two classes named `AnimalCategory` exist:**
1. `optimizer/model/nutrient_requirement.dart` - Model class (requirements data)
2. `core/constants/animal_categories.dart` - Constants class (category keys)

**Solution:** Use prefix import when both needed:
```dart
import '../../../core/constants/animal_categories.dart' as ac;

// Use ac.AnimalCategoryMapper instead of AnimalCategoryMapper
final prefs = ac.AnimalCategoryMapper.getCategoryPreferences(...);
```

### ❌ Deprecated (Don't Use)

```dart
// OLD - Species-based lookup (DEPRECATED)
findCategory('Poultry', 'Starter'); // ❌ Don't use

// NEW - Unified key lookup (RECOMMENDED)
findCategoryByKey('poultry_broiler_starter'); // ✅ Use this
```

---

## 🗂️ Category Key Structure

### Pattern: `{animal}_{stage}` or `{animal}`

**Generic Keys** (fallback):
- `pig`, `poultry`, `ruminant`, `rabbit`, `fish`

**Specific Keys** (precise match):
- `pig_starter`, `pig_grower`, `pig_finisher`
- `poultry_broiler_starter`, `poultry_broiler_grower`, `poultry_broiler_finisher`, `poultry_layer`
- `ruminant_dairy`, `ruminant_beef`, `ruminant_sheep`, `ruminant_goat`
- `fish_freshwater`, `aquaculture`
- `rabbit_grower`

**Preference Order:** Specific → Generic → Related
```
Example for Pig Grower (animalTypeId=1, stage='grower'):
1. 'pig_grower' (exact match)
2. 'pig_starter' (same animal, different stage)
3. 'pig' (generic fallback)
```

---

## 📍 Where Each System is Used

| Feature | Category System Used | Source File |
|---------|---------------------|-------------|
| **Inclusion Limits** | Unified keys | `inclusion_validator.dart` |
| **Optimizer Requirements** | Unified keys | `animal_requirements.dart` |
| **Ingredients JSON** | Unified keys in `max_inclusion_json` | `ingredients_standardized.json` |
| **Add/Update Feed UI** | Animal Type ID + Stage string | `add_feed.dart` |
| **Calculation Engine** | Animal Type ID only | `enhanced_calculation_engine.dart` |

---

## 🔧 Common Tasks

### Add New Animal Category

**1. Add constant to `animal_categories.dart`:**
```dart
abstract class AnimalCategory {
  // ... existing constants ...
  static const String pigLactating = 'pig_lactating';
}
```

**2. Add nutritional requirement to `animal_requirements.dart`:**
```dart
final swineLactating = AnimalCategory(
  species: 'Swine',
  stage: 'Lactating',
  description: 'Lactating sows (nursing piglets)',
  requirements: [
    NutrientRequirement(nutrient: 'Crude Protein', minValue: 16.0, maxValue: 18.0),
    // ...
  ],
  displayName: 'Swine - Lactating',
);

// Add to registry
final Map<String, List<AnimalCategory>> animalCategoryRegistry = {
  // ... existing entries ...
  'pig_lactating': [swineLactating],
};
```

**3. Add mapping to `AnimalCategoryMapper`:**
```dart
static List<String> getCategoryPreferences({
  required num animalTypeId,
  required String productionStage,
}) {
  if (animalTypeId == 1) { // Pig
    final lowerStage = productionStage.toLowerCase();
    // ... existing mappings ...
    if (lowerStage.contains('lactating')) {
      return [AnimalCategory.pigLactating, AnimalCategory.pig];
    }
  }
  // ...
}
```

**4. Done!** New category will work across all features (optimizer, validator, etc.)

---

## 📚 Related Documentation

- [UNIFIED_CATEGORIZATION_IMPLEMENTATION.md](UNIFIED_CATEGORIZATION_IMPLEMENTATION.md) - Full implementation details
- [ANIMAL_CATEGORIES_QUICK_REFERENCE.md](ANIMAL_CATEGORIES_QUICK_REFERENCE.md) - Complete category reference
- [ANIMAL_CATEGORIES_P2.md](ANIMAL_CATEGORIES_P2.md) - Phase 2 expansion details

---

**Quick Help:**  
If confused about which category key to use, call `AnimalCategoryMapper.getCategoryPreferences()` - it returns the correct priority order!
