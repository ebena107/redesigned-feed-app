# Phase 5: Feature Expansion & Polish - Comprehensive Implementation Roadmap

## Executive Summary

Phase 5 builds on the stable Phase 4 (UI Trust Signals) and Phase 4.5 (Price Management) foundation to deliver 5 major feature expansions and production readiness. Target completion: 2-3 weeks with iterative releases.

**Current State**: Baseline established
- ✅ Phase 4 Complete: Production stage selector, standards indicators, ingredient details UI
- ✅ Phase 4.5 Complete: Price history view integrated into StoredIngredients (add/edit/delete prices, multi-currency)
- ✅ Test Baseline: 355 passing tests, 7 skipped, 4 pre-existing failures
- ✅ Code Quality: 0 new errors, 1 pre-existing info-level lint (unnecessary_library_name in animal_categories.dart)

---

## Phase 5.1: Bulk Ingredient Import (CSV/Excel)

### Objective

Enable farmers to import ingredient datasets via CSV (NRC, CVB, INRA formats) or upload own ingredient libraries.

### Architecture

```
lib/src/features/import_export/
├── model/
│   ├── import_wizard_state.dart      # StepperState, MappingConfig
│   ├── csv_row.dart                  # CSVRow (raw data), CSVParsed (typed)
│   ├── conflict_resolution.dart      # Conflict types, MergeStrategy
│   └── import_result.dart            # ImportResult with stats
├── provider/
│   ├── import_wizard_provider.dart   # NotifierProvider<ImportWizardNotifier>
│   ├── csv_parser_provider.dart      # @riverpod for async parsing
│   └── conflict_resolver_provider.dart # Conflict detection & resolution
├── repository/
│   └── csv_import_repository.dart    # CsvImportRepository extends Repository
├── service/
│   ├── csv_parser_service.dart       # parseCSVFile(), detectFormat()
│   ├── conflict_detector.dart        # findDuplicates(), suggestMerges()
│   └── ingredient_mapper.dart        # mapCSVRowToIngredient()
└── view/
    ├── import_wizard_screen.dart     # 3-step stepper UI
    ├── step_1_file_selection.dart    # File picker, format detection
    ├── step_2_data_preview.dart      # Table preview, column mapping
    └── step_3_conflict_resolution.dart # Conflict list, merge options
```

### Implementation Steps

#### Step 1.1: CSV Parser Service

**File**: `lib/src/features/import_export/service/csv_parser_service.dart`

```dart
/// Detects and parses CSV files with auto-format detection
class CsvParserService {
  /// Auto-detect NRC/CVB/INRA format by header row
  /// Returns: (headers, rows, detectedFormat)
  static (List<String>, List<List<String>>, String) parseCSV(
    String filePath,
  ) {
    // Read file
    // Detect format by headers: 
    //   NRC: "Ingredient Name", "Crude Protein", "ME (Growing Pig)"
    //   CVB: "Name", "Crude protein", "Net Energy"
    //   INRA: "Name", "Crude protein %", "NE pig (kcal/kg)"
    // Normalize headers to standard names
    // Parse data rows
  }

  /// Map CSV column names to Ingredient fields
  /// Returns: Map<String, String> (csvColumnName -> ingredientField)
  static Map<String, String> detectColumnMapping(List<String> headers) {
    const standardCols = {
      'name': ['ingredient name', 'name', 'ingredient'],
      'crudeProtein': ['crude protein', 'protein %', 'cp %'],
      'lysine': ['lysine', 'lys', 'amino acid lysine'],
      'priceKg': ['price', 'cost per kg', 'price/kg'],
      'meGrowingPig': ['me growing pig', 'me pig', 'eme pig (kcal/kg)'],
    };
    // Smart matching with fuzzy similarity
  }

  /// Validate parsed data for common errors
  /// Returns: List<ValidationError> (empty if valid)
  static List<ValidationError> validateRows(List<CSVRow> rows) {
    // Check: duplicate names, missing required fields, value ranges
  }
}
```

