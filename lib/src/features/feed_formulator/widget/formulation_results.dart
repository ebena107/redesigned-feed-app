import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for displaying formulation results
class FormulationResults extends ConsumerWidget {
  final FormulatorResult? result;
  final List<String> warnings;

  const FormulationResults({
    required this.result,
    required this.warnings,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (result == null) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'Run formulation to see results',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    final ingredients = ref.watch(ingredientProvider).ingredients;

    return Card(
      margin: EdgeInsets.all(UIConstants.paddingNormal),
      child: Padding(
        padding: EdgeInsets.all(UIConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formulation Results',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: UIConstants.paddingMedium),
            if (warnings.isNotEmpty) ...[
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: EdgeInsets.all(UIConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Warnings & Issues',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.orange.shade700,
                                ),
                      ),
                      SizedBox(height: UIConstants.paddingSmall),
                      ...warnings.take(3).map((warning) => Padding(
                            padding: EdgeInsets.only(
                              bottom: UIConstants.paddingSmall,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: UIConstants.iconSmall,
                                  color: Colors.orange.shade700,
                                ),
                                SizedBox(
                                  width: UIConstants.paddingSmall,
                                ),
                                Expanded(
                                  child: Text(
                                    warning,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      if (warnings.length > 3)
                        Text(
                          '...and ${warnings.length - 3} more',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: UIConstants.paddingMedium),
            ],
            Text(
              'Ingredient Percentages',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: UIConstants.paddingSmall),
            ...result!.ingredientPercents.entries.map((entry) {
              final ingredient = ingredients.firstWhere(
                (ing) => ing.ingredientId == entry.key,
                orElse: () => throw Exception('Ingredient not found'),
              );
              final pct = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: UIConstants.paddingSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ingredient.name ?? 'Unknown',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct / 100,
                          minHeight: 20,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: UIConstants.paddingSmall,
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${pct.toStringAsFixed(1)}%',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: UIConstants.paddingMedium),
            Text(
              'Nutrient Analysis',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: UIConstants.paddingSmall),
            ...result!.nutrients.entries.map((entry) {
              final value = entry.value;
              final label = _getNutrientLabel(entry.key);
              final unit = _getNutrientUnit(entry.key);

              return Padding(
                padding: EdgeInsets.only(
                  bottom: UIConstants.paddingSmall,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${value.toStringAsFixed(2)} $unit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: UIConstants.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cost per kg',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '\$${result!.costPerKg.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getNutrientLabel(NutrientKey key) {
    return switch (key) {
      NutrientKey.energy => 'Energy',
      NutrientKey.protein => 'Crude Protein',
      NutrientKey.lysine => 'Lysine',
      NutrientKey.methionine => 'Methionine',
      NutrientKey.calcium => 'Calcium',
      NutrientKey.phosphorus => 'Phosphorus',
    };
  }

  String _getNutrientUnit(NutrientKey key) {
    return key == NutrientKey.energy ? 'kcal/kg' : '%';
  }
}
