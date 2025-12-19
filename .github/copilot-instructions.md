# Copilot Instructions - Feed Estimator App

## Project Overview

Flutter livestock feed formulation app for analyzing nutrients in animal feed. Primary users: livestock farmers across Nigeria (largest), India, United States, Kenya, and globally (Europe, Asia, Africa). Current version: 1.0.0+11, actively modernized through phased improvements (see [doc/MODERNIZATION_PLAN.md](../doc/MODERNIZATION_PLAN.md)).

## Architecture Essentials

### Feature-First Structure
```
lib/src/
├── features/          # Business domains (add_ingredients, main, reports, etc.)
│   └── [feature]/
│       ├── model/     # Data classes (JSON serialization, NOT sealed)
│       ├── provider/  # Riverpod state (Notifier/AsyncNotifier)
│       ├── repository/# Data access (extends core/repositories/Repository)
│       ├── view/      # Screens
│       └── widget/    # Feature widgets
├── core/
│   ├── value_objects/ # Domain primitives (Weight, Price, Quantity) using Equatable
│   ├── exceptions/    # Custom hierarchy (AppException → 7 specific types)
│   ├── database/      # SQLite (sqflite/sqflite_common_ffi with migrations)
│   └── router/        # Type-safe go_router with @TypedGoRoute annotations
```

### State Management Pattern
**Riverpod 2.5.1 with Notifier (NOT StateNotifier)**:
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
**Current version**: 4 (see `_currentVersion`)

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

### Enhanced Calculation System (v5)

**Phase 3 Implementation**: Harmonized ingredient dataset with comprehensive nutrient tracking

**Key Components**:

1. **EnhancedCalculationEngine** ([lib/src/features/reports/providers/enhanced_calculation_engine.dart](../lib/src/features/reports/providers/enhanced_calculation_engine.dart))
   - Calculates all 10 essential amino acids (lysine, methionine, threonine, tryptophan, cystine, phenylalanine, tyrosine, leucine, isoleucine, valine)
   - Tracks SID (Standardized Ileal Digestibility) values for precision
   - Enhanced phosphorus breakdown: total, available (bioavailable), phytate (bound)
   - Collects proximate analysis: ash, moisture, starch, bulk density
   - Anti-nutritional factor tracking
   - Regulatory and safety warnings collection

   ```dart
   // Usage
   final result = EnhancedCalculationEngine.calculateEnhancedResult(
     feedIngredients: feedIngredients,
     ingredientCache: ingredientCache,
     animalTypeId: 1, // 1=growing pig, 2=poultry, 3=rabbit, 4=ruminant, 5=fish
   );
   
   // Result includes:
   // - Legacy v4 fields (backward compatible): mEnergy, cProtein, calcium, lysine, etc.
   // - Enhanced v5 fields: ash, moisture, totalPhosphorus, availablePhosphorus, etc.
   // - JSON amino acid profiles and warnings
   ```

2. **InclusionLimitValidator** ([lib/src/features/reports/model/inclusion_limit_validator.dart](../lib/src/features/reports/model/inclusion_limit_validator.dart))
   - Validates ingredient inclusion percentages against maximum limits
   - Prevents use of toxic ingredients beyond safety thresholds
   - Enforces regulatory restrictions (e.g., processed animal protein limits)
   - Built-in limits for: cottonseed meal (15%), urea (dangerous), moringa (10%), rapeseed (10%), etc.

   ```dart
   // Usage
   final validation = InclusionLimitValidator.validateFormulation(
     feedIngredients: feedIngredients,
     ingredientCache: ingredientCache,
     totalQuantity: totalQuantity,
   );
   
   if (validation.hasViolations) {
     // Display hard violations - MUST fix before saving
     for (final v in validation.violations) {
       print('VIOLATION: ${v.description}');
     }
   }
   if (validation.hasWarnings) {
     // Display warnings - inform user but allow
     for (final w in validation.warnings) {
       print('WARNING: ${w.description}');
     }
   }
   ```

