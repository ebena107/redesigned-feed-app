import 'dart:convert';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import 'package:feed_estimator/src/core/utils/logger.dart';
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
      AppLogger.info(
        'AminoAcidProfileCard.build: hasSidData=${sidData != null}, hasTotalData=${totalData != null}, '
        'sidSize=${sidData?.length ?? 0}, totalSize=${totalData?.length ?? 0}',
        tag: 'AminoAcidProfileCard',
      );
    } catch (e) {
      // Invalid JSON, show error state
      AppLogger.error(
        'AminoAcidProfileCard: JSON parse error',
        tag: 'AminoAcidProfileCard',
        error: e,
      );
      return Card(
        margin: UIConstants.paddingAllSmall,
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: Text(context.l10n.aminoAcidLoadError),
        ),
      );
    }

    // If no data available
    if (sidData == null && totalData == null) {
      AppLogger.warning(
        'AminoAcidProfileCard: No amino acid data available',
        tag: 'AminoAcidProfileCard',
      );
      return const SizedBox.shrink();
    }

    final displayData = _showSid ? (sidData ?? totalData) : totalData;
    if (displayData == null) {
      AppLogger.warning(
        'AminoAcidProfileCard: displayData is null (showSid=$_showSid)',
        tag: 'AminoAcidProfileCard',
      );
      return const SizedBox.shrink();
    }

    AppLogger.info(
      'AminoAcidProfileCard: Building card with ${displayData.length} amino acids',
      tag: 'AminoAcidProfileCard',
    );

    try {
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
            context.l10n.aminoAcidProfileTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            _showSid
                ? context.l10n.aminoAcidSidLabel
                : context.l10n.aminoAcidTotalLabel,
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
                          segments: [
                            ButtonSegment(
                              value: true,
                              label: Text(context.l10n.aminoAcidSidButton),
                              icon: const Icon(Icons.check_circle, size: 16),
                            ),
                            ButtonSegment(
                              value: false,
                              label: Text(context.l10n.aminoAcidTotalButton),
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
                  _buildAminoAcidTable(displayData, context),

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
                                ? context.l10n.aminoAcidSidInfo
                                : context.l10n.aminoAcidTotalInfo,
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
    } catch (e, stackTrace) {
      AppLogger.error(
        'AminoAcidProfileCard: Exception during build',
        tag: 'AminoAcidProfileCard',
        error: e,
        stackTrace: stackTrace,
      );
      return Card(
        margin: UIConstants.paddingAllSmall,
        child: ListTile(
          leading: const Icon(Icons.error, color: Colors.red),
          title: const Text('Amino Acid Card Error'),
          subtitle: Text('$e'),
        ),
      );
    }
  }

  Widget _buildAminoAcidTable(Map<String, num> data, BuildContext context) {
    final l10n = context.l10n;
    // Essential amino acids in order with localized names
    final aminoAcids = [
      {'name': l10n.aminoAcidLysine, 'key': 'lysine'},
      {'name': l10n.aminoAcidMethionine, 'key': 'methionine'},
      {'name': l10n.aminoAcidCystine, 'key': 'cystine'},
      {'name': l10n.aminoAcidThreonine, 'key': 'threonine'},
      {'name': l10n.aminoAcidTryptophan, 'key': 'tryptophan'},
      {'name': l10n.aminoAcidArginine, 'key': 'arginine'},
      {'name': l10n.aminoAcidIsoleucine, 'key': 'isoleucine'},
      {'name': l10n.aminoAcidLeucine, 'key': 'leucine'},
      {'name': l10n.aminoAcidValine, 'key': 'valine'},
      {'name': l10n.aminoAcidHistidine, 'key': 'histidine'},
      {'name': l10n.aminoAcidPhenylalanine, 'key': 'phenylalanine'},
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
            _buildTableCell(l10n.aminoAcidTableHeaderName, isHeader: true),
            _buildTableCell(l10n.aminoAcidTableHeaderContent, isHeader: true),
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
