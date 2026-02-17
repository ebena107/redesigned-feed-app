# Test Suite for Feed Estimator App

This directory contains comprehensive tests for the Feed Estimator application.

## Test Structure

```
test/
├── unit/                           # Unit tests
│   ├── data_validator_test.dart   # NutritionalDataValidator tests
│   ├── ingredient_model_test.dart  # Ingredient model tests
│   ├── feed_model_test.dart        # Feed & FeedIngredients model tests
│   ├── input_validators_test.dart  # Input validation tests
│   ├── price_value_object_test.dart # Price value object tests
│   └── common_utils_test.dart      # Utility functions tests
├── integration/                    # Integration tests
│   └── feed_integration_test.dart  # End-to-end workflow tests
└── phase_1_4_simple_test.dart     # Legacy provider tests

```

## Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test File

```bash
flutter test test/unit/data_validator_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

### View Coverage Report

```bash
# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

## Test Categories

### Unit Tests (test/unit/)

**Data Validation Tests** (`data_validator_test.dart`)

- Negative value validation
- Bran product validation
- Total nutritional content validation
- Energy value validation
- Batch validation
- Complex validation scenarios

**Ingredient Model Tests** (`ingredient_model_test.dart`)

- Constructor and properties
- JSON serialization/deserialization
- copyWith method
- Helper functions
- Real-world ingredient examples

**Feed Model Tests** (`feed_model_test.dart`)

- Feed constructor and properties
- FeedIngredients model
- JSON serialization
- copyWith methods
- Calculations and business logic

**Input Validators Tests** (`input_validators_test.dart`)

- Price validation
- Quantity validation
- Name validation
- Email validation
- Percentage validation
- Numeric validation with custom ranges
- Phone validation
- Regex patterns

**Price Value Object Tests** (`price_value_object_test.dart`)

- Constructor and validation
- Map serialization
- Arithmetic operations (+, -, *, /)
- Comparison operations (>, <)
- Formatting (multiple currencies)
- Equality
- Complex scenarios (discounts, taxes, etc.)

**Common Utils Tests** (`common_utils_test.dart`)

- Display size functions
- Text style functions
- Time functions
- Feed image mapping
- Animal name mapping
- Input decoration theme
- AppConstants validation

### Integration Tests (test/integration/)

**Feed Integration Tests** (`feed_integration_test.dart`)

- Complete feed creation workflow
- Ingredient validation in feed context
- Feed updates and modifications
- Nutritional composition calculations
- Data consistency through JSON serialization
- Business logic (cost calculations, percentages)
- Error handling

## Test Coverage Goals

| Category | Target Coverage | Current Status |
|----------|----------------|----------------|
| Models | 90%+ | ✅ Achieved |
| Validators | 95%+ | ✅ Achieved |
| Value Objects | 90%+ | ✅ Achieved |
| Utilities | 85%+ | ✅ Achieved |
| Providers | 70%+ | 🟡 In Progress |
| Widgets | 60%+ | ⚠️ Needs Work |
| Integration | 50%+ | ✅ Achieved |

## Writing New Tests

### Unit Test Template

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeatureName Tests', () {
    group('Specific Functionality', () {
      test('should do something specific', () {
        // Arrange
        final input = 'test';
        
        // Act
        final result = functionUnderTest(input);
        
        // Assert
        expect(result, expectedValue);
      });
    });
  });
}
```

### Widget Test Template

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WidgetName should display correctly', (tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: WidgetUnderTest(),
      ),
    );
    
    // Act
    await tester.pump();
    
    // Assert
    expect(find.byType(WidgetUnderTest), findsOneWidget);
  });
}
```

## Best Practices

1. **Test Organization**
   - Group related tests using `group()`
   - Use descriptive test names
   - Follow Arrange-Act-Assert pattern

2. **Test Independence**
   - Each test should be independent
   - Use `setUp()` and `tearDown()` for common setup
   - Avoid test interdependencies

3. **Coverage**
   - Test both happy paths and edge cases
   - Test error conditions
   - Test boundary values

4. **Mocking**
   - Use mocks for external dependencies
   - Keep mocks simple and focused
   - Verify mock interactions when relevant

5. **Performance**
   - Keep tests fast
   - Avoid unnecessary delays
   - Use `pumpAndSettle()` sparingly in widget tests

## Continuous Integration

Tests are automatically run on:

- Every pull request
- Every commit to main branch
- Nightly builds

## Troubleshooting

### Common Issues

**Issue: Tests fail with "No Material widget found"**

```dart
// Solution: Wrap widget in MaterialApp
await tester.pumpWidget(
  MaterialApp(home: YourWidget()),
);
```

**Issue: Async tests timeout**

```dart
// Solution: Increase timeout or use pumpAndSettle
await tester.pumpAndSettle(const Duration(seconds: 5));
```

**Issue: Provider tests fail**

```dart
// Solution: Use ProviderScope and proper disposal
final container = ProviderContainer();
addTearDown(container.dispose);
```

## Contributing

When adding new features:

1. Write tests first (TDD approach recommended)
2. Ensure all tests pass
3. Maintain or improve coverage
4. Update this README if adding new test categories

## Resources

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/language/effective-dart/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
