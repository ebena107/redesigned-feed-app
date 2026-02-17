# Phase 4 Quick Reference & Command Guide

**Current Status**: Phase 4.5 ✅ COMPLETE | Phase 4.5e 🟡 NEXT
**Last Update**: December 20, 2025
**Test Status**: 278/278 tests passing ✅
**Lint Status**: 0 errors/warnings ✅

---

## Quick Navigation

| Phase | Status | Duration | Priority | Docs |
|-------|--------|----------|----------|------|
| 4.5 | ✅ COMPLETE | 2-3h | ✅ | [Link](PHASE_4_5_PRICE_MANAGEMENT_IMPLEMENTATION.md) |
| 4.5e | 🟡 NEXT | 4-6h | ✅ | [Link](PHASE_4_5e_PRICE_MANAGEMENT_UI.md) |
| 4.6 | 📋 PLANNED | 8-12h | 📋 | [Link](PHASE_4_6_INGREDIENT_EXPANSION.md) |
| 4.2-4.4 | 📋 PLANNED | 8-10h | 📋 | [Link](PHASE_4_2_4_4_PERFORMANCE_OPTIMIZATION.md) |
| 4.7+ | 📋 PLANNED | 5-10h | 📋 | [Link](MODERNIZATION_PLAN.md) |

---

## Phase 4.5e Implementation Checklist

### Step 1: Price History View (1.5 hours)

```bash
# Create file
touch lib/src/features/price_management/view/price_history_view.dart

# Required imports
# - ConsumerWidget, WidgetRef (Riverpod)
# - PriceHistory model
# - priceHistoryProvider, priceUpdateNotifier
# - date formatting utilities
# - AppLogger, error handling

# Widget structure
# - AppBar with title
# - Loading state (spinner)
# - Error state (alert)
# - Empty state (message + icon)
# - ListView of price items (sorted by date DESC)
# - Each item: Date | Price | Currency | Source | Notes | Actions

# Key methods to implement
# - _buildPriceItem(): Single price list item
# - _formatDate(): Relative + absolute date display
# - _formatPrice(): Currency formatting
# - _showEditDialog(): Open edit dialog
# - _showDeleteConfirmation(): Confirm deletion
```

### Step 2: Price Edit Dialog (2 hours)

```bash
# Create file
touch lib/src/features/price_management/widget/price_edit_dialog.dart

# Dialog structure
# - ConsumerStatefulWidget for form state
# - TextEditingControllers for price field
# - Form validation with InputValidators
# - Fields:
#   1. Effective Date (dropdown/picker) - default: today
#   2. Price (numeric input) - validation: 0-1,000,000
#   3. Currency (dropdown) - NGN, USD, EUR, GBP
#   4. Source (radio) - user, system, market
#   5. Notes (text field) - optional, max 500 chars

# Key validation
# - Price: InputValidators.validatePrice()
# - Quantity: InputValidators.validateQuantity()
# - Date: cannot be future, must be valid

# Submit flow
# - Validate all fields
# - Show loading state
# - Call priceUpdateNotifier.recordPrice()
# - Handle success/error
# - Close dialog on success

# Example field:
# TextField(
#   controller: _priceController,
#   decoration: InputDecoration(
#     labelText: 'Price per Kg',
#     errorText: _priceError,
#   ),
#   inputFormatters: InputValidators.numericFormatters,
#   onChanged: (val) => _validatePrice(val),
# )
```

### Step 3: Price Trend Chart (1.5-2 hours)

```bash
# Create file
touch lib/src/features/price_management/widget/price_trend_chart.dart

# Dependencies
# - fl_chart: ^6.1.0 (already in pubspec)
# - List<PriceHistory> as input
# - Statistics calculation (min, max, avg, latest)

# Chart implementation
# - LineChart from fl_chart
# - X-axis: dates (formatted)
# - Y-axis: price values
# - Blue line with dots
# - Grid background for readability
# - Tooltips on hover (show exact values)

# Statistics display
# - Card with stats:
#   Latest: ₦100.50
#   Highest: ₦120.00 (date)
#   Lowest: ₦80.00 (date)
#   Average: ₦105.25

# Handle edge cases
# - No data: empty state message + icon
# - Single data point: just show value, no line
# - Large datasets (1000+ records): pagination or sampling
```

### Step 4: Integration Points

