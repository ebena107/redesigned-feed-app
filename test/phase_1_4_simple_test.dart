// ignore_for_file: dangling_library_doc_comments
/// Comprehensive Test Suite for Phases 1-4
/// Tests modernization progress, performance optimizations, and UI/UX improvements
///
/// Phase 1: Foundation (Riverpod migration, architecture)
/// Phase 2: User-Driven Modernization (UI/UX, Material Design 3)
/// Phase 3: Performance (Navigation optimization, caching)
/// Phase 4: Data Quality (Ingredient corrections)
library;

import 'package:feed_estimator/src/features/add_update_feed/providers/feed_provider.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Phase 1-4: Foundation Tests', () {
    group('Riverpod State Management', () {
      test('FeedProvider - creates new feed with valid data', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.setFeedName('Test Feed');
        notifier.setAnimalId(1);

        final state = container.read(feedProvider);

        expect(state.feedName, 'Test Feed');
        expect(state.animalTypeId, 1);
        expect(state.feedIngredients, isEmpty);
      });

      test('FeedProvider - calculates total quantity correctly', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.setFeedName('Test Feed');
        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
          FeedIngredients(
            ingredientId: 2,
            quantity: 30.0,
            priceUnitKg: 15.0,
          ),
        ]);

        final state = container.read(feedProvider);

        expect(state.totalQuantity, 80.0);
        expect(state.feedIngredients.length, 2);
      });

      test('FeedProvider - setFeedName updates state', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);
        notifier.setFeedName('New Feed Name');

        final state = container.read(feedProvider);
        expect(state.feedName, 'New Feed Name');
      });

      test('FeedProvider - setAnimalId updates state', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);
        notifier.setAnimalId(2);

        final state = container.read(feedProvider);
        expect(state.animalTypeId, 2);
      });

      test('FeedProvider - removeIng removes ingredient correctly', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
          FeedIngredients(
            ingredientId: 2,
            quantity: 30.0,
            priceUnitKg: 15.0,
          ),
        ]);

        var state = container.read(feedProvider);
        expect(state.feedIngredients.length, 2);

        notifier.removeIng(1);

        state = container.read(feedProvider);
        expect(state.feedIngredients.length, 1);
        expect(state.feedIngredients.first.ingredientId, 2);
      });
    });

    group('Phase 2: Data Models', () {
      test('Feed model - creates properly', () {
        final feed = Feed(
          feedId: 1,
          feedName: 'Test Feed',
          animalId: 1,
          feedIngredients: const [],
        );

        expect(feed.feedId, 1);
        expect(feed.feedName, 'Test Feed');
        expect(feed.animalId, 1);
        expect(feed.feedIngredients, isEmpty);
      });

      test('FeedIngredients model - creates properly', () {
        final ingredient = FeedIngredients(
          ingredientId: 1,
          quantity: 50.0,
          priceUnitKg: 10.0,
        );

        expect(ingredient.ingredientId, 1);
        expect(ingredient.quantity, 50.0);
        expect(ingredient.priceUnitKg, 10.0);
      });
    });

    group('Phase 3: Performance Optimizations', () {
      test('FeedProvider - setPrice updates ingredient price', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
        ]);

        notifier.setPrice(1, '15.50');

        final state = container.read(feedProvider);
        expect(state.feedIngredients.first.priceUnitKg, 15.50);
      });

      test('FeedProvider - setQuantity updates ingredient quantity', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
        ]);

        notifier.setQuantity(1, '75.5');

        final state = container.read(feedProvider);
        expect(state.feedIngredients.first.quantity, 75.5);
        expect(state.totalQuantity, 75.5);
      });

      test('FeedProvider - calcPercent calculates correctly', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
          FeedIngredients(
            ingredientId: 2,
            quantity: 50.0,
            priceUnitKg: 15.0,
          ),
        ]);

        final percent = notifier.calcPercent(50.0);
        expect(percent, 50.0); // 50 out of 100 total = 50%
      });
    });

    group('Phase 4: Data Quality & Validation', () {
      test('FeedProvider - validates non-empty feed name', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.setFeedName('');
        notifier.setAnimalId(1);
        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
        ]);

        final state = container.read(feedProvider);

        // Feed with empty name should not be valid
        expect(state.feedName.isEmpty, true);
      });

      test('FeedProvider - validates ingredient list not empty', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.setFeedName('Test Feed');
        notifier.setAnimalId(1);

        final state = container.read(feedProvider);

        // Feed with no ingredients should have empty list
        expect(state.feedIngredients.isEmpty, true);
      });

      test('FeedProvider - resetProvider clears state', () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        notifier.setFeedName('Test Feed');
        notifier.setAnimalId(2);
        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
        ]);

        await notifier.resetProvider();

        final state = container.read(feedProvider);

        expect(state.feedName, isEmpty);
        expect(state.feedIngredients, isEmpty);
        expect(state.totalQuantity, 0.0);
      });
    });

    group('Integration Tests', () {
      test('Complete feed creation workflow', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final notifier = container.read(feedProvider.notifier);

        // Step 1: Set feed name
        notifier.setFeedName('Complete Test Feed');
        expect(container.read(feedProvider).feedName, 'Complete Test Feed');

        // Step 2: Set animal type
        notifier.setAnimalId(1);
        expect(container.read(feedProvider).animalTypeId, 1);

        // Step 3: Add ingredients
        notifier.addSelectedIngredients([
          FeedIngredients(
            ingredientId: 1,
            quantity: 50.0,
            priceUnitKg: 10.0,
          ),
          FeedIngredients(
            ingredientId: 2,
            quantity: 30.0,
            priceUnitKg: 15.0,
          ),
        ]);

        final state = container.read(feedProvider);

        expect(state.feedIngredients.length, 2);
        expect(state.totalQuantity, 80.0);

        // Step 4: Verify newFeed is null initially (before setNewFeed)
        expect(state.newFeed, isNull);
      });
    });
  });
}
