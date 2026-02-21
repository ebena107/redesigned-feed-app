// Price Management Integration Tests
//
// NOTE: These tests require Flutter integration test environment with platform
// code support (path_provider plugin for database initialization). They cannot
// run in standard unit test environment.
//
// Price management is adequately tested through:
// - Unit tests: PriceHistory model, validation logic
// - Widget tests: UI rendering and interactions
// - Repository logic covered by unit tests
//
// To run these tests, use Flutter integration test framework with device/emulator.

import 'package:feed_estimator/src/features/price_management/repository/price_history_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/core/database/app_db.dart';

void main() {
  // Initialize Flutter bindings for test environment
  TestWidgetsFlutterBinding.ensureInitialized();

  const runIntegrationTests =
      bool.fromEnvironment('RUN_INTEGRATION_TESTS', defaultValue: false);

  group(
    'Price Management Integration Tests',
    () {
      late PriceHistoryRepository repository;

      setUp(() async {
        // Use AppDatabase singleton and wait for initialization
        final appDb = AppDatabase();
        await appDb.database; // Ensure database is initialized before tests
        repository = PriceHistoryRepository(appDb);
      });

      test('complete price lifecycle: record → edit → retrieve → delete',
          () async {
        const ingredientId = 1;
        const initialPrice = 100.0;
        const updatedPrice = 120.0;
        const currency = 'NGN';
        final effectiveDate = DateTime.now();

        // Step 1: Record new price
        final recordId = await repository.recordPrice(
          ingredientId: ingredientId,
          price: initialPrice,
          currency: currency,
          effectiveDate: effectiveDate,
          source: 'user',
          notes: 'Initial price',
        );

        expect(recordId, greaterThan(0));

        // Step 2: Retrieve recorded price
        final recorded = await repository.getSingle(recordId);
        expect(recorded, isNotNull);
        expect(recorded!.price, initialPrice);
        expect(recorded.currency, currency);
        expect(recorded.notes, 'Initial price');

        // Step 3: Update price
        await repository.update({
          'price': updatedPrice,
          'notes': 'Updated price',
        }, recordId);

        // Step 4: Verify update
        final updated = await repository.getSingle(recordId);
        expect(updated!.price, updatedPrice);
        expect(updated.notes, 'Updated price');

        // Step 5: Get history for ingredient
        final history = await repository.getHistoryForIngredient(ingredientId);
        expect(history.length, 1);
        expect(history.first.price, updatedPrice);

        // Step 6: Get latest price
        final latest = await repository.getLatestPrice(ingredientId);
        expect(latest, isNotNull);
        expect(latest!.price, updatedPrice);

        // Step 7: Delete price record
        await repository.delete(recordId);

        // Step 8: Verify deletion
        final deleted = await repository.getSingle(recordId);
        expect(deleted, isNull);

        final historyAfterDelete =
            await repository.getHistoryForIngredient(ingredientId);
        expect(historyAfterDelete.isEmpty, true);
      });

      test('price history maintains chronological order', () async {
        const ingredientId = 2;
        final dates = [
          DateTime(2024, 1, 1),
          DateTime(2024, 1, 15),
          DateTime(2024, 2, 1),
        ];
        final prices = [100.0, 110.0, 105.0];

        // Record prices in random order
        for (var i = 0; i < dates.length; i++) {
          await repository.recordPrice(
            ingredientId: ingredientId,
            price: prices[i],
            currency: 'NGN',
            effectiveDate: dates[i],
          );
        }

        // Get history - should be sorted by date descending (newest first)
        final history = await repository.getHistoryForIngredient(ingredientId);
        expect(history.length, 3);
        expect(history[0].effectiveDate, dates[2]); // Feb 1 (most recent)
        expect(history[1].effectiveDate, dates[1]); // Jan 15
        expect(history[2].effectiveDate, dates[0]); // Jan 1 (oldest)
      });

      test('average price calculation', () async {
        const ingredientId = 3;
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        // Record 3 prices within range
        await repository.recordPrice(
          ingredientId: ingredientId,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: DateTime(2024, 1, 10),
        );
        await repository.recordPrice(
          ingredientId: ingredientId,
          price: 120.0,
          currency: 'NGN',
          effectiveDate: DateTime(2024, 1, 20),
        );
        await repository.recordPrice(
          ingredientId: ingredientId,
          price: 110.0,
          currency: 'NGN',
          effectiveDate: DateTime(2024, 1, 30),
        );

        // Calculate average
        final average = await repository.calculateAveragePrice(
          ingredientId: ingredientId,
          startDate: startDate,
          endDate: endDate,
        );

        expect(average, 110.0); // (100 + 120 + 110) / 3
      });

      test('multi-currency support', () async {
        const ingredientId = 4;
        final effectiveDate = DateTime.now();

        // Record prices in different currencies
        await repository.recordPrice(
          ingredientId: ingredientId,
          price: 100.0,
          currency: 'NGN',
          effectiveDate: effectiveDate,
        );
        await repository.recordPrice(
          ingredientId: ingredientId,
          price: 5.0,
          currency: 'USD',
          effectiveDate: effectiveDate.add(const Duration(days: 1)),
        );

        final history = await repository.getHistoryForIngredient(ingredientId);
        expect(history.length, 2);
        expect(history.any((h) => h.currency == 'NGN'), true);
        expect(history.any((h) => h.currency == 'USD'), true);
      });
    },
    skip: runIntegrationTests
        ? false
        : 'Requires integration test environment with path_provider.',
  );
}