```bash
# Files to modify for integration

# 1. Ingredient selection screen
# lib/src/features/add_ingredients/view/ingredients_list.dart
# - Show current price badge
# - Add "Price History" button/action
# - Navigate to PriceHistoryView

# 2. Add/Update Feed screen
# lib/src/features/add_update_feed/view/add_update_feed.dart
# - Display currentPriceProvider value next to each ingredient
# - Color indicator (green=lower than default, red=higher)
# - Tap ingredient to open price history

# 3. Cost calculations
# lib/src/features/reports/providers/result_provider.dart
# OLD:
#   final ingredientPrice = ingredient.priceKg ?? 0;
#
# NEW:
#   final ingredientPrice = await ref.watch(
#     currentPriceProvider(ingredientId: ingredient.ingredientId?.toInt() ?? 0)
#   ).whenData((price) => price);
#   // fallback: ingredient.priceKg if no history

# 4. Navigation wiring
# - Add route to PriceHistoryView in routes.dart if not exists
# - Create navigation methods in screens
# - Handle state management (price updates trigger cost recalc)
```

### Step 5: Testing

```bash
# Run specific UI test file
flutter test test/unit/price_value_object_test.dart

# Run full unit suite (after all components)
flutter test test/unit/

# Manual UI testing
# 1. Select ingredient with price history
# 2. Open price history view → should list prices (newest first)
# 3. Click edit price → open dialog with form
# 4. Update price → see cost recalculate in feed view
# 5. Delete price record → confirm dialog, update history
# 6. View price chart → see trend line
# 7. No history scenario → fallback to ingredient.priceKg

# Lint check
flutter analyze

# Full test + lint cycle
flutter test test/unit/ && flutter analyze
```

---

## Useful Commands During Development

### Development Workflow

```bash
# Start dev session
cd c:/dev/feed_estimator/redesigned-feed-app

# Check current status
flutter analyze
flutter test test/unit/input_validators_test.dart  # Quick test

# Code generation (if needed)
dart run build_runner build --delete-conflicting-outputs

# Format code
dart format lib/src/features/price_management/

# Hot reload (after changes)
flutter run -d windows
# Then press 'r' for hot reload, 'R' for hot restart

# Full test suite
flutter test test/unit/

# Generate coverage
flutter test --coverage
```

### Database Testing (if needed)

```bash
# Check database schema
# File: lib/src/core/database/app_db.dart
# Look for tableCreateQuery and schema definitions

# Verify price_history table exists (v9+)
# Migration code in _runMigration() method
# Check _migrationV8ToV9() implementation
```

---

## Key Files for Phase 4.5e

### Already Complete (Phase 4.5)

```
lib/src/features/price_management/
├── model/
│   └── price_history.dart ✅
├── repository/
│   └── price_history_repository.dart ✅
└── provider/
    ├── price_history_provider.dart ✅
    ├── current_price_provider.dart ✅
    └── price_update_notifier.dart ✅
```

### To Create (Phase 4.5e)

```
lib/src/features/price_management/
├── view/
│   └── price_history_view.dart 🟡 TODO
└── widget/
    ├── price_edit_dialog.dart 🟡 TODO
    └── price_trend_chart.dart 🟡 TODO
```

### Reference Files (for patterns)

```
# Dialog example with proper lifecycle
lib/src/features/add_update_feed/widget/feed_ingredients.dart (L400-439)
  → Shows proper navigator/messenger capture before async

# Validation patterns
lib/src/core/utils/input_validators.dart
  → All validators with error messages

# Widget builder utilities
lib/src/core/utils/widget_builders.dart
  → Consistent UI component builders

# UI constants
lib/src/core/constants/ui_constants.dart
  → Spacing, dimensions, colors
```

---

## Common Patterns (Copy-Paste Templates)

### Dialog with Form Validation

