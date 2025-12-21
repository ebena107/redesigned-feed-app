import 'dart:io';

import 'package:feed_estimator/src/features/add_ingredients/model/ingredient.dart';
import 'package:feed_estimator/src/features/add_ingredients/provider/user_ingredients_provider.dart';
import 'package:feed_estimator/src/utils/widgets/modern_dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

// ignore_for_file: use_build_context_synchronously

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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with count and actions
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.science, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your Custom Ingredients (${state.userIngredients.length})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Import/Export action buttons
              Row(
                children: [
                  // Export button
                  if (state.userIngredients.isNotEmpty)
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('Export'),
                        onPressed: () => _showExportDialog(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  if (state.userIngredients.isNotEmpty)
                    const SizedBox(width: 8),
                  // Import button
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.upload, size: 18),
                      label: const Text('Import'),
                      onPressed: () => _showImportDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
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
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (state.filteredIngredients.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
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
    // Capture ScaffoldMessenger before opening dialog
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Custom Ingredient?'),
        content: Text(
          'Remove "${ingredient.name}" from your custom ingredients?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              await ref
                  .read(userIngredientsProvider.notifier)
                  .removeCustomIngredient(ingredient.ingredientId!);

              // Small delay to ensure dialog is closed
              await Future.delayed(const Duration(milliseconds: 200));

              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('${ingredient.name} removed'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green,
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
              await _exportToJson(context);
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _exportToCsv(context);
            },
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }

  /// Export to JSON file
  Future<void> _exportToJson(BuildContext context) async {
    try {
      LoadingDialog.show(context, message: 'Exporting to JSON...');

      final file =
          await ref.read(userIngredientsProvider.notifier).exportToJsonFile();

      if (mounted) {
        LoadingDialog.hide(context);

        // Small delay to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          if (file != null) {
            // Show share dialog
            await Share.shareXFiles(
              [XFile(file.path)],
              subject: 'Custom Ingredients Export',
              text:
                  'Exported ${ref.read(userIngredientsProvider).userIngredients.length} custom ingredients',
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✗ Export failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        LoadingDialog.hide(context);

        // Small delay to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✗ Export failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Export to CSV file
  Future<void> _exportToCsv(BuildContext context) async {
    try {
      LoadingDialog.show(context, message: 'Exporting to CSV...');

      final file =
          await ref.read(userIngredientsProvider.notifier).exportToCsvFile();

      if (mounted) {
        LoadingDialog.hide(context);

        // Small delay to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          if (file != null) {
            // Show share dialog
            await Share.shareXFiles(
              [XFile(file.path)],
              subject: 'Custom Ingredients Export',
              text:
                  'Exported ${ref.read(userIngredientsProvider).userIngredients.length} custom ingredients',
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✗ Export failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        LoadingDialog.hide(context);

        // Small delay to ensure dialog is fully closed
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✗ Export failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  /// Show import format selection dialog
  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Custom Ingredients'),
        content: const Text('Choose the file format to import:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _importWithFilePicker(context, isJson: true);
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _importWithFilePicker(context, isJson: false);
            },
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }

  /// Import using file picker
  Future<void> _importWithFilePicker(BuildContext context,
      {required bool isJson}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [isJson ? 'json' : 'csv'],
      );

      if (result == null) return;

      // Check if widget is still mounted after file picker
      if (!mounted) return;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Importing data...'),
                ],
              ),
            ),
          ),
        ),
      );

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final notifier = ref.read(userIngredientsProvider.notifier);

      if (isJson) {
        await notifier.importFromJson(content);
      } else {
        await notifier.importFromCsv(content);
      }

      // Close loading dialog
      if (mounted && context.mounted) {
        Navigator.pop(context);
      }

      // Check if widget and context are still valid before showing result dialog
      if (!mounted || !context.mounted) return;

      // Show result dialog instead of SnackBar to avoid context issues
      final state = ref.read(userIngredientsProvider);
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: Icon(
            state.status == 'success' ? Icons.check_circle : Icons.error,
            color: state.status == 'success' ? Colors.green : Colors.red,
            size: 48,
          ),
          title: Text(state.status == 'success'
              ? 'Import Successful'
              : 'Import Failed'),
          content: Text(state.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e, stackTrace) {
      // Log the error
      debugPrint('Import error: $e');
      debugPrint('Stack trace: $stackTrace');

      // Close loading dialog if open and context is valid
      if (mounted && context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }

      // Check if widget and context are still valid before showing error dialog
      if (!mounted || !context.mounted) return;

      // Show error dialog
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.error, color: Colors.red, size: 48),
          title: const Text('Import Failed'),
          content: Text('Error: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