**Key Considerations**:
- Support CSV/TSV/XLS via `csv` package
- Auto-detect by header row (NRC "ME (Growing Pig)" vs INRA "NE pig")
- Fuzzy header matching for typos
- Return parsed CSVRow objects with validation errors

#### Step 1.2: Conflict Detection & Resolution

**File**: `lib/src/features/import_export/service/conflict_detector.dart`

```dart
/// Finds duplicate ingredients and suggests merge strategies
class ConflictDetector {
  /// Identify duplicates by name similarity (85%+ match)
  /// Also check: same protein value, similar price
  /// Returns: List<ConflictPair> (importedIng ↔ existingIng)
  static List<ConflictPair> findDuplicates(
    List<Ingredient> importedList,
    List<Ingredient> existingList,
  ) {
    // Levenshtein distance for name matching
    // Score duplicates by likelihood
  }

  /// Suggest merge action: skip, replace, merge (combine fields)
  /// User chooses per conflict in UI
  /// Returns: Map<String, MergeStrategy>
  static Map<int, MergeStrategy> suggestMergeStrategies(
    List<ConflictPair> conflicts,
  ) {
    // For each conflict:
    //   If names very similar (95%+) → REPLACE (new values)
    //   If only prices different → SKIP (keep existing)
    //   If nutrients different → MERGE (flag for review)
  }
}

enum MergeStrategy { skip, replace, merge }
```

#### Step 1.3: Import Wizard UI (3-step Stepper)

**File**: `lib/src/features/import_export/view/import_wizard_screen.dart`

**Step 1: File Selection**
```dart
/// File picker → auto-detect format → preview first 5 rows
class _FileSelectionStep extends ConsumerWidget {
  // Uses file_picker or FilePicker.platform
  // Shows: detected format (NRC/CVB/INRA), file size, row count
  // Button: "Continue to Mapping"
}
```

**Step 2: Column Mapping**
```dart
/// Show CSV headers → allow custom mapping to Ingredient fields
/// Preview 10 rows in table format
class _DataPreviewStep extends ConsumerStatefulWidget {
  // Dropdown for each column: "Select field..."
  // Defaults populated by detectColumnMapping()
  // Show data table preview (10 rows)
  // Validation: required fields present?
  // Button: "Continue to Conflicts"
}
```

**Step 3: Conflict Resolution**
```dart
/// List conflicts found during import
/// User chooses action per conflict: skip/replace/merge
class _ConflictResolutionStep extends ConsumerWidget {
  // Show conflict cards in list
  // Each card: imported name + existing name + similarity %
  // Action buttons for each: [Skip] [Replace] [Merge]
  // Summary: "X duplicates, Y new ingredients to add"
  // Button: "Import"
}
```

### Testing

**Test File**: `test/integration/csv_import_integration_test.dart`

```dart
void main() {
  group('CSV Import Integration', () {
    test('NRC format parsing and column detection', () async {
      // Load test/fixtures/nrc_sample.csv
      // Parse and verify headers detected correctly
      // Verify ingredient fields populated
    });

    test('Conflict detection finds duplicate fish meal', () async {
      // Create existing: "Fish Meal" (crude_protein: 60)
      // Import: "Fish Meal (salted)" (crude_protein: 58)
      // Should detect 95%+ name similarity
    });

    test('End-to-end import with conflict resolution', () async {
      // Load CSV, detect conflicts, skip duplicates, import new
      // Verify only new ingredients added to DB
    });
  });
}
```

---

## Phase 5.2: Advanced Reporting & What-If Analysis

### Objective

Enable farmers to analyze cost drivers, perform scenario modeling, and generate batch reports.

### Architecture

