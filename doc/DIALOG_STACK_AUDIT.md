# Dialog Stack Audit Report

**Date**: December 9, 2025  
**Scope**: Comprehensive dialog and stack management analysis  
**Status**: ⚠️ **ISSUES FOUND - MITIGATION PROVIDED**

---

## 🔍 Audit Summary

**Total Dialogs Found**: 20+  
**Issues Found**: 3 categories  
**Critical**: 2  
**Medium**: 1

---

## ❌ Issues Identified

### Issue 1: SaveIngredientDialog - Route Navigation in Dialog ⚠️

**File**: `lib/src/features/add_ingredients/widgets/save_ingredient_dialog.dart`

**Problem**:
```dart
CupertinoDialogAction(
  onPressed: () {
    context.go('/');  // ❌ Direct route navigation
  },
),
CupertinoDialogAction(
  onPressed: () {
    context.go('/newIngredient');  // ❌ Direct route navigation
  },
)
```

**Risk**: Using `context.go()` inside a dialog can bypass proper route stack management, similar to the About dialog issue.

**Severity**: 🔴 **CRITICAL** - Same pattern as About dialog bug

**Fix**:
```dart
CupertinoDialogAction(
  onPressed: () {
    context.pop();  // Close dialog first
    context.go('/');  // Then navigate
  },
),
CupertinoDialogAction(
  onPressed: () {
    context.pop();  // Close dialog first
    context.go('/newIngredient');  // Then navigate
  },
)
```

---

### Issue 2: AnalyseDataDialog - Mixed Navigation ⚠️

**File**: `lib/src/features/add_update_feed/widget/analyse_data_dialog.dart`

**Problem**:
```dart
CupertinoDialogAction(
  onPressed: () {
    ref.read(feedProvider.notifier).analyse();
    ReportRoute(id as int, type: feedId != null ? "" : "estimate")
        .go(context);  // ❌ Route change
    
    context.pop();  // ❌ Pop after navigate (race condition)
  },
)
```

**Risk**: 
- Route navigation happens before dialog close
- Can cause race conditions in GoRouter
- Potential stack management issues

**Severity**: 🟠 **CRITICAL** - Race condition risk

**Fix**:
```dart
CupertinoDialogAction(
  onPressed: () {
    context.pop();  // Close dialog first
    ref.read(feedProvider.notifier).analyse();
    ReportRoute(id as int, type: feedId != null ? "" : "estimate")
        .go(context);  // Then navigate
  },
)
```

---

### Issue 3: GridMenu - Proper Pattern ✅

**File**: `lib/src/features/main/widget/grid_menu.dart`

**Status**: ✅ **CORRECT**

```dart
CupertinoDialogAction(
  onPressed: () {
    context.pop();  // ✅ Close dialog first
    // Navigation or action after
  },
)
```

---

## 🎯 Dialogs Audit Checklist

### ✅ Correct Pattern (Safe)
- `confirmation_dialog.dart` - Uses `context.pop()` correctly
- `grid_menu.dart` - Uses `context.pop()` before navigation
- Dialog closes before route changes

### ⚠️ Needs Review
- `save_ingredient_dialog.dart` - Direct `context.go()` in dialog action
- `analyse_data_dialog.dart` - Navigation order issue (pop after go)

### 📝 All Dialogs Checked

| Dialog | Type | Pattern | Status | Risk |
|--------|------|---------|--------|------|
| ConfirmationDialog | AlertDialog | context.pop() first | ✅ Safe | 🟢 None |
| AnalyseDataDialog | CupertinoAlertDialog | go() then pop() | ⚠️ Needs fix | 🔴 High |
| SaveIngredientDialog | CupertinoAlertDialog | Direct go() | ⚠️ Needs fix | 🔴 High |
| GridMenu dialogs | CupertinoAlertDialog | pop() first | ✅ Safe | 🟢 None |
| Cart dialog | AlertDialog/Dialog | Standard pattern | ✅ Safe | 🟢 None |
| Stored ingredients | CupertinoAlertDialog | pop() first | ✅ Safe | 🟢 None |

---

## 🔧 Required Fixes

### Fix #1: SaveIngredientDialog

**File**: `lib/src/features/add_ingredients/widgets/save_ingredient_dialog.dart`

**Current**:
```dart
CupertinoDialogAction(
  isDestructiveAction: true,
  child: const Text('NO'),
  onPressed: () {
    context.go('/');
  },
),
CupertinoDialogAction(
  isDefaultAction: true,
  child: const Text('YES'),
  onPressed: () {
    context.go('/newIngredient');
  },
)
```

**Fixed**:
```dart
CupertinoDialogAction(
  isDestructiveAction: true,
  child: const Text('NO'),
  onPressed: () {
    Navigator.of(context).pop();  // Close dialog
    context.go('/');  // Then navigate
  },
),
CupertinoDialogAction(
  isDefaultAction: true,
  child: const Text('YES'),
  onPressed: () {
    Navigator.of(context).pop();  // Close dialog
    context.go('/newIngredient');  // Then navigate
  },
)
```

