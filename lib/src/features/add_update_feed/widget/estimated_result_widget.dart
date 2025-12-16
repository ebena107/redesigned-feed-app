import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/features/reports/model/result.dart';
import 'package:flutter/material.dart';

class ResultEstimateCard extends StatelessWidget {
  final Result data;
  final int? feedId;
  const ResultEstimateCard({required this.data, super.key, this.feedId});

  @override
  Widget build(BuildContext context) {
    final isEdit = feedId != null;
    final cardColor =
        isEdit ? AppConstants.appCarrotColor : AppConstants.appBlueColor;

    return Card(
      color: cardColor,
      elevation: UIConstants.cardElevation,
      margin: UIConstants.paddingAllSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Padding(
        padding: UIConstants.paddingAllMedium,
        child: Column(
          children: [
            // Title
            Text(
              'Estimated Nutritional Content',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppConstants.appBackgroundColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            // Content rows
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      EstimatedContentCard(
                        value: data.mEnergy,
                        title: 'Energy',
                        unit: 'kcal',
                      ),
                      const SizedBox(height: UIConstants.paddingTiny),
                      EstimatedContentCard(
                        value: data.cProtein,
                        title: 'Crude Protein',
                        unit: '%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: UIConstants.paddingSmall),
                Expanded(
                  child: Column(
                    children: [
                      EstimatedContentCard(
                        value: data.cFibre,
                        title: 'Crude Fibre',
                        unit: '%',
                      ),
                      const SizedBox(height: UIConstants.paddingTiny),
                      EstimatedContentCard(
                        value: data.cFat,
                        title: 'Crude Fat',
                        unit: '%',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: UIConstants.paddingSmall),
            // v5 enhanced quick fields
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      EstimatedContentCard(
                        value: data.ash,
                        title: 'Ash',
                        unit: '%',
                      ),
                      const SizedBox(height: UIConstants.paddingTiny),
                      EstimatedContentCard(
                        value: data.moisture,
                        title: 'Moisture',
                        unit: '%',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: UIConstants.paddingSmall),
                Expanded(
                  child: Column(
                    children: [
                      EstimatedContentCard(
                        value: data.totalPhosphorus,
                        title: 'Total P',
                        unit: 'g/Kg',
                      ),
                      const SizedBox(height: UIConstants.paddingTiny),
                      EstimatedContentCard(
                        value: data.availablePhosphorus,
                        title: 'Avail. P',
                        unit: 'g/Kg',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EstimatedContentCard extends StatelessWidget {
  final String? title;
  final num? value;
  final String? unit;

  const EstimatedContentCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value?.toStringAsFixed(2) ?? '--';
    final displayTitle = title ?? 'Unknown';
    final displayUnit = unit ?? '';

    return Container(
      padding: UIConstants.paddingSmallVertical.add(
        UIConstants.paddingSmallHorizontal,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: UIConstants.overlayLight),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Label
          Flexible(
            flex: 2,
            child: Text(
              displayTitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppConstants.appBackgroundColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: UIConstants.paddingTiny),
          // Value with unit
          Flexible(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.appBackgroundColor,
                  ),
                ),
                if (displayUnit.isNotEmpty) ...[
                  const SizedBox(width: 2),
                  Text(
                    displayUnit,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppConstants.appBackgroundColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
