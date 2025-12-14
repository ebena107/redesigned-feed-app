import 'package:feed_estimator/src/features/add_ingredients/repository/ingredients_repository.dart';
import 'package:feed_estimator/src/features/add_ingredients/widgets/user_ingredients_widget.dart';
import 'package:feed_estimator/src/features/store_ingredients/providers/stored_ingredient_provider.dart';
import 'package:feed_estimator/src/features/store_ingredients/widget/ingredient_select_widget.dart';
import 'package:feed_estimator/src/utils/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoredIngredients extends ConsumerWidget {
  const StoredIngredients({super.key});

  static const _brandColor = Color(0xff87643E);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storeIngredientProvider);
    final hasSelection = state.selectedIngredient != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: const FeedAppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Modern app bar
          SliverAppBar.medium(
            backgroundColor: _brandColor,
            foregroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text(
              'Ingredient Library',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => ref.invalidate(ingredientsListProvider),
                tooltip: 'Refresh',
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Ingredient selector
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MANAGE INVENTORY',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: _brandColor,
                          letterSpacing: 1.2,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const IngredientSelectorTile(),
                ],
              ),
            ),
          ),

          // Edit form with animation
          SliverToBoxAdapter(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: hasSelection
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: _EditFormCard(brandColor: _brandColor),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          // Custom ingredients header
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Icon(Icons.science_rounded, color: _brandColor, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Custom Ingredients',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _brandColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      // Navigate to add ingredient
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add New'),
                    style: FilledButton.styleFrom(
                      backgroundColor: _brandColor.withValues(alpha: 0.1),
                      foregroundColor: _brandColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // User ingredients list
          const SliverFillRemaining(
            hasScrollBody: true,
            child: UserIngredientsWidget(),
          ),
        ],
      ),
    );
  }
}

class _EditFormCard extends ConsumerStatefulWidget {
  final Color brandColor;

  const _EditFormCard({required this.brandColor});

  @override
  ConsumerState<_EditFormCard> createState() => _EditFormCardState();
}

class _EditFormCardState extends ConsumerState<_EditFormCard> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final state = ref.read(storeIngredientProvider);
    _priceCtrl =
        TextEditingController(text: state.draftPrice?.toString() ?? '');
    _qtyCtrl = TextEditingController(text: state.draftQty?.toString() ?? '');
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeIngredientProvider);
    final notifier = ref.read(storeIngredientProvider.notifier);

    // Update controllers when state changes
    if (_priceCtrl.text != state.draftPrice?.toString()) {
      _priceCtrl.text = state.draftPrice?.toString() ?? '';
    }
    if (_qtyCtrl.text != state.draftQty?.toString()) {
      _qtyCtrl.text = state.draftQty?.toString() ?? '';
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with favorite toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Details',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Material(
                    color: state.draftFavorite
                        ? widget.brandColor.withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () =>
                          notifier.toggleDraftFavorite(!state.draftFavorite),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              state.draftFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: state.draftFavorite
                                  ? Colors.amber
                                  : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              state.draftFavorite
                                  ? 'Favorite'
                                  : 'Add to favorites',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: state.draftFavorite
                                    ? widget.brandColor
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Input fields
              Row(
                children: [
                  Expanded(
                    child: _ModernTextField(
                      label: 'Price per kg',
                      controller: _priceCtrl,
                      icon: Icons.attach_money_rounded,
                      onChanged: notifier.updateDraftPrice,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final num = double.tryParse(value);
                        if (num == null || num <= 0) return 'Must be > 0';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ModernTextField(
                      label: 'Available Qty (kg)',
                      controller: _qtyCtrl,
                      icon: Icons.inventory_2_rounded,
                      onChanged: notifier.updateDraftQty,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        final num = double.tryParse(value);
                        if (num == null || num < 0) return 'Must be ≥ 0';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  // Delete button
                  IconButton.filledTonal(
                    onPressed: () => _confirmDelete(context, ref),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded),
                    tooltip: 'Delete',
                  ),
                  const SizedBox(width: 12),

                  // Reset button
                  OutlinedButton.icon(
                    onPressed:
                        state.hasChanges ? () => notifier.resetDraft() : null,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Reset'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Save button
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: state.hasChanges && state.isValid
                          ? () => _saveChanges(context, ref)
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: widget.brandColor,
                        disabledBackgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save_rounded),
                      label: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(storeIngredientProvider);
    final ing = state.selectedIngredient;
    if (ing == null) return;

    final updatedIng = ing.copyWith(
      priceKg: state.draftPrice,
      availableQty: state.draftQty,
      favourite: state.draftFavorite ? 1 : 0,
    );

    try {
      await ref
          .read(ingredientsRepository)
          .update(updatedIng.toJson(), updatedIng.ingredientId as num);

      ref.invalidate(ingredientsListProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 12),
                Text('Ingredient updated successfully'),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to save: $e')),
              ],
            ),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.delete_forever_rounded,
            color: Colors.red.shade400, size: 32),
        title: const Text('Delete Ingredient?'),
        content: const Text(
          'This will permanently remove this ingredient from your library. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final ingredientId =
          ref.read(storeIngredientProvider).selectedIngredient?.ingredientId;

      if (ingredientId != null) {
        try {
          // Call your delete method here
          ref.read(storeIngredientProvider.notifier).selectIngredient(null);
          ref.invalidate(ingredientsListProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: Colors.white),
                    SizedBox(width: 12),
                    Text('Ingredient deleted'),
                  ],
                ),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete: $e'),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    }
  }
}

class _ModernTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const _ModernTextField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: const Color(0xff87643E)),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xff87643E), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
