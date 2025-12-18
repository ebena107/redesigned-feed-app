import 'dart:convert';
import 'package:flutter/material.dart';

/// Energy Values Card - displays comprehensive energy values for all animal types
class EnergyValuesCard extends StatefulWidget {
  final String? energyJson;
  final int animalTypeId;

  const EnergyValuesCard({
    super.key,
    required this.energyJson,
    required this.animalTypeId,
  });

  @override
  State<EnergyValuesCard> createState() => _EnergyValuesCardState();
}

class _EnergyValuesCardState extends State<EnergyValuesCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.energyJson == null || widget.energyJson!.isEmpty) {
      return const SizedBox.shrink();
    }

    Map<String, dynamic> energyData;
    try {
      energyData = json.decode(widget.energyJson!);
    } catch (e) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
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
                  Icon(Icons.bolt, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Energy Values',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getPrimaryEnergyLabel(widget.animalTypeId),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
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
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildEnergyTable(energyData, widget.animalTypeId),
                  const SizedBox(height: 12),
                  _buildEnergyLegend(),
                ],
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

  Widget _buildEnergyTable(Map<String, dynamic> energyData, int animalTypeId) {
    final energyTypes = [
      if (energyData['de_pig'] != null)
        {
          'label': 'DE (Pig)',
          'value': energyData['de_pig'],
          'primary': animalTypeId == 1
        },
      if (energyData['me_pig'] != null)
        {'label': 'ME (Pig)', 'value': energyData['me_pig'], 'primary': false},
      if (energyData['ne_pig'] != null)
        {
          'label': 'NE (Pig)',
          'value': energyData['ne_pig'],
          'primary': animalTypeId == 1
        },
      if (energyData['me_poultry'] != null)
        {
          'label': 'ME (Poultry)',
          'value': energyData['me_poultry'],
          'primary': animalTypeId == 2
        },
      if (energyData['me_ruminant'] != null)
        {
          'label': 'ME (Ruminant)',
          'value': energyData['me_ruminant'],
          'primary': animalTypeId == 3
        },
      if (energyData['me_rabbit'] != null)
        {
          'label': 'ME (Rabbit)',
          'value': energyData['me_rabbit'],
          'primary': animalTypeId == 4
        },
      if (energyData['de_salmonids'] != null)
        {
          'label': 'DE (Fish)',
          'value': energyData['de_salmonids'],
          'primary': animalTypeId == 5
        },
    ];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1.5),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            _tableHeader('Energy Type'),
            _tableHeader('Value'),
            _tableHeader('Unit'),
          ],
        ),
        ...energyTypes.map((energy) => TableRow(
              decoration: BoxDecoration(
                color: energy['primary'] == true ? Colors.orange.shade50 : null,
              ),
              children: [
                _tableCell(
                  energy['label'] as String,
                  bold: energy['primary'] == true,
                ),
                _tableCell(
                  (energy['value'] as num).toStringAsFixed(0),
                  align: TextAlign.center,
                  bold: energy['primary'] == true,
                ),
                _tableCell('kcal/kg', align: TextAlign.center),
              ],
            )),
      ],
    );
  }

  Widget _buildEnergyLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Energy Types',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'DE = Digestible Energy\nME = Metabolizable Energy\nNE = Net Energy (NRC 2012 standard for pigs)',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableCell(String text,
      {TextAlign align = TextAlign.left, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }

  String _getPrimaryEnergyLabel(int animalTypeId) {
    switch (animalTypeId) {
      case 1:
        return 'Primary: Net Energy (NE)';
      case 2:
        return 'Primary: ME (Poultry)';
      case 3:
        return 'Primary: ME (Ruminant)';
      case 4:
        return 'Primary: ME (Rabbit)';
      case 5:
        return 'Primary: DE (Salmonids)';
      default:
        return 'All energy values';
    }
  }
}
