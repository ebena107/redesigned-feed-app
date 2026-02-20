import 'dart:convert';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:feed_estimator/src/features/main/model/feed.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:feed_estimator/src/features/reports/providers/result_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultCard extends ConsumerWidget {
  final Feed feed;
  final num? feedId;
  final String? type;

  const ResultCard({
    super.key,
    required this.feed,
    this.feedId,
    this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(resultProvider);

    final Result? result;
    if (type == 'estimate') {
      result = provider.myResult;
    } else {
      // First try to find result in results list
      Result? found;
      try {
        found = provider.results.firstWhere(
          (r) => r.feedId == (feedId ?? feed.feedId),
        );
      } catch (_) {
        found = null;
      }
      // Fallback to myResult if not found (can happen during on-demand calculation)
      result = found ?? provider.myResult;
    }

    if (result == null || result.mEnergy == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    List warnings = [];
    try {
      if (result.warningsJson != null && result.warningsJson!.isNotEmpty) {
        final parsed = jsonDecode(result.warningsJson!);
        if (parsed is List) warnings = parsed;
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.deepPurple, Color(0xFF5E35B1)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 6),
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _StatItem(
                  label: (feed.animalId == 8 || feed.animalId == 9)
                      ? context.l10n.nutrientDigestiveEnergy
                      : context.l10n.nutrientMetabolicEnergy,
                  value: result.mEnergy?.toStringAsFixed(0) ?? '0',
                  unit: context.l10n.unitKcal,
                  isLarge: true,
                ),
              ),
              _VerticalDivider(),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientCrudeProtein,
                  value: result.cProtein?.toStringAsFixed(2) ?? '0',
                  unit: context.l10n.unitPercent,
                  isLarge: true,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 36, thickness: 1.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientCrudeFiber,
                  value: '${result.cFibre?.toStringAsFixed(2)}',
                  unit: context.l10n.unitPercent,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientCrudeFat,
                  value: '${result.cFat?.toStringAsFixed(2)}',
                  unit: context.l10n.unitPercent,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientCalcium,
                  value: '${result.calcium?.toStringAsFixed(2)}',
                  unit: context.l10n.unitGramPerKg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientPhosphorus,
                  value: '${result.phosphorus?.toStringAsFixed(2)}',
                  unit: context.l10n.unitGramPerKg,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientLysine,
                  value: '${result.lysine?.toStringAsFixed(2)}',
                  unit: context.l10n.unitGramPerKg,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientMethionine,
                  value: '${result.methionine?.toStringAsFixed(2)}',
                  unit: context.l10n.unitGramPerKg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientAsh,
                  value: result.ash != null
                      ? result.ash!.toStringAsFixed(1)
                      : '--',
                  unit: context.l10n.unitPercent,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientMoisture,
                  value: result.moisture != null
                      ? result.moisture!.toStringAsFixed(1)
                      : '--',
                  unit: context.l10n.unitPercent,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientAvailablePhosphorus,
                  value: result.availablePhosphorus != null
                      ? result.availablePhosphorus!.toStringAsFixed(2)
                      : '--',
                  unit: context.l10n.unitGramPerKg,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientTotalPhosphorus,
                  value: result.totalPhosphorus != null
                      ? result.totalPhosphorus!.toStringAsFixed(2)
                      : '--',
                  unit: context.l10n.unitGramPerKg,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: context.l10n.nutrientPhytatePhosphorus,
                  value: result.phytatePhosphorus != null
                      ? result.phytatePhosphorus!.toStringAsFixed(2)
                      : '--',
                  unit: context.l10n.unitGramPerKg,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const Divider(color: Colors.white24, height: 36, thickness: 1.5),
          if (warnings.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                context.l10n.warningsCardTitle,
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: warnings
                  .take(5)
                  .map(
                    (w) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        w.toString(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Total Qty',
                    value: '${result.totalQuantity}',
                    unit: 'kg',
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Total Cost',
                    value: result.totalCost != null
                        ? result.totalCost!.toStringAsFixed(2)
                        : '0.00',
                    unit: '#',
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Cost/Unit',
                    value: '${result.costPerUnit?.toStringAsFixed(2)}',
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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.0),
            Colors.white.withValues(alpha: 0.5),
            Colors.white.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final bool isLarge;

  const _StatItem({
    required this.label,
    required this.value,
    this.unit,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLarge) ...[
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ],
          ),
        ] else ...[
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ],
    );
  }
}
