# Copilot Instructions - Feed Estimator App

## Project Overview

Flutter livestock feed formulation app for analyzing nutrients in animal feed. Primary users: livestock farmers across Nigeria (largest), India, United States, Kenya, and globally (Europe, Asia, Africa). Current version: 1.0.1+11, actively modernized through phased improvements (Phases 1-3 complete, Phase 4 75% complete, see [doc/MODERNIZATION_PLAN.md](../doc/MODERNIZATION_PLAN.md)).

## Recent Modernization Notes

**CRITICAL - Feed Formulation Core**:
- **EnhancedCalculationEngine** ([lib/src/features/reports/providers/enhanced_calculation_engine.dart](../lib/src/features/reports/providers/enhanced_calculation_engine.dart)): PRIMARY calculation engine for all nutrient analysis. Supports 10 essential amino acids (total + SID), phosphorus breakdown (total/available/phytate), proximate analysis. Always the entry point for feed calculations.
- **InclusionValidator** ([lib/src/features/add_update_feed/services/inclusion_validator.dart](../lib/src/features/add_update_feed/services/inclusion_validator.dart)): MANDATORY validation before saving feeds. Checks inclusion limits per animal type and detects anti-nutritional factor violations. Always call this before `saveUpdateFeed()`.

**Performance & Infrastructure**:
- **DatabaseTimeout utility**: Centralized 30s timeout wrappers in `lib/src/core/database/database_timeout.dart`. Use instead of inline `Future.timeout()`.
- **PaginationHelper**: For ingredient lists >100 items, use `PaginationHelper` (pageSize=50) from `lib/src/core/utils/pagination_helper.dart` to avoid memory bloat.
- **List virtualization**: Ingredient lists use `ListView.builder` with `itemExtent` (~48), no nested `SingleChildScrollView` - maintains 60fps scroll.

**Secondary Features**:
- **Price Management** (Phase 4.5): Optional dynamic pricing via `PriceHistoryRepository`. Pass `currentPrices` to engine when available, but calculation works without it using stored prices.
- **Feed Optimizer** (Phase 5 - IN DEVELOPMENT): AI-powered feed formulation optimizer in `lib/src/features/optimizer/`. Uses linear programming (simplex algorithm) to auto-generate optimal formulations based on cost, nutrition constraints, and ingredient availability. See [doc/FEED_OPTIMIZER_QUICK_REFERENCE.md](../doc/FEED_OPTIMIZER_QUICK_REFERENCE.md) for architecture.
- **Import/Export** (Phase 5.1 - COMPLETE): Full CSV/JSON import/export for ingredients and feeds in `lib/src/features/import_export/`. Supports bulk ingredient import with price history tracking.
- **Type-Safe Navigation**: Use `@TypedGoRoute` with `.go(context)` pattern (never `Navigator.push()` or `pushNamed()`).
- **Localization (i18n)**: Always use `context.l10n.keyName` for UI strings (5 languages supported).
- **Feature Flags**: Use `FeatureFlags` class (`lib/src/core/constants/feature_flags.dart`) for gradual rollout control. Check flag status with `FeatureFlags.logStatus()` on app startup.
- **Instructions source**: Keep this file in sync when adding cross-cutting patterns so new contributors see updated guidance.

## Architecture Essentials

### Feature-First Structure
```
lib/src/
├── features/          # Business domains (add_ingredients, main, reports, etc.)
│   └── [feature]/
│       ├── model/     # Data classes (JSON serialization, NOT sealed/NOT freezed)
│       ├── provider/  # Riverpod state (Notifier/AsyncNotifier)
│       ├── repository/# Data access (extends core/repositories/Repository)
│       ├── service/   # Business logic services (e.g., optimizer, validators)
│       ├── view/      # Screens
│       └── widget/    # Feature widgets
├── core/
│   ├── value_objects/ # Domain primitives (Weight, Price, Quantity) using Equatable
│   ├── exceptions/    # Custom hierarchy (AppException → 7 specific types)
│   ├── database/      # SQLite (sqflite/sqflite_common_ffi with migrations)
│   ├── constants/     # App-wide constants (ui_constants, feature_flags)
│   ├── localization/  # i18n providers and helpers
│   └── router/        # Type-safe go_router with @TypedGoRoute annotations
```

### State Management Pattern
**Riverpod 2.6.1 with Notifier (NOT StateNotifier)**:
```dart
// Provider pattern
final feedProvider = NotifierProvider<FeedNotifier, FeedState>(FeedNotifier.new);

// State using sealed classes (NOT @freezed)
sealed class FeedState {
  const FeedState({required fields...});
  FeedState copyWith({...}) { /* manual implementation */ }
}

// Notifier implementation - CRITICAL INITIALIZATION PATTERN
class FeedNotifier extends Notifier<FeedState> {
  @override
  FeedState build() {
    // 1. Initialize internal state variables
    _feedId = null;
    _totalQuantity = 0.0;
    
    // 2. Delay async operations until after first frame (CRITICAL!)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(); // Safe to mutate state now
    });
    
    // 3. Return initial state immediately
    return const _FeedState();
  }
}
```

**Key patterns**:
- All 6 major providers use sealed classes (manual `copyWith`, no freezed)
- **CRITICAL**: Async loading MUST use `WidgetsBinding.instance.addPostFrameCallback()` NOT `Future.microtask()` (prevents StateError crashes)
- Use `@riverpod` for async controllers (code gen with `riverpod_generator`)
- Access via `ref.read(provider.notifier).method()` and `ref.watch(provider)`

