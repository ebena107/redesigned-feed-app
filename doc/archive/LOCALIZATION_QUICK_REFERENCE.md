<!-- markdownlint-disable MD022 -->
# Localization Quick Reference

## Using Localized Strings in Your Code

### 1. In Widgets (With BuildContext) - PREFERRED

```dart
import 'package:feed_estimator/src/core/localization/localization_helper.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Simple strings
        Text(context.l10n.appTitle),
        
        // Parameterized strings
        Text(context.l10n.errorRequired('Name')),
        
        // In buttons
        ElevatedButton(
          onPressed: _save,
          child: Text(context.l10n.actionSave),
        ),
        
        // In dialogs
        AlertDialog(
          title: Text(context.l10n.confirmDelete('this ingredient')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.actionCancel),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 2. In Services/Providers (No BuildContext)

```dart
import 'package:feed_estimator/src/core/localization/localization_helper.dart';

class MyRepository {
  String getErrorMessage() {
    // Use LocalizationHelper for fallback
    return LocalizationHelper.currentL10n?.messageLoading ?? 'Loading...';
  }
}
```

### 3. In Provider/Riverpod Code

```dart
import 'package:feed_estimator/src/core/localization/localization_provider.dart';

final myProvider = Provider<String>((ref) {
  final locale = ref.watch(localizationProvider);
  // Use locale for locale-specific logic
  if (locale == AppLocale.yo) {
    return 'Ẹyọ Ajé Rárá';
  }
  return 'Feed Estimator';
});
```

## Adding New Localized Strings

### Step 1: Add to app_en.arb (English - Base Language)

```json
{
  "myNewString": "My new string",
  "myParameterizedString": "Hello {name}",
  "@myParameterizedString": {
    "description": "A greeting with a name parameter",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "John"
      }
    }
  }
}
```

### Step 2: Add to All Other ARB Files (pt, es, yo, fr)

Portuguese (app_pt.arb):
```json
{
  "myNewString": "Minha nova string",
  "myParameterizedString": "Olá {name}",
  "@myParameterizedString": {
    "description": "Uma saudação com parâmetro de nome",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "João"
      }
    }
  }
}
```

Spanish (app_es.arb):
```json
{
  "myNewString": "Mi nueva cadena",
  "myParameterizedString": "Hola {name}",
  "@myParameterizedString": {
    "description": "Un saludo con parámetro de nombre",
    "placeholders": {
      "name": {
        "type": "String",
        "example": "Juan"
      }
    }
  }
}
```

### Step 3: Regenerate Localization Files

```bash
flutter gen-l10n
```

### Step 4: Use in Code

```dart
// Simple string
Text(context.l10n.myNewString)

// Parameterized string
Text(context.l10n.myParameterizedString('John'))
```

## Available Localized Strings

### Navigation
- `navHome` - "Inicio" (es), "Início" (pt), "Accueil" (fr), "Ìbẹ̀rẹ̀" (yo)
- `navFeeds` - My feeds/formulations
- `navIngredients` - Ingredients library
- `navSettings` - Settings
- `navAbout` - About app

### Actions
- `actionCreate`, `actionSave`, `actionUpdate`, `actionDelete`
- `actionCancel`, `actionAdd`, `actionClose`
- `actionExport`, `actionImport`

### Labels
- `labelName`, `labelPrice`, `labelQuantity`
- `labelCategory`, `labelRegion`
- `labelProtein`, `labelFat`, `labelFiber`
- `labelCalcium`, `labelPhosphorus`, `labelEnergy`
- `labelCost`, `labelTotal`

### Validation Errors
- `errorRequired(field)` - Field is required
- `errorInvalidPrice`, `errorInvalidQuantity`
- `errorPriceNegative`, `errorQuantityZero`
- `errorNameTooShort`, `errorNameTooLong`
- `errorUnique(field)` - Item already exists

### Success Messages
- `messageCreatedSuccessfully(item)` - Item created
- `messageUpdatedSuccessfully(item)` - Item updated
- `messageDeletedSuccessfully(item)` - Item deleted

### Status Messages
- `messageLoading` - Loading...
- `messageNoData` - No data available
- `messageEmpty(item)` - No items added yet

### Animal Types
- `animalTypePig`, `animalTypePoultry`, `animalTypeRabbit`
- `animalTypeRuminant`, `animalTypeFish`

### Regions
- `regionAll`, `regionAfrica`, `regionAsia`
- `regionEurope`, `regionAmericas`, `regionOceania`, `regionGlobal`

### Units
- `unitKg`, `unitG`, `unitLb`, `unitTon`
- `unitKcal` - kcal/kg

## Changing App Language

### Programmatically (In Code)

```dart
import 'package:feed_estimator/src/core/localization/localization_provider.dart';

