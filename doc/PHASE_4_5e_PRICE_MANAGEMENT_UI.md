# Phase 4.5e: Price Management UI Implementation

**Status**: 🟡 **IN PROGRESS**
**Estimated Duration**: 4-6 hours
**Priority**: HIGH (completes Phase 4.5 feature)
**Test Coverage Target**: 100% (add UI tests)

---

## Overview

Implement user-facing UI components for the price management system. Users will be able to:
- View historical prices for ingredients
- Edit/update prices with date and notes
- Visualize price trends over time
- See cost impact of price changes

---

## Implementation Plan

### Component 1: Price History View

**File**: `lib/src/features/price_management/view/price_history_view.dart`
**Complexity**: Medium
**Time**: 1.5 hours

**Features**:
- List of historical prices (most recent first)
- Date, price, currency, source display
- Edit/delete action buttons
- Loading/error states
- Empty state message
- Sorted by effective date (descending)

**UI Structure**:
```
┌─ AppBar: "Price History - [Ingredient Name]"
├─ [Loading Spinner] or [Error Alert] or [Empty Message]
└─ ListView of price records:
   ├─ Date (formatted)
   ├─ Price with currency
   ├─ Source badge (user/system/market)
   ├─ Notes (if available)
   └─ Action buttons (Edit, Delete)
```

**Key Methods**:
- Build price list item widget
- Format price with currency symbol
- Format date relative (e.g., "2 days ago") and absolute (Jan 15, 2025)
- Handle empty state
- Show confirm delete dialog

---

### Component 2: Price Edit Dialog

**File**: `lib/src/features/price_management/widget/price_edit_dialog.dart`
**Complexity**: Medium-High
**Time**: 2 hours

**Features**:
- Modal dialog for editing/creating prices
- Date picker (effective date)
- Numeric input with validation (InputValidators.validatePrice)
- Dropdown for source selection
- Text field for notes
- Submit/cancel buttons
- Loading indicator during save

**Form Fields**:
1. **Effective Date**
   - Dropdown/calendar picker
   - Default: today
   - Cannot be in future

2. **Price**
   - Numeric input
   - Format with InputValidators.numericFormatters
   - Validation: 0-1,000,000 range
   - Show error inline

3. **Currency** (optional)
   - Dropdown: NGN, USD, EUR, GBP, INR, etc.
   - Default: NGN

4. **Source** (optional)
   - Radio/dropdown: user, system, market
   - Default: user

5. **Notes** (optional)
   - Text field (max 500 chars)
   - For audit trail/tracking

**Dialog Structure**:
```
┌─ Title: "Update Price" or "Record Price"
├─ [Price History Form]
│  ├─ Effective Date: [Picker]
│  ├─ Price: [TextInput] 100.50
│  ├─ Currency: [Dropdown] NGN
│  ├─ Source: [Radio] ○ User ○ System ○ Market
│  └─ Notes: [TextField] Optional notes...
└─ Actions: [Cancel] [Save]
   (with loading spinner on Save)
```

---

### Component 3: Price Trend Chart

**File**: `lib/src/features/price_management/widget/price_trend_chart.dart`
**Complexity**: High
**Time**: 1.5-2 hours

**Features**:
- Line chart showing price over time
- X-axis: dates
- Y-axis: price
- Hover tooltips showing exact values
- Legend with price stats (min, max, avg)
- Responsive sizing
- No-data empty state

**Chart Data**:
```
Dependencies:
- fl_chart: ^6.1.0 (already in pubspec)

Chart Type: LineChart
- Blue line for price trend
- Dots at each data point
- Grid background
- Scrollable for wide date ranges
```

**Stats Display**:
```
╔═══════════════════════════╗
║ Price Trend Analysis      ║
║ Latest:  ₦100.50          ║
║ Highest: ₦120.00 (Jan 20) ║
║ Lowest:  ₦80.00 (Dec 10)  ║
║ Average: ₦105.25          ║
╚═══════════════════════════╝
```