```dart
class _PriceEditDialog extends ConsumerStatefulWidget {
  final int ingredientId;
  const _PriceEditDialog({required this.ingredientId});

  @override
  ConsumerState<_PriceEditDialog> createState() => _PriceEditDialogState();
}

class _PriceEditDialogState extends ConsumerState<_PriceEditDialog> {
  late TextEditingController _priceController;
  String? _priceError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _validatePrice(String value) {
    setState(() => _priceError = InputValidators.validatePrice(value));
  }

  Future<void> _handleSave() async {
    _validatePrice(_priceController.text);
    if (_priceError != null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(priceUpdateNotifier).recordPrice(
        ingredientId: widget.ingredientId,
        price: double.parse(_priceController.text),
        currency: 'NGN',
        effectiveDate: DateTime.now(),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar(context, 'Failed to save price');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Price'),
      content: TextField(
        controller: _priceController,
        decoration: InputDecoration(
          labelText: 'Price',
          errorText: _priceError,
        ),
        inputFormatters: InputValidators.numericFormatters,
        onChanged: _validatePrice,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _isLoading ? null : _handleSave, child: const Text('Save')),
      ],
    );
  }
}
```

### ListView with No Nesting

```dart
ListView.builder(
  itemExtent: 56.0,  // IMPORTANT: Fixed height for performance
  itemCount: items.length,
  itemBuilder: (context, index) => Material(
    child: InkWell(
      onTap: () => _handleTap(items[index]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(child: Text(items[index].name)),
            Text(items[index].price.toString()),
          ],
        ),
      ),
    ),
  ),
)
```

---

## Testing Patterns (Verify Implementation)

### Unit Test Template

```dart
void main() {
  group('PriceHistoryView Tests', () {
    testWidgets('displays price list correctly', (tester) async {
      final mockPrices = [
        PriceHistory(id: 1, ingredientId: 1, price: 100.0, ...),
        PriceHistory(id: 2, ingredientId: 1, price: 110.0, ...),
      ];

      await tester.pumpWidget(
        MaterialApp(home: PriceHistoryView(ingredientId: 1))
      );

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(PriceItem), findsWidgets);
    });
  });
}
```

---

## Next Session Planning

**Time Block**: 4-6 hours
**Goal**: Complete Phase 4.5e (Price Management UI)

```
Hour 0-1.5: Price History View
  - Create widget
  - Build list UI
  - Test with sample data

Hour 1.5-3.5: Price Edit Dialog
  - Create dialog widget
  - Build form
  - Add validation
  - Test form submission

Hour 3.5-5: Price Trend Chart
  - Create chart widget
  - Implement fl_chart integration
  - Add statistics display

Hour 5-6: Integration & Testing
  - Wire components together
  - Update cost calculations
  - Run full test suite
  - Lint check
  - Manual UI testing
```

**Success Criteria**:
- ✅ All 3 UI components created and working
- ✅ Cost calculations updated to use currentPriceProvider
- ✅ 350+ tests passing (25+ new tests)
- ✅ 0 lint errors/warnings
- ✅ Manual testing: full workflow works end-to-end

---

## Troubleshooting Guide

### Issue: "currentPriceProvider not found"

**Solution**: Import from correct location
```dart
import 'package:feed_estimator/src/features/price_management/provider/current_price_provider.dart';
```

### Issue: "TextField disposed before use"

**Solution**: Check dialog lifecycle in _PriceEditDialog example above (capture navigator before async)

### Issue: "ListView doesn't scroll smoothly"

**Solution**: Add `itemExtent` parameter
```dart
ListView.builder(
  itemExtent: 56.0,  // ← Critical!
  ...
)
```

### Issue: "Chart doesn't render data"

**Solution**: Verify data format (List<PriceHistory> with timestamps)
```dart
final chartData = prices.map((p) => FlSpot(
  p.effectiveDate.millisecondsSinceEpoch.toDouble(),
  p.price.toDouble(),
)).toList();
```

### Issue: "Tests failing with 'Bad state: Tried to read uninitialized provider'"

**Solution**: Use ProviderContainer in tests
```dart
final container = ProviderContainer();
addTearDown(container.dispose);
final result = await container.read(provider);
```

---

## Quick Links

- **Source Code**: `lib/src/features/price_management/`
- **Tests**: `test/unit/` (reference tests: price_value_object_test.dart)
- **Database**: `lib/src/core/database/app_db.dart` (v9 migration)
- **Constants**: `lib/src/core/constants/ui_constants.dart`
- **Validators**: `lib/src/core/utils/input_validators.dart`
- **Widget Builders**: `lib/src/core/utils/widget_builders.dart`
- **Logging**: `lib/src/core/utils/logger.dart`

---

**Last Updated**: December 20, 2025  
**By**: GitHub Copilot  
**Status**: Ready for Phase 4.5e implementation  
**Next Check**: After completion of Phase 4.5e components
