# Phases 4.2-4.4: Performance & Memory Optimization

**Status**: 🟡 **PLANNED** (After Phase 4.5e completion)
**Priority**: MEDIUM (completes Phase 4 foundation)
**Estimated Duration**: 8-10 hours
**Target Metrics**: <2s startup, 60fps scrolling, <150MB memory

---

## Overview

Optimize codebase for performance across all platforms, focusing on:
- Memory usage (ingredient lists, history, reports)
- Query performance (database operations)
- Widget rebuild efficiency (unnecessary redraws)
- Startup time (cold launch)

**Current Baseline** (measured after Phase 4.5):
- Startup time: ~2.5s (target: <2s)
- Ingredient scroll FPS: 50-55 (target: 60fps locked)
- Memory peak: ~160MB (target: <150MB)
- Database query time: <100ms (baseline acceptable)

---

## Phase 4.2: Memory Optimization (3-4 hours)

### Task 4.2.1: Ingredient List Virtualization

**Time**: 1.5 hours
**Impact**: ~30MB memory savings

Current issue: All 245 ingredients loaded in memory at once

```dart
// BEFORE: O(n) memory for entire list
ListView(
  children: ingredients.map((i) => IngredientTile(i)).toList()
)

// AFTER: O(visible) memory with ListView.builder + itemExtent
ListView.builder(
  itemExtent: 56.0,  // Hint for scrolling performance
  itemCount: ingredients.length,
  itemBuilder: (context, index) => IngredientTile(ingredients[index])
)
```

**Files to Update**:
- `lib/src/features/add_ingredients/view/ingredients_list.dart`
- `lib/src/features/store_ingredients/view/stored_ingredient.dart`
- Any list view with >50 items

**Testing**:
- Scroll smoothly with 500+ ingredients
- Memory usage stable (not growing during scroll)
- No janky frame drops

### Task 4.2.2: Image Asset Optimization

**Time**: 1 hour
**Impact**: ~15MB size reduction + faster loads

Current: Animal images are large PNG files (300+ KB each)

```
Actions:
1. Compress existing images (PNG → WebP where possible)
2. Use lazy loading (load image only when displayed)
3. Cache images in memory with bounds
4. Add placeholder/skeleton loader

Before: 2.5MB images → After: 1.5MB
+ Lazy loading = faster startup
```

**Files**:
- `assets/images/` (compress all animal images)
- `lib/src/utils/widgets/animal_image_widget.dart` (NEW)

**Impact**: Startup time ~300ms faster

### Task 4.2.3: History/Result Caching

**Time**: 1-1.5 hours
**Impact**: ~20MB memory savings

Current issue: All price history loaded for every ingredient view

```dart
// Implement caching with size limits
final priceHistoryCache = LRUCache<int, List<PriceHistory>>(
  maxSize: 100,  // Keep 100 most-recent ingredients in cache
);

// Only load when accessed, evict old entries
final history = priceHistoryCache.get(ingredientId) 
  ?? await repository.getHistoryForIngredient(ingredientId);
```

**Benefit**: Reduces memory peak by 20MB, faster switching between ingredients

---

## Phase 4.3: Query & Database Optimization (3-4 hours)

### Task 4.3.1: Database Indexing

**Time**: 1 hour
**Impact**: 50-70% query speedup

Current: Basic queries without indexes

```sql
-- BEFORE: Full table scans
SELECT * FROM price_history 
WHERE ingredient_id = ?
ORDER BY effective_date DESC;  -- ~200ms with 5000 records

-- AFTER: Indexed queries
CREATE INDEX idx_price_history_ing_date 
ON price_history(ingredient_id, effective_date DESC);  -- ~10ms

CREATE INDEX idx_ingredients_name 
ON ingredients(name);  -- Search speedup

CREATE INDEX idx_feed_ingredients_feedid 
ON feed_ingredients(feed_id);  -- Feed loading speedup
```

**Query Optimization**:
```dart
// Bad: N+1 query problem
for (final feed in feeds) {
  feed.ingredients = await getIngredients(feed.id);  // Loop query!
}

// Good: Batch query
final ingredients = await getIngredientsByFeedIds(feedIds);
final feedIngredientMap = groupBy(ingredients, (i) => i.feedId);
for (final feed in feeds) {
  feed.ingredients = feedIngredientMap[feed.id];
}
```