## Critical Workflows

### Common Pitfalls & Solutions

**❌ StateError: "Bad state: Tried to read the state of an uninitialized provider"**
- **Cause**: Calling `ref.read()` or mutating state in `build()` before initialization
- **Fix**: Use `WidgetsBinding.instance.addPostFrameCallback()` for all async loading
- **Bad**: `Future.microtask(() => ref.read(...))` - causes StateError
- **Good**: `WidgetsBinding.instance.addPostFrameCallback((_) => _loadData())` - waits for frame

**❌ Memory leaks in dialogs**
- **Cause**: Creating `TextEditingController` in Consumer widget without disposal
- **Fix**: Use `ConsumerStatefulWidget` with proper `dispose()` in dialog code
- **Example**: See [lib/src/features/add_update_feed/widget/feed_ingredients.dart](../lib/src/features/add_update_feed/widget/feed_ingredients.dart)

### Development Commands
```powershell
# Code generation (REQUIRED after changes to files with 'part' directives)
# Only affects: @riverpod providers, @TypedGoRoute routes, NOT model classes
dart run build_runner build --delete-conflicting-outputs

# Run app (prefer MCP tools: mcp_dart_sdk_mcp__launch_app when available)
flutter run -d windows  # or android/ios/macos

# Hot reload/restart (prefer MCP: mcp_dart_sdk_mcp__hot_reload)
# Press 'r' in terminal for hot reload
# Press 'R' in terminal for hot restart

# Build APK
flutter build apk --release

# Run tests (see test/ directory structure)
flutter test                    # All tests
flutter test test/unit/         # Unit tests only
flutter test --coverage         # With coverage report
```

**Code Generation Patterns**:
- Files with `part '*.g.dart'` directives require `build_runner` after changes
- Async providers using `@riverpod` annotation (see [lib/src/features/main/providers/main_async_provider.dart](../lib/src/features/main/providers/main_async_provider.dart))
- Type-safe routes using `@TypedGoRoute` (see [lib/src/core/router/routes.dart](../lib/src/core/router/routes.dart))
- Model classes with `fromJson`/`toJson` do NOT use code generation (manual implementation)

### Database Migrations
**Location**: `lib/src/core/database/app_db.dart`  
**Current version**: 12 (see `_currentVersion`)

When modifying schema:
1. Increment `_currentVersion` constant
2. Add migration in `_onUpgrade()` method
3. Test with existing DB (version upgrade path)
4. Document in `doc/DATABASE_MIGRATION_ANALYSIS.md`

Platform-specific initialization:
- Windows/Linux: `sqflite_common_ffi` with `getApplicationDocumentsDirectory()`
- Android/iOS/macOS: Standard `openDatabase()` with `getDatabasesPath()`

## Project-Specific Conventions

### Error Handling
**Always use custom exceptions** (never generic `Exception`):
```dart
throw RepositoryException(
  operation: 'create',
  message: 'Failed to create feed',
  originalError: e,
  stackTrace: stackTrace,
);
```

Available types: `RepositoryException`, `ValidationException`, `SyncException`, `DateTimeException`, `CalculationException`, `BusinessLogicException`, `StateException`

### Logging
**Use centralized logger** (not `print()` or `debugPrint()`):
```dart
import 'package:feed_estimator/src/core/utils/logger.dart';

AppLogger.info('Created feed with ID: $result', tag: 'FeedRepository');
AppLogger.error('Error: $e', tag: 'MyClass', error: e, stackTrace: stackTrace);
```

Auto-disabled in production builds. Replaces 20+ scattered `debugPrint()` calls.

### Value Objects
For domain primitives (weights, prices), use existing value objects:
```dart
// lib/src/core/value_objects/
final weight = Weight.validated(10.5, WeightUnit.kg);
final kg = weight.toKg();  // Automatic conversion

// Price with currency validation
final price = Price.validated(100.0, currency: 'NGN');
final discounted = price * 0.9;  // 10% discount
final total = price + price;     // Add prices (same currency only)
final formatted = price.format(); // ₦100.00
```

Includes validation, unit conversion (kg/g/lbs/oz/ton), and arithmetic operations.
Throws `ValidationException` for invalid operations (e.g., dividing by zero, adding different currencies).
See test examples: [test/unit/price_value_object_test.dart](../test/unit/price_value_object_test.dart)

### Dialog Management
**CRITICAL**: Use `context.pop()` (go_router) instead of `Navigator.pop()`:
```dart
// ✅ Correct - StatefulWidget dialog with lifecycle management
class _MyDialog extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends ConsumerState<_MyDialog> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose();  // CRITICAL: Always dispose controllers
    super.dispose();
  }
  
  void _handleAction() async {
    try {
      await ref.read(provider.notifier).action();
      if (mounted) context.pop();
    } catch (e) {
      AppLogger.error('Action failed', tag: 'MyDialog', error: e);
      if (mounted) _showErrorSnackBar(context, 'Failed. Try again.');
    }
  }
}

// ❌ Avoid - Consumer widget with controllers (memory leak)
Consumer(builder: (context, ref, _) {
  final controller = TextEditingController(); // Never disposed!
  return AlertDialog(...);
});
```

**Dialog Best Practices**:
- Use `StatefulWidget` for dialogs with `TextEditingController`
- Always dispose controllers in `dispose()`
- Show loading states during async operations
- Validate inputs before submission (see `_InputValidation` in `feed_ingredients.dart`)
- Use proper error handling with try-catch
- Check `mounted` before calling `context.pop()` after async operations

