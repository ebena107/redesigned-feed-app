import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feed_estimator/src/core/localization/localization_helper.dart';
import '../providers/optimizer_provider.dart';
import '../data/animal_requirements.dart';

/// Widget for selecting animal category and loading nutrient requirements
class AnimalCategoryCard extends ConsumerStatefulWidget {
  const AnimalCategoryCard({super.key});

  @override
  ConsumerState<AnimalCategoryCard> createState() => _AnimalCategoryCardState();
}

class _AnimalCategoryCardState extends ConsumerState<AnimalCategoryCard> {
  String? selectedSpecies;
  String? selectedStage;

  @override
  Widget build(BuildContext context) {
    final optimizerState = ref.watch(optimizerProvider);
    final allCategoryKeys = getAllCategoryKeys()
        .where((key) =>
            !key.contains('_')) // Show only generic categories in dropdown
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Animal Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (optimizerState.selectedCategory != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      ref
                          .read(optimizerProvider.notifier)
                          .clearAnimalCategory();
                      setState(() {
                        selectedSpecies = null;
                        selectedStage = null;
                      });
                    },
                    tooltip: 'Clear Category',
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Category Key Dropdown (unified system)
            DropdownButtonFormField<String>(
              initialValue: selectedSpecies,
              decoration: const InputDecoration(
                labelText: 'Animal Type',
                border: OutlineInputBorder(),
                helperText: 'Select animal category',
              ),
              items: allCategoryKeys.map((categoryKey) {
                return DropdownMenuItem(
                  value: categoryKey,
                  child: Text(_formatCategoryKey(categoryKey)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSpecies = value;
                  selectedStage = null; // Reset stage when category changes
                });
              },
            ),
            const SizedBox(height: 16),

            // Specific Stage Dropdown (if subcategories available)
            if (selectedSpecies != null) ...[
              DropdownButtonFormField<String>(
                initialValue: selectedStage,
                decoration: const InputDecoration(
                  labelText: 'Specific Stage (Optional)',
                  border: OutlineInputBorder(),
                  helperText: 'Select specific production stage',
                ),
                items: _getSubcategoriesFor(selectedSpecies!).map((subKey) {
                  return DropdownMenuItem(
                    value: subKey,
                    child: Text(_formatCategoryKey(subKey)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedStage = value;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],

            // Load Requirements Button
            if (selectedSpecies != null && selectedStage != null) ...[
              ElevatedButton.icon(
                onPressed: () => _loadRequirements(),
                icon: const Icon(Icons.download),
                label: Text(context.l10n.optimizerLoadRequirements),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Current Category Info
            if (optimizerState.selectedCategory != null) ...[
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Loaded: ${optimizerState.selectedCategory}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (optimizerState.requirementSource != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Source: ${optimizerState.requirementSource}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '${optimizerState.constraints.length} constraints loaded',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _loadRequirements() {
    if (selectedSpecies == null) return;

    // Use specific stage if selected, otherwise use generic category
    final categoryKey = selectedStage ?? selectedSpecies!;

    final category = findCategoryByKey(categoryKey);
    if (category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Load requirements into optimizer
    ref.read(optimizerProvider.notifier).loadAnimalRequirements(category);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Loaded ${category.requirements.length} requirements for ${category.displayName}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Format category key for display (e.g., 'pig_grower' → 'Pig - Grower')
  String _formatCategoryKey(String key) {
    if (key == 'pig') return 'Pig (Generic)';
    if (key == 'poultry') return 'Poultry (Generic)';
    if (key == 'ruminant') return 'Ruminant (Generic)';
    if (key == 'rabbit') return 'Rabbit (Generic)';
    if (key == 'fish' || key == 'aquaculture') return 'Fish (Generic)';

    // Format specific categories
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' - ');
  }

  /// Get subcategories for a generic category
  List<String> _getSubcategoriesFor(String genericKey) {
    return getAllCategoryKeys()
        .where((key) => key.startsWith(genericKey) && key != genericKey)
        .toList();
  }
}