```
lib/src/features/advanced_reporting/
├── model/
│   ├── cost_breakdown.dart        # CostBreakdownReport (per ingredient)
│   ├── batch_calculation.dart     # BatchCalculation (multiple feeds)
│   ├── what_if_result.dart        # WhatIfResult (cost/nutrient impact)
│   └── scenario.dart              # Scenario (feed with modifications)
├── provider/
│   ├── cost_breakdown_provider.dart    # AsyncNotifier for cost analysis
│   ├── batch_calculator_provider.dart  # Async batch calculations
│   └── what_if_analyzer_provider.dart  # Scenario modeling
├── service/
│   ├── cost_breakdown_service.dart # Ingredient-level cost attribution
│   ├── what_if_analyzer.dart       # Re-calculate with % changes
│   ├── batch_calculator.dart       # Multiple feed calculations
│   └── report_exporter.dart        # PDF/CSV export
└── view/
    ├── cost_breakdown_screen.dart  # Bar chart + table
    ├── what_if_screen.dart         # Slider UI for % modifications
    ├── batch_calculator_screen.dart # Multiple formulations at once
    └── report_viewer.dart          # PDF preview + export options
```

### Implementation Steps

#### Step 2.1: Cost Breakdown Service

**File**: `lib/src/features/advanced_reporting/service/cost_breakdown_service.dart`

```dart
/// Analyzes cost attribution to each ingredient
class CostBreakdownService {
  /// Calculate per-ingredient costs
  /// Returns: List<CostItem> sorted by cost descending
  /// CostItem: ingredientName, qty, pricePerKg, totalCost, % of total
  static List<CostItem> analyzeCostBreakdown(
    List<FeedIngredients> feedIngredients,
    double totalQuantity,
  ) {
    // For each ingredient:
    //   Calculate: cost = quantity * priceUnitKg
    //   Calculate: percentage = cost / totalCost * 100
    // Sort by cost descending
    // Add total row
  }

  /// Find cost-saving opportunities
  /// E.g. "Replace 10% soybean with peas → save 5%"
  /// Returns: List<Suggestion>
  static List<CostSavingSuggestion> findOptimizations(
    List<CostItem> breakdown,
    Map<num, Ingredient> ingredientCache,
  ) {
    // Identify expensive ingredients (>20% of cost)
    // Find cheaper alternatives with similar protein
    // Calculate potential savings if substituted
  }
}

class CostItem {
  final String ingredientName;
  final double quantity;
  final double pricePerKg;
  final double totalCost;
  final double percentageOfTotal;
  final int rank; // 1=most expensive
  
  String get formattedCost => '₦${totalCost.toStringAsFixed(2)}';
  String get formattedPercentage => '${percentageOfTotal.toStringAsFixed(1)}%';
}
```

#### Step 2.2: What-If Analyzer

**File**: `lib/src/features/advanced_reporting/service/what_if_analyzer.dart`

```dart
/// Scenario modeling for ingredient substitution
class WhatIfAnalyzer {
  /// Re-calculate feed with modified ingredient percentages
  /// E.g. increase soybean from 20% → 25%, decrease maize from 40% → 35%
  /// Returns: (newResult, costDelta, proteinDelta, etc.)
  static WhatIfResult analyzeScenario({
    required List<FeedIngredients> originalFeedIngredients,
    required Map<num, double> percentageChanges, // ingredientId -> newPct
    required Map<num, Ingredient> ingredientCache,
  }) {
    // 1. Normalize percentage changes to total = 100%
    // 2. Calculate new quantities: totalQty * newPct
    // 3. Re-run EnhancedCalculationEngine
    // 4. Compare original vs new:
    //    - Cost delta: newCost - oldCost
    //    - Protein delta: newProtein - oldProtein
    //    - Feasibility: any inclusion violations?
    // 5. Return WhatIfResult with all deltas + warnings
  }

  /// Suggest optimal formulation for cost target
  /// E.g. "Find cheapest formulation that meets min protein"
  /// Returns: optimized FeedIngredients list
  static List<FeedIngredients> optimizeForCost({
    required double targetCost,
    required double minProtein,
    required List<Ingredient> availableIngredients,
  }) {
    // Iterative solver: start with cheapest ingredients
    // Adjust percentages to meet protein constraint
    // Return optimized formulation
  }
}

class WhatIfResult {
  final Result originalResult;
  final Result newResult;
  final double costDelta; // positive = more expensive
  final double proteinDelta;
  final double lysineD elta;
  final List<String> inclusionWarnings;
  final bool isFeasible;
  
  // Formatted display
  String get costDeltaDisplay =>
      costDelta > 0 ? '+₦${costDelta.toStringAsFixed(2)}' : '₦${costDelta.toStringAsFixed(2)}';
  String get proteinDeltaDisplay =>
      proteinDelta > 0 ? '+${proteinDelta.toStringAsFixed(2)}%' : '${proteinDelta.toStringAsFixed(2)}%';
}
```