See `doc/DIALOG_STACK_AUDIT.md` and `lib/src/features/add_update_feed/widget/feed_ingredients.dart` for complete patterns.

## Centralized UI/UX Utilities

### Input Validation (`lib/src/core/utils/input_validators.dart`)
**ALWAYS use centralized validators** instead of inline validation logic:

```dart
import 'package:feed_estimator/src/core/utils/input_validators.dart';

// Validation methods
String? error = InputValidators.validatePrice(value);    // 0-1,000,000 range
String? error = InputValidators.validateQuantity(value); // >0-100,000 range
String? error = InputValidators.validateName(value);     // 3-50 characters
String? error = InputValidators.validateEmail(value);
String? error = InputValidators.validatePercentage(value);
String? error = InputValidators.validateNumeric(value, min: 0, max: 100);
String? error = InputValidators.validateRequired(value, 'Field name');

// Input formatters (normalize commas to periods)
TextField(
  inputFormatters: InputValidators.numericFormatters,
  // or nameFormatters, alphanumericFormatters
);
```

### UI Constants (`lib/src/core/constants/ui_constants.dart`)
**ALWAYS use UIConstants** for consistent styling:

```dart
import 'package:feed_estimator/src/core/constants/ui_constants.dart';

// Dimensions
height: UIConstants.fieldHeight,      // 48px
width: UIConstants.fieldWidth,        // 280px
minWidth: UIConstants.minTapTarget,   // 44px (Material minimum)

// Icon sizes
size: UIConstants.iconSmall,   // 16px
size: UIConstants.iconMedium,  // 20px
size: UIConstants.iconLarge,   // 24px
size: UIConstants.iconXLarge,  // 32px

// Padding (semantic aliases)
padding: UIConstants.paddingTiny,           // 4px all
padding: UIConstants.paddingSmall,          // 8px all
padding: UIConstants.paddingMedium,         // 12px all
padding: UIConstants.paddingNormal,         // 16px all
padding: UIConstants.paddingLarge,          // 24px all
padding: UIConstants.paddingHorizontalSmall,   // 8px horizontal
padding: UIConstants.paddingVerticalNormal,    // 16px vertical

// Borders
border: UIConstants.inputBorder(),           // Default border
border: UIConstants.focusedBorder(),         // Focus state
border: UIConstants.errorBorder,             // Error state
width: UIConstants.borderWidthThin,          // 1.0
width: UIConstants.borderWidthNormal,        // 1.5
width: UIConstants.borderWidthThick,         // 2.0

// Decorations
decoration: UIConstants.cardDecoration(),    // Standard card
decoration: UIConstants.readOnlyFieldDecoration(borderColor: color),

// Shadows
boxShadow: UIConstants.lightShadow,
boxShadow: UIConstants.mediumShadow,
boxShadow: UIConstants.heavyShadow,

// Animation durations
duration: UIConstants.animationFast,    // 150ms
duration: UIConstants.animationNormal,  // 300ms
duration: UIConstants.animationSlow,    // 500ms

// Opacity
opacity: UIConstants.overlayLight,      // 0.1
opacity: UIConstants.overlayMedium,     // 0.3
opacity: UIConstants.overlayHeavy,      // 0.5
```

### Widget Builders (`lib/src/core/utils/widget_builders.dart`)
**Use pre-built widget methods** for consistency:

```dart
import 'package:feed_estimator/src/core/utils/widget_builders.dart';

// Text fields
Widget field = WidgetBuilders.buildTextField(
  label: 'Feed Name',
  hint: 'e.g., Broiler Starter',
  controller: _controller,
  errorText: _errorText,
  inputFormatters: InputValidators.nameFormatters,
  onChanged: (val) => _validate(val),
);

// Read-only fields (edit mode)
Widget readOnly = WidgetBuilders.buildReadOnlyField(
  value: 'Existing Value',
  borderColor: AppConstants.appCarrotColor,
  icon: Icon(Icons.check),
);

// Buttons
Widget primary = WidgetBuilders.buildPrimaryButton(
  label: 'Save Feed',
  onPressed: _handleSave,
  isLoading: _isSaving,
  icon: Icon(Icons.save),
);

Widget outlined = WidgetBuilders.buildOutlinedButton(
  label: 'Cancel',
  onPressed: () => context.pop(),
);

// Cards
Widget card = WidgetBuilders.buildCard(
  child: Text('Content'),
  onTap: () => _handleTap(),
);

// States
Widget loading = WidgetBuilders.buildLoadingIndicator(message: 'Saving...');
Widget empty = WidgetBuilders.buildEmptyState(
  message: 'No ingredients added yet',
  action: buildPrimaryButton(label: 'Add', onPressed: _add),
);
Widget error = WidgetBuilders.buildErrorState(
  message: 'Failed to load data',
  onRetry: _retry,
);

// Dividers
Widget divider = WidgetBuilders.buildSectionDivider(label: 'Optional Section');
```

**Benefits**:
- Consistent UI/UX across entire app
- No magic numbers or scattered constants
- Single source of truth for styling
- Easier to maintain and update theming
- Better accessibility (minimum tap targets enforced)

**Migration from Old Patterns**:
```dart
// ❌ OLD - Inline constants
const double _fieldHeight = 48.0;
const double _iconSize = 20.0;
padding: const EdgeInsets.symmetric(horizontal: 16),

// ✅ NEW - Centralized constants
height: UIConstants.fieldHeight,
size: UIConstants.iconMedium,
padding: UIConstants.paddingHorizontalNormal,
```

