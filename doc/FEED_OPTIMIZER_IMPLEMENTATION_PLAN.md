# Feed Formulation Optimizer - Implementation Plan

## Goal Description

The Feed Formulation Optimizer is a new major feature that will enable users to automatically generate optimal feed formulations based on nutritional requirements, ingredient availability, cost constraints, and inclusion limits. This AI-powered system will use optimization algorithms (Linear Programming or Genetic Algorithms) to select and proportion ingredients that meet specific animal nutritional needs while minimizing cost.

### Background Context

Currently, the app allows users to manually create feed formulations by selecting ingredients and specifying quantities. The system then calculates the resulting nutritional profile and displays warnings if nutritional requirements are not met. However, users must manually adjust ingredient proportions through trial and error to achieve optimal formulations.

The Feed Formulation Optimizer will automate this process by:
- Accepting nutritional constraints (min/max values for protein, energy, amino acids, minerals, etc.)
- Considering ingredient availability and pricing
- Respecting ingredient inclusion limits (min/max percentages)
- Avoiding anti-nutritional factor violations
- Generating optimal formulations that meet all constraints while minimizing cost

### What This Change Accomplishes

This feature will transform the app from a **feed analysis tool** into a **feed optimization platform**, providing significant value to nutritionists, feed mill operators, and livestock producers by:
1. Reducing formulation time from hours to seconds
2. Ensuring nutritional requirements are met consistently
3. Minimizing feed costs through optimal ingredient selection
4. Preventing formulation errors and nutritional deficiencies
5. Enabling rapid reformulation when ingredient prices or availability change

---

## User Review Required

> [!IMPORTANT]
> **Algorithm Selection**: This plan proposes using Linear Programming (Simplex method) as the primary optimization algorithm. For complex scenarios with non-linear constraints, we may need to implement Genetic Algorithms as an alternative. Please confirm if LP is sufficient or if GA should be included in Phase 1.

> [!IMPORTANT]
> **External Dependencies**: Linear Programming will require adding the `lpsolve` or `simplex` Dart package. Please confirm if adding external optimization libraries is acceptable, or if we should implement a custom LP solver.

> [!WARNING]
> **Breaking Changes**: The `Feed` model will need to be extended with new fields (`isOptimized`, `optimizationConstraints`, `optimizationScore`). This requires database migration and may affect existing feed data serialization. Note: The project uses regular Dart classes (not Freezed), so changes will be made to the existing class structure and JSON serialization methods.

> [!IMPORTANT]
> **Pricing Integration**: The optimizer requires ingredient pricing data. Currently, pricing is managed separately in the `price_management` feature. Should we:
1. Use current prices from `price_management` (requires integration)
2. Allow users to specify custom prices during optimization
3. Support both options

---

## Proposed Changes

### Core Optimization Engine

#### [NEW] [formulation_optimizer_service.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/services/formulation_optimizer_service.dart)

The core optimization service that implements the Linear Programming algorithm to solve feed formulation problems.

**Key Responsibilities:**
- Accept optimization constraints (nutritional requirements, ingredient limits, cost objectives)
- Transform constraints into LP problem format (objective function + constraint matrix)
- Solve LP problem using Simplex algorithm
- Return optimal ingredient proportions
- Handle infeasible solutions (no valid formulation exists)
- Support multiple objective functions (minimize cost, maximize protein, etc.)

**Algorithm:**
```
Minimize: Σ(ingredient_i × price_i)
Subject to:
  - Σ(ingredient_i × nutrient_j) >= min_requirement_j  (for all nutrients)
  - Σ(ingredient_i × nutrient_j) <= max_requirement_j  (for all nutrients)
  - min_inclusion_i <= ingredient_i <= max_inclusion_i  (for all ingredients)
  - Σ(ingredient_i) = 100  (total formulation = 100%)
  - ingredient_i >= 0  (non-negativity)
```

---

#### [NEW] [constraint_validator.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/services/constraint_validator.dart)

Validates optimization constraints before passing to the solver and validates results after optimization.

**Key Responsibilities:**
- Validate nutritional constraints are realistic (min <= max)
- Check ingredient availability
- Verify inclusion limits don't create impossible scenarios
- Validate optimized formulation meets all constraints
- Generate detailed validation reports

