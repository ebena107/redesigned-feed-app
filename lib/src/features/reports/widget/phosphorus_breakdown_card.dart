import 'package:flutter/material.dart';
import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/utils/nutrient_formatter.dart';

/// Card displaying phosphorus breakdown (Total, Available, Phytate)
class PhosphorusBreakdownCard extends StatelessWidget {
  final num? totalPhosphorus; // g/kg
  final num? availablePhosphorus; // g/kg
  final num? phytatePhosphorus; // g/kg
  final bool initiallyExpanded;

  const PhosphorusBreakdownCard({
    super.key,
    this.totalPhosphorus,
    this.availablePhosphorus,
    this.phytatePhosphorus,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show if no phosphorus data
    if (totalPhosphorus == null &&
        availablePhosphorus == null &&
        phytatePhosphorus == null) {
      return const SizedBox.shrink();
    }

    // Calculate availability percentage
    double? availabilityPct;
    if (totalPhosphorus != null &&
        availablePhosphorus != null &&
        totalPhosphorus! > 0) {
      availabilityPct = (availablePhosphorus! / totalPhosphorus!) * 100;
    }

    // Check environmental compliance (EU: <3.5 g/kg total P)
    final isEnvironmentallyCompliant =
        totalPhosphorus != null && totalPhosphorus! <= 3.5;

    return Card(
      margin: UIConstants.paddingAllSmall,
      elevation: UIConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: ExpansionTile(
        initiallyExpanded: initiallyExpanded,
        leading: Icon(
          Icons.water_drop,
          color: isEnvironmentallyCompliant ? Colors.green : Colors.orange,
        ),
        title: const Text(
          'Phosphorus Breakdown',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: totalPhosphorus != null
            ? Text(
                'Total: ${NutrientFormatter.formatPhosphorus(totalPhosphorus)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              )
            : null,
        children: [
          Padding(
            padding: UIConstants.paddingAllMedium,
            child: Column(
              children: [
                // Phosphorus values
                _buildPhosphorusRow(
                  'Total Phosphorus',
                  totalPhosphorus,
                  Icons.analytics,
                  Colors.blue,
                ),
                const SizedBox(height: UIConstants.paddingSmall),
                _buildPhosphorusRow(
                  'Available Phosphorus',
                  availablePhosphorus,
                  Icons.check_circle,
                  Colors.green,
                ),
                const SizedBox(height: UIConstants.paddingSmall),
                _buildPhosphorusRow(
                  'Phytate Phosphorus',
                  phytatePhosphorus,
                  Icons.block,
                  Colors.orange,
                ),

                // Availability percentage
                if (availabilityPct != null) ...[
                  const SizedBox(height: UIConstants.paddingMedium),
                  const Divider(),
                  const SizedBox(height: UIConstants.paddingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Availability:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${availabilityPct.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: availabilityPct >= 40
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],

                // Environmental compliance indicator
                const SizedBox(height: UIConstants.paddingMedium),
                Container(
                  padding: UIConstants.paddingAllSmall,
                  decoration: BoxDecoration(
                    color: isEnvironmentallyCompliant
                        ? Colors.green[50]
                        : Colors.orange[50],
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isEnvironmentallyCompliant
                            ? Icons.eco
                            : Icons.warning_amber,
                        size: 16,
                        color: isEnvironmentallyCompliant
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isEnvironmentallyCompliant
                              ? 'Meets EU environmental standards (<3.5 g/kg)'
                              : 'Above EU environmental limit (3.5 g/kg)',
                          style: TextStyle(
                            fontSize: 11,
                            color: isEnvironmentallyCompliant
                                ? Colors.green[700]
                                : Colors.orange[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhosphorusRow(
    String label,
    num? value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: UIConstants.paddingSmallVertical
          .add(UIConstants.paddingSmallHorizontal),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value != null ? NutrientFormatter.formatPhosphorus(value) : '--',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
