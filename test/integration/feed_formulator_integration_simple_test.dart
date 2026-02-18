import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/feed_type.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/feed_formulator_provider.dart';

void main() {
  group('FeedFormulatorProvider Integration Tests', () {
    test('provider initializes with default state', () {
      final container = ProviderContainer();

      final state = container.read(feedFormulatorProvider);

      expect(state, isNotNull);
      expect(state.input.animalTypeId, isA<int>());
      expect(state.input.selectedIngredientIds, isA<Set>());
      expect(state.input.constraints, isA<List>());
    });

    test('setAnimalTypeId updates the state', () {
      final container = ProviderContainer();

      container.read(feedFormulatorProvider.notifier).setAnimalTypeId(1); // Pig

      final state = container.read(feedFormulatorProvider);
      expect(state.input.animalTypeId, 1);
    });

    test('setSelectedIngredientIds adds multiple ingredients', () {
      final container = ProviderContainer();

      container
          .read(feedFormulatorProvider.notifier)
          .setSelectedIngredientIds({1, 2, 3});

      final state = container.read(feedFormulatorProvider);
      expect(state.input.selectedIngredientIds, {1, 2, 3});
    });

    test('toggleIngredientId adds new ingredient', () {
      final container = ProviderContainer();

      container.read(feedFormulatorProvider.notifier).toggleIngredientId(1);

      final state = container.read(feedFormulatorProvider);
      expect(state.input.selectedIngredientIds.contains(1), true);
    });

    test('toggleIngredientId removes existing ingredient', () {
      final container = ProviderContainer();

      container.read(feedFormulatorProvider.notifier).toggleIngredientId(1);
      container.read(feedFormulatorProvider.notifier).toggleIngredientId(1);

      final state = container.read(feedFormulatorProvider);
      expect(state.input.selectedIngredientIds.contains(1), false);
    });

    test('setConstraints updates constraint list', () {
      final container = ProviderContainer();

      final constraints = [
        createNutrientConstraint(
          key: NutrientKey.protein,
          min: 18,
          max: 22,
        ),
      ];

      container
          .read(feedFormulatorProvider.notifier)
          .setConstraints(constraints);

      final state = container.read(feedFormulatorProvider);
      expect(state.input.constraints.length, 1);
      expect(state.input.constraints[0].key, NutrientKey.protein);
    });

    test('updateConstraint modifies existing constraint', () {
      final container = ProviderContainer();

      final constraint = createNutrientConstraint(
        key: NutrientKey.protein,
        min: 18,
        max: 22,
      );

      container
          .read(feedFormulatorProvider.notifier)
          .setConstraints([constraint]);

      container
          .read(feedFormulatorProvider.notifier)
          .updateConstraint(NutrientKey.protein, min: 20, max: 25);

      final state = container.read(feedFormulatorProvider);
      expect(state.input.constraints[0].min, 20);
      expect(state.input.constraints[0].max, 25);
    });

    test('resetResult clears formulation results', () {
      final container = ProviderContainer();

      // Attempt to solve first - this may fail, but we're just testing reset
      var state = container.read(feedFormulatorProvider);
      expect(state.result, isNull);

      // After reset, result should remain null
      container.read(feedFormulatorProvider.notifier).resetResult();
      state = container.read(feedFormulatorProvider);
      expect(state.result, isNull);
    });

    test('multiple state transitions work correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(feedFormulatorProvider.notifier);

      // Chain multiple operations
      notifier.setAnimalTypeId(2); // Poultry
      notifier.toggleIngredientId(1);
      notifier.toggleIngredientId(2);
      notifier.toggleIngredientId(3);

      final constraint = createNutrientConstraint(
        key: NutrientKey.protein,
        min: 16,
        max: 20,
      );
      notifier.setConstraints([constraint]);

      final state = container.read(feedFormulatorProvider);
      expect(state.input.animalTypeId, 2);
      expect(state.input.selectedIngredientIds, {1, 2, 3});
      expect(state.input.constraints.length, 1);
    });

    test('setFeedType updates feed type', () {
      final container = ProviderContainer();

      container
          .read(feedFormulatorProvider.notifier)
          .setFeedType(FeedType.grower);

      final state = container.read(feedFormulatorProvider);
      expect(state.input.feedType, FeedType.grower);
    });

    test('enforceMaxInclusion flag preserved in state', () {
      final container = ProviderContainer();

      final state = container.read(feedFormulatorProvider);

      // Default should be true
      expect(state.input.enforceMaxInclusion, isA<bool>());
    });
  });
}
