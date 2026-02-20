import 'package:flutter/material.dart';
import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/utils/nutrient_formatter.dart';

/// Card displaying phosphorus breakdown (Total, Available, Phytate)
class PhosphorusBreakdownCard extends StatefulWidget {
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
  State<PhosphorusBreakdownCard> createState() =>
      _PhosphorusBreakdownCardState();
}

class _PhosphorusBreakdownCardState extends State<PhosphorusBreakdownCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.totalPhosphorus == null &&
        widget.availablePhosphorus == null &&
        widget.phytatePhosphorus == null) {
      return const SizedBox.shrink();
    }

    // Calculate availability percentage
    double? availabilityPct;
    if (widget.totalPhosphorus != null &&
        widget.availablePhosphorus != null &&
        widget.totalPhosphorus! > 0) {
      availabilityPct =
          (widget.availablePhosphorus! / widget.totalPhosphorus!) * 100;
    }

    final isEnvironmentallyCompliant =
        widget.totalPhosphorus != null && widget.totalPhosphorus! <= 3.5;

    return Card(
      margin: UIConstants.paddingAllSmall,
      elevation: UIConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    Icons.water_drop,
                    color: isEnvironmentallyCompliant
                        ? Colors.green
                        : Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phosphorus Breakdown',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        if (widget.totalPhosphorus != null)
                          Text(
                            'Total: ${NutrientFormatter.formatPhosphorus(widget.totalPhosphorus!)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: UIConstants.paddingAllMedium,
              child: Column(
                children: [
                  _buildPhosphorusRow(
                    'Total Phosphorus',
                    widget.totalPhosphorus,
                    Icons.analytics,
                    Colors.blue,
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  _buildPhosphorusRow(
                    'Available Phosphorus',
                    widget.availablePhosphorus,
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const SizedBox(height: UIConstants.paddingSmall),
                  _buildPhosphorusRow(
                    'Phytate Phosphorus',
                    widget.phytatePhosphorus,
                    Icons.block,
                    Colors.orange,
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
