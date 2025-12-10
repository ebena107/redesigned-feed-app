import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FooterResultCard extends ConsumerWidget {
  final num? feedId;
  const FooterResultCard({super.key, required this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (feedId == null || feedId == 0) return const SizedBox.shrink();

    // PERFORMANCE OPTIMIZATION:
    // Only rebuild this specific card if the Result associated with this feedId changes.
    // This prevents the "N+1" rebuild problem where one update refreshes the whole grid.
    final myResult = ref.watch(resultProvider.select(
      (state) => state.results.firstWhere(
        (r) => r.feedId == feedId,
        orElse: () => Result(),
      ),
    ));

    // If calculation hasn't run yet, show nothing or placeholder
    if (myResult.mEnergy == null) return const SizedBox.shrink();

    return Wrap(
      spacing: 3,
      runSpacing: 2,
      children: [
        _NutrientChip(
          label: 'Energy',
          value: '${myResult.mEnergy?.round() ?? 0}',
          unit: 'kcal',
          color: Colors.orange.shade600,
        ),
        _NutrientChip(
          label: 'Protein',
          value: myResult.cProtein?.toStringAsFixed(1) ?? '0',
          unit: '%',
          color: Colors.purple.shade600,
        ),
        _NutrientChip(
          label: 'Fat',
          value: myResult.cFat?.toStringAsFixed(1) ?? '0',
          unit: '%',
          color: Colors.blue.shade600,
        ),
      ],
    );
  }
}

/// Modern chip-style nutrient badge with colored background
class _NutrientChip extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _NutrientChip({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  IconData get _icon {
    switch (label) {
      case 'Energy':
        return Icons.flash_on;
      case 'Protein':
        return Icons.egg;
      case 'Fat':
        return Icons.water_drop;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: 9,
            color: color,
          ),
          const SizedBox(width: 3),
          // Value and unit
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: color,
                    height: 1.2,
                    letterSpacing: -0.2,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    fontSize: 6.5,
                    fontWeight: FontWeight.w500,
                    color: color.withValues(alpha: 0.8),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