---

### Component 4: Integration Points

**A. Ingredient Selection Screen**
**File**: `lib/src/features/add_ingredients/view/`

Update ingredient list to show:
- Current price prominently
- Badge if price differs from default ("Updated" or price change %)
- "Price History" action button (icon or text)

**B. Add/Update Feed Screen**
**File**: `lib/src/features/add_update_feed/view/`

Show current price next to each ingredient:
- Display: currentPriceProvider value
- Color indicator if differs from default (green=lower, red=higher)
- Tap to open price history

**C. Cost Calculation**
**File**: `lib/src/features/reports/providers/result_provider.dart`

Update to use `currentPriceProvider` instead of `ingredient.priceKg`:
```dart
// OLD
final ingredientPrice = ingredient.priceKg ?? 0;

// NEW
final ingredientPrice = await ref.watch(
  currentPriceProvider(ingredientId: ingredient.ingredientId?.toInt() ?? 0)
).when(
  data: (price) => price,
  loading: () => ingredient.priceKg ?? 0,  // fallback while loading
  error: (_, __) => ingredient.priceKg ?? 0,  // fallback on error
);
```

---

## File Structure

```
lib/src/features/price_management/
├── model/
│   └── price_history.dart              ✅ (DONE in Phase 4.5)
├── repository/
│   └── price_history_repository.dart   ✅ (DONE in Phase 4.5)
├── provider/
│   ├── price_history_provider.dart     ✅ (DONE in Phase 4.5)
│   ├── current_price_provider.dart     ✅ (DONE in Phase 4.5)
│   └── price_update_notifier.dart      ✅ (DONE in Phase 4.5)
├── view/
│   └── price_history_view.dart         🟡 (TODO - 1.5 hours)
└── widget/
    ├── price_edit_dialog.dart          🟡 (TODO - 2 hours)
    └── price_trend_chart.dart          🟡 (TODO - 1.5-2 hours)
```

---

## Testing Strategy

### Unit Tests

- PriceHistory model: ✅ DONE
- Repository CRUD: ✅ DONE
- Providers: ✅ DONE
- Input validation: ✅ DONE
- **NEW**: Price formatting, chart data preparation

### Widget Tests

- **NEW**: Price history view rendering
- **NEW**: Price edit dialog form validation
- **NEW**: Chart rendering with sample data

### Integration Tests

- **NEW**: End-to-end: record price → view history → edit → see cost update
- **NEW**: Fallback when no history exists
- **NEW**: Multi-ingredient price tracking

### Manual Testing (UI Phase)

- [ ] Price history view displays correctly
- [ ] Edit dialog saves prices
- [ ] Chart renders properly
- [ ] Cost calculations update when price changes
- [ ] Fallback works when no history available
- [ ] Error messages are user-friendly
- [ ] Performance acceptable with 100+ price records

---

## Implementation Checklist

### Phase 4.5e-1: Price History View (1.5h)

- [ ] Create PriceHistoryView widget (ConsumerStatefulWidget)
- [ ] Build price list item UI
- [ ] Handle loading/error/empty states
- [ ] Add date formatting utilities
- [ ] Implement edit/delete actions
- [ ] Write unit tests for list rendering
- [ ] Test with sample data (5, 50, 500 records)

### Phase 4.5e-2: Price Edit Dialog (2h)

- [ ] Create PriceEditDialog (ConsumerStatefulWidget)
- [ ] Build form with all fields
- [ ] Implement validation (InputValidators integration)
- [ ] Add date picker
- [ ] Implement submit with loading state
- [ ] Add confirmation messages
- [ ] Handle errors gracefully
- [ ] Write form validation tests

### Phase 4.5e-3: Price Trend Chart (1.5-2h)

- [ ] Create PriceTrendChart widget
- [ ] Prepare chart data from price history
- [ ] Render line chart with fl_chart
- [ ] Add statistics display
- [ ] Handle no-data case
- [ ] Optimize for large datasets
- [ ] Add responsiveness