---

#### [NEW] [formulation_scorer.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/services/formulation_scorer.dart)

Scores and ranks formulations based on multiple criteria.

**Key Responsibilities:**
- Calculate cost score (lower is better)
- Calculate nutritional adequacy score (how well requirements are met)
- Calculate safety score (distance from toxicity limits)
- Calculate overall formulation quality score
- Support weighted scoring (user can prioritize cost vs. quality)

---

### Data Models

#### [NEW] [optimization_constraint.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/model/optimization_constraint.dart)

Regular Dart class representing a single nutritional constraint.

```dart
class OptimizationConstraint {
  final String nutrientName;  // e.g., "crudeProtein", "lysine", "calcium"
  final ConstraintType type;  // MIN, MAX, EXACT
  final double value;         // constraint value
  final String unit;          // %, g/kg, kcal/kg
  final String? animalCategory;  // optional: specific to animal type

  const OptimizationConstraint({
    required this.nutrientName,
    required this.type,
    required this.value,
    required this.unit,
    this.animalCategory,
  });

  OptimizationConstraint copyWith({
    String? nutrientName,
    ConstraintType? type,
    double? value,
    String? unit,
    String? animalCategory,
  }) {
    return OptimizationConstraint(
      nutrientName: nutrientName ?? this.nutrientName,
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      animalCategory: animalCategory ?? this.animalCategory,
    );
  }

  Map<String, dynamic> toJson() => {
    'nutrientName': nutrientName,
    'type': type.name,
    'value': value,
    'unit': unit,
    'animalCategory': animalCategory,
  };

  factory OptimizationConstraint.fromJson(Map<String, dynamic> json) {
    return OptimizationConstraint(
      nutrientName: json['nutrientName'] as String,
      type: ConstraintType.values.firstWhere((e) => e.name == json['type']),
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
      animalCategory: json['animalCategory'] as String?,
    );
  }
}

enum ConstraintType { min, max, exact }
```

---

#### [NEW] [optimization_request.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/model/optimization_request.dart)

Regular Dart class representing a complete optimization request.

```dart
class OptimizationRequest {
  final List<OptimizationConstraint> constraints;
  final List<int> availableIngredientIds;
  final Map<int, double> ingredientPrices;  // ingredientId -> price per kg
  final ObjectiveFunction objective;
  final Map<int, InclusionLimit>? ingredientLimits;  // optional custom limits
  final int? animalTypeId;
  final String? formulationName;

  const OptimizationRequest({
    required this.constraints,
    required this.availableIngredientIds,
    required this.ingredientPrices,
    required this.objective,
    this.ingredientLimits,
    this.animalTypeId,
    this.formulationName,
  });

  Map<String, dynamic> toJson() => {
    'constraints': constraints.map((c) => c.toJson()).toList(),
    'availableIngredientIds': availableIngredientIds,
    'ingredientPrices': ingredientPrices.map((k, v) => MapEntry(k.toString(), v)),
    'objective': objective.name,
    'ingredientLimits': ingredientLimits?.map((k, v) => MapEntry(k.toString(), v.toJson())),
    'animalTypeId': animalTypeId,
    'formulationName': formulationName,
  };
}

enum ObjectiveFunction { minimizeCost, maximizeProtein, maximizeEnergy }
```

---

#### [NEW] [optimization_result.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/model/optimization_result.dart)

Regular Dart class representing optimization results.