3. **Enhanced Ingredient Model** (v5 fields in [lib/src/features/add_ingredients/model/ingredient.dart](../lib/src/features/add_ingredients/model/ingredient.dart))
   ```dart
   class Ingredient {
     // Legacy fields (preserved for backward compatibility)
     num? crudeProtein;
     num? lysine;        // Deprecated: Use aminoAcidsTotalJson
     num? methionine;    // Deprecated: Use aminoAcidsTotalJson
     num? phosphorus;    // Deprecated: Use totalPhosphorus
     
     // New v5 fields
     num? ash;
     num? moisture;
     num? bulkDensity;
     num? totalPhosphorus;
     num? availablePhosphorus;
     num? phytatePhosphorus;
     num? meFinishingPig;
     
     String? aminoAcidsTotalJson;    // Map<String, num> of 10 amino acids
     String? aminoAcidsSidJson;      // Map<String, num> with SID values
     String? antiNutrionalFactorsJson;
     
     num? maxInclusionPct;           // Safety limit (0 = unlimited)
     String? warning;                // Safety warning
     String? regulatoryNote;         // Regulatory restrictions
   }
   ```

4. **Enhanced Result Model** (v5 fields in [lib/src/features/reports/model/result.dart](../lib/src/features/reports/model/result.dart))
   ```dart
   class Result {
     // Legacy fields preserved
     num? mEnergy;
     num? cProtein;
     num? lysine;
     num? methionine;
     
     // New v5 fields
     num? ash;
     num? moisture;
     num? totalPhosphorus;
     num? availablePhosphorus;
     num? phytatePhosphorus;
     
     // JSON stores for complex data
     String? aminoAcidsTotalJson;    // Full amino acid profile
     String? aminoAcidsSidJson;      // SID digestibility values
     String? warningsJson;           // Collection of warnings
   }
   ```

**Migration Strategy** (v4 → v5):
- Database schema expanded with new columns (non-breaking)
- All v4 columns kept active for backward compatibility
- Calculations fallback to v4 values if v5 fields missing
- JSON fields used for complex structures (amino acids, anti-nutritional factors)

**Integration with result_provider.dart**:
- Keep existing `estimatedResult()` and `calculateResult()` methods
- Can replace internals of `calculateResult()` with `EnhancedCalculationEngine.calculateEnhancedResult()`
- Or run both engines and merge results for gradual migration
```

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

**Phase 3 IN PROGRESS** (Harmonized Dataset & Enhanced Calculations):
- ✅ New ingredient JSON structure with 10 essential amino acids (total + SID)
- ✅ Enhanced phosphorus tracking (total, available, phytate)
- ✅ Inclusion limit validation with safety warnings
- 🟡 Database migration v4 → v5 (schema expansion, backward compatible)
- 🟡 Result model enhanced with v5 calculation fields
- 📋 Next: PDF export with amino acid profiles and warnings

**Calculation Improvements** (Recent):
- `EnhancedCalculationEngine` supports harmonized v5 ingredients
- `InclusionLimitValidator` prevents toxic/regulatory violations
- All 10 amino acids tracked (lysine, methionine, threonine, tryptophan, cystine, phenylalanine, tyrosine, leucine, isoleucine, valine)
- Phosphorus breakdown: total, available (bioavailable), phytate (bound)
- Anti-nutritional factors and regulatory notes collected
- Backward compatible with legacy v4 calculations

**User Demographics**: Nigeria (largest market), India, USA, Kenya, plus Europe/Asia/Africa regions. Current rating: 4.5★ (148 reviews).

Refer to:
- `doc/PHASE_2_COMPLETION_REPORT.md` - Ingredient audit results
- `doc/HARMONIZED_DATASET_MIGRATION_PLAN.md` - v4→v5 migration strategy
- `lib/src/features/reports/providers/enhanced_calculation_engine.dart` - Calculation engine
- `lib/src/features/reports/model/inclusion_limit_validator.dart` - Inclusion validation

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

Current Coverage: Unit tests passing with comprehensive edge case coverage.

## Platform Notes
- **Windows dev primary** (PowerShell commands in instructions)
- **Android target** (Google Play Store deployment)
- **Multi-platform DB** (sqflite_common_ffi for desktop, sqflite for mobile)
- **Edge-to-edge UI** with transparent system bars (see [lib/src/feed_app.dart](../lib/src/feed_app.dart))

## MCP Tools Integration

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