## Common Patterns

### Enhanced Calculation System (v5) - FEED FORMULATION CORE

**Phase 3 Implementation**: Harmonized ingredient dataset with comprehensive nutrient tracking for accurate feed formulation

**Key Components**:

1. **EnhancedCalculationEngine** ([lib/src/features/reports/providers/enhanced_calculation_engine.dart](../lib/src/features/reports/providers/enhanced_calculation_engine.dart))
   - PRIMARY calculation engine for all feed nutrient analysis
   - Calculates all 10 essential amino acids (lysine, methionine, threonine, tryptophan, cystine, phenylalanine, tyrosine, leucine, isoleucine, valine)
   - Tracks SID (Standardized Ileal Digestibility) values for precision (NRC 2012 standard)
   - Enhanced phosphorus breakdown: total, available (bioavailable), phytate (bound)
   - Collects proximate analysis: ash, moisture, starch, bulk density
   - Anti-nutritional factor tracking with safety warnings
   - Regulatory and formulation violation warnings

   ```dart
   // CRITICAL: Always use for feed calculations
   final result = EnhancedCalculationEngine.calculateEnhancedResult(
     feedIngredients: feedIngredients,
     ingredientCache: ingredientCache,
     animalTypeId: 1, // 1=pig, 2=poultry, 3=rabbit, 4=ruminant, 5=fish
     currentPrices: ref.watch(currentPriceProvider), // Optional: for cost calculation
   );
   
   // Result includes both legacy v4 fields and enhanced v5 fields
   // v4: mEnergy, cProtein, calcium, lysine, etc.
   // v5: ash, moisture, totalPhosphorus, availablePhosphorus, aminoAcidsJson, warningsJson
   ```

2. **InclusionValidator** ([lib/src/features/add_update_feed/services/inclusion_validator.dart](../lib/src/features/add_update_feed/services/inclusion_validator.dart))
   - **MANDATORY** validation - ALWAYS call before saving a feed
   - Validates ingredient inclusion percentages against maximum safe limits per animal type
   - Prevents use of toxic ingredients beyond safety thresholds (e.g., cottonseed meal >15%, rapeseed >10%)
   - Enforces regulatory restrictions (processed animal protein limits, dangerous substances like urea)
   - Collects anti-nutritional factor warnings (glucosinolates, trypsin inhibitors, tannins, phytic acid)
   - Returns errors (must fix) and warnings (inform user but allow continuation)

   ```dart
   // Usage: CRITICAL for feed validation
   final validation = InclusionValidator.validate(
     feedIngredients: feedIngredients,
     ingredientCache: ingredientCache,
     animalTypeId: 1, // Per-animal type limits
   );
   
   if (!validation.isValid) {
     // Display errors - user cannot save feed until fixed
     for (final error in validation.errors) {
       showError(error);
     }
     return; // Prevent save
   }
   
   // Warnings are collected in calculation engine and included in reports
   for (final warning in validation.warnings) {
     showWarning(warning); // Inform user
   }
   ```

3. **Enhanced Ingredient Model** (v5 fields in [lib/src/features/add_ingredients/model/ingredient.dart](../lib/src/features/add_ingredients/model/ingredient.dart))
   ```dart
   class Ingredient {
     // Legacy fields (v4 - preserved for backward compatibility)
     num? crudeProtein;
     num? lysine;        // Deprecated: Use aminoAcidsTotal for detailed profile
     num? methionine;    // Deprecated: Use aminoAcidsTotal
     num? phosphorus;    // Deprecated: Use totalPhosphorus
     
     // NEW v5 nutrient fields
     num? ash;
     num? moisture;
     num? starch;
     num? bulkDensity;
     num? totalPhosphorus;          // Total phosphorus content
     num? availablePhosphorus;      // Bioavailable phosphorus
     num? phytatePhosphorus;        // Bound phytate phosphorus
     num? meFinishingPig;           // Energy for finishing pigs
     
     // Complex nutrient structures
     AminoAcidsProfile? aminoAcidsTotal;  // 10 amino acids (total)
     AminoAcidsProfile? aminoAcidsSid;    // 10 amino acids (SID digestibility)
     EnergyValues? energy;                // Energy for all animal types
     AntiNutritionalFactors? antiNutritionalFactors;
     
     // Safety & regulatory
     num? maxInclusionPct;           // Maximum % of feed formulation
     Map<String, dynamic>? maxInclusionJson;  // Per-animal-type limits
     String? warning;                // Safety warning (e.g., "High gossypol")
     String? regulatoryNote;         // Regulatory restrictions
     String? region;                 // Regional availability (Africa, Asia, Global)
   }
   ```

4. **Enhanced Result Model** (v5 fields in [lib/src/features/reports/model/result.dart](../lib/src/features/reports/model/result.dart))
   ```dart
   class Result {
     // Legacy v4 fields (backward compatible)
     num? mEnergy;
     num? cProtein;
     num? lysine;
     num? methionine;
     
     // NEW v5 fields (enhanced analysis)
     num? ash;
     num? moisture;
     num? totalPhosphorus;
     num? availablePhosphorus;
     num? phytatePhosphorus;
     
     // JSON stores for complex nutrient profiles and warnings
     String? aminoAcidsTotalJson;    // Full 10-amino-acid profile
     String? aminoAcidsSidJson;      // SID digestibility values
     String? energyJson;             // Energy values for all animal types
     String? warningsJson;           // Formulation warnings & violations
   }
   ```

