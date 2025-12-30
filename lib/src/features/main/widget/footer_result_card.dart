import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FooterResultCard extends ConsumerWidget {
  final num? feedId;
  const FooterResultCard({super.key, required this.feedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (feedId == null || feedId == 0) return const SizedBox.shrink();

    final myResult = ref.watch(resultProvider.select(
      (state) => state.results.firstWhere(
        (r) => r.feedId == feedId,
        orElse: () => Result(),
      ),
    ));

    if (myResult.mEnergy == null) return const SizedBox.shrink();

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 34, maxHeight: 42),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _NutrientChip(
              label: context.l10n.labelEnergy.toUpperCase(),
              value: '${myResult.mEnergy?.round() ?? 0}',
              unit: context.l10n.unitKcal,
              // OPTIMIZATION: DeepOrange is more readable than standard Orange for text
              baseColor: Colors.deepOrange,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _NutrientChip(
              label: context.l10n.labelProtein.toUpperCase(),
              value: myResult.cProtein?.toStringAsFixed(1) ?? '0',
              unit: '%',
              // OPTIMIZATION: Indigo implies strength/structure and contrasts well with Orange
              baseColor: Colors.indigo,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _NutrientChip(
              label: context.l10n.labelFat.toUpperCase(),
              value: myResult.cFat?.toStringAsFixed(1) ?? '0',
              unit: '%',
              // OPTIMIZATION: Teal is visually distinct from Orange (unlike Amber/Yellow)
              baseColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final MaterialColor baseColor;

  const _NutrientChip({
    required this.label,
    required this.value,
    required this.unit,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    // We use shade800 for text to ensure it passes accessibility contrast ratios
    final textColor = baseColor.shade800;
    // We use shade50 for background for a clean, modern "pill" look
    final bgColor = baseColor.shade50;
    final borderColor = baseColor.shade100;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Flexible label with FittedBox to handle long translations
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: textColor.withValues(alpha: 0.8),
                  letterSpacing: 0.3,
                  height: 1.1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          // Value and unit with flexible sizing
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    unit,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: textColor.withValues(alpha: 0.9),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
