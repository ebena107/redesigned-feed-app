import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FooterResultCard extends ConsumerWidget {
  final num? feedId;
  const FooterResultCard({
    super.key,
    required this.feedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Result> data = ref.watch(resultProvider).results;
    final myResult = data.firstWhere(
      (element) => element.feedId == feedId,
      orElse: () => Result(),
    );

    if (myResult.mEnergy == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        Row(
          spacing: 4,
          children: [
            Expanded(
              child: _NutrientBadge(
                title: 'Energy',
                value: myResult.mEnergy?.round().toString() ?? '0',
                unit: 'kcal',
                icon: Icons.flash_on,
                color: Colors.orange.shade600,
              ),
            ),
            Expanded(
              child: _NutrientBadge(
                title: 'Protein',
                value: myResult.cProtein?.toStringAsFixed(1) ?? '0',
                unit: '%',
                icon: Icons.breakfast_dining,
                color: Colors.purple.shade600,
              ),
            ),
          ],
        ),
        Row(
          spacing: 4,
          children: [
            Expanded(
              child: _NutrientBadge(
                title: 'Fat',
                value: myResult.cFat?.toStringAsFixed(1) ?? '0',
                unit: '%',
                icon: Icons.opacity,
                color: Colors.amber.shade700,
              ),
            ),
            Expanded(
              child: _NutrientBadge(
                title: 'Fiber',
                value: myResult.cFibre?.toStringAsFixed(1) ?? '0',
                unit: '%',
                icon: Icons.grass,
                color: Colors.green.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Compact nutrient display badge for cards
class _NutrientBadge extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _NutrientBadge({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      constraints: const BoxConstraints(minHeight: 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 9, color: color),
          SizedBox(height: value.length > 3 ? 0.2 : 0.3),
          Text(
            title,
            style: const TextStyle(
              fontSize: 6.5,
              fontWeight: FontWeight.w600,
              height: 0.9,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.2),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 7.5,
                    fontWeight: FontWeight.w700,
                    color: color,
                    height: 0.9,
                  ),
                ),
                TextSpan(
                  text: unit,
                  style: TextStyle(
                    fontSize: 4.5,
                    fontWeight: FontWeight.w500,
                    color: color.withValues(alpha: 0.7),
                    height: 0.9,
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

// Legacy components kept for compatibility but improved styling

class ContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  const ContentCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                value!.toStringAsFixed(2),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EnergyContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  const EnergyContentCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                value!.round().toString(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