**Integration Pattern - FEED FORMULATION WORKFLOW**:
1. Load feed ingredients and ingredient database cache
2. Call `InclusionValidator.validate()` - if errors, show user and prevent save
3. Call `EnhancedCalculationEngine.calculateEnhancedResult()` with all ingredients
4. Check result for warnings and anti-nutritional factors
5. Display results in report/analysis view
6. Save feed with calculated nutrients

**When Adding New Feed Nutrients**:
1. Add fields to `Ingredient` model (v5 section) with proper defaults
2. Update `EnhancedCalculationEngine._calculateEnhancedValues()` to accumulate new nutrient
3. Update `Result` model with new field (use JSON for complex structures)
4. Extend `_collectWarnings()` if safety-related (e.g., nutrient deficiency)
5. Add test cases in `test/unit/` for calculation correctness
6. Update documentation with new nutrient source and methodology

### Repository Pattern
All repos extend `core/repositories/Repository` (see [lib/src/core/repositories/repository.dart](../lib/src/core/repositories/repository.dart)):
```dart
class FeedRepository implements Repository {
  static const tableName = 'feeds';
  static const colId = 'feed_id';
  final Database db;
  
  @override
  Future<int> create(Map<String, dynamic> data) async {
    try {
      final result = await db.insert(tableName, data);
      AppLogger.info('Created feed with ID: $result', tag: 'FeedRepository');
      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create feed',
        tag: 'FeedRepository',
        error: e,
        stackTrace: stackTrace,
      );
      throw RepositoryException(
        operation: 'create',
        message: 'Failed to create feed in database',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
```

**Repository Providers**:
```dart
// Standard pattern for repository providers
final feedRepository = Provider<FeedRepository>((ref) {
  final db = ref.watch(appDatabase).database;
  return FeedRepository(db);
});
```

See reference implementations:
- [lib/src/features/main/repository/feed_repository.dart](../lib/src/features/main/repository/feed_repository.dart)
- [lib/src/features/add_ingredients/repository/ingredients_repository.dart](../lib/src/features/add_ingredients/repository/ingredients_repository.dart)

### Price Management System (Phase 4.5 - OPTIONAL SECONDARY FEATURE)

**Use Case**: Optional dynamic pricing - calculation works without it using stored ingredient prices.

**Key Components**:

1. **PriceHistory Model** - Tracks ingredient price changes over time (source attribution: user/import/system)
2. **PriceHistoryRepository** - CRUD operations, date range queries for trends
3. **Riverpod Providers** - `current_price_provider` (latest prices map), `price_history_provider` (async)

**Integration Pattern**:
```dart
// Optional: Use current prices in feed calculation (calculates cost with latest prices)
// WITHOUT this: calculation uses ingredient.priceKg values stored in database
final currentPrices = ref.watch(currentPriceProvider);
final result = EnhancedCalculationEngine.calculateEnhancedResult(
  feedIngredients: feedIngredients,
  ingredientCache: ingredientCache,
  animalTypeId: animalTypeId,
  currentPrices: currentPrices, // Optional parameter - omit if not needed
);
```

**When Working with Prices**:
- Price management is NOT required for feed formulation to work
- Use `PriceHistoryRepository.recordPrice()` for audit trail on manual updates
- CSV import via `import_export` feature can bulk load prices
- Always check if `currentPriceProvider` returns null (feature not active)

### Feed Optimizer System (Phase 5 - IN DEVELOPMENT)

**Use Case**: AI-powered automatic formulation optimization based on cost, nutrition, and ingredient availability.

**Status**: Core architecture complete, UI components active, optimization engine in testing phase.

**Key Components**:

1. **FormulationOptimizerService** - Linear programming solver using simplex algorithm
2. **ConstraintValidator** - Pre/post optimization validation
3. **FormulationScorer** - Multi-criteria scoring (cost, quality, safety)
4. **Optimizer Models** - Request/response/constraint data structures

**Location**: `lib/src/features/optimizer/`

**Architecture**:
```dart
// Optimization request structure
final request = OptimizationRequest(
  animalTypeId: 1,
  constraints: [
    OptimizationConstraint(nutrient: 'protein', min: 18, max: 22),
    OptimizationConstraint(nutrient: 'energy', min: 3000),
  ],
  availableIngredients: ingredientList,
  targetCost: 1500.0, // Optional cost ceiling
);

// Run optimization
final result = await FormulationOptimizerService.optimize(request);

// Result includes optimized ingredient proportions and scores
if (result.isValid) {
  // Convert to Feed and save
  final feed = result.toFeed();
}
```

**When Working with Optimizer**:
- **Documentation**: See [doc/FEED_OPTIMIZER_QUICK_REFERENCE.md](../doc/FEED_OPTIMIZER_QUICK_REFERENCE.md) for complete architecture
- **Task Tracking**: Implementation progress in [doc/FEED_OPTIMIZER_TASKS.md](../doc/FEED_OPTIMIZER_TASKS.md)
- **Testing**: Integration tests in `test/integration/formulation_workflow_test.dart`
- **Navigation**: Type-safe routes: `OptimizerSetupRoute().go(context)`
- **Results**: Display uses `OptimizationResultsScreen` with interactive charts

### Regional Ingredient Expansion (Phase 4.6 - DATABASE v12 COMPLETE)

