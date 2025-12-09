import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/user_ingredients_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget to display and manage user-created ingredients
class UserIngredientsWidget extends ConsumerStatefulWidget {
  const UserIngredientsWidget({super.key});

  @override
  ConsumerState<UserIngredientsWidget> createState() =>
      _UserIngredientsWidgetState();
}

class _UserIngredientsWidgetState extends ConsumerState<UserIngredientsWidget> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userIngredientsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count and actions
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                'Your Custom Ingredients (${state.userIngredients.length})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              // Export button
              if (state.userIngredients.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.file_download),
                  tooltip: 'Export ingredients',
                  onPressed: () => _showExportDialog(context),
                ),
              // Import button
              IconButton(
                icon: const Icon(Icons.file_upload),
                tooltip: 'Import ingredients',
                onPressed: () => _showImportDialog(context),
              ),
            ],
          ),
        ),

        // Search field
        if (state.userIngredients.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                ref
                    .read(userIngredientsProvider.notifier)
                    .searchUserIngredients(query);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search your custom ingredients...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(userIngredientsProvider.notifier)
                              .clearSearch();
                          setState(() {});
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

        // List of user ingredients
        if (state.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (state.filteredIngredients.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inbox, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text(
                    state.userIngredients.isEmpty
                        ? 'No custom ingredients yet.\nCreate your first custom ingredient!'
                        : 'No ingredients match your search.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: state.filteredIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = state.filteredIngredients[index];
                return _buildIngredientCard(context, ref, ingredient);
              },
            ),
          ),
      ],
    );
  }

  /// Build a card displaying ingredient details
  Widget _buildIngredientCard(
    BuildContext context,
    WidgetRef ref,
    Ingredient ingredient,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and creator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ingredient.name ?? 'Unknown',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (ingredient.createdBy != null)
                        Text(
                          'by ${ingredient.createdBy}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(context, ref, ingredient);
                  },
                ),
              ],
            ),
            const Divider(),

            // Nutritional summary grid
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              children: [
                _nutrientTile(
                  'Protein',
                  '${ingredient.crudeProtein ?? 0}%',
                ),
                _nutrientTile(
                  'Fat',
                  '${ingredient.crudeFat ?? 0}%',
                ),
                _nutrientTile(
                  'Fiber',
                  '${ingredient.crudeFiber ?? 0}%',
                ),
                _nutrientTile(
                  'Ca',
                  '${ingredient.calcium ?? 0}%',
                ),
                _nutrientTile(
                  'P',
                  '${ingredient.phosphorus ?? 0}%',
                ),
                _nutrientTile(
                  'Price',
                  '\$${ingredient.priceKg ?? 0}',
                ),
              ],
            ),

            if (ingredient.notes != null && ingredient.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    Text(
                      ingredient.notes!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
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

  /// Small widget to display nutrient value
  Widget _nutrientTile(String label, String value) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    Ingredient ingredient,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Custom Ingredient?'),
        content: Text(
          'Remove "${ingredient.name}" from your custom ingredients?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(userIngredientsProvider.notifier)
                  .removeCustomIngredient(ingredient.ingredientId!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${ingredient.name} removed'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Show export format selection dialog
  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Format'),
        content:
            const Text('Choose export format for your custom ingredients:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _exportToJson();
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _exportToCsv();
            },
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }

  /// Export to JSON file
  Future<void> _exportToJson() async {
    final file =
        await ref.read(userIngredientsProvider.notifier).exportToJsonFile();
    if (file != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported to ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Export failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Export to CSV file
  Future<void> _exportToCsv() async {
    final file =
        await ref.read(userIngredientsProvider.notifier).exportToCsvFile();
    if (file != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported to ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Export failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show import format selection dialog
  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose import format:'),
            const SizedBox(height: 8),
            Text(
              'Note: Place your file in the app documents folder',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showImportFileDialog(context, isJson: true);
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showImportFileDialog(context, isJson: false);
            },
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }

  /// Show file name input dialog for import
  void _showImportFileDialog(BuildContext context, {required bool isJson}) {
    final controller = TextEditingController();
    final extension = isJson ? '.json' : '.csv';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Import from ${isJson ? "JSON" : "CSV"}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'File name',
            hintText: 'custom_ingredients$extension',
            suffixText: extension,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var filename = controller.text.trim();
              if (filename.isEmpty) {
                filename = 'custom_ingredients';
              }
              if (!filename.endsWith(extension)) {
                filename = filename + extension;
              }
              await _importFromFile(filename, isJson: isJson);
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  /// Import from file
  Future<void> _importFromFile(String filename, {required bool isJson}) async {
    try {
      final notifier = ref.read(userIngredientsProvider.notifier);
      final content = await notifier.readFileContent(filename);

      if (content.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File not found: $filename'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (isJson) {
        await notifier.importFromJson(content);
      } else {
        await notifier.importFromCsv(content);
      }

      final state = ref.read(userIngredientsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message ?? 'Import complete'),
            backgroundColor:
                state.status == 'success' ? Colors.green : Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