### Phase 4.5e-4: Integration (1h)

- [ ] Update ingredient selection screens
- [ ] Update cost calculations (currentPriceProvider)
- [ ] Add price history buttons to UI
- [ ] Wire up navigation flows
- [ ] Test end-to-end workflow

### Phase 4.5e-5: Testing & Polish (1h)

- [ ] Run full test suite (target: 350+ tests)
- [ ] Manual testing on all platforms
- [ ] Performance profiling
- [ ] Error message review
- [ ] Documentation updates

---

## Success Criteria

✅ **All 5 components implemented and tested**
- [ ] PriceHistoryView: Full-featured, tested, 500+ record capacity
- [ ] PriceEditDialog: Form validation, error handling, proper state management
- [ ] PriceTrendChart: Renders correctly, performant with large datasets
- [ ] Integration: Seamless workflow, cost calculations updated, fallbacks working
- [ ] Testing: 350+ unit tests passing, 0 lint errors

✅ **User Experience**
- [ ] Natural workflow: Select ingredient → View history → Edit price → See cost update
- [ ] Error messages: Clear, actionable, not technical
- [ ] Performance: Dialogs open <500ms, charts render <1s
- [ ] Accessibility: All buttons have tooltips, text readable, colors accessible

✅ **Code Quality**
- [ ] 0 lint errors/warnings
- [ ] All methods documented (dartdoc)
- [ ] Proper null safety
- [ ] Immutable widgets where possible
- [ ] No memory leaks (proper disposal)

---

## Estimated Timeline

| Component | Hours | Status |
|-----------|-------|--------|
| Price History View | 1.5 | 🟡 TODO |
| Price Edit Dialog | 2 | 🟡 TODO |
| Price Trend Chart | 1.5-2 | 🟡 TODO |
| Integration | 1 | 🟡 TODO |
| Testing & Polish | 1 | 🟡 TODO |
| **Total** | **7-7.5** | 🟡 |

**Start**: After Phase 4.5 application layer completion ✅
**End**: Target completion: +7-8 hours from start
**Milestones**:
- 2h: Price history view done
- 4h: Edit dialog done
- 5.5h: Chart done
- 6.5h: Integration done
- 7.5h: All tests passing, Phase 4.5 COMPLETE ✅

---

## Notes & Considerations

### Why These Components?

1. **Price History View**: Required to display historical data (core feature)
2. **Edit Dialog**: Required to modify prices (core feature)
3. **Price Trend Chart**: Nice-to-have for visualization (Phase 4.5 bonus)
4. **Integration**: Glue code to make feature usable in app

### Performance Optimization

- Lazy load charts (don't render if tab not visible)
- Paginate history list (show 20 at a time)
- Cache chart data (reuse unless history changes)
- Use `const` constructors where possible

### Accessibility

- Text contrast: WCAG AA compliant
- Button sizes: Minimum 48px (Material Design)
- Semantic labels: All interactive elements have labels
- Error messages: Clear, not color-only

### Backward Compatibility

- Falls back to ingredient.priceKg if no history
- Doesn't break existing cost calculations
- Legacy ingredients work unchanged
- Optional feature (doesn't require migration)

---

## References

- **Phase 4.5 Application Layer**: PHASE_4_5_PRICE_MANAGEMENT_IMPLEMENTATION.md
- **UI Constants**: `lib/src/core/constants/ui_constants.dart`
- **Input Validators**: `lib/src/core/utils/input_validators.dart`
- **Widget Builders**: `lib/src/core/utils/widget_builders.dart`
- **Price Value Object**: `lib/src/core/value_objects/price.dart`
- **Dialog Example**: `lib/src/features/add_update_feed/widget/feed_ingredients.dart`

---

**Status**: Ready to start implementation
**Next Phase After**: Phase 4.6 (Ingredient Database Expansion)