```dart
class OptimizationResult {
  final bool success;
  final Map<int, double> ingredientProportions;  // ingredientId -> percentage
  final double totalCost;
  final double qualityScore;
  final Map<String, double> achievedNutrients;
  final List<String>? warnings;
  final String? errorMessage;  // if success = false
  final DateTime? timestamp;

  const OptimizationResult({
    required this.success,
    required this.ingredientProportions,
    required this.totalCost,
    required this.qualityScore,
    required this.achievedNutrients,
    this.warnings,
    this.errorMessage,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'ingredientProportions': ingredientProportions.map((k, v) => MapEntry(k.toString(), v)),
    'totalCost': totalCost,
    'qualityScore': qualityScore,
    'achievedNutrients': achievedNutrients,
    'warnings': warnings,
    'errorMessage': errorMessage,
    'timestamp': timestamp?.toIso8601String(),
  };

  factory OptimizationResult.fromJson(Map<String, dynamic> json) {
    return OptimizationResult(
      success: json['success'] as bool,
      ingredientProportions: (json['ingredientProportions'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(int.parse(k), (v as num).toDouble())),
      totalCost: (json['totalCost'] as num).toDouble(),
      qualityScore: (json['qualityScore'] as num).toDouble(),
      achievedNutrients: (json['achievedNutrients'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      warnings: (json['warnings'] as List<dynamic>?)?.cast<String>(),
      errorMessage: json['errorMessage'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String) 
          : null,
    );
  }
}
```

---

#### [MODIFY] [feed.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/main/model/feed.dart)

Extend the existing `Feed` model (regular Dart class) to support optimized formulations.

**Changes:**
- Add `bool isOptimized` field (default: false)
- Add `String? optimizationConstraintsJson` field (serialized constraints)
- Add `double? optimizationScore` field
- Add `String? optimizationObjective` field
- Update `copyWith` method
- Update `toJson` and `fromJson` methods
- Update Isar schema annotations

---

### State Management

#### [NEW] [optimizer_provider.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/providers/optimizer_provider.dart)

Riverpod provider for optimization state management.

**Providers:**
- `optimizerServiceProvider` - Provides `FormulationOptimizerService` instance
- `optimizationRequestProvider` - StateProvider for current optimization request
- `optimizationResultProvider` - FutureProvider for optimization results
- `savedOptimizationsProvider` - AsyncNotifierProvider for saved optimized feeds

---

### UI Components

#### [NEW] [optimizer_screen.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/view/optimizer_screen.dart)

Main screen for the Feed Formulation Optimizer feature.

**Layout:**
1. **Header**: Title, description, help button
2. **Step 1 - Animal Selection**: Select animal type (pig, poultry, etc.)
3. **Step 2 - Constraints**: Add/edit nutritional constraints
4. **Step 3 - Ingredients**: Select available ingredients, set prices
5. **Step 4 - Objective**: Choose optimization objective (minimize cost, etc.)
6. **Action Button**: "Optimize Formulation" button
7. **Results Section**: Display optimized formulation (appears after optimization)

---

#### [NEW] [constraint_input_widget.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/widget/constraint_input_widget.dart)

Widget for adding and editing nutritional constraints.

**Features:**
- Dropdown to select nutrient (protein, energy, lysine, etc.)
- Dropdown to select constraint type (minimum, maximum, exact)
- Text field for value input
- Unit display (auto-populated based on nutrient)
- Add/Remove buttons
- Preset templates (e.g., "NRC 2012 Pig Grower 20-50kg")

---

#### [NEW] [ingredient_selection_widget.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/widget/ingredient_selection_widget.dart)

Widget for selecting available ingredients and setting prices.

**Features:**
- Searchable ingredient list with checkboxes
- Price input field for each selected ingredient
- "Use current prices" button (loads from price_management)
- Inclusion limit override (optional min/max percentages)
- Ingredient availability indicator

---

#### [NEW] [optimization_result_card.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/widget/optimization_result_card.dart)

Displays optimization results in an attractive card format.

**Content:**
- Success/failure status with icon
- Total formulation cost
- Quality score with visual indicator
- Ingredient breakdown (table: ingredient, percentage, cost)
- Achieved nutritional profile (comparison with constraints)
- Warnings (if any)
- Action buttons: "Save as Feed", "Export PDF", "Adjust Constraints"

---

#### [NEW] [constraint_template_dialog.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/optimizer/widget/constraint_template_dialog.dart)

Dialog for selecting pre-defined constraint templates.

**Templates:**
- NRC 2012 Swine (by growth stage)
- NRC 2016 Poultry (by type and age)
- CVB 2021 standards
- Custom saved templates

---

### Integration Points

#### [MODIFY] [main_provider.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/main/providers/main_provider.dart)

Add navigation to the Optimizer screen from the main menu.