**Files**:
- `lib/src/core/database/app_db.dart` (add indexes)
- `lib/src/features/main/repository/feed_ingredient_repository.dart` (batch queries)

### Task 4.3.2: Provider Caching Strategy

**Time**: 1-1.5 hours
**Impact**: 30-40% reduction in repeated calculations

Current: Some providers recalculate unnecessarily

```dart
// BEFORE: No caching
@riverpod
Future<List<Feed>> allFeeds(Ref ref) async {
  // This recalculates every time component rebuilds
  return ref.watch(feedRepository).getAll();
}

// AFTER: Cache with proper invalidation
@riverpod
Future<List<Feed>> allFeeds(Ref ref) async {
  final feeds = await ref.watch(feedRepository).getAll();
  // Automatically cached by Riverpod, invalidated on mutation
  return feeds;
}

// In mutation:
ref.invalidate(allFeedsProvider);  // Only invalidate what changed
```

**Selective Caching**:
```dart
// High-value cache (expensive calculation)
@riverpod(keepAlive: true)
Future<List<PriceChange>> priceChanges(Ref ref) async {
  // Keep in memory across screen changes
  return calculatePriceChanges();
}

// Short-lived cache
@riverpod
Future<Result> estimatedResult(Ref ref) async {
  // Recalculate more often (feed changes frequently)
  return calculateResult();
}
```

**Files**:
- `lib/src/features/reports/providers/result_provider.dart`
- `lib/src/features/main/providers/main_async_provider.dart`

### Task 4.3.3: Query Result Pagination

**Time**: 1-1.5 hours
**Impact**: Lower memory peak, faster initial loads

Current: Load all records at once (problems with large history)

```dart
// BEFORE: Load all 5000 price records at once
Future<List<PriceHistory>> getHistory(int ingredientId) {
  return db.select(...).then((raw) => raw.map(...).toList());
  // Memory spike: ~10MB for 5000 records
}

// AFTER: Paginate results
@riverpod
Future<List<PriceHistory>> priceHistoryPaginated(
  Ref ref,
  int ingredientId,
  {int pageSize = 50}
) async {
  // Load first 50, lazy-load more on scroll
  final repo = ref.watch(priceHistoryRepository);
  return repo.getHistoryPaginated(ingredientId, pageSize: pageSize);
}
```

**Implementation**:
- First load: 50 items (~500KB)
- Scroll to bottom: load next 50
- Infinite scroll pattern
- Memory stays constant (~1MB for current view)

---

## Phase 4.4: Widget & Rebuild Optimization (2-3 hours)

### Task 4.4.1: Reduce Unnecessary Rebuilds

**Time**: 1 hour
**Impact**: 20-30% reduction in frame drops

Current issues (identified by analyzing code):
```dart
// PROBLEM: Parent rebuild causes all children to rebuild
class FeedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);  // Entire widget rebuilds
    
    return Column(
      children: [
        FeedHeader(),  // Rebuilds even if unchanged
        FeedList(),    // Rebuilds even if unchanged
        FeedStats(),   // Rebuilds even if unchanged
      ],
    );
  }
}

// SOLUTION: Extract to separate widgets
class FeedHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final header = ref.watch(feedHeaderProvider);  // Only this watches
    return Text(header.title);
  }
}
// Now only FeedHeader rebuilds when header changes
```

**Refactoring**:
- Extract widgets watching different providers
- Use `const` constructors (prevent rebuilds)
- Avoid rebuilds on unrelated state changes
- Use `select()` for fine-grained updates

```dart
// GOOD: Only watch what's needed
final cost = ref.watch(feedProvider.select((feed) => feed.totalCost));
// Rebuild only when totalCost changes, not other fields
```

**Files**:
- `lib/src/features/add_update_feed/view/add_update_feed.dart`
- `lib/src/features/reports/view/report.dart`
- `lib/src/features/main/view/feed_home.dart`

### Task 4.4.2: Const Constructor Enforcement

**Time**: 0.5 hours
**Impact**: Framework-level optimization

Enable linting rule to enforce const constructors:

```yaml
# analysis_options.yaml
linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
```

Then fix all violations:
```dart
// BEFORE
Padding(
  padding: const EdgeInsets.all(16),
  child: Text("Hello"),
)

// AFTER (more efficient)
const Padding(
  padding: EdgeInsets.all(16),
  child: Text("Hello"),
)
```

