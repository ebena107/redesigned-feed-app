import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import '../providers/optimizer_provider.dart';
import '../../add_ingredients/provider/ingredients_provider.dart';
import '../../add_ingredients/model/ingredient.dart';

/// Screen for displaying optimization results
class OptimizationResultsScreen extends ConsumerWidget {
  const OptimizationResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(optimizationResultProvider);
    final optimizerState = ref.watch(optimizerProvider);
    final ingredientsState = ref.watch(ingredientProvider);

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.optimizerResultsTitle)),
        body: Center(child: Text(context.l10n.optimizerNoResults)),
      );
    }

    // Build ingredient cache
    final ingredientCache = <int, Ingredient>{};
    for (final id in result.ingredientProportions.keys) {
      final ingredient = ingredientsState.ingredients
          .firstWhere((ing) => ing.ingredientId == id);
      ingredientCache[id] = ingredient;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.optimizerResultsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () =>
                _shareResults(context, result, optimizerState, ingredientCache),
            tooltip: context.l10n.optimizerActionShare,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Success/Failure Card
          Card(
            color: result.success ? Colors.green.shade50 : Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    result.success ? Icons.check_circle : Icons.error,
                    color: result.success ? Colors.green : Colors.red,
                    size: 48,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result.success
                              ? 'Optimization Successful!'
                              : 'Optimization Failed',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color:
                                    result.success ? Colors.green : Colors.red,
                              ),
                        ),
                        if (!result.success && result.errorMessage != null)
                          Text(result.errorMessage!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (result.success) ...[
            // Quality Score Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quality Score',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: result.qualityScore / 100.0,
                            minHeight: 20,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(result.qualityScore),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${result.qualityScore.toStringAsFixed(1)}/100',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Cost Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Cost',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '\$${result.totalCost.toStringAsFixed(2)}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ingredient Composition Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Optimized Formulation',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Text(
                          'Total: 100 kg',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cost per kg: \$${(result.totalCost / 100).toStringAsFixed(3)}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    const Divider(height: 24),
                    ...result.ingredientProportions.entries.map((entry) {
                      final ingredient = ingredientCache[entry.key];
                      final percentage = entry.value;
                      final kg =
                          percentage; // Since total is 100kg, percentage = kg
                      final ingredientCost =
                          (optimizerState.ingredientPrices[entry.key] ?? 0.0) *
                              kg;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    ingredient?.name ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${kg.toStringAsFixed(2)} kg',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    Text(
                                      '(${percentage.toStringAsFixed(1)}%)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price: \$${(optimizerState.ingredientPrices[entry.key] ?? 0.0).toStringAsFixed(2)}/kg',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  'Cost: \$${ingredientCost.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: entry.value / 100.0,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nutritional Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nutritional Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ...result.achievedNutrients.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatNutrientName(entry.key)),
                            Text(
                              entry.value.toStringAsFixed(2),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Warnings Card
            if (result.warnings != null && result.warnings!.isNotEmpty)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            'Warnings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...result.warnings!.map((warning) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(warning)),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatNutrientName(String key) {
    final formatted = key
        .replaceAllMapped(
          RegExp(r'([A-Z])'),
          (match) => ' ${match.group(1)}',
        )
        .trim();
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  Future<void> _shareResults(
    BuildContext context,
    dynamic result,
    dynamic optimizerState,
    Map<int, Ingredient> ingredientCache,
  ) async {
    // Show export format dialog
    final format = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.optimizerExportTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(context.l10n.optimizerExportFormatJson),
              onTap: () => Navigator.of(context).pop('json'),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: Text(context.l10n.optimizerExportFormatCsv),
              onTap: () => Navigator.of(context).pop('csv'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: Text(context.l10n.optimizerExportFormatText),
              onTap: () => Navigator.of(context).pop('text'),
            ),
          ],
        ),
      ),
    );

    if (format != null && context.mounted) {
      final filename = format == 'json'
          ? 'formulation.json'
          : format == 'csv'
              ? 'formulation.csv'
              : 'formulation.txt';

      // Share functionality would go here
      // For now, just show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(context.l10n.optimizerExportedAs(format, filename))),
        );
      }
    }
  }
}