#### Step 2.3: Report Exporter

**File**: `lib/src/features/advanced_reporting/service/report_exporter.dart`

```dart
/// Export reports to PDF or CSV
class ReportExporter {
  /// Generate PDF with cost breakdown chart, table, recommendations
  /// Includes: feed formulation, nutrient composition, cost analysis
  static Future<Uint8List> exportToPDF({
    required String feedName,
    required Result result,
    required List<CostItem> costBreakdown,
    required List<CostSavingSuggestion> suggestions,
  }) async {
    // Use pdf package to create report
    // Page 1: Feed summary + nutrient table
    // Page 2: Cost breakdown (bar chart + table)
    // Page 3: Suggestions + recommendations
    // Return PDF bytes
  }

  /// Export to CSV for Excel analysis
  static String exportToCSV({
    required List<CostItem> costBreakdown,
    required List<FeedIngredients> feedIngredients,
  }) {
    // CSV format:
    // Ingredient,Quantity (kg),Price/kg,Total Cost,% of Total
    // [rows]
    // Total,,,cost,100%
    return csvContent;
  }
}
```

### UI Components

**Cost Breakdown Screen**:
- Top: Total cost card + cost per kg
- Middle: Bar chart (ingredient costs)
- Bottom: Table with ingredient details
- Action: "Export PDF" button