**Changes:**
- Add "Feed Optimizer" menu item to drawer
- Add route handling for optimizer screen
- Add icon: `Icons.auto_awesome` (to represent AI/automation)

---

#### [MODIFY] [ingredients_provider.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/add_ingredients/provider/ingredients_provider.dart)

Expose ingredient data for optimizer consumption.

**Changes:**
- Add `getAvailableIngredientsForOptimization()` method
- Add `getIngredientNutrientValue(ingredientId, nutrientName)` helper
- Ensure all nutritional data is accessible programmatically

---

#### [MODIFY] [current_price_provider.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/features/price_management/provider/current_price_provider.dart)

Provide pricing data to the optimizer.

**Changes:**
- Add `getPricesForIngredients(List<int> ingredientIds)` method
- Return Map<int, double> of current prices
- Handle missing prices gracefully (return null or default)

---

#### [NEW] [optimizer_route.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/src/core/routing/optimizer_route.dart)

GoRouter route configuration for optimizer screens.

**Routes:**
- `/optimizer` - Main optimizer screen
- `/optimizer/results/:id` - View saved optimization results
- `/optimizer/templates` - Manage constraint templates

---

### Localization

#### [MODIFY] All Language ARB Files

Add translations for all optimizer UI strings to all 8 supported language files:

**Files to Update:**
- [app_en.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_en.arb) - English (template)
- [app_es.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_es.arb) - Spanish
- [app_pt.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_pt.arb) - Portuguese
- [app_fr.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_fr.arb) - French
- [app_sw.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_sw.arb) - Swahili
- [app_yo.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_yo.arb) - Yoruba
- [app_fil.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_fil.arb) - Filipino
- [app_tl.arb](file:///c:/dev/feed_estimator/redesigned-feed-app/lib/l10n/app_tl.arb) - Tagalog

**New Keys to Add (English):**
- `optimizerTitle`: "Feed Formulation Optimizer"
- `optimizerDescription`: "Automatically generate optimal feed formulations"
- `optimizerMenuTitle`: "Feed Optimizer"
- `addConstraint`: "Add Constraint"
- `selectIngredients`: "Select Ingredients"
- `selectAnimalType`: "Select Animal Type"
- `optimizeButton`: "Optimize Formulation"
- `optimizationSuccess`: "Optimization completed successfully!"
- `optimizationFailed`: "Unable to find a valid formulation"
- `noFeasibleSolution`: "No formulation meets all constraints"
- `constraintType`: "Constraint Type"
- `minimumValue`: "Minimum"
- `maximumValue`: "Maximum"
- `exactValue`: "Exact"
- `nutrientName`: "Nutrient"
- `constraintValue`: "Value"
- `loadTemplate`: "Load Template"
- `saveTemplate`: "Save Template"
- `customTemplate`: "Custom Template"
- `ingredientPrice`: "Price per kg"
- `useCurrentPrices`: "Use Current Prices"
- `inclusionLimit`: "Inclusion Limit"
- `optimizationObjective`: "Optimization Objective"
- `minimizeCost`: "Minimize Cost"
- `maximizeProtein`: "Maximize Protein"
- `maximizeEnergy`: "Maximize Energy"
- `totalCost`: "Total Cost"
- `qualityScore`: "Quality Score"
- `ingredientBreakdown`: "Ingredient Breakdown"
- `achievedNutrients`: "Achieved Nutrients"
- `saveAsFeed`: "Save as Feed"
- `adjustConstraints`: "Adjust Constraints"
- `conflictingConstraints`: "Conflicting constraints detected"
- `invalidConstraint`: "Invalid constraint"
- `optimizationInProgress`: "Optimizing formulation..."
- `optimizedBadge`: "Optimized"

**Translation Process:**
1. Add all English keys to `app_en.arb` first
2. Translate to Spanish (`app_es.arb`)
3. Translate to Portuguese (`app_pt.arb`)
4. Translate to French (`app_fr.arb`)
5. Translate to Swahili (`app_sw.arb`)
6. Translate to Yoruba (`app_yo.arb`)
7. Translate to Filipino (`app_fil.arb`)
8. Translate to Tagalog (`app_tl.arb`)
9. Run localization generation: `flutter gen-l10n`

---

### Testing

#### [NEW] [formulation_optimizer_test.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/test/unit/formulation_optimizer_test.dart)

Unit tests for the core optimization algorithm.

**Test Cases:**
- Simple 2-ingredient optimization (corn + soybean meal)
- Complex multi-ingredient optimization (7+ ingredients)
- Infeasible problem detection (contradictory constraints)
- Inclusion limit enforcement
- Cost minimization accuracy
- Constraint satisfaction verification

---

#### [NEW] [constraint_validator_test.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/test/unit/constraint_validator_test.dart)

Unit tests for constraint validation logic.

**Test Cases:**
- Valid constraint acceptance
- Invalid constraint rejection (min > max)
- Conflicting constraints detection
- Result validation against constraints

---

#### [NEW] [optimizer_integration_test.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/test/integration/optimizer_integration_test.dart)

Integration tests for complete optimization workflows.

**Test Cases:**
- End-to-end optimization: request → solve → save as feed
- Integration with ingredient database
- Integration with pricing system
- Optimized feed can be analyzed and exported
- Optimized feed appears in feed list

---

#### [NEW] [optimizer_widget_test.dart](file:///c:/dev/feed_estimator/redesigned-feed-app/test/widget/optimizer_widget_test.dart)

Widget tests for optimizer UI components.

**Test Cases:**
- Constraint input widget renders correctly
- Adding/removing constraints updates state
- Ingredient selection updates request
- Optimization button triggers optimization
- Results display correctly

---

## Verification Plan

### Automated Tests

#### Unit Tests
```bash
# Run all optimizer unit tests
flutter test test/unit/formulation_optimizer_test.dart
flutter test test/unit/constraint_validator_test.dart
flutter test test/unit/formulation_scorer_test.dart
```

**Expected Results:**
- All test cases pass
- Code coverage > 80% for core optimization logic
- Edge cases handled correctly (infeasible solutions, empty constraints, etc.)

---

#### Integration Tests
```bash
# Run optimizer integration tests
flutter test test/integration/optimizer_integration_test.dart
```

**Expected Results:**
- Complete optimization workflow succeeds
- Optimized feeds are correctly saved to database
- Integration with existing features (ingredients, pricing, feeds) works seamlessly

---

#### Widget Tests
```bash
# Run optimizer widget tests
flutter test test/widget/optimizer_widget_test.dart
```

**Expected Results:**
- All UI components render without errors
- User interactions update state correctly
- Form validation works as expected

---

### Manual Verification

#### Test Scenario 1: Simple Pig Grower Formulation

**Objective:** Verify the optimizer can create a basic pig grower formulation.

**Steps:**
1. Launch the app and navigate to "Feed Optimizer" from the main menu
2. Select "Pig" as animal type
3. Click "Load Template" → "NRC 2012 Pig Grower (20-50 kg)"
4. Verify constraints are populated:
   - Crude Protein: 16-18%
   - NE: 2300-2450 kcal/kg
   - SID Lysine: 0.95-1.05%
5. Select ingredients: Corn, Soybean Meal, Wheat Bran, Limestone, Dicalcium Phosphate
6. Set prices (or use "Load Current Prices")
7. Choose objective: "Minimize Cost"
8. Click "Optimize Formulation"
9. Verify results display:
   - Success message
   - Ingredient proportions (should be reasonable, e.g., 60% corn, 25% soybean meal, etc.)
   - Total cost calculated
   - Nutritional profile meets all constraints
10. Click "Save as Feed" and verify feed is saved
11. Navigate to feed list and verify optimized feed appears with "Optimized" badge

**Expected Outcome:** Optimization completes in < 5 seconds, produces a valid formulation meeting all constraints, and can be saved successfully.

---

#### Test Scenario 2: Infeasible Formulation

**Objective:** Verify the optimizer correctly detects impossible formulations.

**Steps:**
1. Navigate to Feed Optimizer
2. Select "Pig" as animal type
3. Add contradictory constraints:
   - Crude Protein: MIN 25%
   - Crude Protein: MAX 15%
4. Select ingredients: Corn only
5. Click "Optimize Formulation"
6. Verify error message: "No formulation meets all constraints"
7. Verify suggestions are provided (e.g., "Remove conflicting constraints")

**Expected Outcome:** Optimizer detects infeasibility and provides helpful error message.

---

#### Test Scenario 3: Cost Comparison

**Objective:** Verify cost optimization actually minimizes cost.

**Steps:**
1. Create two formulations manually:
   - Formulation A: 70% Corn, 30% Soybean Meal
   - Formulation B: 50% Corn, 40% Soybean Meal, 10% Wheat
2. Note the costs of each
3. Use optimizer with same constraints but "Minimize Cost" objective
4. Compare optimized formulation cost with manual formulations
5. Verify optimized cost is lower or equal

**Expected Outcome:** Optimizer produces a formulation with cost ≤ manual formulations.

---

#### Test Scenario 4: Multi-Language Localization

**Objective:** Verify all optimizer UI is properly translated across all 8 supported languages.

**Steps:**
1. Change app language to Spanish (Settings → Language → Español)
2. Navigate to Feed Optimizer
3. Verify all text is in Spanish (screen title, buttons, labels, error messages)
4. Perform an optimization and verify result messages are in Spanish
5. Repeat steps 1-4 for each language:
   - Portuguese (Português)
   - French (Français)
   - Swahili (Kiswahili)
   - Yoruba (Yorùbá)
   - Filipino
   - Tagalog
6. Verify no English fallbacks appear in any language

**Expected Outcome:** All UI text displays correctly in all 8 languages with no English fallbacks.

---

### Performance Verification

**Test:** Optimize a formulation with 20 ingredients and 15 constraints.

**Command:**
```bash
# Run performance test
flutter test test/performance/optimizer_performance_test.dart
```

**Expected Results:**
- Optimization completes in < 10 seconds on mid-range device
- Memory usage remains stable (no memory leaks)
- UI remains responsive during optimization

---

### Regression Testing

After implementation, run existing test suites to ensure no regressions:

```bash
# Run all existing tests
flutter test

# Run existing integration tests
flutter test test/integration/formulation_workflow_test.dart
```

**Expected Results:**
- All existing tests continue to pass
- No breaking changes to existing features
- Feed analysis and reporting features work with optimized feeds

---

## Implementation Notes

### Dependencies to Add

```yaml
# pubspec.yaml
dependencies:
  # Linear Programming solver (choose one)
  simplex: ^1.0.0  # Option 1: Pure Dart LP solver
  # OR
  lpsolve: ^5.5.0  # Option 2: Native LP solver (better performance)
```

**Note:** This project uses regular Dart classes (not Freezed) for data models. All models will implement manual `toJson`/`fromJson` methods and `copyWith` patterns following the existing codebase architecture.

### Database Migration

The `Feed` model changes require an Isar schema migration:

```dart
// Migration code (to be added in appropriate location)
await isar.writeTxn(() async {
  final feeds = await isar.feeds.where().findAll();
  for (final feed in feeds) {
    feed.isOptimized = false;  // Default for existing feeds
    await isar.feeds.put(feed);
  }
});
```

### Constraint Templates Storage

Constraint templates will be stored as JSON files in `assets/optimizer_templates/`:
- `nrc_2012_swine.json`
- `nrc_2016_poultry.json`
- `cvb_2021.json`
- `user_custom.json` (user-created templates)

---

## Future Enhancements (Out of Scope for Phase 1)

- Multi-objective optimization (Pareto frontier)
- Sensitivity analysis (what-if scenarios)
- Batch optimization (optimize multiple formulations simultaneously)
- Machine learning-based formulation suggestions
- Integration with external ingredient price APIs
- Formulation comparison tool (compare multiple optimized formulations)
- Export optimization report as PDF

---

## Related Documentation

- [Task Breakdown](FEED_OPTIMIZER_TASKS.md) - Detailed task checklist for implementation
- [README.md](../README.md) - Main project documentation
- [PHASE_5_COMPREHENSIVE_ROADMAP.md](PHASE_5_COMPREHENSIVE_ROADMAP.md) - Overall project roadmap