**Database v12 Changes**:
- New `region` column in `ingredients` table (default='Global')
- 211 ingredients tagged with regions: Africa, Asia, Europe, Americas, Oceania, Global
- Index created: `idx_ingredients_region` for fast regional queries
- Backward compatible with all v9-v11 databases

**Regional Tags**:
```dart
// Example regions in ingredients
ingredient.region = 'Africa';        // African crops (cassava, sorghum, etc.)
ingredient.region = 'Asia';          // Asian ingredients (tapioca, fishmeal, etc.)
ingredient.region = 'Global';        // Available everywhere (corn, soybeans, etc.)
ingredient.region = 'Europe,Asia';   // Multiple regions supported
```

**Integration Pattern**:
- Display in ingredient cards: Show region badge (color-coded)
- Filter in StoredIngredients: Allow filtering by All/Africa/Asia/Europe/Americas/Oceania
- Query pattern: `WHERE region LIKE '%[RegionName]%'` for substring matching
- User preference: Store selected region in SharedPreferences for persistence

**When Adding Regional Features**:
1. Update ingredient query methods to accept optional region filter
2. Add region display in ingredient list cards
3. Implement region filter dropdown in StoredIngredients screen
4. Persist user's selected region preference
5. Test regional queries with database migration



### UI Patterns
- **Cupertino dialogs** for updates/deletes (iOS-style): `CupertinoAlertDialog`
- **Material** for main screens: `MaterialApp.router`
- **Minimum tap targets**: Use `UIConstants.minTapTarget` (44px, Material Design minimum)
- **Icon sizes**: Use `UIConstants.iconSmall/Medium/Large` (16/20/24px)
- **InkWell for lists**: Use `Material` + `InkWell` for proper ripple effects
- **Spacing**: Use `UIConstants.padding*` constants (see Centralized UI/UX Utilities above)
- **Validation**: Always use `InputValidators` (see Centralized UI/UX Utilities above)
- **Widget builders**: Prefer `WidgetBuilders` for consistent components

## Key Files & Examples

- **Main entry**: `lib/main.dart` (splash → `lib/src/feed_app.dart`)
- **Routing**: `lib/src/core/router/routes.dart` (type-safe with code gen)
- **Database**: `lib/src/core/database/app_db.dart` (singleton, multi-platform)
- **Models**: `lib/src/features/main/model/feed.dart` (JSON serialization, NOT sealed)
- **Documentation**: `doc/` (40+ markdown files tracking modernization phases)
- **Reference implementations**: 
  - `lib/src/features/add_update_feed/` - Complete optimized feature (dialogs, forms, validation)
  - `lib/src/features/add_update_feed/widget/feed_ingredients.dart` - Input validation patterns

## Current Phase Context

**Phase 1 COMPLETE** (Foundation):
- Sealed classes conversion (6 providers)
- Exception hierarchy + centralized logger
- Lint issues: 296 → 3
- Critical notifier initialization fixes (FeedNotifier, IngredientNotifier)

**Phase 2 COMPLETE** (Ingredient Audit & Corrections):
- Audited all 165 feed ingredients against international standards (NRC, ASABE, CVB, INRA)
- Applied Tier 1 corrections: fish meal methionine alignment, fiber adjustments
- Industry validation complete (see `doc/PHASE_2_COMPLETION_REPORT.md`)

**Phase 3 COMPLETE** (Harmonized Dataset & Enhanced Calculations):
- ✅ New ingredient JSON structure with 10 essential amino acids (total + SID)
- ✅ Enhanced phosphorus tracking (total, available, phytate)
- ✅ Inclusion limit validation with safety warnings (`InclusionValidator`)
- ✅ Database migration v4 → v12 (schema expansion, backward compatible)
- ✅ Result model enhanced with v5 calculation fields
- ✅ Enhanced calculation engine with comprehensive nutrient tracking

**Phase 4 STATUS**: 🟡 **IN PROGRESS** (75% complete)
- ✅ Phase 4.5: Price Management (application layer + UI complete, CSV import integrated)
- ✅ Phase 4.7a: Localization (5 languages: en, pt, es, yo, fr - 120+ strings complete)
- ✅ Phase 5.1: CSV Import (complete with price history bulk import)
- ✅ Phase 4.6: Regional Ingredient Expansion (211 ingredients, DB v12 migration complete)
- 🟡 Phase 4.6 UI: Regional filter dropdown pending (StoredIngredients screen)
- 📋 Phase 4.2-4.4: Performance optimization planned
- 📋 Phase 4.7b+: Accessibility & advanced features planned

**Test Coverage**: ✅ 435+/436 passing (99%+ pass rate)

**Calculation Improvements** (Phase 3 Complete):
- `EnhancedCalculationEngine` ([lib/src/features/reports/providers/enhanced_calculation_engine.dart](../lib/src/features/reports/providers/enhanced_calculation_engine.dart)) supports harmonized v5 ingredients
- `InclusionValidator` ([lib/src/features/add_update_feed/services/inclusion_validator.dart](../lib/src/features/add_update_feed/services/inclusion_validator.dart)) prevents toxic/regulatory violations
- All 10 amino acids tracked (lysine, methionine, threonine, tryptophan, cystine, phenylalanine, tyrosine, leucine, isoleucine, valine)
- Phosphorus breakdown: total, available (bioavailable), phytate (bound)
- Anti-nutritional factors and regulatory notes collected
- Backward compatible with legacy v4 calculations

