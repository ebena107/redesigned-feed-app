import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/optimizer_provider.dart';
import '../../add_ingredients/provider/ingredients_provider.dart';
import '../../add_ingredients/model/ingredient.dart';
import '../services/formulation_exporter.dart';

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
        appBar: AppBar(title: const Text('Optimization Results')),
        body: const Center(child: Text('No results available')),
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
        title: const Text('Optimization Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () =>
                _shareResults(context, result, optimizerState, ingredientCache),
            tooltip: 'Share',
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
                    Text(
                      'Ingredient Composition',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ...result.ingredientProportions.entries.map((entry) {
                      final ingredient = ingredientCache[entry.key];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(ingredient?.name ?? 'Unknown'),
                                Text(
                                  '${entry.value.toStringAsFixed(2)}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: entry.value / 100.0,
                              backgroundColor: Colors.grey.shade300,
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
    final exporter = FormulationExporter();

    // Show export format dialog
    final format = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('JSON'),
              onTap: () => Navigator.of(context).pop('json'),
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('CSV'),
              onTap: () => Navigator.of(context).pop('csv'),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Text Report'),
              onTap: () => Navigator.of(context).pop('text'),
            ),
          ],
        ),
      ),
    );

    if (format != null && context.mounted) {
      String content;
      String filename;

      switch (format) {
        case 'json':
          content = exporter.exportAsJson(
            result: result,
            request: optimizerState,
            ingredientCache: ingredientCache,
          );
          filename = 'formulation.json';
          break;
        case 'csv':
          content = exporter.exportAsCsv(
            result: result,
            request: optimizerState,
            ingredientCache: ingredientCache,
          );
          filename = 'formulation.csv';
          break;
        case 'text':
          content = exporter.exportAsTextReport(
            result: result,
            request: optimizerState,
            ingredientCache: ingredientCache,
          );
          filename = 'formulation.txt';
          break;
        default:
          return;
      }

      // Share functionality would go here
      // For now, just show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export as $format: $filename')),
        );
      }
    }
  }
}