// In a widget with Riverpod
ref.read(localizationProvider.notifier).setLocale(AppLocale.pt);
```

### Via Settings Screen

User opens Settings → Language dropdown → Selects new language

Language change is:
- ✅ Immediate (hot reload)
- ✅ Persistent (saved to SharedPreferences)
- ✅ Applied globally to all screens

## Supported Languages

| Language | Code | Locale | Display Name |
|----------|------|--------|--------------|
| English | en | en_US | English |
| Portuguese | pt | pt_PT | Português |
| Spanish | es | es_ES | Español |
| Yoruba | yo | yo_NG | Yorùbá |
| French | fr | fr_FR | Français |

## Testing Localization

### Unit Tests

```dart
test('localization returns correct string for each language', () {
  // Create instances of each localization
  final enL10n = AppLocalizationsEn();
  expect(enL10n.appTitle, 'Feed Estimator');
  
  final ptL10n = AppLocalizationsPt();
  expect(ptL10n.appTitle, 'Estimador de Ração');
});
```

### Widget Tests

```dart
testWidgets('language selector changes app language', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: const FeedApp(),
    ),
  );
  
  // Tap on Settings
  // Tap on Language Dropdown
  // Select Portuguese
  // Verify app title changed to Portuguese
});
```

### Manual Testing

1. Launch app → Verify English (default)
2. Settings → Language → Português → Verify all text in Portuguese
3. Settings → Language → Español → Verify all text in Spanish
4. Settings → Language → Yorùbá → Verify special characters display
5. Settings → Language → Français → Verify accented characters
6. Restart app → Verify language persists

## String Key Naming Conventions

Follow these patterns for consistency:

### Action Keys
- `action<Action>` - e.g., `actionSave`, `actionDelete`, `actionCreate`

### Label Keys
- `label<Field>` - e.g., `labelPrice`, `labelQuantity`, `labelRegion`

### Error Keys
- `error<Type>` - e.g., `errorRequired`, `errorInvalidPrice`, `errorNameTooShort`

### Message Keys
- `message<Status>` - e.g., `messageLoading`, `messageEmpty`, `messageCreatedSuccessfully`

### Screen Title Keys
- `screenTitle<ScreenName>` - e.g., `screenTitleHome`, `screenTitleIngredientLibrary`

### Navigation Keys
- `nav<Screen>` - e.g., `navHome`, `navFeeds`, `navIngredients`

### Type Keys
- `<type>Type<TypeName>` - e.g., `animalTypePig`, `regionAfrica`

## Troubleshooting

### Issue: "No AppLocalizations found"
**Solution**: Make sure you're in a BuildContext that has MaterialApp.router as ancestor
```dart
// ✅ Good
@override
Widget build(BuildContext context) {
  return Text(context.l10n.appTitle);  // context is available
}

// ❌ Bad
String title = context.l10n.appTitle;  // context may not be MaterialApp child
```

### Issue: Strings don't update when language changes
**Solution**: Make sure widget is wrapped in Consumer/ConsumerWidget to rebuild
```dart
// ✅ Good - Rebuilds when locale changes
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches localization changes and rebuilds
    return Text(context.l10n.appTitle);
  }
}

// ⚠️ May not update - Only rebuilds if explicitly watching
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.appTitle);  // Rebuilds with parent
  }
}
```

### Issue: Missing translations in some languages
**Solution**: Check all ARB files have same keys
```bash
# Compare keys across ARB files
grep -o '"[^"]*":' lib/l10n/app_en.arb | sort | uniq > en_keys.txt
grep -o '"[^"]*":' lib/l10n/app_pt.arb | sort | uniq > pt_keys.txt
diff en_keys.txt pt_keys.txt  # Should be empty
```

---

**For more information**, see:
- [Localization Implementation](PHASE_4_7a_LOCALIZATION_IMPLEMENTATION.md)
- [Flutter i18n Documentation](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization)
