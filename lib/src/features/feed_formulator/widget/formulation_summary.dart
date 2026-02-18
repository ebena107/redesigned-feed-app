import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_result.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/feed_formulator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for displaying formulation summary statistics
class FormulationSummary extends ConsumerWidget {
  final FormulatorResult? result;
  final FormulatorStatus status;

  const FormulationSummary({
    required this.result,
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (result == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.all(UIConstants.paddingNormal),
      color: Colors.blue.shade50,
      child: Padding(
        padding: EdgeInsets.all(UIConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                _buildStatusBadge(context, status),
              ],
            ),
            SizedBox(height: UIConstants.paddingMedium),
            if (result!.limitingNutrients.isNotEmpty) ...[
              Text(
                'Limiting Nutrients',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: UIConstants.paddingSmall),
              Wrap(
                spacing: UIConstants.paddingSmall,
                children: result!.limitingNutrients
                    .map((nutrient) => Chip(
                          label: Text(
                            _getNutrientLabel(nutrient),
                          ),
                          backgroundColor: Colors.orange.shade100,
                        ))
                    .toList(),
              ),
              SizedBox(height: UIConstants.paddingMedium),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  context,
                  'Cost/kg',
                  '\$${result!.costPerKg.toStringAsFixed(2)}',
                ),
                _buildStat(
                  context,
                  'Ingredients',
                  '${result!.ingredientPercents.length}',
                ),
                _buildStat(
                  context,
                  'Nutrients',
                  '${result!.nutrients.length}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
    BuildContext context,
    FormulatorStatus status,
  ) {
    final color = status == FormulatorStatus.success
        ? Colors.green
        : status == FormulatorStatus.failure
            ? Colors.red
            : Colors.grey;

    final label = status == FormulatorStatus.success
        ? 'Optimal'
        : status == FormulatorStatus.failure
            ? 'Infeasible'
            : 'Pending';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UIConstants.paddingMedium,
        vertical: UIConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: UIConstants.paddingSmall),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  String _getNutrientLabel(NutrientKey key) {
    return switch (key) {
      NutrientKey.energy => 'Energy',
      NutrientKey.protein => 'Protein',
      NutrientKey.lysine => 'Lysine',
      NutrientKey.methionine => 'Methionine',
      NutrientKey.calcium => 'Calcium',
      NutrientKey.phosphorus => 'Phosphorus',
    };
  }
}