### Task 4.4.3: ListView Performance Tuning

**Time**: 0.5 hours
**Impact**: 60fps maintained with large lists

Already mostly done (Phase 1), but verify:

```dart
// Essential attributes for performance
ListView.builder(
  itemExtent: 56.0,      // ✅ Critical hint for scroll perf
  cacheExtent: 100.0,    // Preload 100px above/below viewport
  itemCount: items.length,
  itemBuilder: (context, index) => item,
)

// Verify no SingleChildScrollView nesting
// (causes double scroll, janky performance)

// Use shrinkWrap only when necessary (default: false)
```

---

## Performance Metrics & Measurement

### Startup Time Measurement

```bash
# Measure cold launch time
adb shell am start -S -W com.example.feedapp/.MainActivity

# Expected output:
# ThisTime: 2345  (ms to first frame)
# TotalTime: 2500 (ms to fully interactive)

# Target: <2000ms for ThisTime
```

### Memory Profiling

```bash
# Android Studio -> Profilers -> Memory
# Look for:
- Heap size at startup (target: <100MB)
- Heap size after scrolling ingredients (target: <120MB)
- GC events (target: <5 per minute)
- Memory leaks (target: 0)
```

### FPS Monitoring

```dart
// Enable FPS overlay in debug
// Flutter DevTools -> Performance tab -> Show FPS

// Target metrics:
- Ingredient list scroll: 60fps maintained
- Feed calculation: <1s to update display
- Report generation: <2s for complex reports
```

### Database Query Performance

```dart
// Add timing to repository queries
final stopwatch = Stopwatch()..start();
final result = await db.query(...);
stopwatch.stop();
print('Query took ${stopwatch.elapsedMilliseconds}ms');

// Target: <100ms per query
// Red flag: >500ms
```

---

## Success Criteria

✅ **Startup Performance**
- [ ] Cold startup: <2 seconds (down from ~2.5s)
- [ ] Hot startup: <500ms
- [ ] All screens responsive on first open

✅ **Memory Usage**
- [ ] Peak memory: <150MB (down from ~160MB)
- [ ] Memory stable during extended use
- [ ] No memory leaks (GC well-behaved)
- [ ] Handle 5000+ price records gracefully

✅ **Scrolling Performance**
- [ ] 60fps maintained on ingredient lists (all 245+)
- [ ] Smooth scroll with price history (500+ records)
- [ ] No janky frame drops with large feeds

✅ **Query Performance**
- [ ] Typical queries: <100ms
- [ ] Indexed queries: <10ms
- [ ] Batch queries: <500ms for 100 items

✅ **Widget Efficiency**
- [ ] Unnecessary rebuilds eliminated
- [ ] Const constructors enforced
- [ ] No layout thrashing

✅ **Code Quality**
- [ ] 0 performance warnings
- [ ] All linter rules passing
- [ ] Documentation of optimization techniques

---

## Estimated Timeline

| Phase | Task | Hours | Owner |
|-------|------|-------|-------|
| 4.2 | Memory optimization | 3-4 | Developer |
| 4.3 | Query optimization | 3-4 | Database specialist |
| 4.4 | Widget optimization | 2-3 | UI engineer |
| | Testing & profiling | 1-2 | QA |
| **Total** | | **8-10** | Team |

---

## Risk Mitigation

**Risk**: Optimization breaks functionality
- **Mitigation**: Full test suite before/after (350+ tests)
- **Verification**: A/B test on beta users

**Risk**: Over-optimization causes complexity
- **Mitigation**: Profile first, optimize second (only high-impact areas)
- **Verification**: Code review for maintainability

**Risk**: Pagination breaks existing workflows
- **Mitigation**: Invisible to users (same API, different internals)
- **Verification**: Integration tests pass

---

## References

- Flutter Performance Best Practices: <https://docs.flutter.dev/perf>
- Riverpod Caching: <https://riverpod.dev/docs/concepts/caching>
- SQLite Optimization: <https://www.sqlite.org/optoverview.html>
- DevTools Performance Profiling: <https://docs.flutter.dev/development/tools/devtools/performance>

---

**Status**: Ready for Phase 4.3 & 4.4 after Phase 4.5e completion
**Parallel Work**: Can profile performance during Phase 4.5e
**Success Measurement**: After complete, app will feel noticeably snappier
