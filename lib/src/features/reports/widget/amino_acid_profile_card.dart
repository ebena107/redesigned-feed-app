import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:feed_estimator/src/core/constants/ui_constants.dart';
import 'package:feed_estimator/src/utils/nutrient_formatter.dart';

/// Expandable card displaying amino acid profile with SID/Total toggle
class AminoAcidProfileCard extends StatefulWidget {
  final String? aminoAcidsSidJson;
  final String? aminoAcidsTotalJson;
  final String title;
  final bool initiallyExpanded;

  const AminoAcidProfileCard({
    super.key,
    this.aminoAcidsSidJson,
    this.aminoAcidsTotalJson,
    this.title = 'Amino Acid Profile',
    this.initiallyExpanded = false,
  });

  @override
  State<AminoAcidProfileCard> createState() => _AminoAcidProfileCardState();
}

class _AminoAcidProfileCardState extends State<AminoAcidProfileCard> {
  bool _showSid = true; // Default to SID values (industry standard)

  @override
  Widget build(BuildContext context) {
    // Parse amino acid data
    Map<String, num>? sidData;
    Map<String, num>? totalData;

    try {
      if (widget.aminoAcidsSidJson != null) {
        sidData = Map<String, num>.from(json.decode(widget.aminoAcidsSidJson!));
      }
      if (widget.aminoAcidsTotalJson != null) {
        totalData =
            Map<String, num>.from(json.decode(widget.aminoAcidsTotalJson!));
      }
    } catch (e) {
      // Invalid JSON, show error state
      return Card(
        margin: UIConstants.paddingAllSmall,
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: const Text('Error loading amino acid data'),
        ),
      );
    }

    // If no data available
    if (sidData == null && totalData == null) {
      return const SizedBox.shrink();
    }

    final displayData = _showSid ? (sidData ?? totalData) : totalData;
    if (displayData == null) return const SizedBox.shrink();

    return Card(
      margin: UIConstants.paddingAllSmall,
      elevation: UIConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded,
        leading: const Icon(Icons.science, color: AppConstants.appBlueColor),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          _showSid ? 'SID (Digestible)' : 'Total',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        children: [
          Padding(
            padding: UIConstants.paddingAllMedium,
            child: Column(
              children: [
                // Toggle between SID and Total
                if (sidData != null && totalData != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SegmentedButton<bool>(
                        segments: const [
                          ButtonSegment(
                            value: true,
                            label: Text('SID'),
                            icon: Icon(Icons.check_circle, size: 16),
                          ),
                          ButtonSegment(
                            value: false,
                            label: Text('Total'),
                          ),
                        ],
                        selected: {_showSid},
                        onSelectionChanged: (Set<bool> selection) {
                          setState(() {
                            _showSid = selection.first;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: UIConstants.paddingMedium),
                ],

                // Amino acid table
                _buildAminoAcidTable(displayData),

                // Info note
                const SizedBox(height: UIConstants.paddingSmall),
                Container(
                  padding: UIConstants.paddingAllSmall,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _showSid
                              ? 'SID = Standardized Ileal Digestible (industry standard)'
                              : 'Total amino acids (not all digestible)',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue[700],
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

  Widget _buildAminoAcidTable(Map<String, num> data) {
    // Essential amino acids in order
    final aminoAcids = [
      {'name': 'Lysine', 'key': 'lysine'},
      {'name': 'Methionine', 'key': 'methionine'},
      {'name': 'Cystine', 'key': 'cystine'},
      {'name': 'Threonine', 'key': 'threonine'},
      {'name': 'Tryptophan', 'key': 'tryptophan'},
      {'name': 'Arginine', 'key': 'arginine'},
      {'name': 'Isoleucine', 'key': 'isoleucine'},
      {'name': 'Leucine', 'key': 'leucine'},
      {'name': 'Valine', 'key': 'valine'},
      {'name': 'Histidine', 'key': 'histidine'},
      {'name': 'Phenylalanine', 'key': 'phenylalanine'},
    ];

    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        width: 1,
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: AppConstants.appBlueColor.withValues(alpha: 0.1),
          ),
          children: [
            _buildTableCell('Amino Acid', isHeader: true),
            _buildTableCell('Content (%)', isHeader: true),
          ],
        ),
        // Data rows
        ...aminoAcids.map((aa) {
          final value = data[aa['key']];
          return TableRow(
            children: [
              _buildTableCell(aa['name']!),
              _buildTableCell(
                value != null ? NutrientFormatter.formatAminoAcid(value) : '--',
                isNumeric: true,
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTableCell(String text,
      {bool isHeader = false, bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 13 : 12,
        ),
        textAlign: isNumeric ? TextAlign.right : TextAlign.left,
      ),
    );
  }
}