**User Demographics**: Nigeria (largest market), India, USA, Kenya, plus Europe/Asia/Africa regions. Current rating: 4.5★ (148 reviews).

**Localization**: App supports 5 languages (English, Portuguese, Spanish, Yoruba, French) via `AppLocalizations` (Flutter i18n). Use `context.l10n.keyName` for translated strings in UI code. Settings screen allows language switching with persistence.

Refer to:
- `doc/PHASE_2_COMPLETION_REPORT.md` - Ingredient audit results
- `doc/PHASE_3_IMPLEMENTATION_SUMMARY.md` - Phase 3 complete implementation details
- `doc/HARMONIZED_DATASET_MIGRATION_PLAN.md` - v4→v5 migration strategy
- `lib/src/features/reports/providers/enhanced_calculation_engine.dart` - Calculation engine
- `lib/src/features/add_update_feed/services/inclusion_validator.dart` - Inclusion validation
- `lib/src/features/reports/model/inclusion_validation.dart` - Validation data models

### Localization (i18n) Best Practices

**ALWAYS use localized strings** - Never hardcode user-facing text:

```dart
// ✅ CORRECT - Use context.l10n for all UI text
Text(context.l10n.labelPrice)
Text(context.l10n.actionSave)
hintText: context.l10n.hintEnterName

// ❌ WRONG - Hardcoded strings
Text('Price')
Text('Save')
hintText: 'Enter name'
```

**Supported Languages**: English (en), Portuguese (pt), Spanish (es), Yoruba (yo), French (fr)

**Implementation Pattern**:
- Access via `context.l10n.keyName` (requires `BuildContext`)
- Strings defined in `lib/generated/l10n/app_localizations_*.dart` (auto-generated)
- Source files: `lib/l10n/app_*.arb` (edit ARB files to add/modify strings)
- Language switching: `LocalizationProvider` in `lib/src/core/localization/localization_provider.dart`
- Settings integration: Language selector in `SettingsScreen`

**Adding New Strings**:
1. Add key-value to all `lib/l10n/app_*.arb` files (en, pt, es, yo, fr)
2. Run `flutter gen-l10n` to regenerate localization files
3. Use `context.l10n.yourNewKey` in UI code

**Common Patterns**:
```dart
// Labels
Text(context.l10n.labelName)
Text(context.l10n.labelPrice)

// Actions
onPressed: () => context.l10n.actionSave
Text(context.l10n.actionCancel)

// Errors/Messages
Text(context.l10n.errorDatabaseOperation)
Text(context.l10n.confirmDeletionWarning)

// Navigation
title: context.l10n.navIngredients
title: context.l10n.navSettings
```

See `doc/LOCALIZATION_QUICK_REFERENCE.md` for complete list of available strings.

### Next Steps (Phase 4 Roadmap)

**PRIORITY 1 - Feed Formulation Enhancements** (Phase 4.2-4.4):
1. **Amino Acid Optimization** (IN PROGRESS):
   - Enhance SID digestibility calculations per animal type
   - Implement amino acid balance ratios (e.g., Met:Lys ratio for different species)
   - Add amino acid deficiency warnings in reports
   - Test against NRC, CVB, INRA standards

2. **Anti-Nutritional Factor Tracking** (IN PROGRESS):
   - Expand ANF detection (glucosinolates, trypsin inhibitors, tannins, phytic acid)
   - Per-animal-type ANF tolerance thresholds
   - Automatic ingredient replacement suggestions based on ANF levels
   - Add enzyme recommendations (phytase, protease) when needed

3. **Nutrient Balancing** (PLANNED):
   - Implement nutrient:energy ratios (e.g., lysine/ME for optimal growth)
   - Detect nutritional imbalances and suggest corrections
   - Add safety margins per nutrient (avoid over/under-supplementation)
   - Cost-optimized formulation suggestions

4. **Performance Optimization** (Phase 4.2-4.4):
   - Caching of calculation results per feed
   - Database query optimization for large ingredient databases
   - Batch calculation for multiple feeds

**PRIORITY 2 - Regional & User Features** (Phase 4.6):
- Regional ingredient availability filtering (Africa/Asia/Europe/Americas)
- "Popular in Your Region" ingredient suggestions
- Regional pricing variations

**PRIORITY 3 - Polish** (Phase 4.7b+):
- Accessibility improvements
- Advanced reporting features
- Dependency security review

**Success Metrics**: Accurate feed formulation within 5% of international standards, 0 errors/warnings, 80%+ test coverage, 4.7+ rating

## Form & Input Best Practices

**Always use StatefulWidget for forms with controllers**:
```dart
class MyFormField extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends ConsumerState<MyFormField> {
  late TextEditingController _controller;
  String? _errorText;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: initialValue);
  }
  
  @override
  void dispose() {
    _controller.dispose(); // CRITICAL
    super.dispose();
  }
  
  void _validate(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      setState(() => _errorText = 'Field is required');
      return;
    }
    setState(() => _errorText = null);
    ref.read(provider.notifier).setValue(trimmed);
  }
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Label',
        hintText: 'e.g., Example value',
        errorText: _errorText,
      ),
      onChanged: (value) {
        if (_errorText != null) setState(() => _errorText = null);
      },
      onSubmitted: _validate,
    );
  }
}
```

**Navigation Consistency**:
- Use `context.go()` for route changes (go_router)
- Use `context.pop()` for closing dialogs/screens
- Always check `mounted` before navigation after async operations
- Use `showDialog<void>()` instead of `Navigator.restorablePush()`

## Testing Strategy