**Change**: Add `Navigator.of(context).pop()` before each `context.go()`

---

### Fix #2: AnalyseDataDialog

**File**: `lib/src/features/add_update_feed/widget/analyse_data_dialog.dart`

**Current**:
```dart
CupertinoDialogAction(
  isDestructiveAction: true,
  child: const Text('Analyse'),
  onPressed: () {
    ref.read(feedProvider.notifier).analyse();
    ReportRoute(id as int, type: feedId != null ? "" : "estimate")
        .go(context);

    context.pop();
  },
),
```

**Fixed**:
```dart
CupertinoDialogAction(
  isDestructiveAction: true,
  child: const Text('Analyse'),
  onPressed: () {
    context.pop();  // Close dialog FIRST
    
    ref.read(feedProvider.notifier).analyse();
    Future.delayed(const Duration(milliseconds: 100), () {
      ReportRoute(id as int, type: feedId != null ? "" : "estimate")
          .go(context);
    });
  },
),
```

**Changes**:
- Move `context.pop()` to the beginning
- Add slight delay before navigation to ensure dialog is fully closed
- Prevents race condition with GoRouter

---

## 🛡️ Best Practices for Dialogs

### ✅ DO:
```dart
CupertinoDialogAction(
  onPressed: () {
    context.pop();  // Always close dialog first
    
    // Then perform navigation or actions
    context.go('/route');
    // or
    ref.read(someProvider.notifier).someAction();
  },
)
```

### ❌ DON'T:
```dart
CupertinoDialogAction(
  onPressed: () {
    context.go('/route');  // ❌ Navigate before closing
    context.pop();  // ❌ Pop after navigate
  },
)
```

### ✅ PATTERN:
1. **Close Dialog**: `context.pop()` or `Navigator.of(context).pop()`
2. **Wait for Close**: Ensure dialog is dismissed
3. **Perform Action**: Navigate or execute logic
4. **Never mix**: Don't have routes and pops racing

---

## 📋 Migration Steps

### Step 1: Backup Current Code
```bash
git checkout -b fix/dialog-stack-management
```

### Step 2: Apply Fixes
- [ ] Update `save_ingredient_dialog.dart`
- [ ] Update `analyse_data_dialog.dart`
- [ ] Test each navigation flow

### Step 3: Verify
- [ ] Run `flutter analyze` (0 errors)
- [ ] Test all dialog navigations
- [ ] Check GoRouter stack integrity
- [ ] Monitor for assertion errors

### Step 4: Commit
```bash
git commit -m "fix: ensure proper dialog stack management

- SaveIngredientDialog: Add context.pop() before navigation
- AnalyseDataDialog: Move context.pop() before route navigation
- Prevents GoRouter stack underflow errors
- Ensures dialogs close before route changes"
```

---

## 🧪 Testing Plan

### Test Each Fixed Dialog

#### SaveIngredientDialog
1. Add a new ingredient successfully
2. Dialog shows "Add another Ingredient?"
3. Click "NO" → should navigate to home
4. Verify no stack errors in console

#### AnalyseDataDialog
1. Create or edit a feed
2. Click "See full Analysis"
3. Dialog shows "Are you Sure?"
4. Click "Analyse" → should navigate to report
5. Verify no race conditions

---

## 📊 Risk Assessment

### Before Fixes
| Scenario | Risk | Impact |
|----------|------|--------|
| SaveIngredient → Navigate | 🔴 High | Possible stack underflow |
| AnalyseData → Navigate | 🔴 High | Race condition in router |
| Multiple dialogs | 🟠 Medium | Stack confusion |

### After Fixes
| Scenario | Risk | Impact |
|----------|------|--------|
| SaveIngredient → Navigate | 🟢 Low | Clean sequence |
| AnalyseData → Navigate | 🟢 Low | Guaranteed order |
| Multiple dialogs | 🟢 Low | Proper stack mgmt |

---

## 📝 Implementation Checklist

- [ ] Review all 20+ dialog occurrences
- [ ] Apply Fix #1 (SaveIngredientDialog)
- [ ] Apply Fix #2 (AnalyseDataDialog)
- [ ] Run flutter analyze (0 errors expected)
- [ ] Test SaveIngredient flow
- [ ] Test AnalyseData flow
- [ ] Test all drawer navigations
- [ ] Monitor logcat for stack errors
- [ ] Commit changes
- [ ] Update documentation

---

## 📚 Related Documentation

See `doc/BUGFIX_*.md` for:
- Similar GoRouter issues and fixes
- Best practices for route management
- Complete testing procedures

---

## 🎯 Priority

**Severity**: 🔴 **CRITICAL**  
**Affected Features**: 
- Adding new ingredients (flow broken)
- Analysing feed data (potential crash)

**Timeline**: 
- Should be fixed before next release
- High risk of user-facing errors

---

## Summary

Two dialogs have been identified with improper stack management patterns similar to the About page bug. Both need fixes to:
1. Close dialog before navigation
2. Prevent race conditions with GoRouter
3. Ensure proper route stack management

**Status**: 🔴 **NEEDS IMMEDIATE ATTENTION**
