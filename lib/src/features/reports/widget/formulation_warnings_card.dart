import 'dart:convert';
import 'package:flutter/material.dart';

/// Formulation Warnings Card - displays warnings and recommendations
class FormulationWarningsCard extends StatefulWidget {
  final String? warningsJson;

  const FormulationWarningsCard({
    super.key,
    required this.warningsJson,
  });

  @override
  State<FormulationWarningsCard> createState() =>
      _FormulationWarningsCardState();
}

class _FormulationWarningsCardState extends State<FormulationWarningsCard> {
  bool _isExpanded = true; // Expanded by default to show warnings

  @override
  Widget build(BuildContext context) {
    if (widget.warningsJson == null || widget.warningsJson!.isEmpty) {
      return const SizedBox.shrink();
    }

    List<dynamic> warnings;
    try {
      warnings = json.decode(widget.warningsJson!);
      if (warnings.isEmpty) return const SizedBox.shrink();
    } catch (e) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade700, Colors.orange.shade500],
                ),
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(12),
                  bottom: Radius.circular(_isExpanded ? 0 : 12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Warnings & Recommendations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${warnings.length} issue${warnings.length > 1 ? 's' : ''} found',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: warnings.asMap().entries.map((entry) {
                  final index = entry.key;
                  final warning = entry.value.toString();
                  return _buildWarningItem(index + 1, warning);
                }).toList(),
              ),
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningItem(int index, String warning) {
    // Determine warning type based on content
    final isError = warning.toLowerCase().contains('exceed') ||
        warning.toLowerCase().contains('below') ||
        warning.toLowerCase().contains('above');
    final isInfo = warning.toLowerCase().contains('recommend') ||
        warning.toLowerCase().contains('consider');

    Color iconColor = isError
        ? Colors.red.shade700
        : isInfo
            ? Colors.blue.shade700
            : Colors.orange.shade700;
    IconData icon = isError
        ? Icons.error_outline
        : isInfo
            ? Icons.info_outline
            : Icons.warning_amber_outlined;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError
            ? Colors.red.shade50
            : isInfo
                ? Colors.blue.shade50
                : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? Colors.red.shade200
              : isInfo
                  ? Colors.blue.shade200
                  : Colors.orange.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                    height: 1.4,
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
