import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/feed_formulator/model/formulator_constraint.dart';
import 'package:feed_estimator/src/features/feed_formulator/providers/feed_formulator_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget for detecting and displaying constraint conflicts
class ConstraintConflictDetector extends ConsumerWidget {
  const ConstraintConflictDetector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formulator = ref.watch(feedFormulatorProvider);
    final conflicts = _detectConflicts(formulator.input.constraints);

    if (conflicts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.all(UIConstants.paddingNormal),
      color: Colors.red.shade50,
      child: Padding(
        padding: EdgeInsets.all(UIConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red.shade700,
                ),
                SizedBox(width: UIConstants.paddingSmall),
                Text(
                  'Constraint Issues',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.red.shade700,
                      ),
                ),
              ],
            ),
            SizedBox(height: UIConstants.paddingMedium),
            ...conflicts.map((conflict) => Padding(
                  padding: EdgeInsets.only(
                    bottom: UIConstants.paddingSmall,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning,
                        size: UIConstants.iconSmall,
                        color: Colors.red.shade700,
                      ),
                      SizedBox(
                        width: UIConstants.paddingSmall,
                      ),
                      Expanded(
                        child: Text(
                          conflict,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<String> _detectConflicts(
    List<NutrientConstraint> constraints,
  ) {
    final conflicts = <String>[];

    for (final constraint in constraints) {
      final min = constraint.min;
      final max = constraint.max;

      // Check if min > max
      if (min != null && max != null && min > max) {
        conflicts.add(
          '${_getNutrientLabel(constraint.key)}: Minimum (${min.toStringAsFixed(2)}) exceeds maximum (${max.toStringAsFixed(2)}). Please correct this.',
        );
      }

      // Check if range is too narrow
      if (min != null && max != null) {
        final rangeWidth = max - min;
        final minThreshold =
            constraint.key == NutrientKey.energy ? 150.0 : 0.35;

        if (rangeWidth < minThreshold) {
          final unit = constraint.key == NutrientKey.energy ? 'kcal/kg' : '%';
          conflicts.add(
            '${_getNutrientLabel(constraint.key)}: Range is very narrow (${rangeWidth.toStringAsFixed(2)} $unit). Try widening by 10-20% to avoid infeasibility.',
          );
        }
      }

      // Check for unrealistic ranges
      if (constraint.key == NutrientKey.lysine) {
        if (min != null && min < 0.3) {
          conflicts.add(
            'Lysine minimum (${min.toStringAsFixed(2)}%) seems very low. Typical range is 0.6-1.5%.',
          );
        }
        if (max != null && max > 2.0) {
          conflicts.add(
            'Lysine maximum (${max.toStringAsFixed(2)}%) seems very high. Typical range is 0.6-1.5%.',
          );
        }
      }

      if (constraint.key == NutrientKey.protein) {
        if (max != null && max < 5.0) {
          conflicts.add(
            'Protein maximum (${max.toStringAsFixed(2)}%) seems low. Most animals require >5% crude protein.',
          );
        }
        if (min != null && min > 50.0) {
          conflicts.add(
            'Protein minimum (${min.toStringAsFixed(2)}%) seems very high. Rare for any species.',
          );
        }
      }
    }

    return conflicts;
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
}