**What-If Screen**:
- Sliders for top 5 ingredients (adjust %)(
- Real-time result update
- Show: cost delta, protein delta, warnings
- Button: "Apply Changes" or "Reset"

### Testing

**Test File**: `test/integration/advanced_reporting_integration_test.dart`

```dart
void main() {
  group('Cost Breakdown Analysis', () {
    test('analyzes ingredient costs and percentages', () async {
      // Create feed with 3 ingredients
      // Verify breakdown sums to total cost
      // Verify percentages sum to 100%
    });

    test('identifies cost-saving opportunities', () async {
      // Create feed with expensive ingredient
      // Should suggest cheaper alternative
    });
  });

  group('What-If Analysis', () {
    test('re-calculates with ingredient substitution', () async {
      // Increase soybean 20% → 25%
      // Decrease maize 40% → 35%
      // Verify: new cost calculated, new protein calculated
    });

    test('detects inclusion violations in scenario', () async {
      // Try scenario with cottonseed 20% (max 15%)
      // Should return warning in WhatIfResult
    });
  });
}
```

---

## Phase 5.3: Inventory Management

### Objective

Track ingredient stock levels, predict shortages, suggest FIFO ordering.

### Architecture

```
lib/src/features/inventory_management/
├── model/
│   ├── inventory_item.dart        # InventoryItem (stock tracking)
│   ├── stock_alert.dart           # StockAlert (low stock, expiry)
│   └── batch_lot.dart             # BatchLot (quantity, expiryDate, supplier)
├── provider/
│   ├── inventory_provider.dart    # NotifierProvider for inventory state
│   ├── stock_alert_provider.dart  # AsyncNotifier for alert generation
│   └── lot_tracking_provider.dart # Lot-level stock management
├── repository/
│   └── inventory_repository.dart  # CRUD for inventory
├── service/
│   ├── stock_alert_service.dart   # Generate low-stock alerts
│   ├── fifo_calculator.dart       # FIFO lot ordering
│   └── consumption_predictor.dart # Predict stock depletion
└── view/
    ├── inventory_dashboard.dart   # Stock overview + alerts
    ├── inventory_detail_screen.dart # Per-ingredient stock view
    ├── stock_alert_list.dart      # Alerts with dismiss/snooze
    └── batch_entry_form.dart      # Log new stock batch
```

### Implementation Steps

#### Step 3.1: Inventory Model & Repository

**File**: `lib/src/features/inventory_management/model/inventory_item.dart`

```dart
class InventoryItem {
  final int inventoryId;
  final int ingredientId;
  final double currentQty; // kg
  final double minThreshold; // kg
  final double maxCapacity; // kg
  final DateTime lastUpdated;
  
  // Derived fields
  bool get isLowStock => currentQty < minThreshold;
  double get stockPercentage => (currentQty / maxCapacity * 100).clamp(0, 100);
}

class BatchLot {
  final int lotId;
  final int inventoryId;
  final double quantity; // kg
  final DateTime dateReceived;
  final DateTime? expiryDate;
  final String? supplier;
  final double? costPerKg;
  final String? batchNumber;
  
  bool get isExpired => expiryDate != null && expiryDate!.isBefore(DateTime.now());
  int get daysUntilExpiry => expiryDate?.difference(DateTime.now()).inDays ?? 999;
}
```

**File**: `lib/src/features/inventory_management/repository/inventory_repository.dart`

```dart
class InventoryRepository implements Repository {
  static const tableName = 'inventory';
  static const lotsTableName = 'inventory_lots';
  
  // CRUD for inventory items
  Future<int> createInventoryItem(InventoryItem item) async { }
  Future<InventoryItem?> getInventoryByIngredient(int ingredientId) async { }
  Future<void> updateStock(int inventoryId, double newQuantity) async { }
  
  // Lot tracking
  Future<int> addBatchLot(BatchLot lot) async { }
  Future<List<BatchLot>> getLotsByInventory(int inventoryId) async { }
  Future<void> consumeFromLot(int lotId, double quantity) async { } // FIFO
}
```

#### Step 3.2: Stock Alert Service

**File**: `lib/src/features/inventory_management/service/stock_alert_service.dart`

```dart
/// Generates low-stock and expiry alerts
class StockAlertService {
  /// Find all low-stock or expiring items
  /// Returns: List<StockAlert> sorted by severity
  static List<StockAlert> generateAlerts(
    List<InventoryItem> inventoryItems,
    Map<int, List<BatchLot>> lotsMap,
  ) {
    final alerts = <StockAlert>[];
    
    for (final item in inventoryItems) {
      // Alert: Low stock
      if (item.isLowStock) {
        alerts.add(StockAlert(
          type: AlertType.lowStock,
          ingredientId: item.ingredientId,
          message: 'Only ${item.currentQty}kg remaining (min: ${item.minThreshold}kg)',
          severity: Severity.warning,
        ));
      }
      
      // Alert: Expiry (within 7 days)
      final lots = lotsMap[item.inventoryId] ?? [];
      for (final lot in lots) {
        if (lot.daysUntilExpiry >= 0 && lot.daysUntilExpiry <= 7) {
          alerts.add(StockAlert(
            type: AlertType.expiryWarning,
            ingredientId: item.ingredientId,
            message: 'Lot ${lot.batchNumber} expires in ${lot.daysUntilExpiry} days',
            severity: Severity.critical,
          ));
        }
      }
    }
    
    // Sort by severity
    alerts.sort((a, b) => b.severity.index.compareTo(a.severity.index));
    return alerts;
  }
  
  /// Predict when stock will be depleted
  /// Based on recent consumption rate
  /// Returns: DateTime when stock < minThreshold
  static DateTime? predictStockDepletion(
    InventoryItem item,
    List<StockConsumption> history,
  ) {
    // Calculate avg consumption per day from last 30 days
    // Extrapolate: currentQty / avgDailyConsumption = days remaining
  }
}

enum AlertType { lowStock, expiryWarning, orderDue }
enum Severity { info, warning, critical }

class StockAlert {
  final AlertType type;
  final int ingredientId;
  final String message;
  final Severity severity;
  final DateTime createdAt;
  
  bool get isDismissed => false; // Can add dismissal tracking
}
```

#### Step 3.3: FIFO Calculator

**File**: `lib/src/features/inventory_management/service/fifo_calculator.dart`

```dart
/// FIFO-based stock consumption
class FIFOCalculator {
  /// Consume stock from oldest lots first (FIFO)
  /// Updates lot quantities in database
  /// Returns: List<ConsumptionTransaction>
  static Future<List<ConsumptionTransaction>> consumeStock({
    required int inventoryId,
    required double quantity, // kg to consume
    required List<BatchLot> lots, // sorted by dateReceived ascending
    required InventoryRepository repo,
  }) async {
    double remaining = quantity;
    final transactions = <ConsumptionTransaction>[];
    
    // Iterate lots in FIFO order
    for (final lot in lots) {
      if (remaining <= 0) break;
      
      final consumed = min(remaining, lot.quantity);
      remaining -= consumed;
      
      // Update lot
      await repo.consumeFromLot(lot.lotId, consumed);
      
      transactions.add(ConsumptionTransaction(
        lotId: lot.lotId,
        quantityConsumed: consumed,
        date: DateTime.now(),
      ));
    }
    
    return transactions;
  }
}
```

### UI Components

**Inventory Dashboard**:
- Overview cards: Total items, Low stock count, Expiry warnings
- Alert list with color coding (red=critical, yellow=warning)
- Action: "Add Stock" button

**Inventory Detail Screen** (per ingredient):
- Current stock + min/max thresholds
- Stock bar chart (visual representation)
- Batch lots table: lot # | quantity | expiry | supplier
- Action: "Add Lot" button, "Consume" button (FIFO)

### Testing

```dart
void main() {
  group('Stock Alert Generation', () {
    test('generates low-stock alert when below threshold', () async {
      // Create inventory with min=50kg, current=30kg
      // Should generate low-stock alert
    });

    test('generates expiry warning within 7 days', () async {
      // Create lot expiring in 3 days
      // Should generate critical severity alert
    });
  });

  group('FIFO Consumption', () {
    test('consumes from oldest lot first', () async {
      // Create 3 lots: lot1(50kg, 2023-01-01), lot2(30kg, 2023-06-01)
      // Consume 60kg → should use all of lot1 + 10kg from lot2
    });
  });
}
```

---

## Phase 5.4: Localization & Accessibility

### Objective

Support Arabic, Yoruba, Hausa for Nigerian market; ensure WCAG AA compliance.

### Architecture

```
lib/src/core/localization/
├── l10n/                  # .arb files for translations
│   ├── app_en.arb         # English (base)
│   ├── app_ar.arb         # Arabic
│   ├── app_yo.arb         # Yoruba
│   └── app_ha.arb         # Hausa
├── localization_provider.dart    # Language selection provider
└── locale_switcher.dart          # UI to change language
```

### Implementation

#### Step 4.1: Setup intl & .arb Files

**pubspec.yaml**:
```yaml
dev_dependencies:
  intl: ^0.18.0
  intl_translation: ^0.17.0
```

**lib/src/core/localization/app_en.arb** (English base):
```json
{
  "appTitle": "Feed Estimator",
  "addFeed": "Add Feed Formulation",
  "saveFeed": "Save Feed",
  "pricePerKg": "Price per kg",
  "lowStockAlert": "Low stock alert for {ingredientName}",
  "@lowStockAlert": {
    "description": "Alert when ingredient stock below threshold",
    "placeholders": {
      "ingredientName": {"type": "String"}
    }
  }
}
```

**lib/src/core/localization/app_ar.arb** (Arabic):
```json
{
  "appTitle": "مُقَدِّرُ الأعلاف",
  "addFeed": "إضافة صيغة الأعلاف",
  "pricePerKg": "السعر لكل كجم"
}
```

**lib/src/core/localization/app_yo.arb** (Yoruba):
```json
{
  "appTitle": "Àwọn Anu-Eja Rèwà",
  "addFeed": "Fi ohun ìjèjú wá"
}
```

#### Step 4.2: Provider for Language Selection

**File**: `lib/src/core/localization/localization_provider.dart`

```dart
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Load saved locale from SharedPreferences
    // Default to English
    return const Locale('en', 'US');
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
    state = Locale(languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
```

#### Step 4.3: Accessibility Labels

**All interactive widgets must have semantic labels**:

```dart
// ❌ Before
IconButton(
  onPressed: () => _addPrice(),
  icon: const Icon(Icons.add),
)

// ✅ After
IconButton(
  onPressed: () => _addPrice(),
  icon: const Icon(Icons.add),
  tooltip: 'Add Price',
  semanticLabel: 'Add new price entry',
)

// ✅ Text inputs
TextField(
  decoration: InputDecoration(
    labelText: 'Price per kg',
    semanticLabel: 'Enter price per kilogram in currency units',
  ),
  onChanged: (value) => ref.read(provider.notifier).updatePrice(value),
)
```

#### Step 4.4: Color Contrast Compliance

**WCAG AA Minimum**: 4.5:1 for normal text, 3:1 for large text

**Verification**:
```dart
// Test color contrast ratio
Color primaryColor = AppConstants.mainAppColor; // #87643E
Color textColor = Colors.white;

double getContrastRatio(Color bg, Color fg) {
  // Calculate relative luminance
  // Return ratio (min 4.5 for AA)
}
```

### Testing

**Accessibility Tests**:
```dart
void main() {
  testWidgets('all buttons have semantic labels', (tester) async {
    await tester.pumpWidget(MyApp());
    
    final semantics = tester.getSemantics(find.byType(IconButton));
    expect(semantics.isButton, true);
    expect(semantics.label, isNotEmpty);
  });

  testWidgets('color contrast meets WCAG AA', (tester) async {
    // Verify primary color + white text ≥ 4.5:1
  });
}
```

**Localization Tests**:
```dart
void main() {
  testWidgets('switches language to Arabic', (tester) async {
    await tester.pumpWidget(MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'SA'),
        Locale('yo', 'NG'),
        Locale('ha', 'NG'),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        // ...
      ],
    ));
    
    // Find language selector and switch to Arabic
    // Verify text is now in Arabic
  });
}
```

---

## Phase 5.5: Performance Optimization

### Objective

Optimize memory usage, database queries, and UI rendering.

### Architecture

**Database Optimizations**:
- Add indexes on frequently queried columns
- Implement query result caching (30min TTL)
- Add pagination for large lists (50 items/page)

**Memory Optimizations**:
- Lazy load ingredient images
- Implement CircularLinkedHashMap for LRU cache
- Profile with DevTools

**UI Optimizations**:
- Use `const` constructors everywhere
- Extract widgets to avoid rebuilds
- Implement `RepaintBoundary` for expensive widgets

### Implementation

#### Step 5.1: Database Indexes

**File**: `lib/src/core/database/app_db.dart`

Add to migration:
```sql
CREATE INDEX idx_ingredient_id ON feed_ingredients(ingredient_id);
CREATE INDEX idx_feed_id ON feed_ingredients(feed_id);
CREATE INDEX idx_animal_id ON feeds(animal_id);
CREATE INDEX idx_ingredient_name ON ingredients(name);
```

#### Step 5.2: Query Caching

```dart
/// Cache query results with TTL
class QueryCache<T> {
  final Map<String, (T, DateTime)> _cache = {};
  final Duration ttl;

  T? get(String key) {
    final entry = _cache[key];
    if (entry == null) return null;
    
    if (DateTime.now().difference(entry.$2) > ttl) {
      _cache.remove(key);
      return null;
    }
    
    return entry.$1;
  }

  void set(String key, T value) {
    _cache[key] = (value, DateTime.now());
  }
}
```

#### Step 5.3: Widget Optimization

**Const Constructors**:
```dart
// ❌ Before
class IngredientCard extends StatelessWidget {
  final String name;
  
  IngredientCard(this.name);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(name),
    );
  }
}

// ✅ After
class IngredientCard extends StatelessWidget {
  final String name;
  
  const IngredientCard(this.name); // const constructor
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(name),
    );
  }
}
```

### Benchmarks

Target metrics:
- Memory usage: <150MB (typical device)
- Ingredient list scroll: 60fps (500+ items)
- Feed calculation: <100ms
- App startup: <2 seconds

---

## Phase 5.6: Release Preparation

### Objective

Production readiness: documentation, final testing, Play Store submission.

### Checklist

- [ ] Dartdoc for all public APIs (80%+ coverage)
- [ ] Final lint: `flutter analyze` = 0 errors
- [ ] Test coverage: `flutter test --coverage` = 80%+
- [ ] Version bump: `1.0.0+11` → `1.1.0+20` in pubspec.yaml
- [ ] Update RELEASE_NOTES.md with Phase 5 features
- [ ] Build APK: `flutter build apk --release`
- [ ] Sign APK (see android/key.properties)
- [ ] Upload to Google Play Console
- [ ] Update Play Store listing with new features

### Release Notes Template

```markdown
## Version 1.1.0 (Phase 5 Release)

### New Features
- **Bulk Import**: Import ingredients via CSV (NRC, CVB, INRA formats)
- **Cost Analysis**: Break down feed costs by ingredient
- **What-If Analysis**: Model ingredient substitutions
- **Inventory Management**: Track stock levels, expiry dates, FIFO consumption
- **Multi-Language**: Support for Arabic, Yoruba, Hausa
- **Accessibility**: WCAG AA compliance for screen readers

### Improvements
- Price history tracking with multi-currency support (Phase 4.5)
- Production stage selector for animal categories (Phase 4)
- Enhanced ingredient details with standard references (Phase 4)
- Performance optimizations: database indexing, query caching
- Better error handling and user feedback

### Bug Fixes
- Fixed [issue list from GitHub]
```

---

## Timeline & Resource Estimate

| Phase | Tasks | Est. Days | Priority |
|-------|-------|----------|----------|
| 5.1 | CSV Import + Conflict Resolution | 3-4 | HIGH |
| 5.2 | Cost Analysis + What-If | 2-3 | HIGH |
| 5.3 | Inventory Management | 2-3 | MEDIUM |
| 5.4 | Localization + Accessibility | 2-3 | MEDIUM |
| 5.5 | Performance Optimization | 1-2 | LOW |
| 5.6 | Release Preparation | 1 | CRITICAL |

**Total**: 11-16 days (2-3 weeks)

---

## Success Metrics

- ✅ 0 errors, 0 new warnings (lint)
- ✅ 80%+ test coverage
- ✅ <150MB memory usage
- ✅ 60fps scroll with 500+ ingredients
- ✅ 4.7+ Play Store rating
- ✅ 500+ installs (post-release)
- ✅ <3% crash rate

---

## Next Actions

1. **Start Phase 5.1** (Bulk Import):
   - Create CSV parser service
   - Implement conflict detection
   - Build 3-step import wizard UI

2. **Review & Prioritize**:
   - Assess market demand for each feature
   - Adjust timeline based on user feedback

3. **Test Early & Often**:
   - Unit tests for each service class
   - Integration tests for workflows
   - Manual testing on real devices

---

**Prepared for**: Production release targeting Africa market (Nigeria, Kenya, etc.)  
**Status**: Ready to commence Phase 5.1 implementation  
**Last Updated**: [Current Date]
