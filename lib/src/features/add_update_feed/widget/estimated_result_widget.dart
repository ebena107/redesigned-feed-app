import 'dart:convert';

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
                        unit: 'kcal/kg', // More specific unit
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
                        value: data.totalPhosphorus != null
                            ? data.totalPhosphorus! / 10 // Convert g/kg to %
                            : null,
                        title: 'Total P',
                        unit: '%', // Changed from 'g/Kg' to '%'
                      ),
                      const SizedBox(height: UIConstants.paddingTiny),
                      EstimatedContentCard(
                        value: data.availablePhosphorus != null
                            ? data.availablePhosphorus! /
                                10 // Convert g/kg to %
                            : null,
                        title: 'Avail. P',
                        unit: '%', // Changed from 'g/Kg' to '%'
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Warnings section - show inclusion limit violations
            if (data.warningsJson != null && data.warningsJson!.isNotEmpty) ...[
              const SizedBox(height: UIConstants.paddingMedium),
              const Divider(color: Colors.white70, thickness: 1),
              const SizedBox(height: UIConstants.paddingSmall),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.orangeAccent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Warnings',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: UIConstants.paddingSmall),
              ...() {
                try {
                  final parsed = jsonDecode(data.warningsJson!);
                  if (parsed is List) {
                    return parsed
                        .take(5)
                        .map((w) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                          color:
                                              AppConstants.appBackgroundColor,
                                          fontSize: 14)),
                                  Expanded(
                                    child: Text(
                                      w.toString(),
                                      style: const TextStyle(
                                        color: AppConstants.appBackgroundColor,
                                        fontSize: 12,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList();
                  }
                } catch (_) {}
                return <Widget>[];
              }(),
            ],
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