**Test Structure** (see [test/README.md](../test/README.md)):
```
test/
├── unit/                        # Unit tests (validators, models, utils)
│   ├── input_validators_test.dart      # All 11 validator functions
│   ├── price_value_object_test.dart    # Price arithmetic, formatting, validation
│   ├── ingredient_model_test.dart      # Model serialization
│   ├── feed_model_test.dart            # Feed/FeedIngredients models
│   └── common_utils_test.dart          # Display, text style, time utilities
├── integration/                 # Integration tests (end-to-end workflows)
│   └── feed_integration_test.dart      # Complete feed creation flows
└── phase_1_4_simple_test.dart   # Legacy provider tests
```

**Running Tests**:
```powershell
flutter test                     # All tests
flutter test test/unit/          # Unit tests only
flutter test test/integration/   # Integration tests only
flutter test --coverage          # With coverage report
```

**Testing Patterns**:
- **Unit tests**: Validators, models, value objects, utility functions
- **Widget tests**: UI components, dialogs, screens (when needed)
- **Integration tests**: End-to-end workflows (create feed → add ingredients → analyze)
- Always test edge cases: null values, empty lists, boundary conditions
- Use `setUp()` for test data initialization
- Mock database/repository dependencies in unit tests

**Test Coverage Focus**:
- Input validators ([test/unit/input_validators_test.dart](../test/unit/input_validators_test.dart)) - **95%+ coverage**
- Value objects ([test/unit/price_value_object_test.dart](../test/unit/price_value_object_test.dart)) - **90%+ coverage**
- Model serialization/deserialization - **90%+ coverage**
- Repository CRUD operations
- Business logic calculations

Current Coverage: Unit tests passing with comprehensive edge case coverage. Target: 80%+ overall coverage (see `doc/MODERNIZATION_PLAN.md` Phase 3-4 goals).

## Platform Notes
- **Windows dev primary** (PowerShell commands in instructions)
- **Android target** (Google Play Store deployment)
- **Multi-platform DB** (sqflite_common_ffi for desktop, sqflite for mobile)
- **Edge-to-edge UI** with transparent system bars (see [lib/src/feed_app.dart](../lib/src/feed_app.dart))

## MCP Tools Integration

**Note**: MCP (Model Context Protocol) tools provide enhanced IDE integration when available in your development environment. Use them when present for better workflow automation.

When MCP tools are available, **prefer using them over terminal commands**:

**Dart/Flutter Development**:
- `mcp_dart_sdk_mcp__launch_app` - Start Flutter app (replaces `flutter run`)
- `mcp_dart_sdk_mcp__hot_reload` - Hot reload changes (replaces manual 'r' press)
- `mcp_dart_sdk_mcp__hot_restart` - Hot restart app (replaces manual 'R' press)
- `mcp_dart_sdk_mcp__connect_dart_tooling_daemon` - Connect to DTD for debugging
- `mcp_dart_sdk_mcp__get_runtime_errors` - Fetch current runtime errors
- `mcp_dart_sdk_mcp__pub_dev_search` - Search for packages on pub.dev
- `mcp_dart_sdk_mcp__resolve_workspace_symbol` - Find symbols in workspace

**Git Operations** (GitKraken MCP):
- `mcp_gitkraken_git_add_or_commit` - Stage/commit changes
- `mcp_gitkraken_git_push` - Push to remote
- `mcp_gitkraken_git_stash` - Stash working changes
- `mcp_gitkraken_git_blame` - See file history

**GitHub PR Management**:
- `github-pull-request_activePullRequest` - Get current PR details
- `github-pull-request_copilot-coding-agent` - Delegate tasks to coding agent

Fallback to terminal commands when MCP tools are unavailable or for complex operations.

## Critical Agent Patterns & Gotchas

**DO NOT**:
- ❌ Use `Future.microtask()` for state initialization - causes StateError in Riverpod (use `WidgetsBinding.instance.addPostFrameCallback()`)
- ❌ Create `TextEditingController` in Consumer widgets without `ConsumerStatefulWidget` + `dispose()` (memory leaks)
- ❌ Use `Navigator.push()` or `context.pushNamed()` (use type-safe routing: `AddFeedRoute().go(context)`)
- ❌ Hardcode UI strings (always use `context.l10n.keyName` for i18n)
- ❌ Duplicate timeout logic (use `DatabaseTimeout` utility from `lib/src/core/database/database_timeout.dart`)
- ❌ Load entire ingredient lists at once (use `PaginationHelper` with pageSize=50)
- ❌ Skip running `dart run build_runner build` after modifying `@riverpod` or `@TypedGoRoute` (code won't compile)

**DO**:
- ✅ Use sealed classes for state (not @freezed)
- ✅ Use manual `copyWith()` implementations  
- ✅ Always call `InclusionValidator.validate()` before saving feeds
- ✅ Pass `currentPrices` to `EnhancedCalculationEngine` for latest pricing
- ✅ Use `AppLogger` instead of `print()` or `debugPrint()`
- ✅ Use `InputValidators` for all user input (11 validators available)
- ✅ Use `UIConstants` and `WidgetBuilders` for consistent UI
- ✅ Use `ConsumerStatefulWidget` for dialogs with controllers
- ✅ Test edge cases: null values, empty lists, boundary conditions
- ✅ Use `ProviderContainer` in unit tests with `addTearDown(container.dispose)`
- ✅ Initialize test bindings: `TestWidgetsFlutterBinding.ensureInitialized()`
