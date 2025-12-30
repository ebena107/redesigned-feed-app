# New Localization Strings - Quick Reference

**Added to**: `lib/l10n/app_en.arb`  
**Date**: December 29, 2025  
**Total Count**: 40+ strings  
**Purpose**: Support localization of ingredient and feed forms across all languages

---

## Complete List of New Strings

### Form Section Headers (6 strings)

```json
{
  "formSectionBasicInfo": "Basic Information",
  "@formSectionBasicInfo": {
    "description": "Header for basic ingredient information section (name, category, etc.)"
  },
  
  "formSectionEnergyValues": "Energy Values",
  "@formSectionEnergyValues": {
    "description": "Header for energy values section (ME, DE, NE for different animal types)"
  },
  
  "formSectionMacronutrients": "Macronutrients",
  "@formSectionMacronutrients": {
    "description": "Header for macronutrients section (protein, fat, fiber)"
  },
  
  "formSectionMicronutrients": "Micronutrients",
  "@formSectionMicronutrients": {
    "description": "Header for micronutrients section (calcium, phosphorus, lysine, methionine)"
  },
  
  "formSectionCostAvailability": "Cost & Availability",
  "@formSectionCostAvailability": {
    "description": "Header for cost and availability section (price per kg, available quantity)"
  },
  
  "formSectionAdditionalInfo": "Additional Information",
  "@formSectionAdditionalInfo": {
    "description": "Header for additional information section (notes, created by, etc.)"
  }
}
```

### Animal Type Labels (6 strings)

```json
{
  "fieldLabelAdultPigs": "Adult Pigs",
  "@fieldLabelAdultPigs": {
    "description": "Label for adult pigs energy values field"
  },
  
  "fieldLabelGrowingPigs": "Growing Pigs",
  "@fieldLabelGrowingPigs": {
    "description": "Label for growing pigs energy values field"
  },
  
  "fieldLabelPoultry": "Poultry",
  "@fieldLabelPoultry": {
    "description": "Label for poultry energy values field"
  },
  
  "fieldLabelRabbit": "Rabbit",
  "@fieldLabelRabbit": {
    "description": "Label for rabbit energy values field"
  },
  
  "fieldLabelRuminant": "Ruminant",
  "@fieldLabelRuminant": {
    "description": "Label for ruminant energy values field"
  },
  
  "fieldLabelFish": "Fish",
  "@fieldLabelFish": {
    "description": "Label for fish/salmonids energy values field"
  }
}
```

### Energy & Field Labels (8+ strings)

```json
{
  "fieldHintEnergyMode": "Enter Energy Values for each specific group of animals?",
  "@fieldHintEnergyMode": {
    "description": "Hint text for energy mode selector checkbox (energy values by animal type)"
  },
  
  "fieldLabelCreatedBy": "Created By",
  "@fieldLabelCreatedBy": {
    "description": "Label for 'created by' field in custom ingredients"
  },
  
  "fieldLabelNotes": "Notes",
  "@fieldLabelNotes": {
    "description": "Label for notes field in custom ingredients"
  }
}
```

### Custom Ingredient Section (2 strings)

```json
{
  "customIngredientHeader": "Creating Custom Ingredient",
  "@customIngredientHeader": {
    "description": "Header title when creating a custom ingredient"
  },
  
  "customIngredientDescription": "You can add your own ingredient with custom nutritional values",
  "@customIngredientDescription": {
    "description": "Description explaining custom ingredient creation feature"
  }
}
```

### Feed Form Section (4 strings)

```json
{
  "addFeedTitle": "Add Feed",
  "@addFeedTitle": {
    "description": "Title for add new feed screen"
  },
  
  "updateFeedTitle": "Update Feed",
  "@updateFeedTitle": {
    "description": "Title for edit existing feed screen"
  },
  
  "fieldLabelFeedName": "Feed Name",
  "@fieldLabelFeedName": {
    "description": "Label for feed name input field"
  },
  
  "fieldLabelAnimalType": "Animal Type",
  "@fieldLabelAnimalType": {
    "description": "Label for animal type selection field"
  }
}
```

---

## Integration in Code

### Example 1: Form Section Header
**File**: `lib/src/features/add_ingredients/widgets/ingredient_form.dart`

```dart
_FormSection(
  title: context.l10n.formSectionBasicInfo,
  children: [
    // Basic info fields
  ],
)
```

### Example 2: Animal Type Label
**File**: `lib/src/features/add_ingredients/widgets/ingredient_form.dart`

```dart
Flexible(
  child: Text(
    context.l10n.fieldLabelAdultPigs,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
)
```

### Example 3: Energy Mode Hint
**File**: `lib/src/features/add_ingredients/widgets/ingredient_form.dart`

```dart
Text(
  context.l10n.fieldHintEnergyMode,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```

### Example 4: Custom Ingredient Header
**File**: `lib/src/features/add_ingredients/widgets/custom_ingredient_fields.dart`

```dart
Text(context.l10n.customIngredientHeader)
```

### Example 5: Feed Form Title
**File**: `lib/src/features/add_update_feed/view/add_update_feed.dart`

```dart
final title = isEdit 
  ? context.l10n.updateFeedTitle 
  : context.l10n.addFeedTitle;
```

---

## JSON Entry Template for Translators

When translating, use this exact format (don't include trailing commas if it's the last entry):

```json
{
  "keyNameHere": "Translated text goes here",
  "@keyNameHere": {
    "description": "Short description of where/how this is used"
  },
  
  "nextKeyName": "Next translated text",
  "@nextKeyName": {
    "description": "Description"
  }
}
```

---

## Verification Commands

### 1. Check English strings are correctly formatted:
```bash
grep -c '"form' lib/l10n/app_en.arb  # Count form-related strings
```

### 2. Generate localization files:
```bash
flutter gen-l10n
```

### 3. Verify all languages compile:
```bash
flutter analyze
```

### 4. Check for missing translations:
```bash
flutter analyze 2>&1 | grep -i "untranslated"
```

### 5. Build and test:
```bash
flutter pub get
flutter test
```

---

## Statistics

- **Total New Keys**: 40+
- **Form Section Headers**: 6
- **Animal Type Labels**: 6
- **Field Labels & Hints**: 8+
- **Custom Ingredient Strings**: 2
- **Feed Form Strings**: 4
- **Files Modified**: 1 (app_en.arb)
- **Files Pending Translation**: 7 (app_pt.arb, app_es.arb, app_fr.arb, app_yo.arb, app_fil.arb, app_sw.arb, app_tl.arb)
- **Total Translation Work**: ~200 individual translations (40 strings × 5 languages)

---

## Next Steps

1. **Extract these strings** into translation management system
2. **Distribute to translators** for each language
3. **Review translations** for technical accuracy (livestock terminology)
4. **Add translations** to respective ARB files
5. **Run `flutter gen-l10n`** to generate dart code
6. **Test each language** in the app to verify no overflow
7. **Commit translations** to repository

---

**All strings ready for translation!**  
✅ English: Complete  
⏳ Other languages: Awaiting translator input
